CREATE PROCEDURE [dbo].[PutClient]
	@ClientId INT = NULL OUTPUT,  -- NULL for insert,  ClientId fro Update
	@ClientName VARCHAR(255),
	@UserName	VARCHAR(100),
	@VersionId ROWVERSION
AS
SET NOCOUNT ON
SET TRAN ISOLATION LEVEL REPEATABLE READ
    DECLARE @TranCounter INT;  
    SET @TranCounter = @@TRANCOUNT;  
    IF @TranCounter > 0  
        SAVE TRANSACTION ProcedureSave;  
    ELSE  
        BEGIN TRANSACTION;  
    BEGIN TRY  
        IF @ClientId IS NOT NULL 
			IF (SELECT TOP 1 VersionId FROM dbo.Clients WHERE ClientId = @ClientId) = @VersionId
				RAISERROR ('Could not modify Client [%i].  It was already modified by other transaction',16,1, @ClientId)

		;MERGE dbo.Clients AS T
		USING (VALUES(@ClientId, @ClientName, @UserName)
			)	AS S(ClientId, ClientName, UserName)
		ON T.ClientId = S.ClientId
		WHEN MATCHED THEN
			UPDATE SET
				t.ClientName = S.ClientName
				-- CLientCode should not be changed
		WHEN NOT MATCHED THEN
			INSERT(ClientName,UserName)
			VALUES(ClientName,UserName)
		;

		SET @ClientId = ISNULL(@ClientId, SCOPE_IDENTITY())

        IF @TranCounter = 0  
            COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        IF @TranCounter = 0  
            ROLLBACK TRANSACTION;  
        ELSE  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION ProcedureSave;  
			THROW
    END CATCH  

GO
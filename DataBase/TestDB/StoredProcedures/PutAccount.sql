CREATE PROCEDURE [dbo].[PutAccount]
	@AccountId INT = NULL OUTPUT,  -- NULL for insert,  @AccountId fro Update
	@AccountCode VARCHAR(20),
	@ClientId	INT,
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
			IF (SELECT TOP 1 VersionId FROM dbo.Accounts WHERE AccountId = @AccountId) = @VersionId
				RAISERROR ('Could not modify Account [%i].  It was already modified by other transaction',16,1, @AccountId)
		-- Account should not be modified. Only additional parameters could be changed
		;MERGE dbo.Accounts AS T
		USING (VALUES(@AccountId)
			)	AS S(AccountId)
		ON T.AccountId = S.AccountId
		WHEN NOT MATCHED THEN
			INSERT(AccountCode, ClientId)
			VALUES(@AccountCode,@ClientId)
		;

		SET @AccountId = ISNULL(@AccountId, SCOPE_IDENTITY())

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

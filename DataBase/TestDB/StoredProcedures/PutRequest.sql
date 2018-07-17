CREATE PROCEDURE [dbo].PutRequest
	@RequestId INT = NULL OUTPUT,  -- NULL for insert
	@ClientId INT,
	@AccountId INT,
	@RequestDate DATE = NULL, 
	@Comment VARCHAR(4000) = NULL,
	@Amount	utMoney , 
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
        IF @RequestId IS NOT NULL 
			IF (SELECT VersionId FROM dbo.Requests WHERE RequestId = @RequestId) = @VersionId
				RAISERROR ('Could not modify Request [%i].  It was already modified by other transaction',16,1, @RequestId)
		-- Define default RequestDate as Current Date

		IF @RequestId IS NULL 
			SET @RequestDate = ISNULL(@RequestDate, GETUTCDATE())

		DECLARE @RequestStatusDraftId INT 

		SELECT  @RequestStatusDraftId  = RequestStatusId
		FROM dbo.RequestStatus WHERE RequestStatusName = 'Pending'

		-- All Requests are inserted in Pending  status only
		;MERGE dbo.Requests AS T
		USING (VALUES(@RequestId)
			)	AS S(RequestId)
		ON T.RequestId= S.RequestId
		WHEN NOT MATCHED THEN
			INSERT(RequestStatusId, RequestDate, Comment, ClientId, Amount, AccountId )
			VALUES(@RequestStatusDraftId, @RequestDate, @Comment, @ClientId, @Amount, @AccountId )
		WHEN MATCHED AND t.RequestStatusId <> @RequestStatusDraftId THEN	
		-- Only Draft requests could be changed
			UPDATE SET T.Comment = @Comment
		;

		SET @RequestId = ISNULL(@RequestId, SCOPE_IDENTITY())

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

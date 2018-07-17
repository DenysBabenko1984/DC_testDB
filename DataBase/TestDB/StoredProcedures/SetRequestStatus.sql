CREATE PROCEDURE [dbo].[SetRequestStatus]
	@RequestId	INT
	,@RequestStatusName INT
	,@RequestStatusComment  VARCHAR(4000)
	,@VersionId ROWVERSION
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

		DECLARE @CurrentRequestStatusId		INT = (SELECT r.RequestStatusId FROM dbo.Requests r WHERE r.RequestId = @RequestId)
			,@RequestStatusRejectedId		INT = (SELECT rs.RequestStatusId FROM dbo.RequestStatus rs WHERE rs.RequestStatusName = 'Rejected')
			,@RequestStatusPendingId		INT = (SELECT rs.RequestStatusId FROM dbo.RequestStatus rs WHERE rs.RequestStatusName = 'Pending')
			,@RequestStatusAcceptedId		INT = (SELECT rs.RequestStatusId FROM dbo.RequestStatus rs WHERE rs.RequestStatusName = 'Accepted')
		-- We can change Status only for Draft requests.
		IF (@CurrentRequestStatusId <> @RequestStatusPendingId)
			RAISERROR ('Only [Pending] requests could be Rejected or Accepted.',16,1)

		-- Fail in case is incorrect status was requeste
		IF @RequestStatusName NOT IN ( 'Rejected', 'Accepted')
		BEGIN
			RAISERROR('Incorrect status change was requested [%s]. Only [Rejected] and [Accepted] are supported', 16, 1, @RequestStatusName)
		END

		--	Set Rquest status
		UPDATE r
		SET	r.RequestStatusId = CASE @RequestStatusName WHEN 'Rejected' THEN @RequestStatusRejectedId
									WHEN 'Accepted' THEN @RequestStatusAcceptedId
								END
			,r.RequestStatusComment = @RequestStatusComment  
		FROM dbo.Requests r
		WHERE	r.RequestId = @RequestId
		
		-- Generate transaction in case  if Request approved
		IF (@RequestStatusName = 'Accepted' )
		BEGIN
			DECLARE @tmpTransaction TABLE (
				TransactionId INT
				,AccountId INT
				,Amount utMoney
			)

			INSERT INTO dbo.Transactions
			(
			    TransactionDate,		RequestId,			Comment,				AccountId,
			    Amount,					CreatedBy,			CreatedDate
			)
			OUTPUT	Inserted.TransactionId, Inserted.AccountId, Inserted.Amount 
			INTO	@tmpTransaction(TransactionId, AccountId, Amount)
			SELECT 
				GETUTCDATE(),			r.RequestId,		@RequestStatusComment,	r.AccountId,
				r.Amount,				USER_NAME(),		GETUTCDATE()
			FROM dbo.Requests r
			WHERE r.RequestId = @RequestId
			
			-- Update Amount of money on Client's Account
			UPDATE	a
			SET a.Amount += t.Amount
			FROM dbo.Accounts a
			INNER JOIN @tmpTransaction t ON t.AccountId = a.AccountId			 
		END

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
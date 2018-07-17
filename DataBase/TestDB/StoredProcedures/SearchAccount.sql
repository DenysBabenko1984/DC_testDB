CREATE PROCEDURE [dbo].[SearchAccount]
	@AccountCode VARCHAR(255) = NULL,
	@ClientName VARCHAR(255) = NULL,	-- Masks supported
	@UserName	VARCHAR(100) = NULL
AS
SET NOCOUNT ON
    BEGIN TRY  
		SELECT	
			a.AccountCode,
            a.AccountId,
            a.Amount,
            a.ClientId,
			ah.ActionDate AS CreatedDate,
			ah.ActionUser AS CreatedBy,
            c.ClientName,
			c.UserName
		FROM	dbo.Accounts a
		INNER JOIN	dbo.AccountsHistory ah ON ah.AccountId = a.AccountId AND ah.ActionFlag = 'I'
		INNER JOIN dbo.Clients c ON c.ClientId = a.ClientId
		WHERE	(@AccountCode IS NULL OR a.AccountCode LIKE @AccountCode)
		AND		(@ClientName IS NULL OR c.ClientName LIKE @ClientName)
		AND		(@UserName IS NULL OR c.UserName = @UserName)

    END TRY  
    BEGIN CATCH  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION;  
			THROW
    END CATCH  

GO
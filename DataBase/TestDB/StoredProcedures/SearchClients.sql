CREATE PROCEDURE [dbo].[SearchClients]
	@ClientName VARCHAR(255) = NULL,	-- Masks supported
	@UserName	VARCHAR(100) = NULL
AS
SET NOCOUNT ON
    BEGIN TRY  
		SELECT	
			c.ClientId,
			c.UserName,
            c.ClientName
		FROM	dbo.Clients c
		WHERE	(@ClientName IS NULL OR c.ClientName LIKE @ClientName)
		AND		(@UserName IS NULL OR c.UserName = @UserName)

    END TRY  
    BEGIN CATCH  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION;  
			THROW
    END CATCH  

GO
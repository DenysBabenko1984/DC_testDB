CREATE PROCEDURE [dbo].[GetClient]
	@ClientId INT
AS
SET NOCOUNT ON
    BEGIN TRY  
		SELECT	
			c.UserName,
            c.ClientId,
            c.ClientName,
            c.VersionId,
			a.AttributeValue
			,ch.ActionDate AS CreatedDate
			,ch.ActionUser AS CreatedBy
		FROM	dbo.Clients c
		LEFT OUTER JOIN dbo.ClientsHistory ch ON CH.ClientId = c.ClientId AND ch.ActionFlag = 'I'
		LEFT OUTER JOIN dbo.Attributes a ON a.EntityId = c.ClientId
		LEFT OUTER JOIN dbo.AttributeTypes at ON at.AttributeTypeId = a.AttributeTypeId  AND at.AttributeTypeName = 'Client'
    END TRY  
    BEGIN CATCH  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION;  
			THROW
    END CATCH  

GO
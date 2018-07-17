CREATE PROCEDURE [dbo].[GetAccount]
	@AccountId INT
AS
SET NOCOUNT ON
    BEGIN TRY  
		SELECT	
			ac.AccountCode,
            ac.AccountId,
            ac.Amount,
            ac.ClientId,
            ac.VersionId,
			a.AttributeValue,
			ah.ActionDate AS CreatedDate,
			ah.ActionUser AS CreatedBy
		FROM	dbo.Accounts ac
		INNER JOIN	dbo.AccountsHistory ah ON ah.AccountId = ac.AccountId AND ah.ActionFlag = 'I'
		LEFT OUTER JOIN dbo.Attributes a ON a.EntityId = ac.AccountId
		LEFT OUTER JOIN dbo.AttributeTypes at ON at.AttributeTypeId = a.AttributeTypeId  AND at.AttributeTypeName = 'Account'
    END TRY  
    BEGIN CATCH  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION;  
			THROW
    END CATCH  

GO
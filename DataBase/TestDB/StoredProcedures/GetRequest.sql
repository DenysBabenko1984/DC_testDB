CREATE PROCEDURE [dbo].[GetRequest]
	@RequestId INT
AS
SET NOCOUNT ON
    BEGIN TRY  
		SELECT	
			r.RequestId
			,r.RequestStatusId
			,rs.RequestStatusName
			,r.RequestDate
			,r.Comment
			,r.ClientId
			,c.ClientName
			,r.Amount
			,r.VersionId
			,ac.AccountId
			,ac.AccountCode
			,a.AttributeValue
			,rh.ActionDate AS CreatedDate
			,rh.ActionUser AS CreatedBy
		FROM	dbo.Requests r
		INNER JOIN dbo.Clients c ON c.ClientId = r.ClientId
		INNER JOIN dbo.Accounts ac ON ac.AccountId = r.AccountId 
		INNER JOIN dbo.RequestStatus rs ON rs.RequestStatusId = r.RequestStatusId
		LEFT OUTER JOIN dbo.RequestsHistory rh ON rh.RequestId = r.RequestId AND rh.ActionFlag = 'I'
		LEFT OUTER JOIN dbo.Attributes a ON a.EntityId = r.RequestId
		LEFT OUTER JOIN dbo.AttributeTypes at ON at.AttributeTypeId = a.AttributeTypeId  AND at.AttributeTypeName = 'Request'
    END TRY  
    BEGIN CATCH  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION;  
			THROW
    END CATCH  

GO
CREATE PROCEDURE [dbo].[SearchRequest]
	@UserName VARCHAR(100)
	,@StartRequestDate DATE = NULL
	,@EndRequestDate DATE = NULL
	,@RequestStatus VARCHAR(100) 
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
			,r.VersionId
			,ac.AccountId
			,ac.AccountCode
			,rh.ActionDate AS CreatedDate
			,rh.ActionUser AS CreatedBy
		FROM	dbo.Requests r
		INNER JOIN dbo.Clients c ON c.ClientId = r.ClientId
		INNER JOIN dbo.Accounts ac ON ac.AccountId = r.AccountId 
		INNER JOIN dbo.RequestStatus rs ON rs.RequestStatusId = r.RequestStatusId
		LEFT OUTER JOIN dbo.RequestsHistory rh ON rh.RequestId = r.RequestId AND rh.ActionFlag = 'I'
		WHERE	c.UserName = ISNULL(@UserName,USER_NAME())
		AND		r.RequestDate BETWEEN ISNULL(@StartRequestDate, '19000101') AND  ISNULL(@EndRequestDate, '99991231')
		AND		rs.RequestStatusName = @RequestStatus 
    END TRY  
    BEGIN CATCH  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION;  
			THROW
    END CATCH  

GO

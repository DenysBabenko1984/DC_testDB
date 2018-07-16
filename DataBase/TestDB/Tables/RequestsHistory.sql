CREATE TABLE [dbo].[RequestsHistory]
(
	RequestId INT NOT NULL
	,RequestStatusId INT NOT NULL
	,RequestDate DATE NOT NULL
	,Comment VARCHAR(4000) NULL
	,ClientId INT NOT NULL 
	,ActionDate		DATETIME		NOT NULL
	,ActionFlag		CHAR(1)			NOT NULL
	,ActionUser		VARCHAR(100)	NOT NULL
)
GO

CREATE CLUSTERED INDEX CIX_RequestsHistory_RequestId ON dbo.RequestsHistory(RequestId)
GO

CREATE TABLE [dbo].[ClientsHistory]
(
	ClientId			INT NOT NULL
	,ClientName			VARCHAR(255)	NOT NULL
	,UserName			VARCHAR(100)		NOT NULL	
	,ActionDate		DATETIME		NOT NULL
	,ActionFlag		CHAR(1)			NOT NULL
	,ActionUser		VARCHAR(100)	NOT NULL
)
GO

CREATE CLUSTERED INDEX CIX_ClientHistory_ClientId ON [dbo].[ClientsHistory](ClientId)
GO
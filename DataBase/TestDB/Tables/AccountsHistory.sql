CREATE TABLE [dbo].AccountsHistory
(
	AccountId		INT  NOT NULL 
	,AccountCode	VARCHAR(20)	NOT NULL	
	,ClientId		INT	NOT NULL		
	,Amount			NUMERIC(18,2)	NOT NULL 
	,ActionDate		DATETIME		NOT NULL
	,ActionFlag		CHAR(1)			NOT NULL
	,ActionUser		VARCHAR(100)	NOT NULL
)
GO

CREATE CLUSTERED INDEX CIX_AccountsHistory_AccountId ON [dbo].AccountsHistory(AccountId)
GO
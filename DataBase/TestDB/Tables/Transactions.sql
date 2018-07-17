CREATE TABLE [dbo].[Transactions]
(
	TransactionId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Transaction PRIMARY KEY
	,TransactionDate	DATE NOT NULL
	,RequestId	INT NULL CONSTRAINT FK_Transactions_RequestId FOREIGN KEY REFERENCES dbo.Requests(RequestId)  
	-- Transaction could be inserted without request.  For example rollback transaction 
	,Comment	VARCHAR(4000) NULL
	,AccountId	INT	NOT NULL	CONSTRAINT FK_Transactions_AccountId	FOREIGN KEY REFERENCES dbo.Accounts(AccountId)
	,Amount			utMoney	NOT NULL
	-- Half-transaction accounting model is used for simplification. 
	,CreatedBy	VARCHAR(100)	NOT NULL
	,CreatedDate	DATETIME	NOT NULL DEFAULT(GETUTCDATE())
	,VersionId		ROWVERSION
)
GO

CREATE NONCLUSTERED INDEX  IX_Transactions_TransactionDate ON dbo.Transactions(TransactionDate,RequestId)
GO


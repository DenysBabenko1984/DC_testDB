CREATE TABLE [dbo].[Accounts]
(
	AccountId		INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Accounts PRIMARY KEY
	,AccountCode	VARCHAR(20)	NOT NULL	CONSTRAINT UQ_Accounts_AccountCode UNIQUE
	,ClientId		INT	NOT NULL		CONSTRAINT FK_AccountId_ClientId	FOREIGN KEY REFERENCES dbo.Clients(ClientId)
	,Amount			utMoney	NOT NULL DEFAULT(0.0)
	,VersionId		ROWVERSION
)
GO

CREATE TRIGGER dbo.tuAccounts ON dbo.Accounts FOR UPDATE
AS
SET NOCOUNT ON
	INSERT INTO dbo.AccountsHistory
	(
	    AccountId,
	    AccountCode,
	    ClientId,
	    Amount,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT 
		Inserted.AccountId,
		Inserted.AccountCode,
        Inserted.ClientId,
		Inserted.Amount,
        GETUTCDATE(),
		'U',
		SUSER_SNAME()
	FROM Inserted
GO

CREATE TRIGGER dbo.tiAccounts ON dbo.Accounts FOR INSERT
AS
SET NOCOUNT ON
	INSERT INTO dbo.AccountsHistory
	(
	    AccountId,
	    AccountCode,
	    ClientId,
	    Amount,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT 
		Inserted.AccountId,
		Inserted.AccountCode,
        Inserted.ClientId,
		Inserted.Amount,
        GETUTCDATE(),
		'I',
		SUSER_SNAME()
	FROM Inserted
GO

CREATE TRIGGER dbo.tdAccounts ON dbo.Accounts FOR DELETE
AS
SET NOCOUNT ON
	INSERT INTO dbo.AccountsHistory
	(
	    AccountId,
	    AccountCode,
	    ClientId,
	    Amount,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT 
		AccountId,
		AccountCode,
        ClientId,
		Amount,
        GETUTCDATE(),
		'D',
		SUSER_SNAME()
	FROM Deleted
GO
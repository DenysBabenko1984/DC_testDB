CREATE TABLE dbo.Clients
(
	ClientId			INT IDENTITY(1,1) CONSTRAINT PK_Clients PRIMARY KEY 
	,ClientName			VARCHAR(255)	NOT NULL
	,UserName			VARCHAR(100)		NOT NULL	CONSTRAINT UQ_Clients_ClientCode UNIQUE
	,VersionId		ROWVERSION 
)
GO

CREATE NONCLUSTERED INDEX IX_Clients_ClientName ON dbo.Clients (ClientName)
GO

CREATE TRIGGER dbo.tuClients ON dbo.Clients FOR UPDATE
AS
SET NOCOUNT ON
	INSERT INTO dbo.ClientsHistory
	(
	    ClientId,
	    ClientName,
	    UserName,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT	    ClientId,
	    ClientName,
	    UserName,
        GETUTCDATE(),
		'U',
		SUSER_SNAME()
	FROM Inserted
GO

CREATE TRIGGER dbo.tiClients ON dbo.Clients FOR INSERT
AS
SET NOCOUNT ON
	INSERT INTO dbo.ClientsHistory
	(
	    ClientId,
	    ClientName,
	    UserName,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT	    ClientId,
	    ClientName,
	    UserName,
        GETUTCDATE(),
		'I',
		SUSER_SNAME()
	FROM Inserted
GO

CREATE TRIGGER dbo.tdClients ON dbo.Clients FOR DELETE
AS
SET NOCOUNT ON
	INSERT INTO dbo.ClientsHistory
	(
	    ClientId,
	    ClientName,
	    UserName,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT	    ClientId,
	    ClientName,
	    UserName,
        GETUTCDATE(),
		'D',
		SUSER_SNAME()
	FROM Deleted
GO
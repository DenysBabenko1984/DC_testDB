CREATE TABLE [dbo].[Requests]
(
	RequestId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Requests PRIMARY KEY
	,RequestStatusId INT NOT NULL CONSTRAINT FK_Requests_StatusId FOREIGN KEY REFERENCES dbo.[RequestStatus](RequestStatusId)
	,RequestDate DATE NOT NULL
	,Comment VARCHAR(4000) NULL
	,ClientId INT NOT NULL CONSTRAINT FK_Request_ClientId FOREIGN KEY REFERENCES dbo.Clients(ClientId)
	,VersionId		ROWVERSION 
)
GO

CREATE NONCLUSTERED INDEX IX_Requests_RequestDate_ClientId ON dbo.Requests(RequestDate,ClientId)
GO

CREATE TRIGGER dbo.tuRequests ON dbo.Requests FOR UPDATE
AS
SET NOCOUNT ON
	INSERT INTO dbo.RequestsHistory
	(
	    RequestId,
	    RequestStatusId,
	    RequestDate,
	    Comment,
	    ClientId,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT	    	    
		RequestId,
	    RequestStatusId,
	    RequestDate,
	    Comment,
	    ClientId,
        GETUTCDATE(),
		'U',
		SUSER_SNAME()
	FROM Inserted
GO

CREATE TRIGGER dbo.tiRequests ON dbo.Requests FOR INSERT
AS
SET NOCOUNT ON
	INSERT INTO dbo.RequestsHistory
	(
	    RequestId,
	    RequestStatusId,
	    RequestDate,
	    Comment,
	    ClientId,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT	    	    
		RequestId,
	    RequestStatusId,
	    RequestDate,
	    Comment,
	    ClientId,
		GETUTCDATE(),
		'I',
		SUSER_SNAME()
	FROM Inserted
GO

CREATE TRIGGER dbo.tdRequests ON dbo.Requests FOR DELETE
AS
SET NOCOUNT ON
	INSERT INTO dbo.RequestsHistory
	(
	    RequestId,
	    RequestStatusId,
	    RequestDate,
	    Comment,
	    ClientId,
	    ActionDate,
	    ActionFlag,
	    ActionUser
	)
	SELECT	    	    
		RequestId,
	    RequestStatusId,
	    RequestDate,
	    Comment,
	    ClientId,
		GETUTCDATE(),
		'D',
		SUSER_SNAME()
	FROM Deleted
GO
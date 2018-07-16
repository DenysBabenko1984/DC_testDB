CREATE TABLE [dbo].[Attributes]
(
	AttributeId  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Attributes PRIMARY KEY
	,AttributeTypeId INT NOT NULL CONSTRAINT FK_Attributes_AttributeTypeId FOREIGN KEY REFERENCES dbo.[AttributeTypes](AttributeTypeId)
	,EntityId INT NOT NULL -- Reference to dbo.Clients, Accounts, Requests
	,AttributeValue VARCHAR(MAX) NOT NULL
)
GO 

ALTER TABLE dbo.Attributes ADD CONSTRAINT UQ_Attributes UNIQUE (AttributeTypeId, EntityId)
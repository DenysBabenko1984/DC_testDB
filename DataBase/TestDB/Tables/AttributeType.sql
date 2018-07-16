CREATE TABLE [dbo].[AttributeTypes]
(
	AttributeTypeId INT NOT NULL CONSTRAINT PK_AttributeTypes PRIMARY KEY
	,AttributeTypeName VARCHAR(100) NOT NULL CONSTRAINT UQ_AttributeTypes_Name UNIQUE
)
GO

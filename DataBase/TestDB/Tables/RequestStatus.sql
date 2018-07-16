CREATE TABLE [dbo].[RequestStatus]
(
	RequestStatusId INT NOT NULL CONSTRAINT PK_RequestStatus PRIMARY KEY
	,RequestStatusName VARCHAR(100) NOT NULL CONSTRAINT UQ_RequestStatus_Name UNIQUE
)
GO

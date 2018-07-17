SET NOCOUNT ON
DECLARE @SQL VARCHAR(4000) = ''

SELECT @SQL += 'GRANT EXEC ON ' +  s.name + '.' + p.name + ' TO rApprover;'
FROM sys.procedures p
INNER JOIN sys.schemas s ON s.schema_id = p.schema_id

EXECUTE (@SQL)
GO

GRANT EXECUTE ON dbo.[GetRequest] TO rRequester
GRANT EXECUTE ON dbo.[PutRequest] TO rRequester
GRANT EXECUTE ON dbo.SearchRequest TO rRequester
GO
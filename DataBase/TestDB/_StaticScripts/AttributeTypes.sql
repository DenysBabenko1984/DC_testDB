DECLARE @AdhockName VARCHAR(100) = 'AttributeTypes'
	,@AdhockUniqueId UNIQUEIDENTIFIER = '2BA6D5AC-E76D-48AC-BA6C-41C16BAF1BAA' --	SELECT NEWID()

IF NOT EXISTS (SELECT 1 FROM dbo.AdhockHistory WHERE AdhockName = @AdhockName AND UniqueId = @AdhockUniqueId)
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		;MERGE dbo.[AttributeTypes] AS T
		USING (VALUES
			(1, 'Client'), 
			(2,	'Account'), 
			(3,	'Request')
			) AS S(AttributeTypeId, AttributeTypeName)
		ON T.AttributeTypeId = S.AttributeTypeId
		WHEN NOT MATCHED THEN
			INSERT (AttributeTypeId, AttributeTypeName)
			VALUES (S.AttributeTypeId, S.AttributeTypeName)
		WHEN MATCHED THEN
			UPDATE SET 
				T.AttributeTypeName = S.AttributeTypeName
		;

		PRINT 'Adhock COMPLETED: ' + @AdhockName
		INSERT INTO dbo.AdhockHistory(AdhockName, UniqueId) VALUES(@AdhockName,@AdhockUniqueId)
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF (XACT_STATE() = -1) 
			ROLLBACK
		EXEC dbo.LogError
		THROW
	END CATCH
END ELSE 
BEGIN
	PRINT @AdhockName + ' Adhock CANCELLED. No changes for current release.'
END

GO
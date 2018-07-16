DECLARE @AdhockName VARCHAR(100) = 'RequestStatus'
	,@AdhockUniqueId UNIQUEIDENTIFIER = 'A3C028F9-3EDE-45A9-83A7-72DEF8E85939' --	SELECT NEWID()

IF NOT EXISTS (SELECT 1 FROM dbo.AdhockHistory WHERE AdhockName = @AdhockName AND UniqueId = @AdhockUniqueId)
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		;MERGE dbo.RequestStatus AS T
		USING (VALUES
			(1, 'Pending'), 
			(2,	'Accepted'), 
			(3,	'Rejected')
			) AS S(RequestStatusId, RequestStatusName)
		ON T.RequestStatusId = S.RequestStatusId
		WHEN NOT MATCHED THEN
			INSERT (RequestStatusId, RequestStatusName)
			VALUES (S.RequestStatusId, S.RequestStatusName)
		WHEN MATCHED THEN
			UPDATE SET 
				T.RequestStatusName = S.RequestStatusName
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
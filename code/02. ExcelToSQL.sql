SET NOCOUNT ON
GO

USE scrape
GO

/*
DROP TABLE IF EXISTS dbo.summary

CREATE TABLE dbo.summary
(
pkid INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
drawid INT,
recordcount INT
)

DECLARE @x INT = 1
DECLARE @y INT = 1086
DECLARE @SQLString NVARCHAR(MAX)
DECLARE @tablename NVARCHAR(MAX)

WHILE (@x <= @y)
	BEGIN
		SET @tablename = 'raw.t' + RIGHT('00000' + CAST(@x AS VARCHAR), 6)
		SET @SQLString = 'INSERT INTO dbo.summary (drawid, recordcount) SELECT drawid = ' +  CAST(@x AS VARCHAR) + ', recordcount = COUNT(1) FROM ' + @tablename
		EXEC sp_executesql @SQLString
		SET @x = @x + 1
	END


SELECT *
FROM dbo.summary
*/


DECLARE @x INT = 1
DECLARE @y INT = 1088
DECLARE @SQLString NVARCHAR(MAX)
DECLARE @tablename NVARCHAR(MAX)

DECLARE @schemaname NVARCHAR(64) = 'mersey'
DECLARE @foldername NVARCHAR(1024) = 'F:\Gorilla\history\merseyworld\'

WHILE @x <= @y
	BEGIN
		SET @tablename = 't' + RIGHT('00000' + CAST(@x AS VARCHAR), 6)
		SET @SQLString = 
		'INSERT INTO ' + @schemaname + '.' + @tablename + ' (f1, f2, f3, f4, f5)
		SELECT f1, f2, f3, f4, f5  
		FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=Yes;IMEX=1;Database=' + @foldername + '' + CAST(@x AS VARCHAR) + '.xlsx'',
		''SELECT * FROM [' + CAST(@x AS VARCHAR) + '$]'')'

		EXEC sp_executesql @SQLstring

		PRINT @x

		SET @x = @x + 1
	END
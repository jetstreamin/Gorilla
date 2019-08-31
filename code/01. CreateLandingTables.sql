USE scrape
GO

/*
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'raw')
	DROP SCHEMA raw
GO

CREATE SCHEMA mersey
GO
*/
DECLARE @SQLstring NVARCHAR(MAX)
DECLARE @tablename NVARCHAR(256)
DECLARE @x INT
DECLARE @y INT

SET @x = 1088
SET @y = 1088

WHILE (@x <= @y)
	BEGIN
		--<<Approach#1>>
		--SET @temp = @SQLstring
		--SET @temp = REPLACE(@temp,'tablename',CAST(@x AS VARCHAR))
		--PRINT @temp

		--<<Approach#2>>
		--SET @value = 't' + RIGHT('00000' + CAST(@x AS VARCHAR), 6)
		--EXEC sp_executesql @SQLstring, @ParmDefinition, @tablename = @value
		--PRINT @value

		--<<Approach#3>>
		SET @tablename = 't' + RIGHT('00000' + CAST(@x AS VARCHAR), 6)
		SET @SQLstring = N'DROP TABLE IF EXISTS mersey.' + @tablename + ' CREATE TABLE mersey.' + @tablename + ' 
		(
		pk_id INT IDENTITY(1,1) NOT NULL,
		f1 VARCHAR(MAX) NULL,
		f2 VARCHAR(MAX) NULL,
		f3 VARCHAR(MAX) NULL,
		f4 VARCHAR(MAX) NULL,
		f5 VARCHAR(MAX) NULL,
		f6 VARCHAR(MAX) NULL,
		f7 VARCHAR(MAX) NULL,
		f8 VARCHAR(MAX) NULL,
		f9 VARCHAR(MAX) NULL,
		f10 VARCHAR(MAX) NULL
		)'
		EXEC sp_executesql @SQLstring
		SET @x = @x + 1
	END


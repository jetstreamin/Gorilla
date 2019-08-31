--SELECT *
--FROM [raw].[t001086]

/*
- Download timestamp: f1, row 1
- 5B: f1, row 81 - 85
- 2L: f1, row 86 - 87 
- Winner country: f1, row 100
- Ireland claim period: 102
- DrawMachine: f1, row 106
- DrawBallSet: f1, row 107
- DrawTotalEntries: f1, row 108
- UK prize breakdown:
	f1, row 115: Number Matched (header)
	f1, row 116-127: Number Matched (data)
	f2, row 115: Prize per winner (header)
	f2, row 116-127: Prize per winner (data)
	f3, row 115: UK winners (header)
	f3, row 116-127: UK winners (data)
	f4, row 115: Prize fund amount (header)
	f4, row 116-127: Prize fund amount (data)
	f5, row 115: Total winner (header)
	f5, row 116-127: Total Winner (data)
- UK claim period: f1, 129
- French prize breakdown:
	f1, row 130: Number Matched (header)
	f1, row 131-142: Number Matched (data)
	f2, row 130: Prize per winner (header)
	f2, row 131-142: Prize per winner (data)
	f3, row 130: French winners (header)
	f3, row 131-142: French winners (data)
	f4, row 130: Prize fund amount (header)
	f4, row 131-142: Prize fund amount (data)
	f5, row 130: Total winner (header)
	f5, row 131-142: Total Winner (data)
- France claim period: f1, row 144
- Spain prize breakdown:
	f1, row 145: Number Matched (header)
	f1, row 146-157: Number Matched (data)
	f2, row 145: Prize per winner (header)
	f2, row 146-157: Prize per winner (data)
	f3, row 145: Spanish winners (header)
	f3, row 146-157: Spanish winners (data)
	f4, row 145: Prize fund amount (header)
	f4, row 146-157: Prize fund amount (data)
	f5, row 145: Total winner (header)
	f5, row 146-157: Total Winner (data)
- Spain claim period: f1, row 159

*/


/*
SET NOCOUNT ON
GO

DECLARE @x INT = 1
DECLARE @y INT = 1086
DECLARE @SQLString NVARCHAR(MAX)
DECLARE @tablename VARCHAR(MAX)

DROP TABLE IF EXISTS raw.temp
CREATE TABLE raw.temp (drawid INT, recordcount INT)


WHILE (@x <= @y)
	BEGIN
		SET @tablename = 'raw.t' + RIGHT('00000' + CAST(@x AS VARCHAR), 6)
		SET @SQLString = 'INSERT INTO raw.temp (drawid, recordcount) SELECT drawid = ' + CAST(@x AS VARCHAR) + ', [' + @tablename  + '] = COUNT(1) FROM ' + @tablename + ' WHERE f3 like ''%irish%'''
		EXEC sp_executesql @SQLstring
		SET @x = @x + 1
	END

SELECT * FROM raw.temp WHERE recordcount > 0


*/

------------------
--Draw information
-----------------
SET NOCOUNT ON

DECLARE @x INT = 1
DECLARE @y INT = 1088
DECLARE @SQLString NVARCHAR(MAX)
DECLARE @tablename VARCHAR(MAX)
DECLARE @schemaname VARCHAR(MAX)
SET @schemaname = 'mersey'

SET @SQLString = 'DROP TABLE IF EXISTS [' + @schemaname + '].[draw]
CREATE TABLE [mersey].[draw]
(
pkid INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
drawid INT NOT NULL,
tbl_pkid INT NOT NULL,
info VARCHAR(MAX) NOT NULL
)'
EXEC sp_executesql @SQLstring


WHILE (@x <= @y)
	BEGIN
		SET @tablename = '[' + @schemaname + '].t' + RIGHT('00000' + CAST(@x AS VARCHAR), 6)
		SET @SQLString = 'INSERT INTO [' + @schemaname + '].[draw] 
						SELECT	drawid = ' + CAST(@x AS VARCHAR) + ', 
								tbl_pkid = pk_id,
							info = f1 
						FROM ' + @tablename + ' 
						WHERE pk_id = 8
						
						
						--WHERE (pk_id BETWEEN 81 AND 87)
						--	OR pk_id = 1
						--	OR f1 like ''%jackpot ticket matching 5 main numbers%''
						--	OR f1 like ''%Machine Name Used%''
						--	OR f1 like ''%Ball Set Used%''
						--	OR f1 like ''%In total there were%''
						--	OR f1 like ''%purchased in%''
						--	OR f1 like ''%estimated jackpot advertised%''
							
						ORDER BY pk_id'
		EXEC sp_executesql @SQLstring
		SET @x = @x + 1
	END

/*
- Winner country: f1, row 100
- Ireland claim period: 102
- DrawMachine: f1, row 106
- DrawBallSet: f1, row 107
- DrawTotalEntries: f1, row 108

SELECT * FROM [raw].[draw] WHERE info like '%purchased in%'
SELECT * FROM [raw].[t000040]

SELECT * FROM [mersey].[t000001]

*/
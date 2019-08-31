/*
--CREATE SCHEMA staging

CREATE TABLE staging.draw
(
drawid INT NOT NULL PRIMARY KEY,
b1 TINYINT NOT NULL,
b2 TINYINT NOT NULL,
b3 TINYINT NOT NULL,
b4 TINYINT NOT NULL,
b5 TINYINT NOT NULL,
l1 TINYINT NOT NULL,
l2 TINYINT NOT NULL,
downloadtimestamp DATETIME NOT NULL,
winnercountry VARCHAR(128) NULL,
drawmachine VARCHAR(68) NULL,
drawballset VARCHAR(68) NULL,
drawtotalentries INT NULL,
jackpotuk MONEY NULL,
jackpotfrance MONEY NULL,
jackpotspain MONEY NULL,
jackpotireland MONEY NULL,
jackpotbelgium MONEY NULL,
jackpotluxembourg MONEY NULL,
jackpotswitzerland MONEY NULL,
jackpotportugal MONEY NULL,
jackpotaustria MONEY NULL)

CREATE TABLE staging.breakdown
(
pkid INT IDENTITY(1,1) NOT NULL,
drawid INT NOT NULL,
numbersmatched VARCHAR(128),
prizerperwinneruk MONEY,
prizefundamountuk MONEY,
totalwinneruk INT,
prizerperwinnerfrance MONEY,
prizefundamountfrance MONEY,
totalwinnerfrance INT,
prizerperwinnerspain MONEY,
prizefundamountspain MONEY,
totalwinnerspain INT,
prizerperwinnerbelgium MONEY,
prizefundamountbelgium MONEY,
totalwinnerbelgium INT,
prizerperwinnerportugal MONEY,
prizefundamountportugal MONEY,
totalwinnerportugal INT,
prizerperwinneraustria MONEY,
prizefundamountaustria MONEY,
totalwinneraustria INT,
prizerperwinnerluxembourg MONEY,
prizefundamountluxembourg MONEY,
totalwinnerluxembourg INT,
prizerperwinnerswitzerland MONEY,
prizefundamountswitzerland MONEY,
totalwinnerswitzerland INT,
prizerperwinnerireland MONEY,
prizefundamountireland MONEY,
totalwinnerireland INT
)*/

USE scrape
GO

SET NOCOUNT ON
GO

DROP TABLE IF EXISTS [staging].[draw]
CREATE TABLE staging.draw
(
drawid INT NOT NULL PRIMARY KEY CLUSTERED,
b1 TINYINT NOT NULL,
b2 TINYINT NOT NULL,
b3 TINYINT NOT NULL,
b4 TINYINT NOT NULL,
b5 TINYINT NOT NULL,
l1 TINYINT NOT NULL,
l2 TINYINT NOT NULL,
downloadtimestamp DATETIME NULL,
winningcountry VARCHAR(128) NULL,
drawtotalentries INT NULL,
estimatedjackpotuk MONEY NULL,
estimatedjackpotfrance MONEY NULL,
estimatedjackpotspain MONEY NULL,
estimatedjackpotireland MONEY NULL,
estimatedjackpotbelgium MONEY NULL,
estimatedjackpotluxembourg MONEY NULL,
estimatedjackpotswitzerland MONEY NULL,
estimatedjackpotportugal MONEY NULL,
estimatedjackpotaustria MONEY NULL)
GO


SET NOCOUNT ON
DECLARE @x INT = 1
DECLARE @y INT = 1086
DECLARE @SQLString NVARCHAR(MAX)
WHILE (@x <= @y)
	BEGIN
			INSERT INTO [staging].[draw] (drawid, b1, b2, b3, b4, b5, l1, l2, downloadtimestamp, drawtotalentries, estimatedjackpotuk, estimatedjackpotfrance, estimatedjackpotspain, estimatedjackpotireland, estimatedjackpotbelgium, estimatedjackpotluxembourg, estimatedjackpotswitzerland, estimatedjackpotportugal, estimatedjackpotaustria)
						SELECT drawid,
							b1 = MAX(ISNULL(b1,0)),
							b2 = MAX(ISNULL(b2,0)),
							b3 = MAX(ISNULL(b3,0)),
							b4 = MAX(ISNULL(b4,0)),
							b5 = MAX(ISNULL(b5,0)),
							l1 = MAX(ISNULL(l1,0)),
							l2 = MAX(ISNULL(l2,0)),
							downloadtimestamp = MAX(ISNULL(downloadtimestamp,'')),
							drawtotalentries = MAX(ISNULL(drawtotalentries,'')),
							estimatedjackpotuk = MAX(ISNULL(estimatedjackpotuk,0)),
							estimatedjackpotfrance = MAX(ISNULL(estimatedjackpotfrance,0)), 
							estimatedjackpotspain = MAX(ISNULL(estimatedjackpotspain,0)),
							estimatedjackpotireland = MAX(ISNULL(estimatedjackpotireland,0)),
							estimatedjackpotbelgium = MAX(ISNULL(estimatedjackpotbelgium,0)), 
							estimatedjackpotluxembourg = MAX(ISNULL(estimatedjackpotluxembourg,0)),
							estimatedjackpotswitzerland = MAX(ISNULL(estimatedjackpotswitzerland,0)), 
							estimatedjackpotportugal = MAX(ISNULL(estimatedjackpotportugal,0)),
							estimatedjackpotaustria = MAX(ISNULL(estimatedjackpotaustria,0))
						FROM (
							SELECT drawid = @x, b1 = CAST(info AS INT), b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 81 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = CAST(info AS INT), b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 82 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = CAST(info AS INT), b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 83 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = CAST(info AS INT), b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 84 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = CAST(info AS INT), l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 85 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = CAST(info AS INT), l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 86 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = CAST(info AS INT), downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 87 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = CONVERT(DATETIME, info, 103), drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND tbl_pkid = 1 UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = CAST(REPLACE(REPLACE(REPLACE(info,'In total there were ',''), ' entries into this draw from all participating countries.', ''),',','') AS INT), estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL FROM [raw].[draw] WHERE drawid = @x AND info like '%entries%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in the UK prior to the draw was £',''),',',''), '.', '') AS MONEY), estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in the UK%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in France prior to the draw was €',''),',',''), '.', '') AS MONEY), estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in France%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Spain prior to the draw was €',''),',',''), '.', '') AS MONEY), estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Spain%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Portugal prior to the draw was €',''),',',''), '.', '') AS MONEY), estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Portugal%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Belgium prior to the draw was €',''),',',''), '.', '') AS MONEY), estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Belgium%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Austria prior to the draw was €',''),',',''), '.', '') AS MONEY)  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Austria%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Belgium prior to the draw was €',''),',',''), '.', '') AS MONEY), estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Luxembourg%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = NULL, estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Switzerland prior to the draw was CHF',''),',',''), '.', '') AS MONEY), estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Switzerland%' UNION ALL
							SELECT drawid = @x, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = NULL, drawtotalentries = NULL, estimatedjackpotuk = NULL, estimatedjackpotfrance = NULL, estimatedjackpotspain = NULL, estimatedjackpotireland = CAST(REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in Ireland prior to the draw was €',''),',',''), '.', '') AS MONEY), estimatedjackpotbelgium = NULL, estimatedjackpotluxembourg = NULL, estimatedjackpotswitzerland = NULL, estimatedjackpotportugal = NULL, estimatedjackpotaustria = NULL  FROM [raw].[draw] WHERE drawid = @x AND info LIKE '%estimated jackpot advertised in Ireland%'
							) tbl
						GROUP BY drawid
		SET @x = @x + 1
	END

SELECT * FROM [staging].[draw]

/*
SELECT drawid = 1, b1 = NULL, b2 = NULL, b3 = NULL, b4 = NULL, b5 = NULL, l1 = NULL, l2 = NULL, downloadtimestamp = CAST(info AS DATETIME) 

SELECT drawid, *--REPLACE(REPLACE(REPLACE(info,'The estimated jackpot advertised in the UK prior to the draw was £',''),',',''), '.', '') 
FROM [raw].[draw] 
WHERE info like '%estimated jackpot advertised in Austria%'
ORDER BY 1

The estimated jackpot advertised in Spain prior to the draw was €15,000,000.

€
CHF

*/


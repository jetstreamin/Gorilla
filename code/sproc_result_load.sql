USE [gorilla2.0]
GO

DROP PROCEDURE IF EXISTS dbo.sp_draw_load
GO

CREATE PROCEDURE dbo.sp_draw_load
AS

SET NOCOUNT ON

--select * from tmp.stg_draw
--select * from dbo.draw

BEGIN TRY
	DECLARE @count INT
	DECLARE @maxdraw INT
	DECLARE @errormsg VARCHAR(128)

	DROP TABLE IF EXISTS tmp.stg_draw 
	DROP TABLE IF EXISTS tmp.draw

	CREATE TABLE tmp.draw
	(
	drawnumber INT NOT NULL,
	drawday CHAR(3) NOT NULL,
	drawdate DATE NOT NULL,
	dd INT NOT NULL,
	mm INT NOT NULL,
	yyyy INT NOT NULL,
	b1 TINYINT NOT NULL,
	b2 TINYINT NOT NULL,
	b3 TINYINT NOT NULL,
	b4 TINYINT NOT NULL,
	b5 TINYINT NOT NULL,
	l1 TINYINT NOT NULL,
	l2 TINYINT NOT NULL,
	jackpot DECIMAL(18,2),
	wins TINYINT
	)

	CREATE TABLE tmp.stg_draw
	(
	drawnumber VARCHAR(128),
	drawday  VARCHAR(128),
	dd  VARCHAR(128),
	mm  VARCHAR(128),
	yyyy  VARCHAR(128),
	b1 VARCHAR(128),
	b2 VARCHAR(128),
	b3 VARCHAR(128),
	b4 VARCHAR(128),
	b5 VARCHAR(128),
	l1 VARCHAR(128),
	l2 VARCHAR(128),
	jackpot VARCHAR(128),
	wins VARCHAR(128)
	)

	BULK INSERT tmp.stg_draw
	FROM 'F:\Gorilla\load\draw.csv'  
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
	)

	---------------------
	--Remove leading and trailing spaces
	---------------------
	UPDATE tmp.stg_draw
	SET drawnumber = LTRIM(RTRIM(drawnumber)),
		drawday = LTRIM(RTRIM(drawday)),
		dd = LTRIM(RTRIM(dd)),
		mm = LTRIM(RTRIM(mm)),
		yyyy = LTRIM(RTRIM(yyyy)),
		b1 = LTRIM(RTRIM(b1)),
		b2 = LTRIM(RTRIM(b2)),
		b3 = LTRIM(RTRIM(b3)),
		b4 = LTRIM(RTRIM(b4)),
		b5 = LTRIM(RTRIM(b5)),
		l1 = LTRIM(RTRIM(l1)),
		l2 = LTRIM(RTRIM(l2)),
		jackpot = LTRIM(RTRIM(jackpot)),
		wins = LTRIM(RTRIM(wins))

	UPDATE tmp.stg_draw
	SET mm = CASE WHEN mm = 'Jan' THEN '01'
				WHEN mm = 'Feb' THEN '02'
				WHEN mm = 'Mar' THEN '03'
				WHEN mm = 'Apr' THEN '04'
				WHEN mm = 'May' THEN '05'
				WHEN mm = 'Jun' THEN '06'
				WHEN mm = 'Jul' THEN '07'
				WHEN mm = 'Aug' THEN '08'
				WHEN mm = 'Sep' THEN '09'
				WHEN mm = 'Oct' THEN '10'
				WHEN mm = 'Nov' THEN '11'
				WHEN mm = 'Dec' THEN '12'
				ELSE 'X' END 


	---------------------
	--Data quality checks
	---------------------
	--1) non-numeric values in drawnumber
	IF EXISTS (SELECT * FROM tmp.stg_draw WHERE ISNUMERIC(drawnumber) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in column drawnumber. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END	

	--2) Record count coincides with max draw number
	SET @count = (SELECT COUNT(1) FROM tmp.stg_draw)
	SET @maxdraw = (SELECT MAX(CAST(drawnumber AS INT)) FROM tmp.stg_draw)
	IF (@count <> @maxdraw)
		BEGIN
			SET @errormsg = 'Record count (' + CAST(@count AS VARCHAR) + ') and max draw number (' + CAST(@maxdraw AS VARCHAR) + ') are different. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--3) valid drawday values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE LOWER(drawday) NOT IN ('tue','Fri'))
		BEGIN
			SET @errormsg = 'There is at least a value in drawday column that does not correspond to valid weekday values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--4) valid dd values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(dd) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in dd column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(dd AS INT) BETWEEN 1 AND 31)
		BEGIN
			SET @errormsg = 'There is at least a value in dd column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--5) valid mmm values
	IF EXISTS (SELECT * FROM tmp.stg_draw WHERE ISNUMERIC(mm) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in mm column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(mm AS INT) BETWEEN 1 AND 12)
		BEGIN
			SET @errormsg = 'There is at least a value in mm column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--6) valid yyyy values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(yyyy) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in yyyy column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(yyyy AS INT) >= 2004)
		BEGIN
			SET @errormsg = 'There is at least a value in yyyy column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--7) valid b1 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(b1) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in b1 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(b1 AS INT) BETWEEN 1 AND 50)
		BEGIN
			SET @errormsg = 'There is at least a value in b1 column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--8) valid b2 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(b2) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in b2 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(b2 AS INT) BETWEEN 1 AND 50)
		BEGIN
			SET @errormsg = 'There is at least a value in b2 column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--9) valid b3 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(b3) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in b3 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(b3 AS INT) BETWEEN 1 AND 50)
		BEGIN
			SET @errormsg = 'There is at least a value in b3 column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--10) valid b4 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(b4) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in b4 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(b4 AS INT) BETWEEN 1 AND 50)
		BEGIN
			SET @errormsg = 'There is at least a value in b4 column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--11) valid b5 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(b5) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in b5 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(b5 AS INT) BETWEEN 1 AND 50)
		BEGIN
			SET @errormsg = 'There is at least a value in b5 column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--12) valid l1 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(l1) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in 11 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM tmp.stg_draw WHERE CAST(l1 AS INT) BETWEEN 1 AND 12)
		BEGIN
			SET @errormsg = 'There is at least a value in l1 column that does not correspond to valid dd values. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END


	--13) valid l2 values
	IF EXISTS (SELECT drawday FROM tmp.stg_draw WHERE ISNUMERIC(l2) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a non-numeric value in 12 column. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--14) valid jackpot value
	IF EXISTS (SELECT * FROM tmp.stg_draw WHERE ISNUMERIC(jackpot) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a value in jackpot column that does not correspond to a numeric value. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	--14) valid jackpot value
	IF EXISTS (SELECT * FROM tmp.stg_draw WHERE ISNUMERIC(wins) <> 1)
		BEGIN
			SET @errormsg = 'There is at least a value in wins column that does not correspond to a numeric value. Please check the csv file'
			RAISERROR(@errormsg, 16, 1);
		END

	---------------------
	--Data load
	---------------------
	INSERT INTO tmp.draw (drawnumber, drawday, drawdate, dd, mm, yyyy, b1, b2, b3, b4, b5, l1, l2, jackpot, wins)
	SELECT drawnumber = CAST(drawnumber AS INT), 
			drawday = CAST(drawday AS CHAR(3)), 
			drawdate = CAST((yyyy + '-' + mm + '-' + dd) AS DATE), 
			dd = CAST(dd AS INT), 
			mm = CAST(mm AS INT), 
			yyyy = CAST(yyyy AS INT),
			b1 = CAST(b1 AS TINYINT),
			b2 = CAST(b2 AS TINYINT), 
			b3 = CAST(b3 AS TINYINT), 
			b4 = CAST(b4 AS TINYINT), 
			b5 = CAST(b5 AS TINYINT), 
			l1 = CAST(l1 AS TINYINT), 
			l2 = CAST(l2 AS TINYINT),
			jackpot = CAST(jackpot AS DECIMAL(18,2)),
			wins = CAST(wins AS TINYINT)
	FROM tmp.stg_draw
	ORDER BY CAST(drawnumber AS INT)

	INSERT INTO dbo.draw (drawid, drawdate, dow, n1, n2, n3, n4, n5, l1, l2, jackpot, wins)
	SELECT d.drawnumber, d.drawdate, d.drawday, d.b1, d.b2, d.b3, d.b4, d.b5, d.l1, d.l2, d.jackpot, d.wins
	FROM tmp.draw d
		LEFT JOIN dbo.draw g ON d.drawnumber = g.DrawID 
	WHERE g.DrawID IS NULL
	ORDER BY 1 ASC



END TRY
BEGIN CATCH  
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  

    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  

    -- Use RAISERROR inside the CATCH block to return error  
    -- information about the original error that caused  
    -- execution to jump to the CATCH block.  
    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
END CATCH; 
GO

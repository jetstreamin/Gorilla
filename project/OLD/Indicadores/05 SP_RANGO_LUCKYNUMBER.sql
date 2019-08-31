USE Gorilla
GO

SET NOCOUNT ON

DECLARE @rango_size TINYINT
DECLARE @i SMALLINT, @j SMALLINT, @desde SMALLINT, @hasta SMALLINT
DECLARE @numero_sorteos SMALLINT

CREATE TABLE #TEMP_RANGO_VALUES
	(desde SMALLINT,
	hasta SMALLINT
	)
	
CREATE TABLE #TEMP_NUMERO
	(desde SMALLINT,
	hasta SMALLINT,
	L1 TINYINT,
	L2 TINYINT,
	ocurrencia INT,
	)
	
SET @rango_size = 10
SET @i = 1 + 2 + 3 + 4 + 5
SET @j = 46 + 47 + 48 + 49 + 50
SET @numero_sorteos = (SELECT x=COUNT(1) FROM dbo.winner)

WHILE (@i<@j)
	BEGIN
		INSERT #TEMP_RANGO_VALUES (desde, hasta) 
		SELECT @i, (CASE WHEN @i + @rango_size <= @j THEN (@i + @rango_size - 1) ELSE @j END)
		SET @i = @i + (@rango_size )
	END

SELECT *
INTO #TEMP_WINNER
FROM winner 

CREATE INDEX IX_sum_total ON #TEMP_WINNER (sum_total)


DECLARE batch_cursor CURSOR FOR 
SELECT desde, hasta
FROM #TEMP_RANGO_VALUES

OPEN batch_cursor
FETCH NEXT FROM batch_cursor INTO @desde, @hasta
WHILE ( @@fetch_status = 0 )
	BEGIN
		INSERT INTO #TEMP_NUMERO(desde, hasta, L1, L2, ocurrencia)
		SELECT desde = @desde, hasta = @hasta, L1, L2, ocurrencia = COUNT(1)
		FROM #TEMP_WINNER
		WHERE sum_total BETWEEN @desde AND @hasta
		GROUP BY L1, L2
	
		FETCH NEXT FROM batch_cursor INTO @desde, @hasta
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor	

SELECT * FROM #TEMP_NUMERO ORDER BY L1, L2 DESC

SELECT L1, L2, x= COUNT(1)
FROM #TEMP_WINNER
GROUP BY L1, L2 
ORDER BY 3 DESC


DROP TABLE #TEMP_NUMERO
DROP TABLE #TEMP_WINNER
DROP TABLE #TEMP_RANGO_VALUES 
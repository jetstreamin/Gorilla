USE Gorilla
GO

SET NOCOUNT ON

DECLARE @rango_size TINYINT
DECLARE @i SMALLINT, @j SMALLINT, @desde SMALLINT, @hasta SMALLINT
DECLARE @numero_sorteos SMALLINT

CREATE TABLE #TEMP_RANGO_VALUES
	(desde SMALLINT,
	hasta SMALLINT,
	distancia_promedio INT DEFAULT 0
	)
	
CREATE TABLE #TEMP_DISTANCIA_DETALLE
	(desde SMALLINT,
	hasta SMALLINT,
	D1 INT,
	D2 INT,
	D3 INT,
	D4 INT
	)	
	
SET @rango_size = 10
SET @i = 1 + 2 + 3 + 4 + 5
SET @j = 46 + 47 + 48 + 49 + 50
SET @numero_sorteos = (SELECT x=COUNT(1) FROM dbo.winner)

WHILE (@i<@j)
	BEGIN
		INSERT #TEMP_RANGO_VALUES (desde, hasta) SELECT @i, (CASE WHEN @i + @rango_size <= @j THEN @i + @rango_size - 1 ELSE @j END)
		SET @i = @i + @rango_size
	END


SELECT sum_total, N1, N2, N3, N4, N5
INTO #TEMP_WINNER
FROM winner


DECLARE batch_cursor CURSOR FOR 
SELECT desde, hasta
FROM #TEMP_RANGO_VALUES


OPEN batch_cursor
FETCH NEXT FROM batch_cursor INTO @desde, @hasta
WHILE ( @@fetch_status = 0 )
	BEGIN
		INSERT INTO #TEMP_DISTANCIA_DETALLE(desde, hasta, D1, D2, D3, D4)
		SELECT desde = @desde, hasta = @hasta,
				D1 = N2 - N1, 
				D2 = N3 - N2,
				D3 = N4 - N3,
				D4 = N5 - N4
		FROM #TEMP_WINNER
		WHERE sum_total BETWEEN @desde AND @hasta
		
		FETCH NEXT FROM batch_cursor INTO @desde, @hasta
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor	


--INSERT INTO #TEMP_DISTANCIA_RESUMEN (desde, hasta, D1, D2, D3, D4, ocurrencia, porcentaje)
SELECT desde, hasta, D1, D2, D3, D4, ocurrencia = COUNT(1), porcentaje = CONVERT(MONEY,COUNT(1)) * 100 / @numero_sorteos
FROM #TEMP_DISTANCIA_DETALLE
GROUP BY desde, hasta, D1, D2, D3, D4

SELECT D1, D2, D3, D4, ocurrencia = COUNT(1), porcentaje = CONVERT(MONEY,COUNT(1)) * 100 / @numero_sorteos
FROM #TEMP_DISTANCIA_DETALLE
GROUP BY D1, D2, D3, D4
ORDER BY 5 DESC

SELECT desde, hasta,
		D1_P = SUM(D1)/COUNT(1), 
		D2_P = SUM(D2)/COUNT(1),  
		D3_P = SUM(D3)/COUNT(1),   
		D4_P = SUM(D4)/COUNT(1)
FROM #TEMP_DISTANCIA_DETALLE
GROUP BY desde, hasta

SELECT desde, hasta, x = CONVERT(MONEY,SUM(D1+D2+D3+D4))/(COUNT(1)*4)--
FROM #TEMP_DISTANCIA_DETALLE
GROUP BY desde, hasta



DROP TABLE #TEMP_WINNER
DROP TABLE #TEMP_RANGO_VALUES
DROP TABLE #TEMP_DISTANCIA_DETALLE


--SELECT *
--FROM ticket (noLock)
--WHERE (sum_total BETWEEN 120 AND 135)
--	AND (CONVERT(INT,N2)-N1=19 AND
--		CONVERT(INT,N3)-N2=2 AND
--		CONVERT(INT,N4)-N3=15 AND
--		CONVERT(INT,N5)-N4=9
--		)
		
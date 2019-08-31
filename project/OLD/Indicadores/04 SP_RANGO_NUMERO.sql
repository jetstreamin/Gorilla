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
	numero TINYINT,
	ocurrencia INT,
	)

CREATE TABLE #TEMP_NUMERO_DOBLE
	(desde SMALLINT,
	hasta SMALLINT,
	numero1 TINYINT,
	numero2 TINYINT,
	ocurrencia INT
	)

CREATE TABLE #TEMP_NUMERO_TRIPLE
	(desde SMALLINT,
	hasta SMALLINT,
	numero1 TINYINT,
	numero2 TINYINT,
	numero3 TINYINT,
	ocurrencia INT
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
		INSERT INTO #TEMP_NUMERO(desde, hasta, numero, ocurrencia)
		SELECT desde, hasta, numero, ocurrencia = COUNT(1)
		FROM (
			SELECT desde = @desde, hasta = @hasta, numero = N1
			FROM #TEMP_WINNER
			WHERE sum_total BETWEEN @desde AND @hasta
			UNION ALL
			SELECT desde = @desde, hasta = @hasta, numero = N2
			FROM #TEMP_WINNER
			WHERE sum_total BETWEEN @desde AND @hasta	
			UNION ALL
			SELECT desde = @desde, hasta = @hasta, numero = N3
			FROM #TEMP_WINNER
			WHERE sum_total BETWEEN @desde AND @hasta
			UNION ALL
			SELECT desde = @desde, hasta = @hasta, numero = N4
			FROM #TEMP_WINNER
			WHERE sum_total BETWEEN @desde AND @hasta		
			UNION ALL
			SELECT desde = @desde, hasta = @hasta, numero = N5
			FROM #TEMP_WINNER
			WHERE sum_total BETWEEN @desde AND @hasta		
			) A
		GROUP BY desde, hasta, numero
		
		INSERT INTO #TEMP_NUMERO_DOBLE(desde, hasta, numero1, numero2, ocurrencia)
		SELECT DISTINCT desde, hasta, numero1, numero2, ocurrencia = COUNT(1)
		FROM (	SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 = N2
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta		
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 = N3
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta			
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 = N4
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta			
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N2, numero2 = N3
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N2, numero2 = N4
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N2, numero2 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta			
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N3, numero2 = N4
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N3, numero2 =  N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N4, numero2 =  N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta
			) A
		WHERE NOT EXISTS (SELECT 1 FROM #TEMP_NUMERO_DOBLE X WHERE A.numero1 = X.numero1 AND A.numero2 = X.numero2)
		GROUP BY desde, hasta, numero1, numero2
		
		
		INSERT INTO #TEMP_NUMERO_TRIPLE(desde, hasta, numero1, numero2, numero3, ocurrencia)
		SELECT desde, hasta, numero1, numero2, numero3, ocurrencia = COUNT(1)
		FROM (	SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N2, numero3 = N3
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N2, numero3 = N3
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta		
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N2, numero3 = N4
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta				
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N2, numero3 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta			
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N3, numero3 = N4
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N3, numero3 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta					
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N1, numero2 =  N4, numero3 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N2, numero2 =  N3, numero3 = N4
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N2, numero2 =  N3, numero3 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta	
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N2, numero2 =  N4, numero3 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta									
				UNION ALL
				SELECT desde = @desde, hasta = @hasta, numero1 = N3, numero2 =  N4, numero3 = N5
				FROM #TEMP_WINNER
				WHERE sum_total BETWEEN @desde AND @hasta
			) A
		WHERE NOT EXISTS (SELECT 1 FROM #TEMP_NUMERO_TRIPLE X WHERE A.numero1 = X.numero1 AND A.numero2 = X.numero2 AND A.numero3 = X.numero3)
		GROUP BY desde, hasta, numero1, numero2, numero3
			
		
		
		
		FETCH NEXT FROM batch_cursor INTO @desde, @hasta
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor	


SELECT  desde,
		hasta,
		[1] = ISNULL([1],0), [2]= ISNULL([2],0), [3]= ISNULL([3],0), [4]= ISNULL([4],0), [5]= ISNULL([5],0), [6]= ISNULL([6],0), [7]= ISNULL([7],0), [8]= ISNULL([8],0), [9]= ISNULL([9],0), [10]= ISNULL([10],0),
		[11] = ISNULL([11],0), [12] = ISNULL([12],0), [13] = ISNULL([13],0), [14] = ISNULL([14],0), [15] = ISNULL([15],0), [16] = ISNULL([16],0), [17] = ISNULL([17],0), [18] = ISNULL([18],0), [19] = ISNULL([19],0), [20] = ISNULL([20],0),
		[21] = ISNULL([21],0), [22] = ISNULL([22],0), [23] = ISNULL([23],0), [24] = ISNULL([24],0), [25] = ISNULL([25],0), [26] = ISNULL([26],0), [27] = ISNULL([27],0), [28] = ISNULL([28],0), [29] = ISNULL([29],0), [30] = ISNULL([30],0),
		[31] = ISNULL([31],0), [32] = ISNULL([32],0), [33] = ISNULL([33],0), [34] = ISNULL([34],0), [35] = ISNULL([35],0), [36] = ISNULL([36],0), [37] = ISNULL([37],0), [38] = ISNULL([38],0), [39] = ISNULL([39],0), [40] = ISNULL([40],0),
		[41] = ISNULL([41],0), [42] = ISNULL([42],0), [43] = ISNULL([43],0), [44] = ISNULL([44],0), [45] = ISNULL([45],0), [46] = ISNULL([46],0), [47] = ISNULL([47],0), [48] = ISNULL([48],0), [49] = ISNULL([49],0), [50] = ISNULL([50],0)
FROM    
		( 	SELECT desde, hasta, numero, ocurrencia
			FROM #TEMP_NUMERO
        ) p PIVOT ( SUM([ocurrencia])
                    FOR numero IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10],
								[11], [12], [13], [14], [15], [16], [17], [18], [19], [20],
								[21], [22], [23], [24], [25], [26], [27], [28], [29], [30],
								[31], [32], [33], [34], [35], [36], [37], [38], [39], [40],
								[41], [42], [43], [44], [45], [46], [47], [48], [49], [50]
										) ) AS pvt


SELECT * FROM #TEMP_NUMERO_DOBLE ORDER BY 5 DESC

SELECT numero1, numero2, ocurrencia = SUM(ocurrencia)
FROM #TEMP_NUMERO_DOBLE 
GROUP BY numero1, numero2
ORDER BY 3 DESC

SELECT * FROM #TEMP_NUMERO_TRIPLE ORDER BY 6 DESC

SELECT numero1, numero2, numero3, ocurrencia = SUM(ocurrencia)
FROM #TEMP_NUMERO_TRIPLE 
GROUP BY numero1, numero2, numero3
ORDER BY 4 DESC

DECLARE @n1 TINYINT
DECLARE @n2 TINYINT
DECLARE @n3 TINYINT
SELECT @n1 = 4, @n2 = 23, @n3 = 24

SELECT *
FROM #TEMP_winner
WHERE (N1 = @n1 OR N2 = @n1 OR N3 = @n1 OR N5 = @n1)
	AND (N1 = @n2 OR N2 = @n2 OR N3 = @n2 OR N5 = @n2)
	AND (N1 = @n2 OR N2 = @n2 OR N3 = @n2 OR N5 = @n2)

DROP TABLE #TEMP_NUMERO_DOBLE
DROP TABLE #TEMP_NUMERO_TRIPLE
DROP TABLE #TEMP_WINNER
DROP TABLE #TEMP_RANGO_VALUES
DROP TABLE #TEMP_NUMERO



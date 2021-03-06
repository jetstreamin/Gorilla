USE gorilla
GO

--sp_updatestats

DECLARE @distanciaX INT
DECLARE @distanciaY INT
DECLARE @rangoX INT
DECLARE @rangoY INT
DECLARE @min_distance INT
DECLARE @N1 SMALLINT
DECLARE @N2 SMALLINT
DECLARE @N3 SMALLINT
DECLARE @N4 SMALLINT
DECLARE @N5 SMALLINT
DECLARE @min_step INT
DECLARE @max_step INT
DECLARE @i INT
DECLARE @D1 SMALLINT
DECLARE @D2 SMALLINT
DECLARE @D3 SMALLINT
DECLARE @D4 SMALLINT

CREATE TABLE #TEMP_WINNING_NOT_TO_PLAY
(
	X1 SMALLINT,
	X2 SMALLINT,
	X3 SMALLINT,
	X4 SMALLINT,
	X5 SMALLINT
)

CREATE TABLE #TEMP_WINNING_DISTANCES
(
	D1 SMALLINT,
	D2 SMALLINT,
	D3 SMALLINT,
	D4 SMALLINT
)

CREATE TABLE #TEMP_tents
	(
	[1_10] INT,
	[11_20] INT,
	[21_30] INT,
	[31_40] INT,
	[41_50] INT
	)
	
	
CREATE TABLE #TEMP_WINNER
	(
	pk_id INT,
	sum_total INT
	)

INSERT INTO #TEMP_tents
SELECT TOP 20  [1_10], [11_20], [21_30], [31_40], [41_50]
FROM winner (noLock)
ORDER BY pk_id DESC



INSERT INTO #TEMP_WINNER (pk_id, sum_total)
SELECT TOP 10 pk_id, sum_total
FROM winner (noLock)
ORDER BY pk_id DESC


SET @distanciaX = 2
SET @distanciaY = 13
SET @rangoX = 90
SET @rangoY = 160
SET @min_distance = 15
SET @min_step = -50
SET @max_step = 50


CREATE INDEX IX_WNTP ON #TEMP_WINNING_NOT_TO_PLAY(X1,X2,X3,X4,X5)
CREATE INDEX IX_DIS ON #TEMP_WINNING_DISTANCES(D1, D2, D3, D4)


DECLARE batch_cursor CURSOR FOR 
SELECT	N1, N2, N3, N4, N5
FROM winner (noLock)

OPEN batch_cursor
FETCH NEXT FROM batch_cursor INTO @N1, @N2, @N3, @N4, @N5
WHILE ( @@fetch_status = 0 )
	BEGIN
		SET @i = @min_step
		WHILE (@i<=@max_step)
			BEGIN
				INSERT INTO #TEMP_WINNING_NOT_TO_PLAY (X1,X2,X3,X4,X5)
				SELECT @N1+@i, @N2+@i, @N3+@i, @N4+@i, @N5+@i UNION ALL
				SELECT @N1+@i, @N2+@i+1, @N3+@i+2, @N4+@i+3, @N5+@i+4
				
				SET @i = @i + 1
			END
		FETCH NEXT FROM batch_cursor INTO @N1, @N2, @N3, @N4, @N5
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor


DECLARE batch_cursor CURSOR FOR 
SELECT	D1, D2, D3, D4
FROM winner (noLock)

OPEN batch_cursor
FETCH NEXT FROM batch_cursor INTO @D1, @D2, @D3, @D4
WHILE ( @@fetch_status = 0 )
	BEGIN
		SET @i = @min_step
		WHILE (@i<=@max_step)
			BEGIN
				INSERT INTO #TEMP_WINNING_DISTANCES (D1, D2, D3, D4)
				SELECT @D1, @D2, @D3, @D4 UNION ALL
				SELECT @D1+@i, @D2+@i, @D3+@i, @D4+@i
				
				SET @i = @i + 1
			END
		FETCH NEXT FROM batch_cursor INTO @D1, @D2, @D3, @D4
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor



SELECT pk_id, n1, n2, n3, n4, n5
INTO #TEMP_RESULTS
FROM dbo.ticket A (noLock)
WHERE 
	--OK (100%)				
	--1.Excluir tickets ganadores
	NOT EXISTS (SELECT 1 FROM dbo.winner X (noLock) WHERE A.pk_id = X.ticket_id)

	--OK (100%)
	--2.Excluir tickets con todas las distancias iguales
	AND NOT (D1 = D2 AND D2 = D3 AND D3 = D4)

	--OK (90-160) (75%)
	--3. Incluir tickets cuya suma de numeros este dentro de un rango
	AND (sum_total BETWEEN @rangoX AND @rangoY)
	
	--OK (1,2,3,4) (91%)
	--4. Incluir tickets por cantidad de numeros pares/impares
	AND (number_even IN (1,2,3,4) AND number_odd IN (1,2,3,4))
	
	--OK (99%)
	--5. Excluir distancias aparecidas (D1, D2, D3, D4), (D1 + x, D2 + x, D3 + x, D4 + x), (D1 + x, D2 + x, D3 + x). x [-10,10]
	AND NOT EXISTS (SELECT 1 FROM #TEMP_WINNING_DISTANCES Y WHERE Y.D1 = A.D1 AND Y.D2 = A.D2 AND Y.D3 = A.D3 AND Y.D4 = A.D4)

	--OK (95%)
	--6. Excluir distancias aparecidas (D1, D2, D3)
	AND NOT EXISTS (SELECT 1 FROM #TEMP_WINNING_DISTANCES Z WHERE Z.D1 = A.D1 AND Z.D2 = A.D2 AND Z.D3 = A.D3)

	--OK (100%)
	--7. Excluir (D1 + @step) = D2 AND (D2 + @step) = D3 AND (D3 + @step) = D4
	AND NOT EXISTS (SELECT 1 FROM #TEMP_WINNING_DISTANCES M WHERE M.D1 = A.D2 AND M.D2 = A.D3 AND M.D3 = A.D4)

	--OK (100%)
	--8. Excluir cuartetos aparecidos
	AND NOT EXISTS (SELECT 1 FROM CHUNK_QUADRUPLET (noLock) WHERE	(C1 = A.N1 AND C2 = A.N2 AND C3 = A.N3 AND C4 = A.N4)) 
	AND NOT EXISTS (SELECT 1 FROM CHUNK_QUADRUPLET (noLock) WHERE	(C1 = A.N1 AND C2 = A.N2 AND C3 = A.N3 AND C4 = A.N5)) 
	AND NOT EXISTS (SELECT 1 FROM CHUNK_QUADRUPLET (noLock) WHERE	(C1 = A.N1 AND C2 = A.N3 AND C3 = A.N4 AND C4 = A.N5)) 
	AND NOT EXISTS (SELECT 1 FROM CHUNK_QUADRUPLET (noLock) WHERE	(C1 = A.N2 AND C2 = A.N3 AND C3 = A.N4 AND C4 = A.N5)) 
	AND NOT EXISTS (SELECT 1 FROM CHUNK_QUADRUPLET (noLock) WHERE	(C1 = A.N1 AND C2 = A.N2 AND C3 = A.N4 AND C4 = A.N5)) 

	--OK (100%)
	--9. Excluir triples aparecidos
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N1 AND T2 = A.N2 AND T3 = A.N3))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N1 AND T2 = A.N2 AND T3 = A.N4))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N1 AND T2 = A.N2 AND T3 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N1 AND T2 = A.N3 AND T3 = A.N4))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N1 AND T2 = A.N3 AND T3 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N1 AND T2 = A.N4 AND T3 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N2 AND T2 = A.N3 AND T3 = A.N4))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N2 AND T2 = A.N3 AND T3 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N2 AND T2 = A.N4 AND T3 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_TRIPLET (noLock) WHERE	(T1 = A.N3 AND T2 = A.N4 AND T3 = A.N5))

	--OK (90%)
	--10. Excluir dobles aparecidos en los ultimos 5 sorteos
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N1 AND D2 = A.N2))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N1 AND D2 = A.N3))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N1 AND D2 = A.N4))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N1 AND D2 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N2 AND D2 = A.N3))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N2 AND D2 = A.N4))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N2 AND D2 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N3 AND D2 = A.N4))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N3 AND D2 = A.N5))
	AND NOT EXISTS (SELECT 1 FROM CHUNK_DOUBLET (noLock) WHERE	(D1 = A.N4 AND D2 = A.N5))

	--10. Excluir (N1+x), (N2+x), (N3+x), (N4+x), (N5+x), x [-10, 10], (N1+v), (N2+w), (N3+x), (N4+y), (N5+z), v,w,x,y,z [1,2,3,4,5]
	AND NOT EXISTS (SELECT 1 FROM #TEMP_WINNING_NOT_TO_PLAY W (noLock) WHERE A.n1 = W.X1 AND A.n2 = W.X2 AND A.n3 = W.X3 AND A.n4 = W.X4 AND A.n5 = W.X5)

	--11. Exclude sum_distance > 25
	AND (sum_distance > @min_distance)

	--12. Excluir las 10 ultimas sum_total
	AND NOT EXISTS (SELECT 1 FROM #TEMP_WINNER AA WHERE AA.sum_total = A.sum_total)

	--13. Excluir ultimos 20 decenas
	AND NOT EXISTS (SELECT 1 FROM #TEMP_tents AB WHERE AB.[1_10] = A.[1_10] AND AB.[11_20] = A.[11_20] AND AB.[21_30] = A.[21_30] AND AB.[31_40] = A.[31_40] AND AB.[41_50] = A.[41_50])


ORDER BY n1, n2, n3, n4, n5

--TRUNCATE TABLE TEMP_PREVIEW_RESULTS
--INSERT INTO TEMP_PREVIEW_RESULTS (N1, N2, N3, N4, N5)

--SELECT n1, n2, n3=MAX(n4), n4=MAX(n4), n5=MAX(n5)
--FROM #TEMP_RESULTS
--group by n1, n2
--ORDER BY 1,2,3,4,5

2qt


/*
SELECT n1, n2, n3 = MAX(n3), n4 = MAX(n4), n5 = MAX(n5), x = COUNT(1)
FROM #TEMP_RESULTS
GROUP BY n1, n2
ORDER BY 6 DESC

SELECT *
FROM #TEMP_RESULTS
ORDER BY n1, n2, n3, n4, n5
*/

DROP TABLE #TEMP_WINNING_NOT_TO_PLAY
DROP TABLE #TEMP_WINNING_DISTANCES
--DROP TABLE #TEMP_RESULTS
DROP TABLE #TEMP_WINNER
DROP TABLE #TEMP_tents



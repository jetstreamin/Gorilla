USE gorilla
GO

--Playing TOP 5 MOST FRECUENT RANGE (135-144, 105-114, 115-124, 125-134,95-104)
--Playing TOP 2 MOST FRECUENT EVEN-ODD COMBINATION (2-3, 3-2)
--Not playing draw tickets
--Not playing tickets with consecutives numbers
--Playing Avg Number Distance between 8 AND 9
--No jugar distancias que hayan salido
--No jugar los dobles o triples mas comunes

/*

SELECT COUNT(*)
FROM ticket A (noLock)
WHERE sum_total BETWEEN 135 AND 144
	AND ((number_even = 2 AND number_odd = 3) OR (number_even = 3 AND number_odd = 2))
	AND NOT EXISTS (SELECT 1 FROM winner X WHERE A.pk_id = X.ticket_id)
	AND avg_distance BETWEEN @distanceFrom AND @distanceTo
--	AND (n2-n1 > @distance AND n3-n2 > @distance AND n4-n3 > @distance AND n5-n4 > @distance)
*/

DECLARE @distanciaX INT
DECLARE @distanciaY INT
DECLARE @rangoX INT
DECLARE @rangoY INT
DECLARE @n1 tinyint, @n2 tinyint, @n3 tinyint, @n4 tinyint, @n5 tinyint
DECLARE @n1_2 tinyint, @n2_2 tinyint, @n3_2 tinyint, @n4_2 tinyint, @n5_2 tinyint
DECLARE @pk_id BIGINT, @pk_id_2 BIGINT
DECLARE @hits INT
DECLARE @i INT
DECLARE @j INT
DECLARE @sum1 INT, @sum2 INT, @sum3 INT, @sum4 INT, @sum5 INT
DECLARE @tickets INT


CREATE TABLE #TEMP_RESULTS (
	N1 TINYINT,
	N2 TINYINT,
	N3 TINYINT,
	N4 TINYINT,
	N5 TINYINT,
	hits SMALLINT,
	tickets SMALLINT
)

--CREATE TABLE #TEMP_RESULSET (
--	N1 TINYINT,
--	N2 TINYINT,
--	N3 TINYINT,
--	N4 TINYINT,
--	N5 TINYINT,
--)




--SET @distanciaX = 6
--SET @distanciaY = 13
--SET @rangoX = 95
--SET @rangoY = 145



SELECT @i = 1, @j = 1

DECLARE batch_cursor CURSOR FOR 
SELECT pk_id, n1, n2, n3, n4, n5
FROM TEMP_PREVIEW_RESULTS

OPEN batch_cursor
FETCH NEXT FROM batch_cursor INTO @pk_id, @n1, @n2, @n3, @n4, @n5
WHILE ( @@fetch_status = 0 )
	BEGIN
		PRINT @i
		SELECT @hits = 0, @tickets = 0
		
		SET @tickets = ((SELECT X=COUNT(1) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N1 = @n1 OR N1 = @n2 OR N1 = @n3 OR N1 = @n4 OR N1 = @N5)) +
						(SELECT X=COUNT(1) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N2 = @n1 OR N2 = @n2 OR N2 = @n3 OR N2 = @n4 OR N2 = @N5)) +
						(SELECT X=COUNT(1) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N3 = @n1 OR N3 = @n2 OR N3 = @n3 OR N3 = @n4 OR N3 = @N5)) +
						(SELECT X=COUNT(1) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N4 = @n1 OR N4 = @n2 OR N4 = @n3 OR N4 = @n4 OR N4 = @N5)) +
						(SELECT X=COUNT(1) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N5 = @n1 OR N5 = @n2 OR N5 = @n3 OR N5 = @n4 OR N5 = @N5)))
		
	
		SET @hits = (	(SELECT X = SUM(CASE WHEN n1 = @n1 OR n1 = @n2 OR n1 = @n3 OR n1 = @n4 OR n1 = @n5 THEN 1 ELSE 0 END) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N1 = @n1 OR N1 = @n2 OR N1 = @n3 OR N1 = @n4 OR N1 = @N5)) +
						(SELECT X = SUM(CASE WHEN n2 = @n1 OR n2 = @n2 OR n2 = @n3 OR n2 = @n4 OR n2 = @n5 THEN 1 ELSE 0 END) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N2 = @n1 OR N2 = @n2 OR N2 = @n3 OR N2 = @n4 OR N2 = @N5)) +
						(SELECT X = SUM(CASE WHEN n3 = @n1 OR n3 = @n2 OR n3 = @n3 OR n3 = @n4 OR n3 = @n5 THEN 1 ELSE 0 END) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N3 = @n1 OR N3 = @n2 OR N3 = @n3 OR N3 = @n4 OR N3 = @N5)) +
						(SELECT X = SUM(CASE WHEN n4 = @n1 OR n4 = @n2 OR n4 = @n3 OR n4 = @n4 OR n4 = @n5 THEN 1 ELSE 0 END) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N4 = @n1 OR N4 = @n2 OR N4 = @n3 OR N4 = @n4 OR N4 = @N5)) +
						(SELECT X = SUM(CASE WHEN n5 = @n1 OR n5 = @n2 OR n5 = @n3 OR n5 = @n4 OR n5 = @n5 THEN 1 ELSE 0 END) FROM TEMP_PREVIEW_RESULTS (noLock) WHERE pk_id <> @pk_id AND (N5 = @n1 OR N5 = @n2 OR N5 = @n3 OR N5 = @n4 OR N5 = @N5)))
		
		--DROP TABLE #TEMP_RESULSET
			
		INSERT INTO #TEMP_RESULTS (N1, N2, N3, N4, N5, hits, tickets)
		SELECT @n1, @n2, @n3, @n4, @n5, @hits, @tickets
		
		SET @i = @i + 1
		FETCH NEXT FROM batch_cursor INTO @pk_id, @n1, @n2, @n3, @n4, @n5
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor	

--TRUNCATE TABLE TEMP
--INSERT INTO TEMP(N1, N2, N3, N4, N5, hits, tickets)
SELECT N1, N2, N3, N4, N5, hits, tickets 
FROM #TEMP_RESULTS
ORDER BY hits DESC


SELECT N1, N2, N3, N4, N5, hits, tickets 
FROM #TEMP_RESULTS
WHERE 
	N1 NOT IN (2,5,7,39,46,1,8,10,36,43,3,6,13,40,41,11,16,32,33,47,9,22,26,35,48,15,17,18,27,42,4,20,25,44,49,14,21,28,29,45) AND
	N2 NOT IN (2,5,7,39,46,1,8,10,36,43,3,6,13,40,41,11,16,32,33,47,9,22,26,35,48,15,17,18,27,42,4,20,25,44,49,14,21,28,29,45) AND
	N3 NOT IN (2,5,7,39,46,1,8,10,36,43,3,6,13,40,41,11,16,32,33,47,9,22,26,35,48,15,17,18,27,42,4,20,25,44,49,14,21,28,29,45) AND
	N4 NOT IN (2,5,7,39,46,1,8,10,36,43,3,6,13,40,41,11,16,32,33,47,9,22,26,35,48,15,17,18,27,42,4,20,25,44,49,14,21,28,29,45) AND
	N5 NOT IN (2,5,7,39,46,1,8,10,36,43,3,6,13,40,41,11,16,32,33,47,9,22,26,35,48,15,17,18,27,42,4,20,25,44,49,14,21,28,29,45)
ORDER BY hits DESC




2	5	7	39	46
1	8	10	36	43 
3	6	13	40	41 
11	16	32	33	47
9	22	26	35	48
15	17	18	27	42	
4	20	25	44	49
14	21	28	29	45 

--DROP TABLE #TEMP_RESULTS


	

SELECT n1, n2, n3, n4, n5
FROM dbo.winner A (noLock)
WHERE sum_total BETWEEN 95 AND 145

--Distances ALL
SELECT	D1 = (N2 - N1),
		D2 = (N3 - N2),
		D3 = (N4 - N3),
		D4 = (N5 - N4),
		sum_distance = (N2 - N1) + (N3 - N2) + (N4 - N3) + (N5 - N4),
		draw_date
FROM dbo.winner A (noLock)
--WHERE (N2 - N1) + (N3 - N2) + (N4 - N3) + (N5 - N4) > 38
ORDER BY 5,1,2,3,4

SELECT	N1, N2, N3, N4, N5,
		--D1 = (N2 - N1),
		--D2 = (N3 - N2),
		--D3 = (N4 - N3),
		--D4 = (N5 - N4),
		sum_distance = (N2 - N1) + (N3 - N2) + (N4 - N3) + (N5 - N4)
FROM dbo.ticket A (noLock)
WHERE (N2 - N1) + (N3 - N2) + (N4 - N3) + (N5 - N4) BETWEEN 12 AND 15
ORDER BY 5,1,2,3,4

SELECT	sum_distance = (N2 - N1) + (N3 - N2) + (N4 - N3) + (N5 - N4), x = COUNT(1),
		perc = (COUNT(1))*100/276.0
FROM dbo.winner A (noLock)
WHERE sum_total BETWEEN 95 AND 145
GROUP BY (N2 - N1) + (N3 - N2) + (N4 - N3) + (N5 - N4)
ORDER BY 1


DECLARE @step INT
SET @step = 8
SELECT *
FROM (	SELECT	D1 = (N2 - N1),
				D2 = (N3 - N2),
				D3 = (N4 - N3),
				D4 = (N5 - N4)
		FROM dbo.winner A (noLock)
	) A
WHERE	(D1 + @step) = D2 AND (D2 + @step) = D3 AND (D3 + @step) = D4
ORDER BY 1,2,3,4




/*
- Exclude same distance (D1, D2, D3, D4), (D1, D2, D3), (D1 + x, D2 + x, D3 + x, D4 + x), (D1 + x, D2 + x, D3 + x). x [-10,10]
- Exclude (D1 + @step) = D2 AND (D2 + @step) = D3 AND (D3 + @step) = D4
- Exclude sum_distance > 25


*/



--Average Distance total draws
DECLARE @number_tickets MONEY

SET @number_tickets = (SELECT COUNT(1) FROM winner)
SELECT	D1 = SUM(N2 - N1)/@number_tickets,
		D2 = SUM(N3 - N2)/@number_tickets,
		D3 = SUM(N4 - N3)/@number_tickets,
		D4 = SUM(N5 - N4)/@number_tickets
FROM dbo.winner A (noLock)


--Average Distance Range 95 - 145
DECLARE @number_tickets MONEY

SET @number_tickets = (SELECT COUNT(1) FROM winner WHERE sum_total BETWEEN 95 AND 145)
SELECT	D1 = SUM(N2 - N1)/@number_tickets,
		D2 = SUM(N3 - N2)/@number_tickets,
		D3 = SUM(N4 - N3)/@number_tickets,
		D4 = SUM(N5 - N4)/@number_tickets
FROM dbo.winner A (noLock)
WHERE sum_total BETWEEN 95 AND 145

--Distances COUNT total draw
SELECT D1, D2, D3, D4, X=COUNT(1)
FROM (	SELECT	D1 = (N2 - N1),
				D2 = (N3 - N2),
				D3 = (N4 - N3),
				D4 = (N5 - N4)
		FROM dbo.winner A (noLock)
	) A
GROUP BY D1, D2, D3, D4
ORDER BY 5 DESC


--Distances COUNT range 95-145
SELECT D1, D2, D3, D4, X=COUNT(1)
FROM (	SELECT	D1 = (N2 - N1),
				D2 = (N3 - N2),
				D3 = (N4 - N3),
				D4 = (N5 - N4)
		FROM dbo.winner A (noLock)
		WHERE sum_total BETWEEN 95 AND 145
	) A
GROUP BY D1, D2, D3, D4
ORDER BY 5 DESC

--Find tickets x distance
SELECT *
FROM ticket
WHERE (n2 - N1) = 3 AND
	(N3 - N2) = 6 AND
	(N4 - N3) = 9 AND
	(N5 - N4) = 4
	
	
--Winning tickets with same distances
SELECT * 
FROM	(
		SELECT	D1 = (N2 - N1),
				D2 = (N3 - N2),
				D3 = (N4 - N3),
				D4 = (N5 - N4)
		FROM dbo.winner A (noLock)
		) A
WHERE	D1 = D2 AND
		D2 = D3 AND
		D3 = D4


--Duplicate distances ALL
SELECT * 
FROM	(
		SELECT	D1 = (N2 - N1),
				D2 = (N3 - N2),
				D3 = (N4 - N3),
				D4 = (N5 - N4)
		FROM dbo.winner A (noLock)
		) A
WHERE	(D1 = D2 OR D1 = D3 OR D1 = D4) OR
		(D2 = D1 OR D2 = D3 OR D2 = D4) OR
		(D3 = D1 OR D3 = D2 OR D3 = D4) OR
		(D4 = D1 OR D4 = D2 OR D3 = D4)
		
--Duplicate distances ALL
SELECT * 
FROM	(
		SELECT	D1 = (N2 - N1),
				D2 = (N3 - N2),
				D3 = (N4 - N3),
				D4 = (N5 - N4)
		FROM dbo.winner A (noLock)
		WHERE sum_total BETWEEN 95 AND 145
		) A
WHERE	(D1 = D2 OR D1 = D3 OR D1 = D4) OR
		(D2 = D1 OR D2 = D3 OR D2 = D4) OR
		(D3 = D1 OR D3 = D2 OR D3 = D4) OR
		(D4 = D1 OR D4 = D2 OR D3 = D4)

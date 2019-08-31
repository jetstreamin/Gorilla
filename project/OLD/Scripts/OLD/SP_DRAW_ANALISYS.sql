USE gorilla
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'SP_DRAW_ANALYSIS')
	DROP PROCEDURE SP_DRAW_ANALYSIS
GO

CREATE PROCEDURE dbo.SP_DRAW_ANALYSIS
AS
BEGIN

	SET NOCOUNT ON
	
	IF EXISTS (SELECT 1 FROM sys.syscursors WHERE cursor_name = 'batch_cursor')
		BEGIN
			CLOSE batch_cursor
			DEALLOCATE batch_cursor
		END
	

	DECLARE @N1 SMALLINT
	DECLARE @N2 SMALLINT
	DECLARE @N3 SMALLINT
	DECLARE @N4 SMALLINT
	DECLARE @N5 SMALLINT
	DECLARE @pk_id SMALLINT
	DECLARE @new_doublet BIT
	DECLARE @new_triplet BIT
	DECLARE @new_quadruplet BIT
	DECLARE @draw_date DATETIME
	DECLARE @sum_total INT
	DECLARE @number_odd SMALLINT 
	DECLARE @number_even SMALLINT
	DECLARE @D1 SMALLINT
	DECLARE @D2 SMALLINT
	DECLARE @D3 SMALLINT
	DECLARE @D4 SMALLINT
	DECLARE @number_previous_5_draw SMALLINT
	DECLARE @number_previous_10_draw SMALLINT
	DECLARE @last_doublet TINYINT
	DECLARE @ticket_id BIGINT
	DECLARE @all_same_distance BIT
	DECLARE @is_winning_distance BIT
	DECLARE @is_winning_distance_X_50 BIT
	DECLARE @min_step SMALLINT
	DECLARE @max_step SMALLINT
	DECLARE @i SMALLINT
	DECLARE @is_winning_distance_D1_D2_D3 SMALLINT
	DECLARE @is_winning_distance_X_50_D1_D2_D3 SMALLINT
	DECLARE @is_winning_number_X BIT
	DECLARE @last_sum_number_draw_when INT
	DECLARE @1_10 TINYINT, @11_20 TINYINT, @21_30 TINYINT, @31_40 TINYINT, @41_50 TINYINT
	DECLARE @last_tent_draw_when INT


	CREATE TABLE #TEMP_tents
		(
		pk_id INT,
		[1_10] INT,
		[11_20] INT,
		[21_30] INT,
		[31_40] INT,
		[41_50] INT
		)


	CREATE TABLE #TEMP_winner
	(
		pk_id BIGINT,
		sum_total INT
	)


	CREATE TABLE #TEMP_is_winning_number_X
	(
		pk_id BIGINT,
		N1 SMALLINT,
		N2 SMALLINT,
		N3 SMALLINT,
		N4 SMALLINT,
		N5 SMALLINT
	)



	CREATE TABLE #TEMP_winning_distance_D1_D2_D3
	(
		D1 SMALLINT,
		D2 SMALLINT,
		D3 SMALLINT
	)


	CREATE TABLE #TEMP_winning_distance_X_50_D1_D2_D3
	(
		pk_id BIGINT,
		D1 SMALLINT,
		D2 SMALLINT,
		D3 SMALLINT
	)


	CREATE TABLE #TEMP_winning_distance_X_50
	(
		pk_id BIGINT,
		D1 SMALLINT,
		D2 SMALLINT,
		D3 SMALLINT,
		D4 SMALLINT
	)


	CREATE TABLE #TEMP_winning_distance
	(
		D1 SMALLINT,
		D2 SMALLINT,
		D3 SMALLINT,
		D4 SMALLINT
	)

	
	CREATE TABLE #TEMP_doublet
	(
		D1 SMALLINT,
		D2 SMALLINT,
		ticket_id INT
	)
	
	CREATE TABLE #TEMP_triplet
	(
		T1 SMALLINT,
		T2 SMALLINT,
		T3 SMALLINT,
		ticket_id INT
	)

	CREATE TABLE #TEMP_quadruplet
	(
		Q1 SMALLINT,
		Q2 SMALLINT,
		Q3 SMALLINT,
		Q4 SMALLINT,
		ticket_id INT
	)

	CREATE TABLE #TEMP_results
	(
		ticket_id BIGINT,
		draw_date DATETIME,
		N1 SMALLINT,
		N2 SMALLINT,
		N3 SMALLINT,
		N4 SMALLINT,
		N5 SMALLINT,
		new_doublet BIT,
		new_triplet BIT,
		new_quadruplet BIT,
		doublet_draws_ago_when TINYINT,
		sum_total INT,
		number_odd SMALLINT,
		number_even SMALLINT,
		D1 SMALLINT,
		D2 SMALLINT,
		D3 SMALLINT,
		D4 SMALLINT,
		number_previous_1_draw SMALLINT,
		number_previous_5_draw SMALLINT,
		sum_distance INT,
		all_same_distance BIT,
		is_winning_distance BIT,
		is_winning_distance_X_50 BIT,
		is_winning_distance_D1_D2_D3 BIT,
		is_winning_distance_X_50_D1_D2_D3 BIT,
		is_winning_number_X BIT,
		last_sum_number_draw_when INT,
		[1_10] TINYINT,
		[11_20] TINYINT,
		[21_30] TINYINT,
		[31_40] TINYINT,
		[41_50] TINYINT,
		last_tent_draw_when INT
	)
	
	CREATE TABLE #TEMP_doublet_ago
	(
		doublet_draws_ago_when SMALLINT
	)	



	CREATE INDEX IX_D1 ON #TEMP_doublet(ticket_id)
	CREATE INDEX IX_D2 ON #TEMP_doublet(D1, D2)
	CREATE INDEX IX_T1 ON #TEMP_triplet(ticket_id)
	CREATE INDEX IX_T2 ON #TEMP_triplet(T1, T2, T3)
	CREATE INDEX IX_Q1 ON #TEMP_quadruplet(ticket_id)
	CREATE INDEX IX_Q2 ON #TEMP_quadruplet(Q1, Q2, Q3, Q4)
	CREATE INDEX IX_WD_50 ON #TEMP_winning_distance_X_50(pk_id, D1, D2, D3, D4)
	CREATE INDEX IX_WD_50_D1_3 ON #TEMP_winning_distance_D1_D2_D3(D1, D2, D3)
	CREATE INDEX IX_WD_50_X_50_D1_3 ON #TEMP_winning_distance_X_50_D1_D2_D3(pk_id, D1, D2, D3)
	CREATE INDEX IX_WN_X ON #TEMP_is_winning_number_X(pk_id, N1, N2, N3, N4, N5)
	CREATE INDEX IX_SM ON #TEMP_winner	(pk_id)
	

	SET @min_step = -50
	SET @max_step = 50

	DECLARE batch_cursor CURSOR FOR 
	SELECT pk_id, N1, N2, N3, N4, N5
	FROM winner (nOLock)

	OPEN batch_cursor
	FETCH NEXT FROM batch_cursor INTO @pk_id, @n1, @n2, @n3, @n4, @n5
	WHILE ( @@fetch_status = 0 )
		BEGIN
			INSERT INTO #TEMP_quadruplet (Q1, Q2, Q3, Q4, ticket_id)
			SELECT N1 = @N1, N2 = @N2, N3 = @N3, N4 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N2, N3 = @N3, N4 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N3, N3 = @N4, N4 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N2, N3 = @N4, N4 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N3, N3 = @N4, N4 = @N5, ticket_id = @pk_id 

			
			INSERT INTO #TEMP_triplet (T1, T2, T3, ticket_id)
			SELECT N1 = @N1, N2 = @N2, N3 = @N3, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N2, N3 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N2, N3 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N3, N3 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N3, N3 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N4, N3 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N3, N3 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N3, N3 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N4, N3 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N3, N2 = @N4, N3 = @N5, ticket_id = @pk_id 

		

			INSERT INTO #TEMP_doublet(D1, D2, ticket_id)
			SELECT N1 = @N1, N2 = @N2, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N3, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N1, N2 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N3, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N2, N2 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N3, N2 = @N4, ticket_id = @pk_id UNION
			SELECT N1 = @N3, N2 = @N5, ticket_id = @pk_id UNION
			SELECT N1 = @N4, N2 = @N5, ticket_id = @pk_id

			SET @i = @min_step 
			WHILE (@i <= @max_step)
				BEGIN
					INSERT INTO #TEMP_winning_distance_X_50(pk_id, D1, D2, D3, D4)
					SELECT pk_id = @pk_id, D1 = @D1 + @i, D2 = @D2 + @i, D3 = @D3 + @i, D4 = @D4 + @i UNION
					SELECT pk_id = @pk_id, D1 = @D1 + @i, D2 = @D2 + @i + 1, D3 = @D3 + @i + 2, D4 = @D4 + @i + 3
				

					INSERT INTO #TEMP_winning_distance_X_50_D1_D2_D3(pk_id, D1, D2, D3)
					SELECT pk_id = @pk_id, D1 = @D1 + @i, D2 = @D2 + @i, D3 = @D3 + @i UNION
					SELECT pk_id = @pk_id, D1 = @D1 + @i, D2 = @D2 + @i + 1, D3 = @D3 + @i + 2

					INSERT INTO #TEMP_is_winning_number_X(pk_id, N1, N2, N3, N4, N5)
					SELECT pk_id = @pk_id, N1 = @N1 + @i, N2 = @N2 + @i, N3 = @N3 + @i, N4 = @N4 + @i, N5 = @N5 + @i UNION
					SELECT pk_id = @pk_id, N1 = @N1 + @i, N2 = @N2 + @i + 1, N3 = @N3 + @i + 2, N4 = @N4 + @i + 3, N5 = @N5 + @i + 4
					
					SET @i = @i + 1
				END
			


			FETCH NEXT FROM batch_cursor INTO @pk_id, @n1, @n2, @n3, @n4, @n5
		END
	CLOSE batch_cursor
	DEALLOCATE batch_cursor	
	
	INSERT INTO #TEMP_winner (pk_id, sum_total)
	SELECT pk_id, sum_total
	FROM winner  (noLock)
	

	--SELECT DISTINCT D1, D2 FROM #TEMP_doublet
	--SELECT DISTINCT  FROM #TEMP_triplet
	--SELECT * FROM #TEMP_quadruplet


	DECLARE batch_cursor CURSOR FOR 
	SELECT ticket_id, draw_date, pk_id, N1, N2, N3, N4, N5, sum_total, number_odd, number_even, D1, D2, D3, D4, [1_10], [11_20], [21_30], [31_40], [41_50]
	FROM winner (nOLock)

	OPEN batch_cursor
	FETCH NEXT FROM batch_cursor INTO @ticket_id, @draw_date, @pk_id, @n1, @n2, @n3, @n4, @n5,  @sum_total, @number_odd, @number_even, @D1, @D2, @D3, @D4, @1_10, @11_20, @21_30, @31_40, @41_50
	WHILE ( @@fetch_status = 0 )
		BEGIN
		
			IF	EXISTS (SELECT 1 FROM #TEMP_doublet A WHERE A.ticket_id < @pk_id AND (D1 = @N1 AND D2 = @N2)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet B WHERE B.ticket_id < @pk_id AND (D1 = @N1 AND D2 = @N3)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet C WHERE C.ticket_id < @pk_id AND (D1 = @N1 AND D2 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet D WHERE D.ticket_id < @pk_id AND (D1 = @N1 AND D2 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet E WHERE E.ticket_id < @pk_id AND (D1 = @N2 AND D2 = @N3)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet F WHERE F.ticket_id < @pk_id AND (D1 = @N2 AND D2 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet G WHERE G.ticket_id < @pk_id AND (D1 = @N2 AND D2 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet H WHERE H.ticket_id < @pk_id AND (D1 = @N3 AND D2 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet I WHERE I.ticket_id < @pk_id AND (D1 = @N3 AND D2 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_doublet J WHERE J.ticket_id < @pk_id AND (D1 = @N4 AND D2 = @N5))
					SET @new_doublet = 0
			ELSE
					SET @new_doublet = 1
				
					
			IF	EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N1 AND T2 = @N2 AND T3 = @N3)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N1 AND T2 = @N2 AND T3 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N1 AND T2 = @N2 AND T3 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N1 AND T2 = @N3 AND T3 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N1 AND T2 = @N3 AND T3 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N1 AND T2 = @N4 AND T3 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N2 AND T2 = @N3 AND T3 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N2 AND T2 = @N3 AND T3 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N2 AND T2 = @N4 AND T3 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_triplet WHERE ticket_id < @pk_id AND (T1 = @N3 AND T2 = @N4 AND T3 = @N5))
					SET @new_triplet = 0
			ELSE
					SET @new_triplet = 1

			IF	EXISTS (SELECT 1 FROM #TEMP_quadruplet WHERE ticket_id < @pk_id AND (Q1 = @N1 AND Q2 = @N2 AND Q3 = @N3 AND Q4 = @N4)) AND
				EXISTS (SELECT 1 FROM #TEMP_quadruplet WHERE ticket_id < @pk_id AND (Q1 = @N1 AND Q2 = @N2 AND Q3 = @N3 AND Q4 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_quadruplet WHERE ticket_id < @pk_id AND (Q1 = @N1 AND Q2 = @N2 AND Q3 = @N4 AND Q4 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_quadruplet WHERE ticket_id < @pk_id AND (Q1 = @N1 AND Q2 = @N3 AND Q3 = @N4 AND Q4 = @N5)) AND
				EXISTS (SELECT 1 FROM #TEMP_quadruplet WHERE ticket_id < @pk_id AND (Q1 = @N2 AND Q2 = @N3 AND Q3 = @N4 AND Q4 = @N5))
					SET @new_quadruplet = 0
			ELSE
					SET @new_quadruplet = 1
			

			SELECT TOP 1 draw_date, N1, N2, N3, N4, N5
			INTO #TEMP_CHECK_5_PREVIOUS_DRAWS
			FROM winner (noLock)
			WHERE pk_id < @pk_id
			ORDER BY pk_id DESC
			
			
			SELECT TOP 5 draw_date, N1, N2, N3, N4, N5
			INTO #TEMP_CHECK_10_PREVIOUS_DRAWS
			FROM winner (noLock)
			WHERE pk_id < @pk_id
			ORDER BY pk_id DESC

			
			IF EXISTS (SELECT 1 FROM #TEMP_CHECK_5_PREVIOUS_DRAWS WHERE N1 IN (@n1, @n2, @n3, @n4, @n5) OR N2 IN (@n1, @n2, @n3, @n4, @n5) OR N3 IN (@n1, @n2, @n3, @n4, @n5) OR N4 IN (@n1, @n2, @n3, @n4, @n5) OR N5 IN (@n1, @n2, @n3, @n4, @n5))		
				SET @number_previous_5_draw = (
					--SELECT	SUM(dbo.number_compare(N1,@N1) + dbo.number_compare(N1,@N2) + dbo.number_compare(N1,@N3) + dbo.number_compare(N1,@N4) + dbo.number_compare(N1,@N5) +
					--		dbo.number_compare(N2,@N1) + dbo.number_compare(N2,@N2) + dbo.number_compare(N2,@N3) + dbo.number_compare(N2,@N4) + dbo.number_compare(N2,@N5) +
					--		dbo.number_compare(N3,@N1) + dbo.number_compare(N3,@N2) + dbo.number_compare(N3,@N3) + dbo.number_compare(N3,@N4) + dbo.number_compare(N3,@N5) +
					--		dbo.number_compare(N3,@N1) + dbo.number_compare(N4,@N2) + dbo.number_compare(N4,@N3) + dbo.number_compare(N4,@N4) + dbo.number_compare(N4,@N5) +
					--		dbo.number_compare(N5,@N1) + dbo.number_compare(N5,@N2) + dbo.number_compare(N5,@N3) + dbo.number_compare(N5,@N4) + dbo.number_compare(N5,@N5))
					--FROM #TEMP_CHECK_5_PREVIOUS_DRAWS 
					--WHERE	N1 IN (@n1, @n2, @n3, @n4, @n5) OR 
					--		N2 IN (@n1, @n2, @n3, @n4, @n5) OR 
					--		N3 IN (@n1, @n2, @n3, @n4, @n5) OR 
					--		N4 IN (@n1, @n2, @n3, @n4, @n5) OR 
					--		N5 IN (@n1, @n2, @n3, @n4, @n5)
					SELECT SUM(dbo.number_compare(X,@N1) + dbo.number_compare(X,@N2) + dbo.number_compare(X,@N3) + dbo.number_compare(X,@N4) + dbo.number_compare(X,@N5))
					FROM (	SELECT x=N1 FROM #TEMP_CHECK_5_PREVIOUS_DRAWS UNION
							SELECT x=N2 FROM #TEMP_CHECK_5_PREVIOUS_DRAWS UNION
							SELECT x=N3 FROM #TEMP_CHECK_5_PREVIOUS_DRAWS UNION
							SELECT x=N4 FROM #TEMP_CHECK_5_PREVIOUS_DRAWS UNION
							SELECT x=N5 FROM #TEMP_CHECK_5_PREVIOUS_DRAWS
						) A
					)
			ELSE
				SET @number_previous_5_draw = 0
			

			
			
			
			
			
			IF EXISTS (SELECT 1 FROM #TEMP_CHECK_10_PREVIOUS_DRAWS WHERE N1 IN (@n1, @n2, @n3, @n4, @n5) OR N2 IN (@n1, @n2, @n3, @n4, @n5) OR N3 IN (@n1, @n2, @n3, @n4, @n5) OR N4 IN (@n1, @n2, @n3, @n4, @n5) OR N5 IN (@n1, @n2, @n3, @n4, @n5))		
				SET @number_previous_10_draw = (
				--SELECT	SUM(dbo.number_compare(N1,@N1) + dbo.number_compare(N1,@N2) + dbo.number_compare(N1,@N3) + dbo.number_compare(N1,@N4) + dbo.number_compare(N1,@N5) +
				--		dbo.number_compare(N2,@N1) + dbo.number_compare(N2,@N2) + dbo.number_compare(N2,@N3) + dbo.number_compare(N2,@N4) + dbo.number_compare(N2,@N5) +
				--		dbo.number_compare(N3,@N1) + dbo.number_compare(N3,@N2) + dbo.number_compare(N3,@N3) + dbo.number_compare(N3,@N4) + dbo.number_compare(N3,@N5) +
				--		dbo.number_compare(N3,@N1) + dbo.number_compare(N4,@N2) + dbo.number_compare(N4,@N3) + dbo.number_compare(N4,@N4) + dbo.number_compare(N4,@N5) +
				--		dbo.number_compare(N5,@N1) + dbo.number_compare(N5,@N2) + dbo.number_compare(N5,@N3) + dbo.number_compare(N5,@N4) + dbo.number_compare(N5,@N5))
				--	FROM #TEMP_CHECK_10_PREVIOUS_DRAWS 
				--	WHERE N1 IN (@n1, @n2, @n3, @n4, @n5) OR N2 IN (@n1, @n2, @n3, @n4, @n5) OR N3 IN (@n1, @n2, @n3, @n4, @n5) OR N4 IN (@n1, @n2, @n3, @n4, @n5) OR N5 IN (@n1, @n2, @n3, @n4, @n5)
					SELECT SUM(dbo.number_compare(X,@N1) + dbo.number_compare(X,@N2) + dbo.number_compare(X,@N3) + dbo.number_compare(X,@N4) + dbo.number_compare(X,@N5))
					FROM (	SELECT x=N1 FROM #TEMP_CHECK_10_PREVIOUS_DRAWS UNION
							SELECT x=N2 FROM #TEMP_CHECK_10_PREVIOUS_DRAWS UNION
							SELECT x=N3 FROM #TEMP_CHECK_10_PREVIOUS_DRAWS UNION
							SELECT x=N4 FROM #TEMP_CHECK_10_PREVIOUS_DRAWS UNION
							SELECT x=N5 FROM #TEMP_CHECK_10_PREVIOUS_DRAWS
						) A				
					)
			ELSE
				SET @number_previous_10_draw = 0
			
			
			SET @last_doublet = (
			SELECT x = (CASE WHEN MAX(ticket_id) IS NOT NULL THEN @pk_id - MAX(ticket_id) ELSE 0 END)
			FROM (	SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N1 AND D2 = @N2 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N1 AND D2 = @N3 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N1 AND D2 = @N4 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N1 AND D2 = @N5 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N2 AND D2 = @N3 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N2 AND D2 = @N4 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N2 AND D2 = @N5 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N3 AND D2 = @N4 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N3 AND D2 = @N5 UNION ALL
					SELECT ticket_id=MAX(ticket_id) FROM #TEMP_doublet WHERE ticket_id < @pk_id AND D1 = @N4 AND D2 = @N5
					) A
				)
				
			SET @all_same_distance = (CASE WHEN @D1 = @D2 AND @D2 = @D3 AND @D3 = @D4 THEN 1 ELSE 0 END)
		
			IF EXISTS (SELECT 1 FROM #TEMP_winning_distance WHERE D1 = @D1 AND D2 = @D2 AND D3 = @D3 AND D4 = @D4)
				SET @is_winning_distance = 1
			ELSE	
				BEGIN
					SET @is_winning_distance = 0
					
					INSERT INTO #TEMP_winning_distance
					SELECT @D1, @D2, @D3, @D4
				END	
				
	
			IF EXISTS (SELECT 1 FROM #TEMP_winning_distance_D1_D2_D3 WHERE D1 = @D1 AND D2 = @D2 AND D3 = @D3)
				SET @is_winning_distance_D1_D2_D3 = 1
			ELSE	
				BEGIN
					SET @is_winning_distance_D1_D2_D3 = 0
					
					INSERT INTO #TEMP_winning_distance_D1_D2_D3
					SELECT @D1, @D2, @D3
				END	
						
			IF EXISTS (SELECT 1 FROM #TEMP_winning_distance_X_50 WHERE pk_id < @pk_id AND D1 = @D1 AND D2 = @D2 AND D3 = @D3 AND D4 = @D4)
				SET @is_winning_distance_X_50 = 1
			ELSE
				SET @is_winning_distance_X_50 = 0
	
			IF EXISTS (SELECT 1 FROM #TEMP_winning_distance_X_50_D1_D2_D3 WHERE pk_id < @pk_id AND D1 = @D1 AND D2 = @D2 AND D3 = @D3)
				SET @is_winning_distance_X_50_D1_D2_D3 = 1
			ELSE
				SET @is_winning_distance_X_50_D1_D2_D3 = 0
	
	
			IF EXISTS (SELECT 1 FROM #TEMP_is_winning_number_X WHERE pk_id < @pk_id AND N1 = @N1 AND N2 = @N2 AND N3 = @N3 AND N4 = @N4 AND N5 = @N5)
				SET @is_winning_number_X = 1
			ELSE	
				SET @is_winning_number_X = 0
	
			
			SET @last_sum_number_draw_when = ISNULL((SELECT @pk_id - MAX(pk_id) FROM #TEMP_winner (noLock) WHERE pk_id < @pk_id AND sum_total = @sum_total),0)
			
			--INSERT INTO #TEMP_last_sum_number_draw_when (pk_id, x)
			--SELECT @pk_id, @last_sum_number_draw_when
			
					
			DROP TABLE #TEMP_CHECK_5_PREVIOUS_DRAWS
			DROP TABLE #TEMP_CHECK_10_PREVIOUS_DRAWS
				
				
			--SET @1_10 = dbo.number_between(@n1, 1,10) + dbo.number_between(@n2, 1,10) + dbo.number_between(@n3, 1,10) + dbo.number_between(@n4, 1,10) + dbo.number_between(@n5, 1,10) 
			--SET @11_20 = dbo.number_between(@n1, 11,20) + dbo.number_between(@n2, 11,20) + dbo.number_between(@n3, 11,20) + dbo.number_between(@n4, 11,20) + dbo.number_between(@n5, 11,20) 
			--SET @21_30 = dbo.number_between(@n1, 21,30) + dbo.number_between(@n2, 21,30) + dbo.number_between(@n3, 21,30) + dbo.number_between(@n4, 21,30) + dbo.number_between(@n5, 21,30) 
			--SET @31_40 = dbo.number_between(@n1, 31,40) + dbo.number_between(@n2, 31,40) + dbo.number_between(@n3, 31,40) + dbo.number_between(@n4, 31,40) + dbo.number_between(@n5, 31,40) 
			--SET @41_50 = dbo.number_between(@n1, 41,50) + dbo.number_between(@n2, 41,50) + dbo.number_between(@n3, 41,50) + dbo.number_between(@n4, 41,50) + dbo.number_between(@n5, 41,50) 
				
			INSERT INTO #TEMP_tents SELECT @pk_id, @1_10, @11_20, @21_30, @31_40, @41_50
			
			SET @last_tent_draw_when = ISNULL((SELECT @pk_id - MAX(pk_id) FROM #TEMP_tents (noLock) WHERE pk_id < @pk_id AND [1_10] = @1_10 AND [11_20] = @11_20 AND [21_30] = @21_30 AND [31_40] = @31_40 AND [41_50] = @41_50 ),0)
				
			INSERT INTO #TEMP_results(ticket_id, draw_date, N1, N2, N3, N4, N5, new_doublet, new_triplet, new_quadruplet, doublet_draws_ago_when, sum_total, number_odd, number_even, D1, D2, D3, D4, number_previous_1_draw, number_previous_5_draw, sum_distance, all_same_distance, is_winning_distance, is_winning_distance_X_50, is_winning_distance_D1_D2_D3, is_winning_distance_X_50_D1_D2_D3, is_winning_number_X, last_sum_number_draw_when, [1_10], [11_20], [21_30], [31_40], [41_50], last_tent_draw_when)
			SELECT @ticket_id, @draw_date, @n1, @n2, @n3, @n4, @n5, @new_doublet, @new_triplet, @new_quadruplet, @last_doublet, @sum_total, @number_odd, @number_even, @D1, @D2, @D3, @D4, @number_previous_5_draw, @number_previous_10_draw, (@D1+@D2+@D3+@D4), @all_same_distance, @is_winning_distance, @is_winning_distance_X_50, @is_winning_distance_D1_D2_D3, @is_winning_distance_X_50_D1_D2_D3, @is_winning_number_X, @last_sum_number_draw_when, @1_10, @11_20, @21_30, @31_40, @41_50, @last_tent_draw_when
					
			INSERT INTO #TEMP_doublet_ago
			SELECT @last_doublet

			FETCH NEXT FROM batch_cursor INTO @ticket_id, @draw_date, @pk_id, @n1, @n2, @n3, @n4, @n5, @sum_total, @number_odd, @number_even, @D1, @D2, @D3, @D4, @1_10, @11_20, @21_30, @31_40, @41_50
		END
	CLOSE batch_cursor
	DEALLOCATE batch_cursor	

	SELECT * FROM #TEMP_results ORDER BY 2 ASC



	DROP TABLE #TEMP_results
	DROP TABLE #TEMP_doublet
	DROP TABLE #TEMP_triplet
	DROP TABLE #TEMP_quadruplet
	DROP TABLE #TEMP_doublet_ago
	DROP TABLE #TEMP_winning_distance
	DROP TABLE #TEMP_winning_distance_X_50
	DROP TABLE #TEMP_winning_distance_X_50_D1_D2_D3
	DROP TABLE #TEMP_winning_distance_D1_D2_D3
	DROP TABLE #TEMP_is_winning_number_X
	DROP TABLE #TEMP_winner
	DROP TABLE #TEMP_tents
	--DROP TABLE #TEMP_last_sum_number_draw_when
END
GO
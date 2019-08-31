USE gorilla
GO

DECLARE @draw_date SMALLDATETIME
DECLARE @N1 SMALLINT, @N2 SMALLINT, @N3 SMALLINT, @N4 SMALLINT, @N5 SMALLINT, @L1 SMALLINT, @L2 SMALLINT
DECLARE @jackpot BIGINT
DECLARE @weekday CHAR(3)
DECLARE @number_odd SMALLINT
DECLARE @number_even SMALLINT
DECLARE @lucky_odd SMALLINT
DECLARE @lucky_even SMALLINT
DECLARE @wins TINYINT
DECLARE @ticket_id BIGINT

SELECT *
INTO #temp_draws
FROM (	SELECT draw_date = '2012-4-10', N1 = 22, N2 = 25, N3 = 27, N4 = 36, N5 = 37, L1 = 5, L2 = 9, jackpot = 32603075, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-4-13', N1 = 8, N2 = 13, N3 = 26, N4 = 39, N5 = 43, L1 = 3, L2 = 5, jackpot = 44408417, wins = 1, weekday = ' Fri' UNION
		SELECT draw_date = '2012-4-17', N1 = 10, N2 = 28, N3 = 33, N4 = 48, N5 = 49, L1 = 1, L2 = 10, jackpot = 12369000, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-4-20', N1 = 3, N2 = 6, N3 = 29, N4 = 32, N5 = 41, L1 = 10, L2 = 11, jackpot = 21345735, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-4-24', N1 = 8, N2 = 9, N3 = 24, N4 = 43, N5 = 48, L1 = 3, L2 = 5, jackpot = 26895374, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-4-27', N1 = 20, N2 = 27, N3 = 30, N4 = 36, N5 = 43, L1 = 1, L2 = 6, jackpot = 36231900, wins = 1, weekday = ' Fri' UNION
		SELECT draw_date = '2012-5-1', N1 = 4, N2 = 5, N3 = 15, N4 = 19, N5 = 41, L1 = 9, L2 = 11, jackpot = 12258000, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-5-4', N1 = 3, N2 = 26, N3 = 39, N4 = 40, N5 = 41, L1 = 1, L2 = 2, jackpot = 21084008, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-5-8', N1 = 3, N2 = 21, N3 = 34, N4 = 38, N5 = 48, L1 = 5, L2 = 8, jackpot = 26250991, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-5-11', N1 = 1, N2 = 13, N3 = 17, N4 = 38, N5 = 44, L1 = 2, L2 = 11, jackpot = 35495169, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-5-15', N1 = 2, N2 = 11, N3 = 13, N4 = 26, N5 = 50, L1 = 2, L2 = 5, jackpot = 41232245, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-5-18', N1 = 13, N2 = 29, N3 = 43, N4 = 47, N5 = 50, L1 = 9, L2 = 11, jackpot = 53068969, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-5-22', N1 = 16, N2 = 31, N3 = 32, N4 = 37, N5 = 41, L1 = 1, L2 = 7, jackpot = 60290704, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-5-25', N1 = 12, N2 = 22, N3 = 35, N4 = 46, N5 = 49, L1 = 2, L2 = 8, jackpot = 71823678, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-5-29', N1 = 8, N2 = 15, N3 = 17, N4 = 25, N5 = 28, L1 = 3, L2 = 11, jackpot = 80806756, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-6-1', N1 = 2, N2 = 4, N3 = 14, N4 = 26, N5 = 36, L1 = 9, L2 = 10, jackpot = 97123444, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-6-5', N1 = 13, N2 = 34, N3 = 37, N4 = 47, N5 = 49, L1 = 8, L2 = 9, jackpot = 109315762, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-6-8', N1 = 5, N2 = 11, N3 = 22, N4 = 34, N5 = 40, L1 = 9, L2 = 11, jackpot = 63837544, wins = 2, weekday = ' Fri' UNION
		SELECT draw_date = '2012-6-12', N1 = 8, N2 = 15, N3 = 26, N4 = 30, N5 = 48, L1 = 9, L2 = 10, jackpot = 12043500, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-6-15', N1 = 10, N2 = 22, N3 = 27, N4 = 38, N5 = 48, L1 = 3, L2 = 7, jackpot = 10814550, wins = 2, weekday = ' Fri' UNION
		SELECT draw_date = '2012-6-19', N1 = 7, N2 = 17, N3 = 20, N4 = 35, N5 = 50, L1 = 5, L2 = 11, jackpot = 12109500, wins = 1, weekday = ' Tue' UNION
		SELECT draw_date = '2012-6-22', N1 = 14, N2 = 18, N3 = 19, N4 = 43, N5 = 49, L1 = 3, L2 = 7, jackpot = 12117000, wins = 0, weekday = ' Fri' UNION
		SELECT draw_date = '2012-6-26', N1 = 1, N2 = 11, N3 = 20, N4 = 22, N5 = 35, L1 = 8, L2 = 10, jackpot = 17516871, wins = 0, weekday = ' Tue' UNION
		SELECT draw_date = '2012-6-29', N1 = 14, N2 = 17, N3 = 28, N4 = 29, N5 = 39, L1 = 1, L2 = 11, jackpot = 26900432, wins = 0, weekday = ' Fri'
	) A


DECLARE batch_cursor CURSOR FOR 
SELECT draw_date=CONVERT(SMALLDATETIME,draw_date,120), N1, N2, N3, N4, N5, L1, L2, jackpot, wins, weekday
FROM #temp_draws
ORDER BY 1

OPEN batch_cursor
	FETCH NEXT FROM batch_cursor INTO @draw_date, @N1, @N2, @N3, @N4, @N5, @L1, @L2, @jackpot, @wins, @weekday
	WHILE ( @@fetch_status = 0 )
		BEGIN
			--SET @draw_date = '2012-04-03'
			--SET @N1 = 1
			--SET @N2 = 8
			--SET @N3 = 18
			--SET @N4 = 25
			--SET @N5 = 30
			--SET @L1 = 9
			--SET @L2 = 10
			--SET @jackpot = 21716352
			--SET @wins = 0
			--SET @weekday = 'Tue' --or 'Tue'
			SET @number_odd = (CASE WHEN @N1 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N2 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N3 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N4 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N5 % 2 <> 0 THEN 1 ELSE 0 END)
			SET @number_even = (CASE WHEN @N1 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N2 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N3 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N4 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N5 % 2 <> 0 THEN 0 ELSE 1 END)
			SET @lucky_odd = (CASE WHEN @L1 % 2 <> 0 THEN 1 ELSE 0 END)  +  (CASE WHEN @L2 % 2 <> 0 THEN 1 ELSE 0 END)
			SET @lucky_even = (CASE WHEN @L1 % 2 <> 0 THEN 0 ELSE 1 END)  +  (CASE WHEN @L2 % 2 <> 0 THEN 0 ELSE 2 END)
			SET @ticket_id = (SELECT B.pk_id FROM ticket B (noLock) WHERE N1 = @n1 AND N2 = @n2 AND N3 = @n3 AND N4 = @n4 AND N5 = @n5)
				
			IF NOT EXISTS (SELECT 1 FROM dbo.winner WHERE draw_date = @draw_date)
				INSERT INTO [winner] ([N1],[N2],[N3],[N4],[N5],[L1],[L2],[jackpot],[draw_date],[weekday],[wins],[sum_total],[number_odd],[number_even], [lucky_odd], [lucky_even], [ticket_id])
				VALUES(@N1, @N2, @N3, @N4, @N5, @L1, @L2, @jackpot, @draw_date, @weekday, @wins, @N1+@N2+@N3+@N4+@N5, @number_odd, @number_even, @lucky_odd, @lucky_even, @ticket_id)
			ELSE
				PRINT 'DRAW ALREADY INSERTED'


			FETCH NEXT FROM batch_cursor INTO @draw_date, @N1, @N2, @N3, @N4, @N5, @L1, @L2, @jackpot, @wins, @weekday
		END
CLOSE batch_cursor
DEALLOCATE batch_cursor	


DROP TABLE #temp_draws

SELECT *
FROM winner
ORDER BY 1 DESC



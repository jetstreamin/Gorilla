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
DECLARE @1_10 TINYINT, @11_20 TINYINT, @21_30 TINYINT, @31_40 TINYINT, @41_50 TINYINT


SET @draw_date = '2012-04-10'
SET @N1 = 22
SET @N2 = 25
SET @N3 = 27
SET @N4 = 36
SET @N5 = 37
SET @L1 = 5
SET @L2 = 9
SET @jackpot = 39523670
SET @wins = 0
SET @weekday = 'Tue' --or 'Tue'
SET @number_odd = (CASE WHEN @N1 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N2 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N3 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N4 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN @N5 % 2 <> 0 THEN 1 ELSE 0 END)
SET @number_even = (CASE WHEN @N1 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N2 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N3 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N4 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN @N5 % 2 <> 0 THEN 0 ELSE 1 END)
SET @lucky_odd = (CASE WHEN @L1 % 2 <> 0 THEN 1 ELSE 0 END)  +  (CASE WHEN @L2 % 2 <> 0 THEN 1 ELSE 0 END)
SET @lucky_even = (CASE WHEN @L1 % 2 <> 0 THEN 0 ELSE 1 END)  +  (CASE WHEN @L2 % 2 <> 0 THEN 0 ELSE 2 END)
SET @ticket_id = (SELECT B.pk_id FROM ticket B (noLock) WHERE N1 = @n1 AND N2 = @n2 AND N3 = @n3 AND N4 = @n4 AND N5 = @n5)
SET @1_10 = dbo.number_between(@n1, 1,10) + dbo.number_between(@n2, 1,10) + dbo.number_between(@n3, 1,10) + dbo.number_between(@n4, 1,10) + dbo.number_between(@n5, 1,10) 
SET @11_20 = dbo.number_between(@n1, 11,20) + dbo.number_between(@n2, 11,20) + dbo.number_between(@n3, 11,20) + dbo.number_between(@n4, 11,20) + dbo.number_between(@n5, 11,20) 
SET @21_30 = dbo.number_between(@n1, 21,30) + dbo.number_between(@n2, 21,30) + dbo.number_between(@n3, 21,30) + dbo.number_between(@n4, 21,30) + dbo.number_between(@n5, 21,30) 
SET @31_40 = dbo.number_between(@n1, 31,40) + dbo.number_between(@n2, 31,40) + dbo.number_between(@n3, 31,40) + dbo.number_between(@n4, 31,40) + dbo.number_between(@n5, 31,40) 
SET @41_50 = dbo.number_between(@n1, 41,50) + dbo.number_between(@n2, 41,50) + dbo.number_between(@n3, 41,50) + dbo.number_between(@n4, 41,50) + dbo.number_between(@n5, 41,50) 
				



IF NOT EXISTS (SELECT 1 FROM dbo.winner WHERE draw_date = @draw_date)
	INSERT INTO [winner] ([N1],[N2],[N3],[N4],[N5],[L1],[L2],[jackpot],[draw_date],[weekday],[wins],[sum_total],[number_odd],[number_even], [lucky_odd], [lucky_even], [ticket_id], [1_10], [11_20], [21_30], [31_40], [41_50])
	VALUES(@N1, @N2, @N3, @N4, @N5, @L1, @L2, @jackpot, @draw_date, @weekday, @wins, @N1+@N2+@N3+@N4+@N5, @number_odd, @number_even, @lucky_odd, @lucky_even, @ticket_id, @1_10, @11_20, @21_30, @31_40, @41_50)
ELSE
	PRINT 'DRAW ALREADY INSERTED'

SELECT TOP 1 *
FROM winner
ORDER BY 1 DESC

--SELECT * FROM winner ORDER BY 1 DESC

--SP_GetTicketsNewCombinations

--sp_updatestats

/*
TRUNCATE TABLE winner

INSERT INTO [gorilla].[dbo].[winner] ([pk_id],[N1],[N2],[N3],[N4],[N5],[L1],[L2],[jackpot],[draw_date],[weekday],[wins],[sum_total],[number_odd],[number_even], [lucky_odd], [lucky_even])

SELECT pk_id= [No] , N1, N2, N3, N4, N5, L1, L2, 
	jackpot, draw_date = CONVERT(SMALLDATETIME, DD + ' ' + MMM + ' ' +  YYYY), [weekday] = [day],
	wins, sum_total= CONVERT(SMALLINT,N1)+CONVERT(SMALLINT,N2)+CONVERT(SMALLINT,N3)+CONVERT(SMALLINT,N4)+CONVERT(SMALLINT,N5), 
	number_odd = (CASE WHEN N1 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN N2 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN N3 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN N4 % 2 <> 0 THEN 1 ELSE 0 END) + (CASE WHEN N5 % 2 <> 0 THEN 1 ELSE 0 END),
	number_even = (CASE WHEN N1 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN N2 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN N3 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN N4 % 2 <> 0 THEN 0 ELSE 1 END) + (CASE WHEN N5 % 2 <> 0 THEN 0 ELSE 1 END),
	lucky_odd = (CASE WHEN L1 % 2 <> 0 THEN 1 ELSE 0 END)  +  (CASE WHEN L2 % 2 <> 0 THEN 1 ELSE 0 END),
	lucky_even = (CASE WHEN L1 % 2 <> 0 THEN 0 ELSE 1 END)  +  (CASE WHEN L2 % 2 <> 0 THEN 0 ELSE 1 END)
--SELECT *
FROM gorilla.dbo.euro
ORDER BY 1
*/


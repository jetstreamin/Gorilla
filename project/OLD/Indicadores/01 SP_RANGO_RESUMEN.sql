USE gorilla
GO

SET NOCOUNT ON

DECLARE @rango_size TINYINT
DECLARE @i SMALLINT, @j SMALLINT, @desde SMALLINT, @hasta SMALLINT
DECLARE @numero_sorteos SMALLINT
DECLARE @2004 SMALLINT, @2005 SMALLINT, @2006 SMALLINT, @2007 SMALLINT, @2008 SMALLINT, @2009 SMALLINT, @2010 SMALLINT, @2011 SMALLINT, @2012 SMALLINT
DECLARE @ene SMALLINT, @feb SMALLINT, @mar SMALLINT, @abr SMALLINT, @may SMALLINT, @jun SMALLINT, @jul SMALLINT, @ago SMALLINT, @sep SMALLINT, @oct SMALLINT, @nov SMALLINT, @dic SMALLINT
DECLARE @5_0 INT, @4_1 INT,@3_2 INT,@2_3 INT,@1_4 INT,@0_5 INT
DECLARE @ocurrencias SMALLINT, @numero_tickets_rango INT, @sum_espera SMALLINT, @min_espera SMALLINT, @max_espera SMALLINT, @ultima_vez SMALLDATETIME, @overdue SMALLINT
DECLARE @draw_date SMALLDATETIME, @sum_total INT, @N1 TINYINT, @N2 TINYINT, @N3 TINYINT, @N4 TINYINT, @N5 TINYINT
DECLARE @temp_distancia INT, @sorteo INT, @espera SMALLINT

CREATE TABLE #TEMP_RANGO_VALUES
	(desde SMALLINT,
	hasta SMALLINT
	)
	
--CREATE TABLE #TEMP_ESPERA_TEST
--(
--desde INT,
--hasta INT,
--draw_date SMALLDATETIME,
--min_espera INT,
--max_espera INT
--)

	
	
CREATE TABLE #TEMP_RESULTS
(
	[DESDE] SMALLINT
	,[HASTA] SMALLINT
	,[#_TICKETS] INT  --DEFAULT 0
	,[OCURRENCIA] INT  --DEFAULT 0
	,[% OCURRENCIA] MONEY  --DEFAULT 0
	,[AVG_ESPERA] SMALLINT  --DEFAULT 0
	,[MIN_ESPERA] SMALLINT  --DEFAULT 0
	,[MAX_ESPERA] SMALLINT  --DEFAULT 0
	,[ULTIMA_VEZ] SMALLDATETIME
	,[OVERDUE] INT
	,[AVG_DISTANCIA] MONEY
	,[5-0] INT --DEFAULT 0
	,[4-1] INT --DEFAULT 0
	,[3-2] INT --DEFAULT 0
	,[2-3] INT --DEFAULT 0
	,[1-4] INT --DEFAULT 0
	,[0-5] INT --DEFAULT 0
	,[2004] INT
	,[2005] INT
	,[2006] INT
	,[2007] INT
	,[2008] INT
	,[2009] INT
	,[2010] INT
	,[2011] INT
	,[2012] INT
	,[Enero] INT
	,[Febrero] INT
	,[Marzo] INT
	,[Abril] INT
	,[Mayo] INT
	,[Junio] INT
	,[Julio] INT
	,[Agosto] INT
	,[Septiembre] INT
	,[Octubre] INT
	,[Noviembre] INT
	,[Diciembre] INT
)	

SET @rango_size = 15
SET @i = 1 + 2 + 3 + 4 + 5
SET @j = 46 + 47 + 48 + 49 + 50
SET @numero_sorteos = (SELECT x=COUNT(1) FROM dbo.winner)

WHILE (@i<@j)
	BEGIN
		INSERT #TEMP_RANGO_VALUES SELECT @i, (CASE WHEN @i + @rango_size <= @j THEN (@i + @rango_size -1) ELSE @j END)
		SET @i = @i + @rango_size
	END

SELECT sorteo = pk_id, draw_date, sum_total, N1, N2, N3, N4, N5
INTO #TEMP_WINNER
FROM dbo.winner A (noLock)

DECLARE batch_cursor CURSOR FOR 
SELECT desde, hasta
FROM #TEMP_RANGO_VALUES

OPEN batch_cursor
FETCH NEXT FROM batch_cursor INTO @desde, @hasta
WHILE ( @@fetch_status = 0 )
	BEGIN
		SELECT @2004 = 0, @2005 = 0, @2006 = 0, @2007 = 0, @2008 = 0, @2009 = 0, @2010 = 0, @2011 = 0, @2012 = 0, 
				@ene = 0, @feb = 0, @mar = 0, @abr = 0, @may = 0, @jun = 0, @jul = 0, @ago = 0, @sep = 0, @oct = 0, @nov = 0, @dic = 0,
				@5_0 = 0, @4_1 = 0,  @3_2 = 0, @2_3 = 0, @1_4 = 0, @0_5 = 0,
				@ocurrencias = 0, @numero_tickets_rango = 0, @min_espera = 0, @max_espera = 0, @overdue = 0, @ultima_vez = NULL
	
		
		SELECT @numero_tickets_rango = COUNT(1)
		FROM dbo.ticket A (noLock)
		WHERE sum_total BETWEEN @desde AND @hasta
		
		SELECT @ocurrencias = COUNT(1),
				@5_0 = SUM(CASE WHEN number_even = 5 AND number_odd = 0 THEN 1 ELSE 0 END), 
				@4_1 = SUM(CASE WHEN number_even = 4 AND number_odd = 1 THEN 1 ELSE 0 END),  
				@3_2 = SUM(CASE WHEN number_even = 3 AND number_odd = 2 THEN 1 ELSE 0 END), 
				@2_3 = SUM(CASE WHEN number_even = 2 AND number_odd = 3 THEN 1 ELSE 0 END), 
				@1_4 = SUM(CASE WHEN number_even = 1 AND number_odd = 4 THEN 1 ELSE 0 END), 
				@0_5 = SUM(CASE WHEN number_even = 0 AND number_odd = 5 THEN 1 ELSE 0 END),
				@2004 = SUM(CASE WHEN YEAR(draw_date) = 2004 THEN 1 ELSE 0 END),
				@2005 = SUM(CASE WHEN YEAR(draw_date) = 2005 THEN 1 ELSE 0 END),
				@2006 = SUM(CASE WHEN YEAR(draw_date) = 2006 THEN 1 ELSE 0 END),
				@2007 = SUM(CASE WHEN YEAR(draw_date) = 2007 THEN 1 ELSE 0 END),
				@2008 = SUM(CASE WHEN YEAR(draw_date) = 2008 THEN 1 ELSE 0 END),
				@2009 = SUM(CASE WHEN YEAR(draw_date) = 2009 THEN 1 ELSE 0 END),
				@2010 = SUM(CASE WHEN YEAR(draw_date) = 2010 THEN 1 ELSE 0 END),
				@2011 = SUM(CASE WHEN YEAR(draw_date) = 2011 THEN 1 ELSE 0 END),
				@2012 = SUM(CASE WHEN YEAR(draw_date) = 2012 THEN 1 ELSE 0 END),
				@ene = SUM(CASE WHEN MONTH(draw_date) = 1 THEN 1 ELSE 0 END),
				@feb = SUM(CASE WHEN MONTH(draw_date) = 2 THEN 1 ELSE 0 END),
				@mar = SUM(CASE WHEN MONTH(draw_date) = 3 THEN 1 ELSE 0 END),
				@abr = SUM(CASE WHEN MONTH(draw_date) = 4 THEN 1 ELSE 0 END),
				@may = SUM(CASE WHEN MONTH(draw_date) = 5 THEN 1 ELSE 0 END),
				@jun = SUM(CASE WHEN MONTH(draw_date) = 6 THEN 1 ELSE 0 END),
				@jul = SUM(CASE WHEN MONTH(draw_date) = 7 THEN 1 ELSE 0 END),
				@ago = SUM(CASE WHEN MONTH(draw_date) = 8 THEN 1 ELSE 0 END),
				@sep = SUM(CASE WHEN MONTH(draw_date) = 9 THEN 1 ELSE 0 END),
				@oct = SUM(CASE WHEN MONTH(draw_date) = 10 THEN 1 ELSE 0 END),
				@nov = SUM(CASE WHEN MONTH(draw_date) = 11 THEN 1 ELSE 0 END),
				@dic = SUM(CASE WHEN MONTH(draw_date) = 12 THEN 1 ELSE 0 END),
				@ultima_vez = MAX(draw_date)
		FROM dbo.winner A (noLock)
		WHERE sum_total BETWEEN @desde AND @hasta
		
		SELECT @sum_espera = 0, @min_espera = 0, @max_espera = 0, @temp_distancia = 0, @espera = 1, @ultima_vez = NULL
		
		DECLARE batch_winner CURSOR FOR 
		SELECT draw_date, sum_total, N1, N2, N3, N4, N5
		FROM #TEMP_WINNER
		
		OPEN batch_winner
		FETCH NEXT FROM batch_winner INTO @draw_date, @sum_total, @N1, @N2, @N3, @N4, @N5
		WHILE ( @@fetch_status = 0 )
			BEGIN
				IF @sum_total BETWEEN @desde AND @hasta
					BEGIN
						SET @temp_distancia = @temp_distancia + ((@N2 - @N1) + (@N3 - @N2) + (@N4 - @N3) + (@N5 - @N4))
						SET @sum_espera = @sum_espera + @espera
						SET @min_espera = (CASE WHEN @min_espera < @espera AND @min_espera <> 0 THEN @min_espera ELSE @espera END)
						SET @max_espera = (CASE WHEN @espera > @max_espera THEN @espera ELSE @max_espera END)
						SET @ultima_vez = @draw_date
						SET @espera = 1
						
						--INSERT INTO #TEMP_ESPERA_TEST
						--SELECT @desde, @hasta, @draw_date, @min_espera, @max_espera
						
						
					END
				ELSE
					BEGIN
						SET @espera = @espera + 1
					END
		
	
				FETCH NEXT FROM batch_winner INTO @draw_date, @sum_total, @N1, @N2, @N3, @N4, @N5
			END
		CLOSE batch_winner
		DEALLOCATE batch_winner
		

		--numero_sorteos_transcurridos
		--avg_distancia
		--avg_espera
		--min_espera
		--max_espera
		
		
		INSERT INTO #TEMP_RESULTS ([DESDE],[HASTA],[#_TICKETS],[OCURRENCIA],[% OCURRENCIA],[AVG_ESPERA], [MIN_ESPERA], [MAX_ESPERA],[ULTIMA_VEZ],[OVERDUE],[AVG_DISTANCIA],[5-0],[4-1],[3-2],[2-3],[1-4],[0-5],[2004],[2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[Enero],[Febrero],[Marzo],[Abril],[Mayo],[Junio],[Julio],[Agosto],[Septiembre],[Octubre],[Noviembre],[Diciembre])
		SELECT [DESDE] = @desde,
				[HASTA] = @hasta,
				[#_TICKETS] = @numero_tickets_rango,
				[OCURRENCIA] = @ocurrencias,
				[% ] = CONVERT(MONEY,@ocurrencias) * 100 / @numero_sorteos,
				[AVG_ESPERA] = (CASE WHEN @ocurrencias > 0 THEN CONVERT(MONEY,@sum_espera) / @ocurrencias ELSE 0 END),
				[MIN_ESPERA] = @min_espera,
				[MAX_ESPERA] = @max_espera,
				[ULTIMA_VEZ] = @ultima_vez,
				[OVERDUE] = (CASE WHEN @ocurrencias > 0 THEN @espera - (CONVERT(MONEY,@sum_espera) / @ocurrencias)ELSE 0 END),
				[AVG_DISTANCIA] = (CASE WHEN @ocurrencias > 0 THEN @temp_distancia / @ocurrencias ELSE 0 END),
				[5-0] = @5_0, [4-1] = @4_1, [3-2] = @3_2, [2-3] = @2_3, [1-4] = @1_4, [0-5] = @0_5,
				[2004] = ISNULL(@2004,0), [2005] = ISNULL(@2005,0), [2006] = ISNULL(@2006,0), [2007] = ISNULL(@2007,0), [2008] = ISNULL(@2008,0), [2009] = ISNULL(@2009,0), [2010] = ISNULL(@2010,0), [2011] = ISNULL(@2011,0), [2012] = ISNULL(@2012,0),
				[Enero] = @ene, [Febrero] = @feb, [Marzo] = @mar, [Abril] = @abr, [Mayo] = @may, [Junio] = @jun, [Julio] = @jul, [Agosto] = @ago, [Septiembre] = @sep, [Octubre] = @oct, [Noviembre] = @nov, [Diciembre] = @dic


		FETCH NEXT FROM batch_cursor INTO @desde, @hasta
	END
CLOSE batch_cursor
DEALLOCATE batch_cursor

SELECT * FROM #TEMP_RESULTS ORDER BY OCURRENCIA DESC
--SELECT * FROM #TEMP_ESPERA_TEST ORDER BY desde, HASTA


DROP TABLE #TEMP_RANGO_VALUES
DROP TABLE #TEMP_RESULTS
DROP TABLE #TEMP_WINNER
--DROP TABLE #TEMP_ESPERA_TEST

/*
CLOSE batch_cursor
DEALLOCATE batch_cursor

CLOSE batch_winner
DEALLOCATE batch_winner

DROP TABLE #TEMP_RANGO_VALUES
DROP TABLE #TEMP_RESULTS
DROP TABLE #TEMP_TICKET
DROP TABLE #TEMP_WINNER
DROP TABLE #TEMP_ESPERA_TEST
*/

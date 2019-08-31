DECLARE @N1 SMALLINT
DECLARE @N2 SMALLINT
DECLARE @N3 SMALLINT
DECLARE @N4 SMALLINT
DECLARE @N5 SMALLINT
DECLARE @maxN1 SMALLINT
DECLARE @maxN2 SMALLINT
DECLARE @maxN3 SMALLINT
DECLARE @maxN4 SMALLINT
DECLARE @maxN5 SMALLINT



SET @N1 = 17
SET @N2 = 1
SET @N3 = 1
SET @N4 = 1
SET @N5 = 1
SET @maxN1=17
SET @maxN2=50
SET @maxN3=50
SET @maxN4=50
SET @maxN5=50

--75933794	15	47	36	1	32
77687392	17	3	15	48	50
--IF EXISTS (SELECT TOP 1 1 FROM numbers)
--	TRUNCATE TABLE numbers

WHILE (@N1<=@maxN1)
	BEGIN --(@N1<=@max)
		WHILE (@N2<=@maxn1)
			BEGIN --(@N2<=@max)
				IF (@N2<>@N1)
					BEGIN --(@N2<>@N1)
						WHILE (@N3<=@maxN3)
							BEGIN --(@N3<=@max)
								IF (@N3<>@N1 AND @N3<>@N2)
									BEGIN --(@N3<>@N1 AND @N3<>@N2)
										WHILE (@N4<=@maxN4)
											BEGIN --(@N4<=@max)
												--PRINT CONVERT(VARCHAR,@N1) + '-' + CONVERT(VARCHAR,@N2) + '-' + CONVERT(VARCHAR,@N3)
												IF (@N4<>@N1 AND @N4<>@N2 AND @N4<>@N3)
													BEGIN --(@N4<>@N1 AND @N4<>@N2 AND @N4<>@N3)
														WHILE (@N5<=@maxN5)
															BEGIN --(@N5<=@max)
																--IF (@N1<>@N2 AND @N1<>@N3 AND @N1<>@N4 AND @N1<>@N5 AND @N2<>@N3 AND @N2<>@N4 AND @N2<>@N5 AND @N3<>@N4 AND @N3<>@N5 AND @N4<>@N5)
																IF (@N5<>@N1 AND @N5<>@N2 AND @N5<>@N3 AND @N5<>@N4)
																	BEGIN
																		INSERT INTO numbers VALUES(@N1, @N2, @N3, @N4, @N5)
																		--PRINT CONVERT(VARCHAR,@N1) + '-' + CONVERT(VARCHAR,@N2) + '-' + CONVERT(VARCHAR,@N3)
																	END
																SET @N5 = @N5 + 1
															END --(@N5<=@max)
													END --(@N4<>@N1 AND @N4<>@N2 AND @N4<>@N3)
												SET @N4 = @N4 + 1
												SET @N5 = 1
											END --(@N4<=@max)
									END --(@N3<>@N1 AND @N3<>@N2)
								SET @N3 = @N3 + 1
								SET @N4 = 1
							END --(@N3<=@max)
					END --(@N2<>@N1)
				SET @N2 = @N2 + 1
				SET @N3 = 1
			END --(@N2<=@max)
		SET @N1 = @N1 + 1
		SET @N2 = 1
	END --(@N1<=@max)
PRINT CONVERT(VARCHAR,@N1) + '-' + CONVERT(VARCHAR,@N2) + '-' + CONVERT(VARCHAR,@N3)


--DROP TABLE #tick
--SELECT * FROM #tick

--N1, N2, N3 --> A,B,C
--
--N1<>A, N2<>B, N3<>C
--N1<>A, N2<>C, N3<>B
--N1<>B, N2<>A, N3<>C
--N1<>B, N2<>C, N3<>A
--N1<>C, N2<>B, N3<>A
--N1<>C, N2<>A, N3<>B
--
--
--(N1=@N1 AND N2=@N2 AND N3=@N3) OR (N1=@N1 AND N2=@N3 AND N3=@N2) OR (N1=@N2 AND N2=@N1 AND N3=@N3) OR (N1=@N2 AND N2=@N3 AND N3=@N1) OR (N1=@N3 AND N2=@N2 AND N3=@N1) OR (N1=@N3 AND N2=@N1 AND N3=@N2)

--
--N1, N2, N3, N4, N5 --> A,B,C,D,E
--
--N1=@N1 AND N2=
--
--
--SELECT *
--FROM EURO
--WHERE N1 NOT IN (1,2,3,5,6)
--
--SELECT *
--FROM TICKET
--WHERE N1<>N2<>N3
--
--N1<>N2 AND N1<>N3 AND N1<>N4 AND N1<>N5 N2<>N3 AND N2<>N4 AND N2<>N5 N3<>N4 AND N3<>N5 N4<>N5


--SELECT * FROM NUMBERS
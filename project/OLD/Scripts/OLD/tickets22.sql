DECLARE @N1 SMALLINT
DECLARE @N2 SMALLINT
DECLARE @N3 SMALLINT
DECLARE @N4 SMALLINT
DECLARE @N5 SMALLINT
DECLARE @max1 SMALLINT
DECLARE @max2 SMALLINT
DECLARE @max3 SMALLINT
DECLARE @max4 SMALLINT
DECLARE @max5 SMALLINT

SET @N1 = 1
SET @N2 = 2
SET @N3 = 3
SET @N4 = 4
SET @N5 = 5
SET @max1=46
SET @max2=47
SET @max3=48
SET @max4=49
SET @max5=50

/*
IF EXISTS (SELECT TOP 1 1 FROM ticket)
	TRUNCATE TABLE ticket
	*/

WHILE (@N1<=@max1)
	BEGIN
		WHILE (@N2<=@max2)
			BEGIN
				WHILE (@N3<=@max3)
					BEGIN
						WHILE (@N4<=@max4)
							BEGIN
								WHILE (@N5<=@max5)
									BEGIN
										IF (@N1<@N2 AND @N1<@N3 AND @N1<@N4 AND @N1<@N5 AND @N2<@N3 AND @N2<@N4 AND @N2<@N5 AND @N3<@N4 AND @N3<@N5 AND @N4<@N5)
											BEGIN
													INSERT ticket
													SELECT N1=@N1, N2=@N2, N3=@N3, N4=@N4, N5=@N5
													--FROM numbers2 (noLock)
													--WHERE (N1=@N1 OR N2=@N1 OR N3=@N1 OR N4=@N1 OR N5=@N1) AND (N1=@N2 OR N2=@N2 OR N3=@N2 OR N4=@N2 OR N5=@N2) AND (N1=@N3 OR N2=@N3 OR N3=@N3 OR N4=@N3 OR N5=@N3) AND (N1=@N4 OR N2=@N4 OR N3=@N4 OR N4=@N4 OR N5=@N4) AND (N1=@N5 OR N2=@N5 OR N3=@N5 OR N4=@N5 OR N5=@N5)
													--PRINT CONVERT(VARCHAR,@N1) + '-' + CONVERT(VARCHAR,@N2) + '-' + CONVERT(VARCHAR,@N3)+ '-' + CONVERT(VARCHAR,@N4)+ '-' + CONVERT(VARCHAR,@N5)
											END
										SET @N5 = @N5 + 1
									END
								SET @N4 = @N4 + 1
								SET @N5 = 1
							END
						SET @N3 = @N3 + 1
						SET @N4 = 1
					END
			SET @N2 = @N2 + 1
			SET @N3 = 1
			END
		SET @N1 = @N1 + 1
		SET @N2 = 1
		SET @N3 = 1
		SET @N4 = 1
		SET @N5 = 1
	END




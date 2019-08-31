DECLARE @id INT
DECLARE @n1 TINYINT, @n2 TINYINT, @n3 TINYINT, @n4 TINYINT, @n5 TINYINT
DECLARE @i TINYINT, @j TINYINT, @k TINYINT, @l TINYINT, @m TINYINT

DECLARE results CURSOR FOR  
SELECT id, n1, n2, n3, n4, n5
FROM dbo.euro
 

OPEN results 
FETCH NEXT FROM results INTO @id, @n1, @n2, @n3, @n4, @n5 

WHILE @@FETCH_STATUS = 0   
BEGIN
	--Par
	SET @i = 1
	WHILE (@i<=5)
		BEGIN
			SET @j = 1
			WHILE (@j<=5)
				BEGIN
					IF @i<@j
						PRINT 'INSERT dbo.par(id,N1,N2) SELECT id=' + CONVERT(VARCHAR,@id) + ',  n1=@N' + CONVERT(CHAR(1),@i) + ', n2=@N' + CONVERT(CHAR(1),@j)
					SET @j = @j + 1
				END
			SET @i = @i + 1
		END

	--Triple
	SET @i = 1
	WHILE (@i<=5)
		BEGIN
			SET @j = 1
			WHILE (@j<=5)
				BEGIN
					IF (@i<@j)
						BEGIN
							SET @k = 1
							WHILE (@k<=5)
								BEGIN
									IF @j<@k
										PRINT 'INSERT dbo.triple(id, N1,N2,N3) SELECT id= ' + CONVERT(VARCHAR,@id) + ', n1=@N' + CONVERT(CHAR(1),@i) + ', n2=@N' + CONVERT(CHAR(1),@j) + ', n3=@N' + CONVERT(CHAR(1),@k)
							
									SET @k = @k + 1
								END

						END

					SET @j = @j + 1
				END
			SET @i = @i + 1
		END

	--Quatro
	SET @i = 1
	WHILE (@i<=5)
		BEGIN --WHILE (@i<=5)
			SET @j = 1
			WHILE (@j<=5)
				BEGIN --WHILE (@j<=5)
					IF (@i<@j)
						BEGIN --IF (@i<@j)
							SET @k = 1
							WHILE (@k<=5)
								BEGIN --WHILE (@k<=5)
									IF (@j<@k)
										BEGIN --IF (@j<@k)
											SET @l = 1
											WHILE (@l<=5)
												BEGIN --WHILE (@l<=5)
													IF (@k<@l)
														PRINT 'INSERT dbo.quattro(id, N1,N2,N3) SELECT id= ' + CONVERT(VARCHAR,@id) + ', n1=@N' + CONVERT(CHAR(1),@i) + ', n2=@N' + CONVERT(CHAR(1),@j) + ', n3=@N' + CONVERT(CHAR(1),@k) + ', n4=@N' + CONVERT(CHAR(1),@l)
													SET @l = @l + 1
												END --WHILE (@l<=5)
										END --IF (@j<@k)
									SET @k = @k + 1
								END --WHILE (@k<=5)							
						END --IF (@i<@j)
					SET @j = @j + 1
				END --WHILE (@j<=5)
			SET @i = @i + 1
		END --WHILE (@i<=5)

	FETCH NEXT FROM results INTO @id, @n1, @n2, @n3, @n4, @n5    
END   

CLOSE results   
DEALLOCATE results
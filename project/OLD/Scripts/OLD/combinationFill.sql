DECLARE @id INT
DECLARE @n1 TINYINT, @n2 TINYINT, @n3 TINYINT, @n4 TINYINT, @n5 TINYINT

DECLARE results CURSOR FOR  
SELECT id, n1, n2, n3, n4, n5
FROM dbo.euro

--TRUNCATE TABLE par
--TRUNCATE TABLE triple
--TRUNCATE TABLE quattro

OPEN results 
FETCH NEXT FROM results INTO @id, @n1, @n2, @n3, @n4, @n5 
WHILE @@FETCH_STATUS = 0   
BEGIN

	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N1, n2=@N2
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N1, n2=@N3
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N1, n2=@N4
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N1, n2=@N5
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N2, n2=@N3
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N2, n2=@N4
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N2, n2=@N5
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N3, n2=@N4
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N3, n2=@N5
	INSERT dbo.par(id,N1,N2) SELECT id=@id,  n1=@N4, n2=@N5
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N1, n2=@N2, n3=@N3
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N1, n2=@N2, n3=@N4
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N1, n2=@N2, n3=@N5
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N1, n2=@N3, n3=@N4
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N1, n2=@N3, n3=@N5
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N1, n2=@N4, n3=@N5
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N2, n2=@N3, n3=@N4
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N2, n2=@N3, n3=@N5
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N2, n2=@N4, n3=@N5
	INSERT dbo.triple(id, N1,N2,N3) SELECT id=@id, n1=@N3, n2=@N4, n3=@N5
	INSERT dbo.quattro(id, N1,N2,N3,N4) SELECT id=@id, n1=@N1, n2=@N2, n3=@N3, n4=@N4
	INSERT dbo.quattro(id, N1,N2,N3,N4) SELECT id=@id, n1=@N1, n2=@N2, n3=@N3, n4=@N5
	INSERT dbo.quattro(id, N1,N2,N3,N4) SELECT id=@id, n1=@N1, n2=@N2, n3=@N4, n4=@N5
	INSERT dbo.quattro(id, N1,N2,N3,N4) SELECT id=@id, n1=@N1, n2=@N3, n3=@N4, n4=@N5
	INSERT dbo.quattro(id, N1,N2,N3,N4) SELECT id=@id, n1=@N2, n2=@N3, n3=@N4, n4=@N5

	FETCH NEXT FROM results INTO @id, @n1, @n2, @n3, @n4, @n5    
END   

CLOSE results   
DEALLOCATE results
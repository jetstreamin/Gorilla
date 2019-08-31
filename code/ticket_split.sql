/*
DROP TABLE IF EXISTS [dbo].[ticket_split]
GO

CREATE TABLE [dbo].[ticket_split](
	[ticketid] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[n1] [tinyint] NOT NULL,
	[n2] [tinyint] NOT NULL,
	[n3] [tinyint] NOT NULL,
	[n4] [tinyint] NOT NULL,
	[n5] [tinyint] NOT NULL,
	[s1] SMALLINT,
	s2 SMALLINT,
	s3 SMALLINT,
	s4 SMALLINT,
	s5 SMALLINT,
	iswinner BIT DEFAULT 0,
	w2004 INT DEFAULT 0,
	w2005 INT DEFAULT 0,
	w2006 INT DEFAULT 0,
	w2007 INT DEFAULT 0,
	w2008 INT DEFAULT 0,
	w2009 INT DEFAULT 0,
	w2010 INT DEFAULT 0,
	w2011 INT DEFAULT 0,
	w2012 INT DEFAULT 0,
	w2013 INT DEFAULT 0,
	w2014 INT DEFAULT 0,
	w2015 INT DEFAULT 0,
	w2016 INT DEFAULT 0,
	w2017 INT DEFAULT 0,
	w2018 INT DEFAULT 0,
	)
GO

INSERT INTO [dbo].[ticket_split] (ticketid, n1, n2, n3, n4, n5)
SELECT ticketid, n1, n2, n3, n4, n5
FROM [dbo].[ticket]
GO

UPDATE ts
SET iswinner = 1,
	w2004 = CASE WHEN YEAR(drawdate) = 2004 THEN 1 ELSE 0 END,
	w2005 = CASE WHEN YEAR(drawdate) = 2005 THEN 1 ELSE 0 END,
	w2006 = CASE WHEN YEAR(drawdate) = 2006 THEN 1 ELSE 0 END,
	w2007 = CASE WHEN YEAR(drawdate) = 2007 THEN 1 ELSE 0 END,
	w2008 = CASE WHEN YEAR(drawdate) = 2008 THEN 1 ELSE 0 END,
	w2009 = CASE WHEN YEAR(drawdate) = 2009 THEN 1 ELSE 0 END,
	w2010 = CASE WHEN YEAR(drawdate) = 2010 THEN 1 ELSE 0 END,
	w2011 = CASE WHEN YEAR(drawdate) = 2011 THEN 1 ELSE 0 END,
	w2012 = CASE WHEN YEAR(drawdate) = 2012 THEN 1 ELSE 0 END,
	w2013 = CASE WHEN YEAR(drawdate) = 2013 THEN 1 ELSE 0 END,
	w2014 = CASE WHEN YEAR(drawdate) = 2014 THEN 1 ELSE 0 END,
	w2015 = CASE WHEN YEAR(drawdate) = 2015 THEN 1 ELSE 0 END,
	w2016 = CASE WHEN YEAR(drawdate) = 2016 THEN 1 ELSE 0 END,
	w2017 = CASE WHEN YEAR(drawdate) = 2017 THEN 1 ELSE 0 END,
	w2018 = CASE WHEN YEAR(drawdate) = 2018 THEN 1 ELSE 0 END
FROM dbo.ticket_split ts
	INNER JOIN dbo.draw d ON ts.n1 = d.n1 AND ts.n2 = d.n2 AND ts.n3 = d.n3 AND ts.n4 = d.n4 AND ts.n5 = d.n5 
GO
*/

/*
SELECT COUNT(1)
FROM [dbo].[ticket]

SELECT COUNT(1)%56, COUNT(1)/56.00
FROM [dbo].[ticket_split]

14 buckets = 151,340 tickets each (s1)
23 buckets = 92,120 tickets each (s2) 	
35 buckets = 60,536 tickets each (s3)
47 buckets = 45,080 tickets each (s4)
56 buckets = 37,835 tickets each (s5)

5
7
14
20
23
28

*/


--s1
DECLARE @x INT = 1
DECLARE @y INT = 14
DECLARE @a INT = 1
DECLARE @b INT = (SELECT COUNT(1) FROM dbo.ticket_split)/@y
DECLARE @c INT = @b

UPDATE dbo.ticket_split SET s1 = NULL

WHILE (@x <= @y)
	BEGIN
		UPDATE dbo.ticket_split
		SET s1 = @x
		WHERE ticketid >= @a AND ticketid <= @b

		SET @x = @x + 1
		SET @a = @b + 1
		SET @b = @b + @c

	END

GO


--s2
DECLARE @x INT = 1
DECLARE @y INT = 23
DECLARE @a INT = 1
DECLARE @b INT = (SELECT COUNT(1) FROM dbo.ticket_split)/@y
DECLARE @c INT = @b

UPDATE dbo.ticket_split SET s2 = NULL

WHILE (@x <= @y)
	BEGIN
		UPDATE dbo.ticket_split
		SET s2 = @x
		WHERE ticketid >= @a AND ticketid <= @b

		SET @x = @x + 1
		SET @a = @b + 1
		SET @b = @b + @c

	END

GO


--s3
DECLARE @x INT = 1
DECLARE @y INT = 35
DECLARE @a INT = 1
DECLARE @b INT = (SELECT COUNT(1) FROM dbo.ticket_split)/@y
DECLARE @c INT = @b

UPDATE dbo.ticket_split SET s3 = NULL

WHILE (@x <= @y)
	BEGIN
		UPDATE dbo.ticket_split
		SET s3 = @x
		WHERE ticketid >= @a AND ticketid <= @b

		SET @x = @x + 1
		SET @a = @b + 1
		SET @b = @b + @c

	END

GO

--s4
DECLARE @x INT = 1
DECLARE @y INT = 47
DECLARE @a INT = 1
DECLARE @b INT = (SELECT COUNT(1) FROM dbo.ticket_split)/@y
DECLARE @c INT = @b

UPDATE dbo.ticket_split SET s4 = NULL

WHILE (@x <= @y)
	BEGIN
		UPDATE dbo.ticket_split
		SET s4 = @x
		WHERE ticketid >= @a AND ticketid <= @b

		SET @x = @x + 1
		SET @a = @b + 1
		SET @b = @b + @c

	END

GO

--s5
DECLARE @x INT = 1
DECLARE @y INT = 56
DECLARE @a INT = 1
DECLARE @b INT = (SELECT COUNT(1) FROM dbo.ticket_split)/@y
DECLARE @c INT = @b

UPDATE dbo.ticket_split SET s5 = NULL

WHILE (@x <= @y)
	BEGIN
		UPDATE dbo.ticket_split
		SET s5 = @x
		WHERE ticketid >= @a AND ticketid <= @b

		SET @x = @x + 1
		SET @a = @b + 1
		SET @b = @b + @c

	END

SELECT *
FROM dbo.ticket_split


GO

/*

DROP TABLE IF EXISTS dbo.ticket_bucket
GO

CREATE TABLE dbo.ticket_bucket
(
pk_id INTEGER IDENTITY(1,1) PRIMARY KEY CLUSTERED,
bucketname VARCHAR(2),
bucketnumber SMALLINT,
totalrecordcount INT,
totalwinner INT,
w2004 DECIMAL(5,2),
w2005 DECIMAL(5,2),
w2006 DECIMAL(5,2),
w2007 DECIMAL(5,2),
w2008 DECIMAL(5,2),
w2009 DECIMAL(5,2),
w2010 DECIMAL(5,2),
w2011 DECIMAL(5,2),
w2012 DECIMAL(5,2),
w2013 DECIMAL(5,2),
w2014 DECIMAL(5,2),
w2015 DECIMAL(5,2),
w2016 DECIMAL(5,2),
w2017 DECIMAL(5,2),
w2018 DECIMAL(5,2)
)
GO

DECLARE @w2004 DECIMAL(5,2), @w2005 DECIMAL(5,2), @w2006 DECIMAL(5,2), @w2007 DECIMAL(5,2), @w2008 DECIMAL(5,2), 
@w2009 DECIMAL(5,2), @w2010 DECIMAL(5,2), @w2011 DECIMAL(5,2), @w2012 DECIMAL(5,2), @w2013 DECIMAL(5,2),
@w2014 DECIMAL(5,2), @w2015 DECIMAL(5,2), @w2016 DECIMAL(5,2), @w2017 DECIMAL(5,2), @w2018 DECIMAL(5,2)

SELECT 	@w2004 = SUM(CASE WHEN YEAR(drawdate) = 2004 THEN 1 ELSE 0 END),
	@w2005 = SUM(CASE WHEN YEAR(drawdate) = 2005 THEN 1 ELSE 0 END),
	@w2006 = SUM(CASE WHEN YEAR(drawdate) = 2006 THEN 1 ELSE 0 END),
	@w2007 = SUM(CASE WHEN YEAR(drawdate) = 2007 THEN 1 ELSE 0 END),
	@w2008 = SUM(CASE WHEN YEAR(drawdate) = 2008 THEN 1 ELSE 0 END),
	@w2009 = SUM(CASE WHEN YEAR(drawdate) = 2009 THEN 1 ELSE 0 END),
	@w2010 = SUM(CASE WHEN YEAR(drawdate) = 2010 THEN 1 ELSE 0 END),
	@w2011 = SUM(CASE WHEN YEAR(drawdate) = 2011 THEN 1 ELSE 0 END),
	@w2012 = SUM(CASE WHEN YEAR(drawdate) = 2012 THEN 1 ELSE 0 END),
	@w2013 = SUM(CASE WHEN YEAR(drawdate) = 2013 THEN 1 ELSE 0 END),
	@w2014 = SUM(CASE WHEN YEAR(drawdate) = 2014 THEN 1 ELSE 0 END),
	@w2015 = SUM(CASE WHEN YEAR(drawdate) = 2015 THEN 1 ELSE 0 END),
	@w2016 = SUM(CASE WHEN YEAR(drawdate) = 2016 THEN 1 ELSE 0 END),
	@w2017 = SUM(CASE WHEN YEAR(drawdate) = 2017 THEN 1 ELSE 0 END),
	@w2018 = SUM(CASE WHEN YEAR(drawdate) = 2018 THEN 1 ELSE 0 END)
FROM dbo.draw


INSERT INTO dbo.ticket_bucket (bucketname, bucketnumber, totalrecordcount, totalwinner,w2004,w2005,w2006,w2007,w2008,w2009,w2010,w2011,w2012,w2013,w2014,w2015,w2016,w2017,w2018)
SELECT bucketname='s1', bucketnumber=s1, totalrecordcount = COUNT(1), totalwinner=SUM(CAST(iswinner AS SMALLINT)),
		w2004 = SUM(w2004)*100/@w2004,
		w2005 = SUM(w2005)*100/@w2005,
		w2006 = SUM(w2006)*100/@w2006,
		w2007 = SUM(w2007)*100/@w2007,
		w2008 = SUM(w2008)*100/@w2008,
		w2009 = SUM(w2009)*100/@w2009,
		w2010 = SUM(w2010)*100/@w2010,
		w2011 = SUM(w2011)*100/@w2011,
		w2012 = SUM(w2012)*100/@w2012,
		w2013 = SUM(w2013)*100/@w2013,
		w2014 = SUM(w2014)*100/@w2014,
		w2015 = SUM(w2015)*100/@w2015,
		w2016 = SUM(w2016)*100/@w2016,
		w2017 = SUM(w2017)*100/@w2017,
		w2018 = SUM(w2018)*100/@w2018
FROM dbo.ticket_split
GROUP BY s1

UNION ALL

SELECT bucketname='s2', bucketnumber=s2, totalrecordcount = COUNT(1), totalwinner=SUM(CAST(iswinner AS SMALLINT)),
		w2004 = SUM(w2004)*100/@w2004,
		w2005 = SUM(w2005)*100/@w2005,
		w2006 = SUM(w2006)*100/@w2006,
		w2007 = SUM(w2007)*100/@w2007,
		w2008 = SUM(w2008)*100/@w2008,
		w2009 = SUM(w2009)*100/@w2009,
		w2010 = SUM(w2010)*100/@w2010,
		w2011 = SUM(w2011)*100/@w2011,
		w2012 = SUM(w2012)*100/@w2012,
		w2013 = SUM(w2013)*100/@w2013,
		w2014 = SUM(w2014)*100/@w2014,
		w2015 = SUM(w2015)*100/@w2015,
		w2016 = SUM(w2016)*100/@w2016,
		w2017 = SUM(w2017)*100/@w2017,
		w2018 = SUM(w2018)*100/@w2018
FROM dbo.ticket_split
GROUP BY s2

UNION ALL

SELECT bucketname='s3', bucketnumber=s3, totalrecordcount = COUNT(1), totalwinner=SUM(CAST(iswinner AS SMALLINT)),
		w2004 = SUM(w2004)*100/@w2004,
		w2005 = SUM(w2005)*100/@w2005,
		w2006 = SUM(w2006)*100/@w2006,
		w2007 = SUM(w2007)*100/@w2007,
		w2008 = SUM(w2008)*100/@w2008,
		w2009 = SUM(w2009)*100/@w2009,
		w2010 = SUM(w2010)*100/@w2010,
		w2011 = SUM(w2011)*100/@w2011,
		w2012 = SUM(w2012)*100/@w2012,
		w2013 = SUM(w2013)*100/@w2013,
		w2014 = SUM(w2014)*100/@w2014,
		w2015 = SUM(w2015)*100/@w2015,
		w2016 = SUM(w2016)*100/@w2016,
		w2017 = SUM(w2017)*100/@w2017,
		w2018 = SUM(w2018)*100/@w2018
FROM dbo.ticket_split
GROUP BY s3

UNION ALL

SELECT bucketname='s4', bucketnumber=s4, totalrecordcount = COUNT(1), totalwinner=SUM(CAST(iswinner AS SMALLINT)),
		w2004 = SUM(w2004)*100/@w2004,
		w2005 = SUM(w2005)*100/@w2005,
		w2006 = SUM(w2006)*100/@w2006,
		w2007 = SUM(w2007)*100/@w2007,
		w2008 = SUM(w2008)*100/@w2008,
		w2009 = SUM(w2009)*100/@w2009,
		w2010 = SUM(w2010)*100/@w2010,
		w2011 = SUM(w2011)*100/@w2011,
		w2012 = SUM(w2012)*100/@w2012,
		w2013 = SUM(w2013)*100/@w2013,
		w2014 = SUM(w2014)*100/@w2014,
		w2015 = SUM(w2015)*100/@w2015,
		w2016 = SUM(w2016)*100/@w2016,
		w2017 = SUM(w2017)*100/@w2017,
		w2018 = SUM(w2018)*100/@w2018
FROM dbo.ticket_split
GROUP BY s4

UNION ALL

SELECT bucketname='s5', bucketnumber=s5, totalrecordcount = COUNT(1), totalwinner=SUM(CAST(iswinner AS SMALLINT)),
		w2004 = SUM(w2004)*100/@w2004,
		w2005 = SUM(w2005)*100/@w2005,
		w2006 = SUM(w2006)*100/@w2006,
		w2007 = SUM(w2007)*100/@w2007,
		w2008 = SUM(w2008)*100/@w2008,
		w2009 = SUM(w2009)*100/@w2009,
		w2010 = SUM(w2010)*100/@w2010,
		w2011 = SUM(w2011)*100/@w2011,
		w2012 = SUM(w2012)*100/@w2012,
		w2013 = SUM(w2013)*100/@w2013,
		w2014 = SUM(w2014)*100/@w2014,
		w2015 = SUM(w2015)*100/@w2015,
		w2016 = SUM(w2016)*100/@w2016,
		w2017 = SUM(w2017)*100/@w2017,
		w2018 = SUM(w2018)*100/@w2018
FROM dbo.ticket_split
GROUP BY s5

*/



SELECT *
FROM dbo.ticket_bucket
WHERE bucketname = 's3'
ORDER BY totalwinner DESC

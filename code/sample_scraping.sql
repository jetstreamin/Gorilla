DECLARE @text NVARCHAR(MAX)
DECLARE @YourTable table (ID int, tabstring VARCHAR(MAX))

SET @text = 
'Numbers Matched	Prize Per Winner	UK Winners	Prize Fund Amount	Total Winners
Match 5 and 2 Stars	£95,972,671.00	0	£0.00	0
Match 5 and 1 Star	£0.00	0	£0.00	3
Match 5	£24,506.30	2	£49,012.60	9
Match 4 and 2 Stars	£2,631.20	12	£31,574.40	41
Match 4 and 1 Star	£119.20	229	£27,296.80	965
Match 3 and 2 Stars	£88.30	470	£41,501.00	1,818
Match 4	£46.60	502	£23,393.20	1,954
Match 2 and 2 Stars	£14.90	7,355	£109,589.50	28,065
Match 3 and 1 Star	£9.80	11,063	£108,417.40	44,803
Match 3	£9.10	23,344	£212,430.40	91,932
Match 1 and 2 Stars	£7.30	41,716	£304,526.80	161,018
Match 2 and 1 Star	£5.30	163,462	£866,348.60	669,394
Match 2	£3.20	346,166	£1,107,731.20	1,363,018
Totals	-	594,321	£2,881,821.90	2,363,020'


INSERT INTO @YourTable VALUES (1,@text)

;WITH CTE_Lines AS
(
	SELECT ID, a.ROWID , a.Lines 
	FROM @YourTable
    CROSS APPLY (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS ROWID, value Lines
				FROM STRING_SPLIT(TabString, CHAR(13)) --Splits by new lines
    ) a
), 

CTE_Columns AS
(
	SELECT ID, ROWID, b.ColsID, b.[Cols] 
	FROM CTE_Lines
		CROSS APPLY (SELECT  ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS ColsID, value [Cols] 
					FROM STRING_SPLIT(Lines, CHAR(9)) --Splits by tabs
					) b
    WHERE ROWID <> 1 --Removes the headers
)

SELECT NumbersMatched, 
	PrizePerWinner = CAST(PrizePerWinner AS MONEY),
	UKWinner = CAST(CAST(UKWinner AS MONEY) AS INT),
	PrizeFundAmount = CAST(PrizeFundAmount AS MONEY),
	TotalWinner = CAST(CAST(TotalWinner AS MONEY) AS INT)
FROM (	SELECT [1] NumbersMatched, [2] PrizePerWinner, [3] UKWinner, [4] PrizeFundAmount, [5] TotalWinner  
		FROM 
		(
			SELECT ID, ROWID, ColsID, [Cols]  
			FROM CTE_Columns 
		) a
		PIVOT (MAX(a.Cols) FOR ColsId in ([1],[2],[3], [4], [5])) as pvt
	) tbl
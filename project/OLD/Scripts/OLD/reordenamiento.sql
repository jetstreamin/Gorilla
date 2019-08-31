SELECT count(*) FROM NUMBERS (NOLOCK)

DECLARE @temp SMALLINT

WHILE (x=0)
	BEGIN
		IF N5 < N4
			BEGIN
				SET @temp = N4
				SET N4 = N5
				SET N5 = @temp
			END
		IF N4 < N3
			BEGIN
				SET @temp = N3
				SET N3 = N4
				SET N4 = @temp
			END
		IF N3 < N2
			BEGIN
				SET @temp = N2
				SET N2 = N3
				SET N3 = @temp
			END
		IF N2 < N1
			BEGIN
				SET @temp = N1
				SET N1 = N2
				SET N2 = @temp
			END
		IF (N5<N4) AND (N4<N3) AND(N3<N2) AND (N2<N1)
			SET x=1
	END


select *
from euro
where jackpot>50000000
order by jackpot DESC

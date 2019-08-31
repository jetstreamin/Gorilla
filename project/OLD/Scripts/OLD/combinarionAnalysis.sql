select N1, N2, x=COUNT(*)
from par
GROUP BY N1, N2
ORDER BY x DESC


select N1, N2, N3, x=COUNT(*)
from triple
GROUP BY N1, N2, N3
ORDER BY x DESC, N1 ASC, N2 ASC, N3 ASC

select * from euro
UPDATE A
SET avg_distance = CONVERT(MONEY,(n2-n1) + (n3-n2) + (n4-n3) + (n5-n4))/4
FROM ticket A

SELECT *
FROM ticket


SELECT y, 
N1=SUM(N1),
N2=SUM(N2),
N3=SUM(N3),
N4=SUM(N4),
N5=SUM(N5),
N6=SUM(N6),
N7=SUM(N7),
N8=SUM(N8),
N9=SUM(N9),
N10=SUM(N10),

N11=SUM(N11),
N12=SUM(N12),
N13=SUM(N13),
N14=SUM(N14),
N15=SUM(N15),
N16=SUM(N16),
N17=SUM(N17),
N18=SUM(N18),
N19=SUM(N19),
N20=SUM(N20),

N21=SUM(N21),
N22=SUM(N22),
N23=SUM(N23),
N24=SUM(N24),
N25=SUM(N25),
N26=SUM(N26),
N27=SUM(N27),
N28=SUM(N28),
N29=SUM(N29),
N30=SUM(N30),

N31=SUM(N31),
N32=SUM(N32),
N33=SUM(N33),
N34=SUM(N34),
N35=SUM(N35),
N36=SUM(N36),
N37=SUM(N37),
N38=SUM(N38),
N39=SUM(N39),
N40=SUM(N40),

N41=SUM(N41),
N42=SUM(N42),
N43=SUM(N43),
N44=SUM(N44),
N45=SUM(N45),
N46=SUM(N46),
N47=SUM(N47),
N48=SUM(N48),
N49=SUM(N49),
N50=SUM(N50)

FROM (

select y=year(date),
	N1 = (CASE WHEN N1=1 or N2=1 OR N3=1 OR N4=1 OR N5=1 THEN 1 ELSE 0 END),
	N2 = (CASE WHEN N1=2 or N2=2 OR N3=2 OR N4=2 OR N5=2 THEN 1 ELSE 0 END),
	N3 = (CASE WHEN N1=3 or N2=3 OR N3=3 OR N4=3 OR N5=3 THEN 1 ELSE 0 END),
	N4 = (CASE WHEN N1=4 or N2=4 OR N3=4 OR N4=4 OR N5=4 THEN 1 ELSE 0 END),
	N5 = (CASE WHEN N1=5 or N2=5 OR N3=5 OR N4=5 OR N5=5 THEN 1 ELSE 0 END),
	N6 = (CASE WHEN N1=6 or N2=6 OR N3=6 OR N4=6 OR N5=6 THEN 1 ELSE 0 END),
	N7 = (CASE WHEN N1=7 or N2=7 OR N3=7 OR N4=7 OR N5=7 THEN 1 ELSE 0 END),
	N8 = (CASE WHEN N1=8 or N2=8 OR N3=8 OR N4=8 OR N5=8 THEN 1 ELSE 0 END),
	N9 = (CASE WHEN N1=9 or N2=9 OR N3=9 OR N4=9 OR N5=9 THEN 1 ELSE 0 END),
	N10 = (CASE WHEN N1=10 or N2=10 OR N3=10 OR N4=10 OR N5=10 THEN 1 ELSE 0 END),

	N11 = (CASE WHEN N1=11 or N2=11 OR N3=11 OR N4=11 OR N5=11 THEN 1 ELSE 0 END),
	N12 = (CASE WHEN N1=12 or N2=12 OR N3=12 OR N4=12 OR N5=12 THEN 1 ELSE 0 END),
	N13 = (CASE WHEN N1=13 or N2=13 OR N3=13 OR N4=13 OR N5=13 THEN 1 ELSE 0 END),
	N14 = (CASE WHEN N1=14 or N2=14 OR N3=14 OR N4=14 OR N5=14 THEN 1 ELSE 0 END),
	N15 = (CASE WHEN N1=15 or N2=15 OR N3=15 OR N4=15 OR N5=15 THEN 1 ELSE 0 END),
	N16 = (CASE WHEN N1=16 or N2=16 OR N3=16 OR N4=16 OR N5=16 THEN 1 ELSE 0 END),
	N17 = (CASE WHEN N1=17 or N2=17 OR N3=17 OR N4=17 OR N5=17 THEN 1 ELSE 0 END),
	N18 = (CASE WHEN N1=18 or N2=18 OR N3=18 OR N4=18 OR N5=18 THEN 1 ELSE 0 END),
	N19 = (CASE WHEN N1=19 or N2=19 OR N3=19 OR N4=19 OR N5=19 THEN 1 ELSE 0 END),
	N20 = (CASE WHEN N1=20 or N2=20 OR N3=20 OR N4=20 OR N5=20 THEN 1 ELSE 0 END),

	N21 = (CASE WHEN N1=21 or N2=21 OR N3=21 OR N4=21 OR N5=21 THEN 1 ELSE 0 END),
	N22 = (CASE WHEN N1=22 or N2=22 OR N3=22 OR N4=22 OR N5=22 THEN 1 ELSE 0 END),
	N23 = (CASE WHEN N1=23 or N2=23 OR N3=23 OR N4=23 OR N5=23 THEN 1 ELSE 0 END),
	N24 = (CASE WHEN N1=24 or N2=24 OR N3=24 OR N4=24 OR N5=24 THEN 1 ELSE 0 END),
	N25 = (CASE WHEN N1=25 or N2=25 OR N3=25 OR N4=25 OR N5=25 THEN 1 ELSE 0 END),
	N26 = (CASE WHEN N1=26 or N2=26 OR N3=26 OR N4=26 OR N5=26 THEN 1 ELSE 0 END),
	N27 = (CASE WHEN N1=27 or N2=27 OR N3=27 OR N4=27 OR N5=27 THEN 1 ELSE 0 END),
	N28 = (CASE WHEN N1=28 or N2=28 OR N3=28 OR N4=28 OR N5=28 THEN 1 ELSE 0 END),
	N29 = (CASE WHEN N1=29 or N2=29 OR N3=29 OR N4=29 OR N5=29 THEN 1 ELSE 0 END),
	N30 = (CASE WHEN N1=30 or N2=30 OR N3=30 OR N4=30 OR N5=30 THEN 1 ELSE 0 END),

	N31 = (CASE WHEN N1=31 or N2=31 OR N3=31 OR N4=31 OR N5=31 THEN 1 ELSE 0 END),
	N32 = (CASE WHEN N1=32 or N2=32 OR N3=32 OR N4=32 OR N5=32 THEN 1 ELSE 0 END),
	N33 = (CASE WHEN N1=33 or N2=33 OR N3=33 OR N4=33 OR N5=33 THEN 1 ELSE 0 END),
	N34 = (CASE WHEN N1=34 or N2=34 OR N3=34 OR N4=34 OR N5=34 THEN 1 ELSE 0 END),
	N35 = (CASE WHEN N1=35 or N2=35 OR N3=35 OR N4=35 OR N5=35 THEN 1 ELSE 0 END),
	N36 = (CASE WHEN N1=36 or N2=36 OR N3=36 OR N4=36 OR N5=36 THEN 1 ELSE 0 END),
	N37 = (CASE WHEN N1=37 or N2=37 OR N3=37 OR N4=37 OR N5=37 THEN 1 ELSE 0 END),
	N38 = (CASE WHEN N1=38 or N2=38 OR N3=38 OR N4=38 OR N5=38 THEN 1 ELSE 0 END),
	N39 = (CASE WHEN N1=39 or N2=39 OR N3=39 OR N4=39 OR N5=39 THEN 1 ELSE 0 END),
	N40 = (CASE WHEN N1=40 or N2=40 OR N3=40 OR N4=40 OR N5=40 THEN 1 ELSE 0 END),

	N41 = (CASE WHEN N1=41 or N2=41 OR N3=41 OR N4=41 OR N5=41 THEN 1 ELSE 0 END),
	N42 = (CASE WHEN N1=42 or N2=42 OR N3=42 OR N4=42 OR N5=42 THEN 1 ELSE 0 END),
	N43 = (CASE WHEN N1=43 or N2=43 OR N3=43 OR N4=43 OR N5=43 THEN 1 ELSE 0 END),
	N44 = (CASE WHEN N1=44 or N2=44 OR N3=44 OR N4=44 OR N5=44 THEN 1 ELSE 0 END),
	N45 = (CASE WHEN N1=45 or N2=45 OR N3=45 OR N4=45 OR N5=45 THEN 1 ELSE 0 END),
	N46 = (CASE WHEN N1=46 or N2=46 OR N3=46 OR N4=46 OR N5=46 THEN 1 ELSE 0 END),
	N47 = (CASE WHEN N1=47 or N2=47 OR N3=47 OR N4=47 OR N5=47 THEN 1 ELSE 0 END),
	N48 = (CASE WHEN N1=48 or N2=48 OR N3=48 OR N4=48 OR N5=48 THEN 1 ELSE 0 END),
	N49 = (CASE WHEN N1=49 or N2=49 OR N3=49 OR N4=49 OR N5=49 THEN 1 ELSE 0 END),
	N50 = (CASE WHEN N1=50 or N2=50 OR N3=50 OR N4=50 OR N5=50 THEN 1 ELSE 0 END)
from euro) a
GROUP BY y
--where date between '2010-01-01' AND '2010-12-31'
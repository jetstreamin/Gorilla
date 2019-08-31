--EXEC Gorilla..SP_POPULATE_CHUNK_TABLES
--EXEC Gorilla..SP_DRAW_ANALYSIS

/*
new_doublet: si el sorteo generó un nuevo doble
new_triplet: si el sorteo generó un nuevo triple
new_quadruplet: si el sorteo generó un nuevo quadruplet
doublet_draws_ago_when: numero de sorteos que han pasado desde la ultima aparición de algun doble
sum_total: sumatoria de todos los numeros
number_odd: numero de impares
number_even: numero de pares
D1: distancia entre el 1er y 2do numero (D2-D1)
D2: distancia entre el 2do y 3er numero (D3-D2)
D3: distancia entre el 3er y 4to numero (D4-D3)
D4: distancia entre el 4to y 5to numero (D5-D4)
number_previous_1_draw: cantidad de numeros iguales en el sorteo anterior
number_previous_5_draw: cantidad de numeros iguales hasta 5 sorteos anteriores
sum_distance: sumatoria de distancias (D1+D2+D3+D4)
all_same_distance: si las distancias son iguales
is_winning_distance: si es una combinación de distancias ganadora
is_winning_distance_X_50: si es una combinación de distancias ganadora D1 + @i, D2 + @i, D3 + @i, D4 + @i (@i -50, 50)
is_winning_distance_D1_D2_D3: si es una combinación de distancias ganadora D1, D2, D3
is_winning_distance_X_50_D1_D2_D3: si es una combinación de distancias ganadora D1 + @i, D2 + @i, D3 + @i (@i -50, 50)
is_winning_number_X: n1 + @i, n2 + @i, n3 + @i, n4 + @i, n5 + @i (@i -50, 50)
last_sum_number_draw_when: hace cuantos sorteos aparecio el mismo sum_number
X_Y: cantidad de numeros aparecidos en ese rango
last_tent_draw_when: hace cuantos sorteos aparecio la misma combinacion de X_Y


*/



SELECT *
FROM winner
WHERE (sum_total BETWEEN 90 AND 160)
	AND (number_even in (2,3) AND number_odd IN (2,3))
	AND sum_distance > 20
	AND first_half IN (2,3) AND second_half IN (2,3)

SELECT *
FROM winner
WHERE (number_even in (1,2,3,4) AND number_odd IN (1,2,3,4))
AND (sum_total BETWEEN 90 AND 160)

select 451/475.0



SELECT MIN_N1 = MIN(N1), MIN_N2 = MIN(N2), MIN_N3 = MIN(N3), MIN_N4 = MIN(N4), MIN_N5 = MIN(N5)
FROM winner

SELECT MAX_N1 = MAX(N1), MAX_N2 = MAX(N2), MAX_N3 = MAX(N3), MAX_N4 = MAX(N4), MAX_N5 = MAX(N5)
FROM winner

select *
from CHUNK_DOUBLET

--UPDATE A
--SET [1_10] = dbo.number_between(n1, 1,10) + dbo.number_between(n2, 1,10) + dbo.number_between(n3, 1,10) + dbo.number_between(n4, 1,10) + dbo.number_between(n5, 1,10),
--	[11_20] = dbo.number_between(n1, 11,20) + dbo.number_between(n2, 11,20) + dbo.number_between(n3, 11,20) + dbo.number_between(n4, 11,20) + dbo.number_between(n5, 11,20),
--	[21_30] = dbo.number_between(n1, 21,30) + dbo.number_between(n2, 21,30) + dbo.number_between(n3, 21,30) + dbo.number_between(n4, 21,30) + dbo.number_between(n5, 21,30),
--	[31_40] = dbo.number_between(n1, 31,40) + dbo.number_between(n2, 31,40) + dbo.number_between(n3, 31,40) + dbo.number_between(n4, 31,40) + dbo.number_between(n5, 31,40),
--	[41_50] = dbo.number_between(n1, 41,50) + dbo.number_between(n2, 41,50) + dbo.number_between(n3, 41,50) + dbo.number_between(n4, 41,50) + dbo.number_between(n5, 41,50) 
--FROM ticket A


select MAX(pk_id)
from ticket

2.118.760
2118760

select 2010*1050

select 2118760/1050

select (1051*1919)-2118760
/*
1) SP para generar la lista de tickets a jugar
	- Crear tabla XYZ e insertar universo de tickets
	- Ejecutar cada condicion y su SP asociado para eliminar tickets en tabla XYZ
		- Crear cada SP para cada condicion
	- Mostrar resultados
2) SP para analizar los tickets ganadores con una columna por cada criterio utilizado
	- Crear una tabla por cada condicion y repopularla cada vez que se ejecute SP previo
	- Cada ticket ganador se cruzara con cada tabla-condicion
3) OK Tabla para guardar las todas condiciones y especificar: descripcion, nombre sp, si está activo, orden ejecucion, etc



Procesos:

- tbl_filter
- tbl_ticket
- tbl_winning

A. Generación de lista de ticket
	- sp_list_generate
		- sp_filter_xxx
		- sp_filter_yyy
		- sp_filter_zzz
	- tbl_list_draw (tbl_draw_drawid_YYYYMMDD
	
B. Analisis de ganadores
	- sp_winning_analysis
	- tbl_filter_xxx
	- tbl_filter_yyy
	- tbl_filter_zzz
*/

SELECT *
FROM tbl_filter


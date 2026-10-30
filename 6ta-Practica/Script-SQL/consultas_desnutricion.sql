


SELECT * FROM dim_estado;
SELECT * FROM dim_ubicacion;
SELECT * FROM dim_nino LIMIT 10;
SELECT * FROM dim_fecha LIMIT 10;
TRUNCATE dim_nino, dim_estado, dim_ubicacion, dim_fecha, fact_desnutricion RESTART IDENTITY CASCADE;



SELECT * FROM fact_desnutricion LIMIT 10;


SELECT 'dim_nino' AS tabla, COUNT(*) FROM dim_nino
UNION ALL SELECT 'dim_estado', COUNT(*) FROM dim_estado
UNION ALL SELECT 'dim_ubicacion', COUNT(*) FROM dim_ubicacion
UNION ALL SELECT 'dim_fecha', COUNT(*) FROM dim_fecha
UNION ALL SELECT 'fact_desnutricion', COUNT(*) FROM fact_desnutricion;

SELECT u.region, e.tipo_desnutricion, SUM(f.num_casos) AS casos
FROM fact_desnutricion f
JOIN dim_ubicacion u ON u.id_ubicacion = f.id_ubicacion
JOIN dim_estado e    ON e.id_estado    = f.id_estado
GROUP BY u.region, e.tipo_desnutricion
ORDER BY u.region, casos DESC;


SELECT n.grupo_edad, n.genero, e.tipo_desnutricion, SUM(f.num_casos) AS casos
FROM fact_desnutricion f
JOIN dim_nino n   ON n.id_nino   = f.id_nino
JOIN dim_estado e ON e.id_estado = f.id_estado
GROUP BY n.grupo_edad, n.genero, e.tipo_desnutricion
ORDER BY n.grupo_edad, n.genero, e.tipo_desnutricion;


-- Solo por edad
SELECT n.grupo_edad, e.tipo_desnutricion, SUM(f.num_casos) AS casos
FROM fact_desnutricion f
JOIN dim_nino n   ON n.id_nino   = f.id_nino
JOIN dim_estado e ON e.id_estado = f.id_estado
GROUP BY n.grupo_edad, e.tipo_desnutricion
ORDER BY n.grupo_edad, e.tipo_desnutricion;

-- Solo por género
SELECT n.genero, e.tipo_desnutricion, SUM(f.num_casos) AS casos
FROM fact_desnutricion f
JOIN dim_nino n   ON n.id_nino   = f.id_nino
JOIN dim_estado e ON e.id_estado = f.id_estado
GROUP BY n.genero, e.tipo_desnutricion
ORDER BY n.genero, e.tipo_desnutricion;


SELECT u.institucion, SUM(f.num_casos) AS casos,
       ROUND(100.0 * SUM(f.num_casos) / SUM(SUM(f.num_casos)) OVER (), 1) AS porcentaje
FROM fact_desnutricion f
JOIN dim_ubicacion u ON u.id_ubicacion = f.id_ubicacion
GROUP BY u.institucion
ORDER BY casos DESC;


SELECT u.institucion, SUM(f.num_casos) AS casos
FROM fact_desnutricion f
JOIN dim_ubicacion u ON u.id_ubicacion = f.id_ubicacion
GROUP BY u.institucion
ORDER BY casos DESC;





-- Reconstrucción del registro original desde el esquema estrella
SELECT n.child_id, n.genero, n.grupo_edad, e.tipo_desnutricion,
       u.region, u.institucion, d.fecha, f.peso_kg, f.talla_cm
FROM fact_desnutricion f
JOIN dim_nino n      ON n.id_nino      = f.id_nino
JOIN dim_estado e    ON e.id_estado    = f.id_estado
JOIN dim_ubicacion u ON u.id_ubicacion = f.id_ubicacion
JOIN dim_fecha d     ON d.id_fecha     = f.id_fecha
ORDER BY n.child_id
LIMIT 10;
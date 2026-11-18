0) Comprobar la carga:
SELECT 'fact_pedidos' tabla, COUNT(*) filas FROM fact_pedidos
UNION ALL SELECT 'fact_soporte', COUNT(*) FROM fact_soporte
UNION ALL SELECT 'dim_fecha', COUNT(*) FROM dim_fecha
UNION ALL SELECT 'dim_producto', COUNT(*) FROM dim_producto
UNION ALL SELECT 'dim_cliente', COUNT(*) FROM dim_cliente
UNION ALL SELECT 'dim_ubicacion', COUNT(*) FROM dim_ubicacion;

1) Productos y categorías más vendidos por ciudad:
SELECT u.ciudad, p.categoria, p.producto, SUM(f.cantidad) AS unidades
FROM fact_pedidos f
JOIN dim_producto  p ON p.id_producto  = f.id_producto
JOIN dim_ubicacion u ON u.id_ubicacion = f.id_ubicacion
GROUP BY u.ciudad, p.categoria, p.producto
ORDER BY u.ciudad, unidades DESC;


2) Clientes que compran más productos por ciudad:
SELECT u.ciudad, c.cliente, SUM(f.cantidad) AS unidades
FROM fact_pedidos f
JOIN dim_cliente   c ON c.id_cliente   
= f.id_cliente
JOIN dim_ubicacion u ON u.id_ubicacion = f.id_ubicacion
GROUP BY u.ciudad, c.cliente
ORDER BY unidades DESC;

3) Productos y categorías con más tickets. Ahora se usa fact_soporte, y COUNT(*) 
cuenta tickets:
SELECT p.categoria, p.producto, COUNT(*) AS tickets
FROM fact_soporte s
JOIN dim_producto p ON p.id_producto = s.id_producto
GROUP BY p.categoria, p.producto
ORDER BY tickets DESC;

4) Clientes con más tickets:
SELECT c.cliente, COUNT(*) AS tickets
FROM fact_soporte s
JOIN dim_cliente c ON c.id_cliente = s.id_cliente
GROUP BY c.cliente
ORDER BY tickets DESC;

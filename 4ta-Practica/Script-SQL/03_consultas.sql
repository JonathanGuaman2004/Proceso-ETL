-- 1. Ventas por categoría y mes
SELECT p.category, d.year_month, COUNT(*) AS num_ventas, SUM(f.sales_amount) AS total
FROM fact_ventas f
JOIN dim_producto p ON p.product_key = f.product_key
JOIN dim_fecha d    ON d.date_key    = f.order_date_key
GROUP BY p.category, d.year_month ORDER BY d.year_month, p.category;

-- 2. Ingreso total por cliente y género
SELECT c.customer_key, c.gender, SUM(f.sales_amount) AS ingreso_total
FROM fact_ventas f JOIN dim_cliente c ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.gender ORDER BY ingreso_total DESC;

-- 3. Cantidad total vendida por producto
SELECT p.product_name, SUM(f.quantity) AS cantidad_total
FROM fact_ventas f JOIN dim_producto p ON p.product_key = f.product_key
GROUP BY p.product_name ORDER BY cantidad_total DESC;

-- 4. Cantidad enviada por mes de envío 
SELECT d.year_month AS mes_envio, SUM(f.quantity) AS cantidad_enviada
FROM fact_ventas f JOIN dim_fecha d ON d.date_key = f.ship_date_key
GROUP BY d.year_month ORDER BY d.year_month;

-- 5. Ventas por tamaño y estado civil
SELECT p.size, c.marital_status, SUM(f.sales_amount) AS total_vendido
FROM fact_ventas f
JOIN dim_producto p ON p.product_key = f.product_key
JOIN dim_cliente c  ON c.customer_key = f.customer_key
GROUP BY p.size, c.marital_status ORDER BY p.size, c.marital_status;
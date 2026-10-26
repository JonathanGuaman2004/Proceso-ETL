-- ===== products =====
SELECT COUNT(*) AS total_registros FROM stg_products;               
SELECT COUNT(DISTINCT product_id) AS productos_unicos FROM stg_products;  
SELECT COUNT(DISTINCT category) AS categorias,
       COUNT(DISTINCT subcategory) AS subcategorias FROM stg_products;    

UPDATE stg_products
SET product_name = btrim(regexp_replace(regexp_replace(product_name, '\s+', ' ', 'g'), '\s+\)', ')', 'g')),
    category     = btrim(category),
    subcategory  = btrim(subcategory);

SELECT product_id, COUNT(*) FROM stg_products GROUP BY product_id HAVING COUNT(*) > 1;  
SELECT * FROM stg_products WHERE product_id IS NULL OR product_id = '';                 

-- ===== ventas =====
SELECT COUNT(*) AS filas, COUNT(DISTINCT order_number) AS ordenes,
       COUNT(DISTINCT product_key) AS productos, COUNT(DISTINCT customer_key) AS clientes
FROM stg_ventas;                                      
SELECT * FROM stg_ventas
WHERE product_key IS NULL OR customer_key IS NULL OR order_date IS NULL OR sales_amount IS NULL;  

SELECT * FROM stg_ventas WHERE ship_date < order_date;               
SELECT * FROM stg_ventas WHERE quantity * unit_price <> sales_amount; 

UPDATE stg_ventas SET
  product_name = TRIM(product_name), category = TRIM(category), subcategory = TRIM(subcategory),
  color = TRIM(color), size = TRIM(size), marital_status = TRIM(marital_status),
  gender = UPPER(TRIM(gender)), home_owner = TRIM(home_owner);


-- Carga de dimensiones
INSERT INTO dim_producto
SELECT DISTINCT product_key, product_code, product_name, list_price, color, size, category, subcategory
FROM stg_ventas;

INSERT INTO dim_cliente
SELECT DISTINCT customer_key, birth_date, marital_status, gender, income, children, home_owner, cars
FROM stg_ventas;

INSERT INTO dim_fecha
SELECT DISTINCT TO_CHAR(f,'YYYYMMDD')::INT, f, EXTRACT(YEAR FROM f), EXTRACT(QUARTER FROM f),
       EXTRACT(MONTH FROM f), TRIM(TO_CHAR(f,'TMMonth')), TO_CHAR(f,'YYYY-MM')
FROM (SELECT order_date AS f FROM stg_ventas
      UNION SELECT ship_date FROM stg_ventas) t;

INSERT INTO fact_ventas
SELECT order_number, order_line_number, product_key, customer_key,
       order_date_key, ship_date_key, quantity, unit_price, product_cost, sales_amount
FROM stg_ventas;

-- Comprobación
SELECT (SELECT COUNT(*) FROM dim_producto) AS productos,   
       (SELECT COUNT(*) FROM dim_cliente)  AS clientes,    
       (SELECT COUNT(*) FROM dim_fecha)    AS fechas,     
       (SELECT COUNT(*) FROM fact_ventas)  AS ventas,      
       (SELECT SUM(sales_amount) FROM fact_ventas) AS total;  
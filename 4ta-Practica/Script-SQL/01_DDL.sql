DROP TABLE IF EXISTS fact_ventas, dim_producto, dim_cliente, dim_fecha, stg_ventas, stg_products;

-- Staging de products.csv 
CREATE TABLE stg_products (
  product_id VARCHAR(5), product_name VARCHAR(150),
  category VARCHAR(80), subcategory VARCHAR(80));

-- Staging de ventas
CREATE TABLE stg_ventas (
  product_key INT, product_code VARCHAR(10), product_name VARCHAR(100), list_price NUMERIC(10,2),
  color VARCHAR(20), size VARCHAR(20), category VARCHAR(50), subcategory VARCHAR(50),
  customer_key INT, birth_date DATE, marital_status VARCHAR(20), gender CHAR(1), income NUMERIC(12,2),
  children INT, home_owner VARCHAR(5), cars INT,
  order_date_key INT, order_date DATE, ship_date_key INT, ship_date DATE,
  order_number VARCHAR(20), order_line_number INT, quantity INT,
  unit_price NUMERIC(10,2), product_cost NUMERIC(10,2), sales_amount NUMERIC(12,2));

CREATE TABLE dim_producto (
  product_key INT PRIMARY KEY, product_code VARCHAR(10) NOT NULL, product_name VARCHAR(100) NOT NULL,
  list_price NUMERIC(10,2), color VARCHAR(20), size VARCHAR(20),
  category VARCHAR(50), subcategory VARCHAR(50));

CREATE TABLE dim_cliente (
  customer_key INT PRIMARY KEY, birth_date DATE, marital_status VARCHAR(20), gender CHAR(1),
  income NUMERIC(12,2), children INT, home_owner VARCHAR(5), cars INT);

CREATE TABLE dim_fecha (
  date_key INT PRIMARY KEY, full_date DATE NOT NULL, year INT, quarter INT,
  month INT, month_name VARCHAR(15), year_month CHAR(7));

CREATE TABLE fact_ventas (
  order_number VARCHAR(20), order_line_number INT,
  product_key   INT REFERENCES dim_producto(product_key),
  customer_key  INT REFERENCES dim_cliente(customer_key),
  order_date_key INT REFERENCES dim_fecha(date_key),
  ship_date_key  INT REFERENCES dim_fecha(date_key),
  quantity INT, unit_price NUMERIC(10,2), product_cost NUMERIC(10,2), sales_amount NUMERIC(12,2),
  PRIMARY KEY (order_number, order_line_number));
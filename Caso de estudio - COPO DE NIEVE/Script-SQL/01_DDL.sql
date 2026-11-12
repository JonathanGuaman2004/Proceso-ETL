-- ============================================================================
-- SCRIPT 01: DDL - CREACIÓN DEL MODELO COPO DE NIEVE (SNOWFLAKE SCHEMA)
-- ============================================================================

-- 1. SUB-DIMENSIONES (NIVEL 2 DEL COPO DE NIEVE)
CREATE TABLE brand (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. DIMENSIONES PRINCIPALES (NIVEL 1)
CREATE TABLE store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(150) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(150),
    street VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20)
);

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL REFERENCES brand(brand_id),
    category_id INT NOT NULL REFERENCES category(category_id),
    model_year INT NOT NULL,
    list_price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(150),
    street VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20)
);

CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(50),
    active INT NOT NULL,
    store_id INT NOT NULL REFERENCES store(store_id),
    manager_id INT REFERENCES staff(staff_id)
);

CREATE TABLE calendar (
    date_value DATE PRIMARY KEY,
    year INT NOT NULL,
    quarter_of_year INT NOT NULL,
    month_of_year INT NOT NULL,
    day_of_month INT NOT NULL,
    date_int INT UNIQUE NOT NULL,
    month_name VARCHAR(30) NOT NULL,
    month_in_calendar VARCHAR(30) NOT NULL,
    quarter_in_calendar VARCHAR(30) NOT NULL,
    day_in_week INT NOT NULL,
    day_of_week_name VARCHAR(30) NOT NULL,
    week_ending DATE NOT NULL,
    week_number INT NOT NULL,
    month_n_year INT NOT NULL,
    quarter_n_year INT NOT NULL,
    short_year INT NOT NULL,
    fy VARCHAR(20) NOT NULL
);

-- 3. TABLAS DE HECHOS (FACT TABLES)
CREATE TABLE stock (
    store_id INT NOT NULL REFERENCES store(store_id),
    product_id INT NOT NULL REFERENCES product(product_id),
    quantity INT NOT NULL,
    PRIMARY KEY (store_id, product_id)
);

CREATE TABLE order_details (
    order_id INT NOT NULL,
    product_id INT NOT NULL REFERENCES product(product_id),
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    order_date DATE NOT NULL REFERENCES calendar(date_value),
    required_date DATE NOT NULL,
    shipped_date DATE REFERENCES calendar(date_value),
    store_id INT NOT NULL REFERENCES store(store_id),
    staff_id INT NOT NULL REFERENCES staff(staff_id),
    quantity INT NOT NULL,
    list_price NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);
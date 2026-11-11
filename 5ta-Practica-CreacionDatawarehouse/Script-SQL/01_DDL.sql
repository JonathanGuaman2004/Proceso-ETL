-- =====================================================
-- DW Desnutrición Infantil - Esquema estrella
-- Base de datos: dw_desnutricion (PostgreSQL)
-- =====================================================
DROP TABLE IF EXISTS fact_desnutricion, dim_nino, dim_estado, dim_ubicacion,
                     dim_fecha, stg_desnutricion CASCADE;

-- Tabla temporal donde Pentaho carga el CSV
CREATE TABLE stg_desnutricion (
    child_id            VARCHAR(10),
    gender              CHAR(1),
    age_months          INT,
    weight_kg           NUMERIC(5,2),
    height_cm           NUMERIC(5,2),
    nutritional_status  VARCHAR(20),
    region              VARCHAR(30),
    institution         VARCHAR(50),
    date_measured       DATE
);

-- ¿edad y género?
CREATE TABLE dim_nino (
    id_nino      SERIAL PRIMARY KEY,
    child_id     VARCHAR(10) UNIQUE NOT NULL,
    genero       VARCHAR(10),
    edad_meses   INT,
    grupo_edad   VARCHAR(20)
);

-- ¿qué tipo?
CREATE TABLE dim_estado (
    id_estado          SERIAL PRIMARY KEY,
    tipo_desnutricion  VARCHAR(20) UNIQUE NOT NULL
);

-- ¿qué región? ¿qué institución?
CREATE TABLE dim_ubicacion (
    id_ubicacion  SERIAL PRIMARY KEY,
    region        VARCHAR(30) NOT NULL,
    institucion   VARCHAR(50) NOT NULL,
    UNIQUE (region, institucion)
);

-- ¿cuándo?
CREATE TABLE dim_fecha (
    id_fecha   SERIAL PRIMARY KEY,
    fecha      DATE UNIQUE NOT NULL,
    anio       INT,
    trimestre  INT,
    mes        INT,
    dia        INT
);

-- Tabla de hechos
CREATE TABLE fact_desnutricion (
    id_hecho      SERIAL PRIMARY KEY,
    id_nino       INT REFERENCES dim_nino(id_nino),
    id_estado     INT REFERENCES dim_estado(id_estado),
    id_ubicacion  INT REFERENCES dim_ubicacion(id_ubicacion),
    id_fecha      INT REFERENCES dim_fecha(id_fecha),
    peso_kg       NUMERIC(5,2),
    talla_cm      NUMERIC(5,2),
    num_casos     INT DEFAULT 1
);

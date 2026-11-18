DROP TABLE IF EXISTS fact_pedidos, fact_soporte, dim_fecha, dim_producto, dim_cliente, dim_ubicacion, dim_motivo CASCADE;


CREATE TABLE dim_producto (
    id_producto  SERIAL PRIMARY KEY,
    producto     VARCHAR(60),
    categoria    VARCHAR(40),
    marca        VARCHAR(40)
);

CREATE TABLE dim_cliente (
    id_cliente   SERIAL PRIMARY KEY,
    cliente      VARCHAR(60)
);
CREATE TABLE dim_ubicacion (
    id_ubicacion SERIAL PRIMARY KEY,
    ciudad       VARCHAR(40),
    region       VARCHAR(20)
);

CREATE TABLE dim_fecha (
    id_fecha     SERIAL PRIMARY KEY,
    fecha        DATE,
    anio         INTEGER,
    mes         INTEGER,
    dia         INTEGER,
    dia_semana   INTEGER  
);



CREATE TABLE fact_pedidos (
    id_pedido     SERIAL PRIMARY KEY,
    id_fecha      INTEGER REFERENCES dim_fecha(id_fecha),
    id_producto   INTEGER REFERENCES dim_producto(id_producto),
    id_cliente    INTEGER REFERENCES dim_cliente(id_cliente),
    id_ubicacion  INTEGER REFERENCES dim_ubicacion(id_ubicacion),
    cantidad      INTEGER,
    total_pedido  NUMERIC(12,2)
);


CREATE TABLE fact_soporte (
    id_soporte       SERIAL PRIMARY KEY,
    ticket_id        INTEGER,
    id_fecha         INTEGER REFERENCES dim_fecha(id_fecha),      
    id_producto      INTEGER REFERENCES dim_producto(id_producto),   
    id_cliente          INTEGER REFERENCES dim_cliente(id_cliente),   
    id_ubicacion        INTEGER REFERENCES dim_ubicacion(id_ubicacion),
    motivo                 VARCHAR(60),
    tiempo_respuesta_horas INTEGER,
    cantidad_tickets       INTEGER DEFAULT 1
);

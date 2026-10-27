<div align="center" style="font-family: Arial, Helvetica, sans-serif; color: #0C233F; max-width: 900px; margin: 0 auto;">

  <!-- Encabezado institucional -->
  <div style="background-color: #0C233F; padding: 32px 20px; border-radius: 8px 8px 0 0;">
  <img src="../img/logos/EPN-blanco.png"
         alt="Logo de la Escuela Politécnica Nacional"
         width="200">
<h1 style="color: #FFFFFF; font-size: 25px; margin: 20px 0 8px;">
      ESCUELA POLITÉCNICA NACIONAL
    </h1>
<p style="color: #DBD49A; font-size: 17px; margin: 0;">
      Facultad de Ingeniería en Sistemas
    </p>

  </div>

  <!-- Línea institucional -->
  <div style="height: 5px; background-color: #E22726;"></div>

  <!-- Información académica -->
  <div style="padding: 38px 24px 28px; border: 1px solid #E2E8F0; border-top: none;">

<p style="color: #E22726; font-size: 13px; font-weight: bold; letter-spacing: 2px;">
      INFORME ACADÉMICO
    </p>

<div style="width: 65px; height: 3px; background-color: #F4BC47; margin: 18px auto;"></div>

<h2 style="color: #0C233F; font-size: 28px; margin: 20px 0;">
      MODELO FÍSICO DIMENSIONAL POSTGRESQL
    </h2>

<p style="font-size: 16px; color: #475569;">
      <strong>Materia:</strong> Business Intelligence<br>
      <strong>Paralelo:</strong> GR2SW_2026-B<br>
      <strong>Fecha:</strong> 27 de octubre de 2026
    </p>

<br>

<!-- Integrantes -->
<div style="background-color: #F7F5E9; border-left: 4px solid #F4BC47; padding: 20px; margin: 10px auto; max-width: 520px;">

<h3 style="color: #0C233F; font-size: 17px; margin-top: 0;">
        INTEGRANTES
      </h3>

<p style="color: #334155; line-height: 1.9; margin-bottom: 0;">
        Guamán Maza Jonathan Steven<br>
        Jarrin Román Helen Scarleth<br>
        Maldonado Simbaña Shirley Estefani<br>
        Sigcha Diaz Christian David
      </p>

</div>

  </div>

  <!-- Pie decorativo -->
  <div style="height: 4px; background-color: #F4BC47;"></div>

</div>

---

**[Enlace al repositorio de GitHub][1]**

---

## Índice

### Contenido

1. [Objetivos](#objetivos)
   - [Objetivo general](#objetivo-general)
   - [Objetivos específicos](#objetivos-específicos)
2.

### Índice de figuras

-

### Índice de tablas

-

---

## Objetivos

### Objetivo general

-

### Objetivos específicos

-

---

## Fuentes de datos

Se utilizó los archivos [`products.csv`](Proceso-ETL/4ta-Practica/Fuentes/products.csv) y [`Tabla_Desnormalizada_Ventas.csv`](Proceso-ETL/4ta-Practica/Fuentes/Tabla_Desnormalizada_Ventas.csv) , disponible en el Aula Virtual de la EPN.

**Figura 1:** Archivo fuente original.

![Archivo fuente](img/fuenteOriginal.png)

_Descripción: Captura de pantalla de los archivos `.csv` del que se obtuvieron los datos, disponible en el Aula Virtual de la EPN._

---

## Diseño dimensional

**Figura 2:** Diagrama en Power Pivot.

![Archivo fuente](img/PowerPivot/diagrama.png)

_Descripción: _

---

## Problemas encontrados en los datos

- **Estructura del archivo:** El archivo `Tabla_Desnormalizada_Ventas.csv` utiliza punto y coma (`;`) como delimitador en lugar de coma, está codificado en UTF-8 con BOM y usa saltos de línea de Windows (CRLF). Si no se configura el delimitador correcto en pgAdmin, la importación falla. Además, los nombres de columna contienen espacios y mayúsculas (`Product Name`, `Marital Status`, `Order Date`), por lo que se renombraron en formato `snake_case` (`product_name`, `marital_status`, `order_date`) para facilitar su uso en SQL.
- **Desnormalización general:** Toda la información de producto, cliente, fechas y venta se encuentra en una sola tabla de 100 registros. Esto provoca que los atributos de los 9 productos y los 10 clientes se repitan en cada venta; por ejemplo, los datos del cliente `1043` se repiten en todas sus compras.
- **`ProductKey`, `Product Code` y `Product Name`:** El mismo producto se identifica con tres valores distintos que siguen numeraciones diferentes, lo que genera redundancia y puede causar confusión. Por ejemplo, el producto con `ProductKey` `105` tiene el código `P104` y el nombre `Product 5`. Se utilizó `ProductKey` como clave de la dimensión.
- **`Product Name`:** Los nombres de producto son genéricos (`Product 5`, `Product 12`) y no describen el artículo, por lo que no aportan valor descriptivo en los análisis.
- **`List Price` y `UnitPrice`:** Ambos campos tienen el mismo valor en el 100 % de los registros, lo que constituye información redundante. Como no se registran descuentos, el precio de lista se ubicó en `dim_producto` y el precio unitario en la tabla de hechos.
- **`Category` y `Subcategory`:** No se identificaron inconsistencias de escritura ni variaciones en los nombres. Sin embargo, la clasificación es discutible en algunos casos: la subcategoría `Cameras` se encuentra en `Accessories`, mientras que productos similares como `Tablets` y `Computers` pertenecen a `Electronics`.
- **`Color` y `Size`:** No se identificaron inconsistencias evidentes; cada producto tiene un único color y un único tamaño (`Small`, `Medium`, `Large`).
- **`CustomerKey`:** El conjunto de datos no incluye el nombre del cliente, por lo que las consultas por cliente deben realizarse únicamente con su identificador numérico.
- **`Birth Date`, `Order Date` y `Ship Date`:** Las fechas están almacenadas como texto en formato `AAAA-MM-DD` y requieren conversión al tipo `DATE`. Además, la edad del cliente no está registrada y debe calcularse a partir de `Birth Date`.
- **`OrderDateKey` y `ShipDateKey`:** Estos campos repiten la misma información que `Order Date` y `Ship Date`, pero en formato numérico `AAAAMMDD`, por lo que son redundantes. Se aprovecharon como clave de la dimensión `dim_fecha`. No se encontraron fechas de envío anteriores a la fecha de venta.
- **`Gender`, `Marital Status` y `Home Owner`:** Los valores están codificados (`M`/`F`) o en inglés (`Single`/`Married`, `Yes`/`No`). En particular, `Home Owner` es un dato lógico almacenado como texto en lugar de un valor booleano.
- **`Income`:** El campo no indica la moneda ni si corresponde a un ingreso mensual o anual.
- **`OrderNumber` y `OrderLineNumber`:** Cada orden contiene una sola línea, por lo que `OrderLineNumber` siempre vale `1` y no aporta información adicional.
- **`ProductCost`:** El nombre del campo no indica si el costo es unitario o total. Al compararlo con `UnitPrice` se determinó que es unitario. También varía entre ventas del mismo producto; por ejemplo, el costo de `Product 19` va de `267` a `277`. Por esta razón se registró en la tabla de hechos y no en la dimensión de producto.
- **`SalesAmount`:** Es un campo calculado (`Quantity × UnitPrice`); se verificó que la operación coincide en todos los registros.
- **Valores nulos y duplicados:** No se encontraron valores vacíos ni registros duplicados en el conjunto de datos.
- **`product_name` (products.csv):** Algunos nombres de producto contienen tabulaciones y espacios repetidos, por lo que se limpiaron con `btrim` y `regexp_replace` antes de cargarlos a `dim_product`.

---

## Transformaciones aplicadas

### Tabla_Desnormalizada_Ventas.csv

- **Nombres de columnas:** Se renombraron las 26 columnas al formato `snake_case`, sin espacios y en minúsculas; por ejemplo, `Product Name` pasó a `product_name` y `Marital Status` a `marital_status`. La importación se configuró con delimitador `;`, codificación `UTF8` y encabezado activado.
- **`ProductKey`, `CustomerKey`, `OrderDateKey` y `ShipDateKey`:** Se conservaron los identificadores originales y se utilizaron como claves primarias de las dimensiones y como claves foráneas en la tabla de hechos.
- **`Product Code` y `Product Name`:** Se conservaron los valores originales; solo se eliminaron los espacios al inicio y al final mediante `TRIM()`.
- **`Category`, `Subcategory`, `Color` y `Size`:** Se aplicó `TRIM()` para eliminar espacios adicionales. No fue necesario unificar valores, ya que no presentaban variaciones de escritura.
- **`Gender`:** Se aplicó `TRIM()` y `UPPER()` para asegurar que los códigos queden en mayúscula (`M`/`F`).
- **`Marital Status` y `Home Owner`:** Se aplicó `TRIM()` y se conservaron los valores originales (`Single`/`Married`, `Yes`/`No`).
- **`Birth Date`, `Order Date` y `Ship Date`:** Se configuró el tipo de dato `DATE` durante la carga en la tabla de staging.
- **`List Price`, `UnitPrice`, `ProductCost`, `SalesAmount` e `Income`:** Se configuró el tipo de dato decimal (`NUMERIC`) para permitir el tratamiento numérico de los valores.
- **`Children`, `Cars`, `Quantity` y `OrderLineNumber`:** Se configuró el tipo de dato entero (`INT`).
- **Separación en dimensiones:** Mediante `SELECT DISTINCT` se extrajeron los atributos únicos de producto y de cliente, generando `dim_producto` (9 registros) y `dim_cliente` (10 registros) y eliminando la repetición de datos de la tabla original.
- **`dim_fecha`:** Se construyó uniendo (`UNION`) las fechas de venta y de envío. A partir de cada fecha se derivaron los atributos año, trimestre, mes, nombre del mes y año-mes (`AAAA-MM`), generando 147 fechas únicas.
- **`fact_ventas`:** Se cargaron los 100 registros de venta, conservando únicamente las claves de las dimensiones, el número de orden y las medidas (`quantity`, `unit_price`, `product_cost`, `sales_amount`). Se verificó que el total vendido (`69 547`) coincide con el de la tabla de staging.

### products.csv

- **Nombres de columnas:** Los encabezados `product (brand)` y `sub_category` se cargaron en las columnas `product_name` y `subcategory` de `stg_products`. La importación se configuró con delimitador `,`, comillas `"`, codificación `UTF8` y encabezado activado.
- **`product_id`:** Se conservó el identificador original de cada producto como clave natural, y se verificó que no existieran valores nulos ni duplicados.
- **`product_name`:** Se reemplazaron las tabulaciones y los espacios repetidos por un solo espacio mediante `regexp_replace()`, se eliminaron los espacios antes del paréntesis de cierre de la marca (por ejemplo, `(Nescafe )` pasó a `(Nescafe)`) y se aplicó `btrim()` para eliminar los espacios al inicio y al final. La marca se conservó dentro del nombre.
- **`category` y `subcategory`:** Se aplicó `btrim()` para eliminar espacios adicionales y se conservaron los valores originales, incluidas las clasificaciones incorrectas detectadas, ya que corregirlas requiere validación con el negocio.
- **`dim_product`:** Se cargaron los 699 productos desde `stg_products` y se generó una clave sustituta (`product_key`) de tipo `BIGSERIAL`, independiente del identificador del sistema fuente.

---

## Configuración de carga

<a id="imagen-3"></a>

> **Figura 3:** Crear tablas en PostgreSQL.
>
> ![Crear Tablas](img/Proceso/crearTablas.png)
>
> _Descripción: _

<a id="imagen-4"></a>

> **Figura 4:** Importar product.csv.
>
> ![Conexión con la base de datos](img/Proceso/importarProduct.png)
>
> _Descripción: _

<a id="figura-5"></a>

> **Figura 5:** Importación Tabla_Desnormalizada_Ventas
>
> ![Inserción de datos](img/Proceso/importarTablaDesnormalizada.png)
>
> _Descripción: _

<a id="figura-6"></a>

> **Figura 6:** Delimitación en Tabla Desnormalizada
>
> ![Inserción de datos](img/Proceso/delimitacion.png)
>
> _Descripción: _

<a id="figura-7"></a>

> **Figura 7:** Importación completa
>
> ![Inserción de datos](img/Proceso/importacionCompleta.png)
>
> _Descripción: _

<a id="figura-8"></a>

> **Figura 8:** Limpieza de datos
>
> ![Inserción de datos](img/Proceso/limpiezaDatos.png)
>
> _Descripción: _

<a id="figura-9"></a>

> **Figura 9:** Creación de dimensiones
>
> ![Inserción de datos](img/Proceso/cargaDimensiones.png)
>
> _Descripción: _

<a id="figura-10"></a>

> **Figura 10:** Comprobación carga de dimensiones
>
> ![Inserción de datos](img/Proceso/comprobacionCarga.png)
>
> _Descripción: _

## Consultas - Resultado

<a id="figura-11"></a>

> **Figura 11:** Consulta 1
>
> ![Inserción de datos](img/Consultas/consulta1.png)
>
> _Descripción: _

<a id="figura-12"></a>

> **Figura 12:** Consulta 2
>
> ![Inserción de datos](img/Consultas/consulta2.png)
>
> _Descripción: _

<a id="figura-13"></a>

> **Figura 13:** Consulta 3
>
> ![Inserción de datos](img/Consultas/consulta3.png)
>
> _Descripción: _

<a id="figura-14"></a>

> **Figura 14:** Consulta 4
>
> ![Inserción de datos](img/Consultas/consulta4.png)
>
> _Descripción: _

<a id="figura-15"></a>

> **Figura 15:** Consulta 5
>
> ![Inserción de datos](img/Consultas/consulta5.png)
>
> _Descripción: _

---

## Conclusiones

- Modelar la tabla `Tabla_Desnormalizada_Ventas.csv` en un esquema estrella permitió separar lo que describe a una venta de lo que se mide en ella. Los 100 registros originales quedaron en una tabla de hechos (`fact_ventas`) y tres dimensiones: `dim_producto` con 9 productos, `dim_cliente` con 10 clientes y `dim_fecha` con 147 fechas. Así, los datos de cada producto y de cada cliente se guardan una sola vez en lugar de repetirse en cada venta.
- La tabla de staging fue útil para revisar y limpiar los datos sin tocar los archivos fuente. En `stg_products` se corrigieron los espacios y tabulaciones de los nombres antes de cargar los 699 productos en `dim_product`. En `stg_ventas` se verificó que no hubiera valores nulos, fechas de envío anteriores a la fecha de venta ni montos mal calculados.
- La comprobación final confirmó que la carga fue correcta. La tabla de hechos tiene las mismas 100 ventas del archivo original y el total vendido es de **69 547**, igual en la tabla de staging y en `fact_ventas`, por lo que no se perdió ni se duplicó ninguna venta.
- Con el modelo estrella fue sencillo responder las cinco preguntas de negocio, porque cada consulta solo necesitó unir la tabla de hechos con las dimensiones que hacían falta. Por ejemplo, se encontró que el cliente `1022` es el que más ingresos generó (11 656), que `Product 19` es el producto más vendido (60 unidades) y que los productos de tamaño `Medium` comprados por clientes casados suman el mayor monto de ventas (23 714).
- La dimensión `dim_fecha` resultó muy práctica, ya que una misma tabla sirvió para analizar tanto la fecha de venta como la fecha de envío. Además, tener ya calculados el año, el mes y el año-mes evitó repetir funciones de fecha en cada consulta.
- Mantener `category` y `subcategory` dentro de la dimensión de producto, aunque sus valores se repitan, facilita el análisis y mantiene el modelo como un esquema estrella simple. Separarlas en tablas propias lo habría convertido en un esquema copo de nieve, con más uniones en cada consulta.
- El diagrama en Power Pivot ayudó a comprobar visualmente las relaciones uno a muchos entre cada dimensión y la tabla de hechos, y confirmó que el diseño hecho en PostgreSQL era coherente antes de usarlo para el análisis.

- ***

## Referencias bibliográficas

\[1\] Escuela Politécnica Nacional, "Práctica 4. Implementación física de una dimensión para un modelo estrella en PostgreSQL", guía de práctica de la asignatura Business Intelligence, Quito, Ecuador, 2026.

\[2\] R. Kimball y M. Ross, *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling*, 3.ª ed. Indianapolis, IN, EE. UU.: Wiley, 2013.

\[3\] Microsoft, "Power Pivot: Powerful data analysis and data modeling in Excel". [En línea]. Disponible en: https://support.microsoft.com/es-es/office/power-pivot-an%C3%A1lisis-de-datos-y-modelado-de-datos-eficaces-en-excel-a9c2c6e2-cc49-4976-a7d7-40896795d045

---

## Declaración de uso de IA

Se declara formalmente que el porcentaje de uso de herramientas de inteligencia artificial generativa para la estructuración, redacción y corrección de estilo ortotipográfico de este informe ha sido del **20 %**. La IA se utilizó como apoyo para la redacción y el formato Markdown, mientras que el análisis técnico, el diseño del proceso ETL en Pentaho, las capturas de pantalla y las lógicas de transformación son producto del trabajo intelectual de los integrantes del grupo.

---

[1]: https://github.com/JonathanGuaman2004/Proceso-ETL.git

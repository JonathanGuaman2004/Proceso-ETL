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

- [Índice](#índice)
  - [Contenido](#contenido)
  - [Índice de figuras](#índice-de-figuras)
- [Objetivos](#objetivos)
  - [Objetivo general](#objetivo-general)
  - [Objetivos específicos](#objetivos-específicos)
- [Fuentes de datos](#fuentes-de-datos)
- [Diseño dimensional](#diseño-dimensional)
- [Problemas encontrados en los datos](#problemas-encontrados-en-los-datos)
- [Transformaciones aplicadas](#transformaciones-aplicadas)
  - [Tabla\_Desnormalizada\_Ventas.csv](#tabla_desnormalizada_ventascsv)
  - [products.csv](#productscsv)
- [Configuración de carga](#configuración-de-carga)
- [Consultas - Resultado](#consultas---resultado)
- [Conclusiones](#conclusiones)
- [Referencias bibliográficas](#referencias-bibliográficas)
- [Declaración de uso de IA](#declaración-de-uso-de-ia)

### Índice de figuras

- [Figura 1. Archivo fuente original](#figura-1)
- [Figura 2. Diagrama en Power Pivot](#figura-2)
- [Figura 3. Crear tablas en PostgreSQL](#figura-3)
- [Figura 4. Importar product.csv](#figura-4)
- [Figura 5. Importación Tabla_Desnormalizada_Ventas](#figura-5)
- [Figura 6. Delimitación en Tabla Desnormalizada](#figura-6)
- [Figura 7. Importación completa](#figura-7)
- [Figura 8. Limpieza de datos](#figura-8)
- [Figura 9. Creación de dimensiones](#figura-9)
- [Figura 10. Comprobación carga de dimensiones](#figura-10)
- [Figura 11. Consulta 1](#figura-11)
- [Figura 12. Consulta 2](#figura-12)
- [Figura 13. Consulta 3](#figura-13)
- [Figura 14. Consulta 4](#figura-14)
- [Figura 15. Consulta 5](#figura-15)

---

## Objetivos

### Objetivo general

- Diseñar e implementar un modelo físico dimensional en esquema estrella utilizando PostgreSQL, a partir de datos desnormalizados de ventas y un catálogo de productos, aplicando los procesos de extracción, transformación y carga (ETL) necesarios para su análisis.

### Objetivos específicos

- Modelar un esquema estrella separando los datos del archivo desnormalizado en una tabla de hechos (`fact_ventas`) y sus respectivas dimensiones (`dim_producto`, `dim_cliente`, `dim_fecha`).
- Crear tablas temporales de *staging* (`stg_products`, `stg_ventas`) para importar los datos crudos desde archivos CSV utilizando la herramienta de Importación/Exportación de pgAdmin.
- Ejecutar scripts de limpieza (DML) para corregir formatos de texto, eliminar espacios innecesarios y estandarizar la información antes de su inserción en el modelo final.
- Implementar claves sustitutas (*surrogate keys*) para las dimensiones y resolver consultas SQL analíticas sobre el modelo dimensional para responder a las preguntas de negocio planteadas.

---

## Fuentes de datos

Se utilizaron los archivos [`products.csv`](Proceso-ETL/4ta-Practica/Fuentes/products.csv) y [`Tabla_Desnormalizada_Ventas.csv`](Proceso-ETL/4ta-Practica/Fuentes/Tabla_Desnormalizada_Ventas.csv), disponibles en el Aula Virtual de la EPN.

<a id="figura-1"></a>

**Figura 1:** Archivo fuente original.

![Archivo fuente](img/fuenteOriginal.png)

_Descripción: Captura de pantalla de los archivos `.csv` de los que se obtuvieron los datos, disponibles en el Aula Virtual de la EPN._

---

## Diseño dimensional

<a id="figura-2"></a>

**Figura 2:** Diagrama en Power Pivot.

![Diagrama Power Pivot](img/PowerPivot/diagrama.png)

_Descripción: Diseño del modelo dimensional en esquema estrella. Se observa la tabla de hechos `fact_ventas` en el centro, conectada mediante claves foráneas a las dimensiones `dim_producto`, `dim_cliente` y `dim_fecha`._

El modelo se compone de una tabla de hechos central y tres dimensiones principales:

*   **`fact_ventas` (Tabla de Hechos):** 
    *   Actúa como el núcleo transaccional del modelo, registrando cada línea de venta individual.
    *   Contiene las claves foráneas (`product_key`, `customer_key`, `order_date_key`, `ship_date_key`) que la conectan con las dimensiones, así como las medidas cuantitativas del negocio (`quantity`, `unit_price`, `product_cost`, `sales_amount`).
*   **`dim_cliente` (Dimensión de Clientes):** 
    *   Almacena los atributos demográficos y socioeconómicos asociados a cada comprador.
    *   Incluye variables clave como la fecha de nacimiento (`birth_date`), estado civil (`marital_status`), género (`gender`), ingresos (`income`), número de hijos (`children`), propiedad de vivienda (`home_owner`) y cantidad de vehículos (`cars`).
*   **`dim_producto` (Dimensión de Productos):** 
    *   Agrupa la información descriptiva de los artículos utilizando una clave sustituta (`product_key`) como clave primaria.
    *   Incorpora atributos jerárquicos y descriptivos como el código del producto (`product_code`), nombre (`product_name`), precio de lista (`list_price`), color, tamaño (`size`), categoría (`category`) y subcategoría (`subcategory`).
*   **`dim_fecha` (Dimensión de Tiempo):** 
    *   Construida a partir de la unificación de las fechas de orden y envío para permitir análisis temporales avanzados.
    *   Desglosa cada fecha en atributos jerárquicos estándar como año (`year`), trimestre (`quarter`), mes (`month`), nombre del mes (`month_name`) y periodo año-mes (`year_month`).

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

Para llevar a cabo el proceso de importación y transformación en PostgreSQL mediante pgAdmin, se siguió una secuencia estructurada de extracción, limpieza y carga hacia el modelo estrella:

1. **Creación de estructuras (DDL):** El primer paso consistió en ejecutar el script de creación de tablas. Se crearon dos tablas temporales o de *staging* (`stg_products` y `stg_ventas`) para recibir los datos crudos, así como las tablas definitivas del modelo estrella: las dimensiones (`dim_producto`, `dim_cliente`, `dim_fecha`) y la tabla de hechos (`fact_ventas`).
2. **Importación de datos a Staging:** Utilizando la herramienta *Import/Export Data* de pgAdmin, se poblaron las tablas temporales. Para `products.csv` se utilizó codificación UTF8 y el separador de coma (`,`). Para `Tabla_Desnormalizada_Ventas.csv`, al venir en otro formato, se ajustó el delimitador a punto y coma (`;`). En ambos casos se activó la opción "Header" para omitir la fila de encabezados.
3. **Limpieza y transformación (DML):** Una vez los datos en *staging*, se ejecutaron sentencias `UPDATE` para sanear la información. Se utilizaron funciones como `TRIM()`, `UPPER()` y `regexp_replace()` para eliminar espacios redundantes, tabulaciones ocultas y estandarizar mayúsculas.
4. **Carga al Modelo Dimensional:** Finalmente, se utilizaron sentencias `INSERT INTO ... SELECT DISTINCT` para extraer los registros únicos de productos, clientes y fechas desde `stg_ventas`, poblando las dimensiones y autogenerando sus claves sustitutas (tipo `SERIAL` o `INT`). Posteriormente, se cargó la tabla `fact_ventas` relacionando las métricas con las claves dimensionales correspondientes. Se verificaron los conteos finales para asegurar la integridad de los datos.

A continuación, se detallan las evidencias visuales de este proceso:

<a id="figura-3"></a>

> **Figura 3:** Crear tablas en PostgreSQL.
>
> ![Crear Tablas](img/Proceso/crearTablas.png)
>
> _Descripción: Ejecución del script DDL en el Query Tool de pgAdmin para la creación de los esquemas y las estructuras de las tablas de staging, dimensiones y hechos._

<a id="figura-4"></a>

> **Figura 4:** Importar product.csv.
>
> ![Importar products.csv](img/Proceso/importarProduct.png)
>
> _Descripción: Configuración de la interfaz Import/Export Data en pgAdmin para cargar el archivo `products.csv` hacia la tabla `stg_products`, estableciendo la codificación en UTF-8._

<a id="figura-5"></a>

> **Figura 5:** Importación Tabla_Desnormalizada_Ventas
>
> ![Importar Tabla Desnormalizada](img/Proceso/importarTablaDesnormalizada.png)
>
> _Descripción: Selección del archivo `Tabla_Desnormalizada_Ventas.csv` en la herramienta de importación de pgAdmin para poblar la tabla `stg_ventas`._

<a id="figura-6"></a>

> **Figura 6:** Delimitación en Tabla Desnormalizada
>
> ![Delimitación](img/Proceso/delimitacion.png)
>
> _Descripción: Configuración de las opciones de formato para el archivo de ventas, especificando el uso de punto y coma (`;`) como delimitador y activando la opción "Header" para la primera fila._

<a id="figura-7"></a>

> **Figura 7:** Importación completa
>
> ![Importación completa](img/Proceso/importacionCompleta.png)
>
> _Descripción: Mensaje de confirmación (Notificación) de pgAdmin indicando que el proceso de copiado de datos desde los archivos CSV a las tablas de staging finalizó exitosamente._

<a id="figura-8"></a>

> **Figura 8:** Limpieza de datos
>
> ![Limpieza de datos](img/Proceso/limpiezaDatos.png)
>
> _Descripción: Ejecución del script SQL (UPDATE) aplicado a las tablas de staging para limpiar los textos, eliminando espacios en blanco sobrantes mediante funciones como `TRIM()` y `regexp_replace()`._

<a id="figura-9"></a>

> **Figura 9:** Creación de dimensiones
>
> ![Carga de dimensiones](img/Proceso/cargaDimensiones.png)
>
> _Descripción: Ejecución de las sentencias `INSERT INTO ... SELECT DISTINCT` para trasladar los datos limpios desde el staging hacia las tablas definitivas de dimensiones, extrayendo también atributos de fecha con `TO_CHAR` y `EXTRACT`._

<a id="figura-10"></a>

> **Figura 10:** Comprobación carga de dimensiones
>
> ![Comprobación carga](img/Proceso/comprobacionCarga.png)
>
> _Descripción: Verificación mediante consultas `SELECT` de que los datos dimensionales se estructuraron correctamente en el esquema final. Se comprobó la existencia de 9 productos, 10 clientes, 147 fechas y 100 ventas con el valor total exacto._

---

## Consultas - Resultado

Para validar la utilidad y correcta estructuración del modelo estrella implementado, se diseñaron cinco consultas SQL que responden a requerimientos analíticos específicos de negocio. Gracias a las claves foráneas en la tabla de hechos, los cruces de información (`JOIN`) resultan directos e intuitivos. 

A continuación se detalla la lógica de cada consulta y su resultado:

<a id="figura-11"></a>

> **Figura 11:** Consulta 1
>
> ![Consulta 1](img/Consultas/consulta1.png)
>
> *Lógica:* Se realizó un `JOIN` entre `fact_ventas`, `dim_producto` y `dim_fecha` (usando `order_date_key`). Se agrupó la información por la categoría del producto (`p.category`) y el mes-año de la fecha de orden (`d.year_month`). Se aplicaron funciones de agregación para contar el número de transacciones (`COUNT`) y sumar los ingresos (`SUM(sales_amount)`).
> 
> _Descripción: Respuesta a la pregunta 1: Cantidad de ventas realizadas y monto total agrupadas por categoría de producto y mes._

<a id="figura-12"></a>

> **Figura 12:** Consulta 2
>
> ![Consulta 2](img/Consultas/consulta2.png)
>
> *Lógica:* Se cruzaron las tablas `fact_ventas` y `dim_cliente`. Los datos se agruparon por la clave del cliente (`c.customer_key`) y su género (`c.gender`), sumando el total de la columna `sales_amount` y ordenando los resultados de mayor a menor ingreso.
>
> _Descripción: Respuesta a la pregunta 2: Ingreso total generado por concepto de ventas segmentado por identificador de cliente y género._

<a id="figura-13"></a>

> **Figura 13:** Consulta 3
>
> ![Consulta 3](img/Consultas/consulta3.png)
>
> *Lógica:* Mediante un `JOIN` entre `fact_ventas` y `dim_producto`, se agrupó por el nombre del producto (`p.product_name`) y se sumó el campo de cantidad (`f.quantity`). El resultado se ordenó de manera descendente.
>
> _Descripción: Respuesta a la pregunta 3: Cantidad total de artículos vendidos por cada producto, mostrando cuáles son los más demandados._

<a id="figura-14"></a>

> **Figura 14:** Consulta 4
>
> ![Consulta 4](img/Consultas/consulta4.png)
>
> *Lógica:* Se analizó la tabla `fact_ventas` cruzándola con `dim_fecha`, pero esta vez utilizando la clave de fecha de envío (`f.ship_date_key = d.date_key`). Se agrupó por el año y mes (`d.year_month`) para sumar la cantidad de productos enviados (`f.quantity`).
>
> _Descripción: Respuesta a la pregunta 4: Sumatoria de la cantidad de productos enviados, agrupados por el mes correspondiente a la fecha de envío._

<a id="figura-15"></a>

> **Figura 15:** Consulta 5
>
> ![Consulta 5](img/Consultas/consulta5.png)
>
> *Lógica:* Se realizó un triple `JOIN` involucrando `fact_ventas`, `dim_producto` y `dim_cliente`. Los datos se segmentaron cruzando el tamaño del producto (`p.size`) y el estado civil del cliente (`c.marital_status`), agregando el monto total de ventas (`SUM(sales_amount)`).
>
> _Descripción: Respuesta a la pregunta 5: Monto total de ventas cruzando la variable de tamaño del producto (Size) y el estado civil del cliente (Marital Status)._

---

## Conclusiones

- La transición de un modelo de datos completamente desnormalizado a un esquema estrella reduce significativamente la redundancia de la información. Al extraer los datos repetitivos (como la información de clientes y detalles de productos) y colocarlos en dimensiones separadas, se optimiza el almacenamiento y se agilizan las consultas.
- El uso de tablas de *staging* es un paso crítico y necesario en cualquier proceso ETL. Permitieron identificar y corregir errores de formato de origen (espacios extra, tabulaciones y delimitadores incorrectos) utilizando funciones como `TRIM()` y `regexp_replace()` sin comprometer la base de datos de producción ni afectar los archivos originales.
- Mantener los atributos de jerarquía (como `category` y `subcategory`) dentro de la misma tabla de dimensión `dim_product` comprobó ser una decisión acertada para el modelo estrella, ya que evita la sobre-normalización (modelo copo de nieve) y simplifica la estructura de los `JOINs` al momento de realizar consultas analíticas, favoreciendo el rendimiento.
- La implementación de claves sustitutas (*surrogate keys*, usando `BIGSERIAL` o `INT` autogenerados) proporciona independencia frente a las claves naturales de los sistemas origen. Esto previene conflictos si el sistema fuente cambia su lógica de codificación de productos y garantiza una arquitectura de Data Warehouse mucho más robusta y escalable.

---

## Referencias bibliográficas

[1] Escuela Politécnica Nacional, "Guía Práctica 4: Modelo Físico Dimensional PostgreSQL", Facultad de Ingeniería de Sistemas, 2026.

## Declaración de uso de IA

Se declara formalmente que el porcentaje de uso de herramientas de inteligencia artificial generativa para la estructuración, redacción y corrección de estilo ortotipográfico de este informe ha sido del **20 %**. La IA se utilizó como apoyo para la redacción y el formato Markdown, mientras que el análisis técnico, el diseño del proceso ETL, las descripciones detalladas de los procesos de carga, las capturas de pantalla y las lógicas de transformación son producto del trabajo intelectual de los integrantes del grupo.

---

[1]: https://github.com/JonathanGuaman2004/Proceso-ETL.git

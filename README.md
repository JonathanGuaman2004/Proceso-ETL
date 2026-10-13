<div align="center" style="font-family: Arial, Helvetica, sans-serif; color: #0C233F; max-width: 900px; margin: 0 auto;">

  <!-- Encabezado institucional -->
  <div style="background-color: #0C233F; padding: 32px 20px; border-radius: 8px 8px 0 0;">
  <img src="img/logos/EPN-blanco.png"
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
      Procesos ETL
    </h2>

<p style="font-size: 16px; color: #475569;">
      <strong>Materia:</strong> Business Intelligence<br>
      <strong>Paralelo:</strong> GR2SW_2026-B<br>
      <strong>Fecha:</strong> 13 de octubre de 2026
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
**[Enlace del Repositorio de GitHub][1]**
---

## Índice

1. [Objetivos](#objetivos)
   - [Objetivo General](#objetivo-general)
   - [Objetivos Específicos](#objetivos-específicos)
2. [Fuentes de Datos](#fuentes-de-datos)
3. [Problemas encontrados en los datos](#problemas-encontrados-en-los-datos)
4. [Transformaciones aplicadas](#transformaciones-aplicadas)
5. [Flujo ETL desarrollado](#flujo-etl-desarrollado)
   - [Entrada](#entrada)
   - [Transformar](#transformar)
   - [Salida](#salida)
6. [Evidencia del resultado](#evidencia-del-resultado)
   - [Ejecución del proceso](#ejecución-del-proceso)
   - [Configuración de la salida](#configuración-de-la-salida)
   - [Archivo resultante](#archivo-resultante)
   - [Validación de los resultados](#validación-de-los-resultados)
7. [Arquitectura de Data Warehouse](#explicación-de-cómo-el-proceso-se-relaciona-con-una-arquitectura-de-data-warehouse)
8. [Conclusiones](#conclusiones)
9. [Referencias Bibliográficas](#referencias-bibliográficas)
10. [Declaración de uso de IA](#declaración-de-uso-de-ia)

---

## Objetivos

### Objetivo General

- Implementar un proceso ETL (Extract, Transform, Load) completo y una Staging Area utilizando Pentaho Data Integration, con el fin de extraer, preparar y limpiar datos, relacionando este desarrollo con la arquitectura básica de un Data Warehouse.

### Objetivos Específicos

- Reconocer los principales componentes de Pentaho Data Integration para extraer datos desde dos tipos diferentes de fuentes externas hacia un entorno de preparación.
- Aplicar transformaciones básicas orientadas a limpiar y estandarizar la información, abordando específicamente la corrección de nombres y apellidos y la validación de campos de fecha.
- Ejecutar el flujo de datos completo y verificar la calidad y consistencia de los registros obtenidos en la salida final.

---

## Fuentes de Datos

Se utilizó el archivo Estudiantes.xls que se encuentra en el Aula Virtual de la EPN con los siguientes atributos: ID, NOMBRES, APELLIDOS, CEDULA, MODALIDAD, NIVEL, FECHA ADMISIÓN, ESTADO ACTUAL, y FECHA ESTADO.

> **Figura 1:** Archivo fuente original.
> ![Archivo fuente](img/FuenteDatos.png) 
> *Descripción: Captura de pantalla que muestra los datos originales en formato tabular tomados del Aula Virtual de la EPN antes de aplicar el proceso ETL.*

Dado que la actividad indica la utilización de 2 fuentes diferentes de datos, se separó el archivo original en otros 2 archivos con diferentes extensiones y datos.

**Tabla 1:** Descripción de las fuentes de datos generadas.
| Nombre | Extensión | Descripción |
|---|---|---|
| `Caso Estudiantes Fechas Cedula Fuente1` | `.xls` | Hoja de cálculo estándar de Excel. |
| `Caso Estudiantes Fechas Cedula Fuente2` | `.csv` | Archivo de texto plano separado por comas. |
*Descripción: La tabla detalla los dos archivos creados a partir de la fuente original para cumplir con el requisito de utilizar múltiples formatos de entrada en Pentaho.*

---

## Problemas encontrados en los datos

- **ID:** No se identificaron problemas en los datos de este campo.
- **NOMBRES y APELLIDOS:** Errores en la codificación de caracteres especiales. Las vocales con tilde (`é`) se representan incorrectamente mediante el símbolo `||`. El carácter `ñ` aparece sustituido por el símbolo `~`.
- **CÉDULA:** Presencia de registros con números de cédula de 8 y 9 dígitos, cuando se esperan 10 dígitos obligatorios.
- **MODALIDAD, NIVEL y ESTADO ACTUAL:** Inconsistencias en el uso de mayúsculas y minúsculas. Uso ocasional de abreviaturas en los estados, generando falta de uniformidad.
- **FECHA ADMISIÓN y FECHA ESTADO:** Presencia de fechas registradas en diferentes formatos y de caracteres especiales no esperados que afectan la integridad de los datos.

---

## Transformaciones aplicadas

- **NOMBRES y APELLIDOS:** Corrección de caracteres especiales, sustituyendo `||` por `é` y `~` por `ñ`.
- **CÉDULA:** Eliminación de registros con cédulas de menos de 9 dígitos y adición de un `0` al inicio de las cédulas con exactamente 9 dígitos para completar el formato requerido.
- **MODALIDAD, NIVEL y ESTADO ACTUAL:** Conversión de todos los caracteres a formato de mayúsculas y sustitución de abreviaturas por sus términos completos.
- **FECHAS:** Eliminación de caracteres especiales y estandarización al formato unificado `dd/MM/yyyy`.

---

## Flujo ETL desarrollado

Para este trabajo se realizó una sola transformación en Pentaho Data Integration que sigue las etapas **Extract**, **Transform** y **Load**.

<a id="imagen-2"></a>
> **Figura 2:** Flujo ETL general.
> ![Flujo ETL](img/ProcesoETL.png) 
> *Descripción: Vista general de la transformación diseñada en Spoon, mostrando la entrada desde múltiples fuentes, el flujo de estandarización, las transformaciones de limpieza y la salida final.*

### Entrada

Se configuran dos nodos de lectura, uno para cada formato de archivo. 

> **Figura 3:** Entrada de la primera fuente (archivo `.xls`).
> ![Entrada 1](img/Entrada/Entrada1.png) 
> *Descripción: Configuración del paso "Microsoft Excel input" para la lectura del primer bloque de datos.*

> **Figura 4:** Entrada de la segunda fuente (archivo `.csv`).
> ![Entrada 2](img/Entrada/Entrada2.png) 
> *Descripción: Configuración del paso "CSV file input" utilizando codificación UTF-8.*

Antes de unir las fuentes, se aplica el paso `Selecciona/Renombra valores` para igualar los esquemas de metadatos. 

> **Figura 5:** Estandarización de la entrada 1.
> ![Estandarizacion 1](img/Entrada/EstandarizacionEntrada1.png)
> *Descripción: Ajuste de nombres de campos en la rama proveniente del archivo Excel.*

> **Figura 6:** Estandarización de la entrada 2.
> ![Estandarizacion 2](img/Entrada/EstandarizacionEntrada2.png)
> *Descripción: Ajuste de nombres de campos en la rama proveniente del archivo CSV.*

### Transformar

1. **String operations:** Pasa a mayúsculas y quita espacios en blanco.
> **Figura 7:** Paso String operations.
> ![String operations](img/Transformar/1-String%20operations.png)
> *Descripción: Interfaz de configuración para la limpieza de espacios y conversión a mayúsculas.*

2. **Replace in string:** Reemplaza textos inconsistentes y caracteres mal codificados.
> **Figura 8:** Paso Replace in string.
> ![Replace in string](img/Transformar/2-Replace%20in%20string.png)
> *Descripción: Diccionario de reemplazo configurado en Pentaho para estandarizar cadenas de texto.*

3. **Valor JavaScript modificado:** Evalúa y corrige las cédulas (agrega el "0" faltante y valida la longitud).
> **Figura 9:** Valor JavaScript modificado.
> ![JavaScript](img/Transformar/3-Valor%20JavaScript%20modificado.png)
> *Descripción: Script en JavaScript inyectado para aplicar lógica condicional sobre la longitud del campo Cédula.*

4. **Filtrar filas y Ordenar filas:**
> **Figura 10:** Filtrado de filas.
> ![Filtrar filas](img/Transformar/4-Filtrar%20filas.png)
> *Descripción: Paso condicional que descarta registros donde la cédula no sea válida.*

> **Figura 11:** Ordenamiento.
> ![Ordenar filas](img/Transformar/5-Ordenar%20filas.png)
> *Descripción: Reordenamiento ascendente de los registros utilizando el campo ID.*

6. **Selecciona/Renombra valores 3:**
> **Figura 12:** Selección de salida.
> ![Renombrar Salida](img/Transformar/6-Selecciona%20Renombra%20valores.png)
> *Descripción: Ajuste final de tipos de datos (fechas) y nombres de columnas antes de la carga.*

### Salida

> **Figura 13:** Data validator.
> ![Data validator](img/Salida/Data%20validator.png)
> *Descripción: Regla de validación que asegura que todos los registros de salida posean una cédula de mínimo 10 caracteres.*

> **Figura 14:** Salida en formato `.xls`.
> ![Salida](img/Salida/Salida.png)
> *Descripción: Configuración del nodo "Microsoft Excel writer" definiendo el formato de fecha final y parámetros del archivo.*

---

## Evidencia del resultado

### Ejecución del proceso

**Tabla 2:** Resumen de registros procesados durante la ejecución del flujo ETL.
| Paso | Registros leídos | Registros escritos | Errores |
|---|---|---|---|
| String operations (unión de fuentes) | 99 | 99 | 0 |
| Replace in string | 99 | 99 | 0 |
| Valor JavaScript modificado | 99 | 99 | 0 |
| Filtrar filas | 99 | 98 | 0 |
| Ordenar filas | 98 | 98 | 0 |
| Microsoft Excel writer | 98 | 98 | 0 |
| Data validator | 98 | 98 | 0 |
*Descripción: La tabla demuestra que de 99 registros ingresados, 98 superaron exitosamente los filtros de calidad, descartándose un único registro por cédula irrecuperable.*

### Archivo resultante

> **Figura 15:** Archivo final procesado.
> ![Resultado final](img/Salida/Resultado.png)
> *Descripción: Vista de los datos procesados en Microsoft Excel, evidenciando la correcta estandarización de columnas y formatos de fecha.*

**Tabla 3:** Comparación de campos antes y después del proceso ETL.
| ID | Campo | Antes | Después |
|---|---|---|---|
| L000101 | CEDULA | `500852125` | `0500852125` |
| L000101 | APELLIDOS | `Mu~oz Molina` | `Muñoz Molina` |
| L000101 | FECHA ESTADO | `´12/06/2014` | `06/12/2014` |
| L000102 | ESTADO ACTUAL | `Egresado` | `EGRESADO` |
| L000110 | NOMBRES | `Sonia In\|\|s` | `Sonia Inés` |
| L000199 | CEDULA | `95258652` | Registro descartado |
*Descripción: Ejemplos de las transformaciones específicas aplicadas a registros seleccionados para verificar la efectividad de los reemplazos.*

---

## Explicación de cómo el proceso se relaciona con una arquitectura de Data Warehouse

Un **Data Warehouse** es un repositorio central donde se guardan datos limpios y organizados que vienen de distintas fuentes. Para llegar a él, los datos pasan por varias etapas: fuentes de datos, Staging Area, transformación y destino. 

Los archivos `.xls` y `.csv` actúan como las fuentes primarias. Los pasos iniciales de lectura y renombrado cumplen el papel de **Staging Area**, donde se unifican esquemas sin modificar aún la integridad de los datos para observar las anomalías. La **Transformación** ocurre al limpiar caracteres, completar campos y estandarizar valores categóricos, asegurando que la data histórica a insertarse sea fidedigna. Finalmente, el proceso de **Load** materializa este repositorio consolidado y de alta calidad (que en la práctica se representó en un archivo de Excel validado, pero en la realidad se enviaría al almacén de datos dimensional).

---

## Conclusiones

- El uso del diseñador gráfico Spoon de Pentaho Data Integration permitió reconocer e implementar de forma exitosa las fases de extracción, transformación y carga, logrando unificar dos fuentes de datos diferentes en un solo flujo de trabajo.
- La implementación de una Staging Area resultó ser una práctica efectiva para aislar y preparar los datos originales de los archivos de entrada, facilitando su manipulación previa a la etapa de almacenamiento final.
- Las transformaciones diseñadas cumplieron exitosamente con los requerimientos de limpieza al corregir los problemas encontrados en los nombres y apellidos y al asegurar la validación de las fechas, lo que mejoró significativamente el estado de los datos.
- La verificación de los resultados demostró que el conjunto de datos de salida mantiene un alto nivel de calidad y consistencia, evidenciando de manera práctica cómo este tipo de procesos se relacionan y sustentan la arquitectura básica de un Data Warehouse.

---

## Referencias Bibliográficas

[1] Escuela Politécnica Nacional, "Práctica 1. Implementación de un proceso ETL y Staging Area con Pentaho Data Integration", Guía de práctica de la asignatura Business Intelligence, Quito, Ecuador, 2024.

---

## Declaración de uso de IA

Se declara formalmente que el porcentaje de uso de herramientas de Inteligencia Artificial Generativa para la estructuración, redacción y corrección de estilo ortotipográfico de este informe ha sido del **15%**. La IA fue empleada como apoyo a la redacción y formato Markdown, mientras que el análisis técnico, el diseño del proceso ETL en Pentaho, las capturas de pantalla y las lógicas de transformación son producto del trabajo intelectual de los integrantes del grupo.

---
[1]: https://github.com/JonathanGuaman2004/Proceso-ETL.git

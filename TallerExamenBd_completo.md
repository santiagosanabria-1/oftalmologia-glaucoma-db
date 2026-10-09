# Formulación del problema

## Título

**Diseño e implementación de una base de datos relacional normalizada para la gestión de historias clínicas de pacientes del área de oftalmología y glaucoma.**

## Problema

El área de oftalmología y glaucoma maneja información clínica que posee múltiples relaciones y una alta dependencia del histórico del paciente. Un diseño de datos inadecuado puede generar redundancia, inconsistencias, pérdida de trazabilidad y dificultades para consultar la evolución clínica.

Por esta razón, se requiere construir una base de datos relacional en MySQL que permita organizar correctamente pacientes, historias clínicas, consultas, diagnósticos, antecedentes, exámenes oftalmológicos, tratamientos y controles de glaucoma.

El diseño deberá aplicar técnicas de modelado conceptual, lógico y físico, así como un proceso de normalización hasta la Cuarta Forma Normal. Posteriormente se deberán implementar mecanismos de consulta y procesamiento mediante SQL, incluyendo consultas básicas, intermedias y avanzadas, subconsultas, funciones agregadas, vistas, procedimientos almacenados, funciones, triggers y eventos.

El resultado deberá ser una base de datos íntegra, consistente, escalable y capaz de responder consultas relacionadas con el seguimiento histórico y clínico de los pacientes.

Cada paciente puede asistir a múltiples consultas a lo largo del tiempo y, durante cada atención, pueden generarse diferentes tipos de datos clínicos.

Por ejemplo:

```
Paciente
   |
   +-- Datos personales
   |
   +-- Historia clínica
   |
   +-- Antecedentes
   |
   +-- Consultas
   |      |
   |      +-- Diagnósticos
   |      +-- Examen oftalmológico
   |      +-- Presión intraocular
   |      +-- Tratamientos
   |
   +-- Estudios especializados
          |
          +-- OCT
          +-- Campo visual
          +-- Paquimetría
          +-- Gonioscopía
```

En pacientes con glaucoma, la necesidad de conservar información histórica es aún mayor, debido a que variables como la presión intraocular, el estado del nervio óptico, la paquimetría, los resultados de OCT y los campos visuales deben compararse entre diferentes controles.

Si esta información se almacena de manera desestructurada, pueden aparecer problemas como:

- duplicidad de datos;
- inconsistencias entre registros;
- redundancia;
- dificultad para establecer relaciones entre consultas y resultados;
- pérdida de trazabilidad;
- dificultad para consultar la evolución histórica;
- dificultad para obtener indicadores;
- problemas para generar reportes;
- almacenamiento de información repetida;
- dependencia excesiva de campos de texto libre.

Por esta razón se requiere diseñar una base de datos relacional que permita representar correctamente la información clínica y mantener su integridad.

# 2. Situación problema

La información de una historia clínica oftalmológica está compuesta por múltiples entidades relacionadas entre sí.

Por ejemplo, un paciente puede presentar:

```
1 paciente
      |
      +-- 1 historia clínica
      |
      +-- N consultas
      |
      +-- N diagnósticos
      |
      +-- N tratamientos
      |
      +-- N mediciones de presión intraocular
      |
      +-- N estudios OCT
      |
      +-- N campos visuales
```

Además, muchas variables deben manejarse separadamente para:

```
OD = ojo derecho
OI = ojo izquierdo
```

Un diseño inadecuado podría conducir a estructuras como:

```
paciente
--------------------------------------------------
id
nombre
diagnostico1
diagnostico2
diagnostico3
medicamento1
medicamento2
presion_od_1
presion_oi_1
presion_od_2
presion_oi_2
oct1
oct2
campo_visual1
campo_visual2
```

Este diseño presenta importantes problemas de normalización.

Entre ellos:

- grupos repetitivos;
- múltiples valores dentro de una misma entidad;
- dificultad para agregar nuevos registros;
- redundancia;
- anomalías de inserción;
- anomalías de actualización;
- anomalías de eliminación.

Por esta razón será necesario aplicar un proceso formal de normalización.

# 3. Problema central

Se requiere diseñar una base de datos relacional en MySQL que permita gestionar de forma estructurada la información correspondiente a historias clínicas de pacientes atendidos en el área de oftalmología y glaucoma.

El diseño deberá permitir representar adecuadamente las relaciones existentes entre pacientes, historias clínicas, consultas, diagnósticos, antecedentes, medicamentos, tratamientos, estudios oftalmológicos y controles de glaucoma.

La estructura deberá minimizar redundancias y anomalías mediante un proceso de normalización hasta alcanzar la **Cuarta Forma Normal —4FN—**.

Además, la base de datos deberá permitir realizar operaciones de consulta y procesamiento de información utilizando SQL en diferentes niveles de complejidad.

# 4. Pregunta problema

**¿Cómo diseñar e implementar una base de datos relacional en MySQL, normalizada hasta la Cuarta Forma Normal, que permita almacenar, relacionar, consultar y procesar eficientemente la información de las historias clínicas de pacientes del área de oftalmología y glaucoma?**

# 5. Objetivo general

Diseñar e implementar una base de datos relacional en MySQL para la gestión de historias clínicas del área de oftalmología y glaucoma, aplicando técnicas de modelado de datos, normalización hasta 4FN, integridad referencial y consultas SQL de diferentes niveles de complejidad.

# 6. Objetivos específicos

1. Identificar las entidades, atributos y relaciones necesarias para representar la información clínica de pacientes de oftalmología y glaucoma.
2. Construir el modelo conceptual de la base de datos.
3. Diseñar el modelo lógico relacional.
4. Elaborar el Diagrama Entidad-Relación —DER—.
5. Aplicar el proceso de normalización hasta alcanzar la Cuarta Forma Normal.
6. Implementar el modelo físico utilizando MySQL.
7. Definir claves primarias y foráneas.
8. Implementar restricciones de integridad utilizando:

```
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
CHECK
DEFAULT
```

1. Insertar datos de prueba coherentes con el dominio del problema.
2. Construir consultas SQL básicas.
3. Construir consultas SQL de nivel intermedio.
4. Construir consultas SQL avanzadas.
5. Implementar subconsultas.
6. Aplicar funciones agregadas.
7. Utilizar agrupamientos con `GROUP BY` y filtros con `HAVING`.
8. Implementar vistas para facilitar consultas recurrentes.
9. Desarrollar procedimientos almacenados.
10. Implementar funciones almacenadas.
11. Crear disparadores —triggers— para automatizar operaciones y auditoría.
12. Utilizar eventos programados cuando el caso de estudio lo requiera.

# 7. Alcance del proyecto

El proyecto estará limitado al diseño, implementación y explotación de la base de datos.

No incluirá:

```
Frontend
Aplicación web
Aplicación móvil
API REST
Backend
Interfaces gráficas
```

El producto principal será una base de datos funcional en MySQL.

# 8. Alcance funcional de la base de datos

La base de datos deberá permitir gestionar información relacionada con:

```
Pacientes
Historias clínicas
Profesionales
Consultas
Antecedentes
Diagnósticos
Especialidades
Exámenes oftalmológicos
Presión intraocular
Paquimetrías
Gonioscopías
OCT
Campos visuales
Tratamientos
Medicamentos
Procedimientos
Controles de glaucoma
Archivos clínicos
Auditoría
```

# 9. Entidades preliminares

A partir del análisis inicial podrían identificarse entidades como:

```
patients
clinical_histories
medical_visits
healthcare_professionals
specialties
medical_histories
diagnoses
visit_diagnoses
ophthalmologic_exams
intraocular_pressures
pachymetry_exams
gonioscopy_exams
oct_exams
visual_field_exams
glaucoma_records
glaucoma_controls
medications
treatments
procedures
clinical_documents
audit_logs
```

Estas entidades deberán validarse y refinarse durante el modelado.

# 10. Modelo conceptual esperado

En el modelo conceptual deberán representarse las entidades principales sin depender todavía de detalles específicos del motor MySQL.

Una aproximación inicial podría ser:

```
PACIENTE
   |
   | 1
   |
   | 1
   v
HISTORIA_CLINICA
   |
   | 1
   |
   | N
   v
CONSULTA
   |
   +------------------+
   |                  |
   v                  v
DIAGNOSTICO       EXAMEN_OFTALMOLOGICO
                      |
        +-------------+-------------+
        |             |             |
        v             v             v
       PIO           OCT       CAMPO_VISUAL
```

Además:

```
PACIENTE
   |
   | 1
   |
   | N
   v
TRATAMIENTO
```

y:

```
PACIENTE
   |
   | 1
   |
   | N
   v
CONTROL_GLAUCOMA
```

# 11. Modelo lógico esperado

El modelo lógico deberá transformar las entidades conceptuales en relaciones.

Ejemplo:

```
PATIENTS
-------
id PK
document_type_id FK
document_number
first_name
last_name
birth_date
sex

CLINICAL_HISTORIES
------------------
id PK
patient_id FK

MEDICAL_VISITS
--------------
id PK
clinical_history_id FK
professional_id FK
visit_date
reason
assessment
plan
```

El modelo completo deberá incluir todas las claves y cardinalidades.

# 12. Diagrama Entidad-Relación

El DER deberá representar:

- entidades;
- atributos;
- claves primarias;
- claves foráneas;
- relaciones;
- cardinalidades;
- participación;
- entidades asociativas.

Por ejemplo:

```
PATIENT
1
|
|
1
CLINICAL_HISTORY

CLINICAL_HISTORY
1
|
|
N
MEDICAL_VISIT

MEDICAL_VISIT
N
|
|
N
DIAGNOSIS
```

La relación muchos a muchos entre consulta y diagnóstico deberá resolverse mediante una entidad asociativa:

```
VISIT_DIAGNOSES
```

# 13. Proceso de normalización

Uno de los componentes principales del proyecto será demostrar el proceso de normalización.

La normalización deberá desarrollarse progresivamente.

# 14. Datos no normalizados

Podría partirse de una estructura como:

```
HISTORIA_CLINICA

paciente
documento
telefono
consulta_fecha
diagnosticos
medicamentos
presion_od
presion_oi
oct
campo_visual
```

Ejemplo:

```
Paciente:
Carlos Gómez

Diagnósticos:
Glaucoma, Catarata

Medicamentos:
Latanoprost, Timolol
```

Aquí existen valores multivaluados.

# 15. Primera Forma Normal —1FN

La 1FN exige:

- atributos atómicos;
- ausencia de grupos repetitivos;
- una celda debe contener un solo valor.

Incorrecto:

```
diagnosticos:
Glaucoma, Catarata
```

Correcto:

```
VISIT_DIAGNOSES

visit_id | diagnosis_id
------------------------
1        | 5
1        | 8
```

# 16. Segunda Forma Normal —2FN

La 2FN requiere:

- estar en 1FN;
- eliminar dependencias parciales respecto a claves compuestas.

Ejemplo:

```
VISIT_DIAGNOSES

visit_id
diagnosis_id
diagnosis_name
```

Si:

```
diagnosis_name
```

depende únicamente de:

```
diagnosis_id
```

debe trasladarse a:

```
DIAGNOSES
```

# 17. Tercera Forma Normal —3FN

La 3FN elimina dependencias transitivas.

Ejemplo incorrecto:

```
PATIENTS

patient_id
city_id
city_name
department_name
```

Si:

```
patient_id -> city_id
city_id -> city_name
```

entonces:

```
city_name
```

no debe almacenarse directamente en `patients`.

Se crean catálogos independientes.

# 18. Forma Normal de Boyce-Codd —BCNF

Cuando sea pertinente, deberán revisarse dependencias funcionales más estrictas.

Toda dependencia funcional:

```
X -> Y
```

deberá tener como determinante una superclave.

# 19. Cuarta Forma Normal —4FN

La 4FN será especialmente importante en este proyecto debido a la existencia de atributos multivaluados independientes.

Supóngase:

```
PATIENT

patient_id
allergy
family_history
```

Un paciente puede tener:

```
N alergias
```

y también:

```
N antecedentes familiares
```

ambos independientes.

Una única relación podría producir combinaciones artificiales:

```
Alergia A + Antecedente 1
Alergia A + Antecedente 2
Alergia B + Antecedente 1
Alergia B + Antecedente 2
```

Esto representa una dependencia multivaluada.

Para alcanzar 4FN deberían separarse:

```
PATIENT_ALLERGIES
```

y:

```
PATIENT_FAMILY_HISTORIES
```

# 20. Ejemplo de aplicación de 4FN en el proyecto

Otra situación:

Un paciente puede tener múltiples:

```
medicamentos
```

y múltiples:

```
antecedentes
```

Estos conjuntos no dependen entre sí.

Incorrecto:

```
patient_medications_histories
```

Correcto:

```
PATIENT_MEDICATIONS

patient_id
medication_id
```

y:

```
PATIENT_HISTORIES

patient_id
history_type_id
description
```

# 21. Implementación física en MySQL

Después de validar el modelo lógico, deberá construirse el modelo físico mediante:

```
CREATE DATABASE
CREATE TABLE
ALTER TABLE
```

Se deberán utilizar tipos apropiados como:

```
BIGINT
INT
VARCHAR
TEXT
DATE
DATETIME
DECIMAL
BOOLEAN
```

# 22. Restricciones

El proyecto deberá implementar restricciones.

Ejemplo:

```
CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,

    CONSTRAINT uq_patient_document
        UNIQUE(document_number)
);
```

# 23. Integridad referencial

Ejemplo:

```
CREATE TABLE clinical_histories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,

    CONSTRAINT uq_history_patient
        UNIQUE(patient_id),

    CONSTRAINT fk_history_patient
        FOREIGN KEY(patient_id)
        REFERENCES patients(id)
);
```

# 24. Datos de prueba

El proyecto deberá incluir información suficiente para validar las consultas.

Por ejemplo:

```
20 pacientes
5 profesionales
10 tipos de diagnósticos
30 consultas
50 mediciones PIO
20 OCT
20 campos visuales
15 tratamientos
```

Los datos deberán ser coherentes con las relaciones definidas.

# 25. Consultas básicas

Deberán desarrollarse consultas como:

```
SELECT *
FROM patients;
```

Buscar por identificación:

```
SELECT *
FROM patients
WHERE document_number = '1098123456';
```

Ordenar:

```
SELECT *
FROM patients
ORDER BY last_name;
```

# 26. Consultas intermedias

Deberán utilizarse:

```
JOIN
ORDER BY
GROUP BY
HAVING
DISTINCT
CASE
```

Ejemplo:

```
SELECT
    p.first_name,
    p.last_name,
    mv.visit_date
FROM patients p
INNER JOIN clinical_histories ch
    ON p.id = ch.patient_id
INNER JOIN medical_visits mv
    ON ch.id = mv.clinical_history_id;
```

# 27. Consultas avanzadas

Ejemplo:

Obtener cada paciente con su última consulta:

```
SELECT
    p.id,
    p.first_name,
    p.last_name,
    MAX(mv.visit_date) AS last_visit
FROM patients p
INNER JOIN clinical_histories ch
    ON p.id = ch.patient_id
INNER JOIN medical_visits mv
    ON ch.id = mv.clinical_history_id
GROUP BY
    p.id,
    p.first_name,
    p.last_name;
```

# 28. Subconsultas

Ejemplo:

Obtener pacientes con más consultas que el promedio:

```
SELECT
    patient_id,
    total_visits
FROM (
    SELECT
        ch.patient_id,
        COUNT(*) AS total_visits
    FROM clinical_histories ch
    INNER JOIN medical_visits mv
        ON ch.id = mv.clinical_history_id
    GROUP BY ch.patient_id
) x
WHERE total_visits > (
    SELECT AVG(total_visits)
    FROM (
        SELECT
            COUNT(*) AS total_visits
        FROM clinical_histories ch
        INNER JOIN medical_visits mv
            ON ch.id = mv.clinical_history_id
        GROUP BY ch.patient_id
    ) y
);
```

# 29. Funciones agregadas

El proyecto deberá utilizar:

```
COUNT
SUM
AVG
MIN
MAX
```

Ejemplo:

```
SELECT
    AVG(pressure) AS average_pressure,
    MIN(pressure) AS minimum_pressure,
    MAX(pressure) AS maximum_pressure
FROM intraocular_pressures;
```

# 30. GROUP BY

Ejemplo:

```
SELECT
    eye,
    AVG(pressure) AS average_pressure
FROM intraocular_pressures
GROUP BY eye;
```

# 31. HAVING

Ejemplo:

```
SELECT
    patient_id,
    COUNT(*) AS controls
FROM glaucoma_controls
GROUP BY patient_id
HAVING COUNT(*) >= 3;
```

# 32. Procedimientos almacenados

Deberán implementarse procedimientos que representen operaciones del dominio.

Ejemplo conceptual:

```
sp_create_medical_visit
sp_register_intraocular_pressure
sp_register_diagnosis
sp_get_patient_history
```

Ejemplo:

```
DELIMITER $$

CREATE PROCEDURE sp_get_patient_visits(
    IN p_patient_id BIGINT
)
BEGIN

    SELECT
        mv.id,
        mv.visit_date,
        mv.reason
    FROM clinical_histories ch
    INNER JOIN medical_visits mv
        ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id
    ORDER BY mv.visit_date DESC;

END $$

DELIMITER ;
```

# 33. Funciones almacenadas

Ejemplo:

Calcular edad del paciente:

```
DELIMITER $$

CREATE FUNCTION fn_patient_age(
    p_birth_date DATE
)
RETURNS INT
DETERMINISTIC
BEGIN

    RETURN TIMESTAMPDIFF(
        YEAR,
        p_birth_date,
        CURDATE()
    );

END $$

DELIMITER ;
```

Consulta:

```
SELECT
    first_name,
    last_name,
    fn_patient_age(birth_date) AS age
FROM patients;
```

# 34. Triggers

Se deberán utilizar triggers cuando exista una justificación clara.

Ejemplo:

Crear auditoría automática de cambios.

```
CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100),
    record_id BIGINT,
    action VARCHAR(20),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

Trigger:

```
DELIMITER $$

CREATE TRIGGER trg_patient_after_update
AFTER UPDATE
ON patients
FOR EACH ROW
BEGIN

    INSERT INTO audit_logs(
        table_name,
        record_id,
        action
    )
    VALUES(
        'patients',
        NEW.id,
        'UPDATE'
    );

END $$

DELIMITER ;
```

# 35. Otros triggers posibles

```
Auditar cambios en consultas
Auditar tratamientos
Registrar cambios de diagnóstico
Registrar eliminación lógica
Actualizar fechas de modificación
```

# 36. Eventos

Si se desea incorporar eventos MySQL, podrían utilizarse para tareas como:

```
limpieza periódica de registros temporales
generación de resúmenes
actualización de tablas de indicadores
```

Ejemplo:

```
CREATE EVENT ev_daily_statistics
ON SCHEDULE EVERY 1 DAY
DO
    CALL sp_generate_daily_statistics();
```

# 37. Vistas

También deberían incorporarse vistas.

Por ejemplo:

```
CREATE VIEW vw_patient_last_visit AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient,
    MAX(mv.visit_date) AS last_visit
FROM patients p
INNER JOIN clinical_histories ch
    ON p.id = ch.patient_id
INNER JOIN medical_visits mv
    ON ch.id = mv.clinical_history_id
GROUP BY
    p.id,
    p.first_name,
    p.last_name;
```

# 38. Posibles consultas requeridas

El proyecto podría exigir al estudiante construir al menos:

```
10 consultas básicas
10 consultas intermedias
10 consultas avanzadas
5 subconsultas
5 consultas con funciones agregadas
3 vistas
3 procedimientos almacenados
3 funciones
3 triggers
1 evento programado
```

# 39. Preguntas que la base de datos deberá responder

Algunos ejemplos:

1. ¿Cuántos pacientes se encuentran registrados?
2. ¿Cuántas consultas ha tenido cada paciente?
3. ¿Cuál fue la última consulta de un paciente?
4. ¿Qué pacientes tienen diagnóstico de glaucoma?
5. ¿Cuántos pacientes existen por tipo de glaucoma?
6. ¿Cuál es la presión intraocular promedio por ojo?
7. ¿Cuál es la presión máxima registrada por paciente?
8. ¿Qué pacientes tienen más de tres controles de glaucoma?
9. ¿Qué profesionales han atendido más pacientes?
10. ¿Qué medicamentos son utilizados con mayor frecuencia?
11. ¿Cuántos estudios OCT se realizaron por mes?
12. ¿Qué pacientes no han tenido consulta durante determinado período?
13. ¿Cuál es la evolución de la presión intraocular de un paciente?
14. ¿Qué pacientes presentan valores de PIO superiores a determinado umbral?
15. ¿Cuántos procedimientos se realizaron por tipo?

# 40. Producto final esperado

El proyecto deberá entregar:

```
1. Formulación del problema
2. Identificación de entidades
3. Diccionario preliminar de datos
4. Modelo conceptual
5. DER
6. Modelo lógico
7. Evidencia de normalización:
   - 1FN
   - 2FN
   - 3FN
   - BCNF cuando aplique
   - 4FN
8. Modelo físico MySQL
9. Script DDL
10. Script de datos de prueba
11. Banco de 250 ejercicios MySQL
12. Evidencias de ejecución
```



# 42. Pregunta orientadora final

**¿Cómo modelar, normalizar e implementar en MySQL una base de datos relacional para historias clínicas de oftalmología y glaucoma que permita garantizar integridad, reducir redundancia y soportar consultas y procesos SQL de diferentes niveles de complejidad?**

# Banco de 250 ejercicios MySQL

## Proyecto: Historias clínicas de Oftalmología y Glaucoma

Este banco de ejercicios está organizado en cinco categorías:

1. Consultas SQL.
2. Subconsultas.
3. Procedimientos almacenados.
4. Triggers.
5. Funciones almacenadas.

Cada categoría contiene **50 ejercicios**, para un total de **250 actividades**.

Como referencia, se asume que la base de datos contiene entidades similares a:

```
patients
clinical_histories
medical_visits
healthcare_professionals
specialties
diagnoses
visit_diagnoses
glaucoma_records
glaucoma_controls
intraocular_pressures
pachymetry_exams
gonioscopy_exams
oct_exams
visual_field_exams
medications
treatments
procedures
clinical_documents
audit_logs
```

# PARTE I — 50 EJERCICIOS DE CONSULTAS SQL

## Nivel básico

### 1.

Mostrar todos los pacientes registrados en la base de datos.

```sql
SELECT *
FROM patients;
```



### 2.

Mostrar únicamente el número de documento, nombres y apellidos de todos los pacientes.

```sql
SELECT document_number,
       first_name,
       last_name
FROM patients;
```



### 3.

Listar todos los profesionales de salud registrados.

```sql
SELECT *
FROM healthcare_professionals;
```



### 4.

Mostrar todos los diagnósticos disponibles en el catálogo.

```sql
SELECT *
FROM diagnoses;
```



### 5.

Consultar todas las historias clínicas registradas.

```sql
SELECT *
FROM clinical_histories;
```



### 6.

Mostrar todos los pacientes ordenados alfabéticamente por apellido.

```sql
SELECT *
FROM patients
ORDER BY last_name, first_name;
```



### 7.

Mostrar los pacientes ordenados por fecha de nacimiento desde el más joven hasta el de mayor edad.

```sql
SELECT *
FROM patients
ORDER BY birth_date DESC;
```



### 8.

Consultar los pacientes cuyo apellido sea `Gómez`.

```SQL
SELECT *
FROM patients
WHERE last_name = 'Gómez';
```



### 9.

Mostrar los pacientes cuyo número de documento comience por `10`.

```sql
SELECT *
FROM patients
WHERE document_number LIKE '10%';
```



### 10.

Consultar los pacientes cuyo correo electrónico pertenezca al dominio `gmail.com`.

```sql
SELECT *
FROM patients
WHERE email LIKE '%@gmail.com';
```



### 11.

Mostrar los pacientes que no tengan correo electrónico registrado.

```sql
SELECT *
FROM patients
WHERE email IS NULL;
```



### 12.

Mostrar los profesionales cuya especialidad sea Oftalmología.

```sql
SELECT hp.first_name,
       hp.last_name,
       s.name AS specialty
FROM healthcare_professionals hp
INNER JOIN specialties s ON hp.specialty_id = s.id
WHERE s.name = 'Oftalmología';
```



### 13.

Consultar todas las consultas médicas realizadas durante el año 2026.

```sql
SELECT *
FROM medical_visits
WHERE visit_date >= '2026-01-01'
  AND visit_date < '2027-01-01';
```



### 14.

Mostrar las consultas realizadas durante un mes determinado.

```sql
-- Mes de ejemplo: junio de 2026.
SELECT *
FROM medical_visits
WHERE YEAR(visit_date) = 2026
  AND MONTH(visit_date) = 6;
```



### 15.

Consultar las mediciones de presión intraocular superiores a 20 mmHg.

```sql
SELECT *
FROM intraocular_pressures
WHERE pressure > 20;
```



### 16.

Mostrar las mediciones de presión intraocular correspondientes únicamente al ojo derecho.

```sql
SELECT *
FROM intraocular_pressures
WHERE eye = 'OD';
```



### 17.

Mostrar las mediciones correspondientes únicamente al ojo izquierdo.

```sql
SELECT *
FROM intraocular_pressures
WHERE eye = 'OI';
```



### 18.

Consultar todos los tratamientos que se encuentren activos.

```sql
SELECT *
FROM treatments
WHERE status = 'ACTIVO';
```



### 19.

Mostrar todos los tratamientos que hayan finalizado.

```sql
SELECT *
FROM treatments
WHERE status = 'FINALIZADO';
```



### 20.

Consultar los procedimientos realizados después de una fecha determinada.

```sql
-- Fecha de ejemplo: 1 de enero de 2026.
SELECT *
FROM procedures
WHERE performed_at > '2026-01-01';
```



## Nivel intermedio

### 21.

Mostrar cada paciente junto con el número de su historia clínica.

```sql
SELECT p.first_name,
       p.last_name,
       ch.history_number
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id;
```



### 22.

Mostrar cada consulta indicando el nombre completo del paciente.

```sql
SELECT mv.id,
       mv.visit_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient
FROM medical_visits mv
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id;
```



### 23.

Mostrar cada consulta junto con el nombre del profesional que la realizó.

```sql
SELECT mv.id,
       mv.visit_date,
       CONCAT(hp.first_name, ' ', hp.last_name) AS professional
FROM medical_visits mv
INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id;
```



### 24.

Listar todos los pacientes junto con la fecha de sus consultas.

```sql
-- LEFT JOIN para incluir también a los pacientes sin consultas (fecha NULL).
SELECT p.first_name,
       p.last_name,
       mv.visit_date
FROM patients p
LEFT JOIN clinical_histories ch ON p.id = ch.patient_id
LEFT JOIN medical_visits mv ON ch.id = mv.clinical_history_id
ORDER BY p.last_name, mv.visit_date;
```



### 25.

Mostrar los diagnósticos asociados a cada consulta.

```sql
SELECT mv.id AS visit_id,
       mv.visit_date,
       d.code,
       d.name AS diagnosis
FROM medical_visits mv
INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
ORDER BY mv.id;
```



### 26.

Mostrar nombre del paciente, fecha de consulta y diagnóstico correspondiente.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       mv.visit_date,
       d.name AS diagnosis
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
ORDER BY patient, mv.visit_date;
```



### 27.

Consultar todos los pacientes que tengan diagnóstico de glaucoma.

```sql
-- Se usa diagnoses.is_glaucoma: "Sospecha de glaucoma" (H40.0) no es glaucoma confirmado.
SELECT DISTINCT p.id,
       p.first_name,
       p.last_name
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
WHERE d.is_glaucoma = TRUE;
```



### 28.

Mostrar todos los controles de glaucoma indicando el paciente correspondiente.

```sql
SELECT gc.id,
       gc.control_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient,
       gc.progression_detected,
       gc.notes
FROM glaucoma_controls gc
INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
INNER JOIN patients p ON g.patient_id = p.id
ORDER BY gc.control_date;
```



### 29.

Mostrar cada medición de presión intraocular junto con nombre del paciente, fecha y ojo.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       ip.measured_at,
       ip.eye,
       ip.pressure
FROM intraocular_pressures ip
INNER JOIN medical_visits mv ON ip.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY p.last_name, ip.measured_at, ip.eye;
```



### 30.

Mostrar los estudios OCT realizados indicando paciente, ojo y fecha.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       o.eye,
       o.exam_date
FROM oct_exams o
INNER JOIN medical_visits mv ON o.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY o.exam_date, patient, o.eye;
```



### 31.

Mostrar los campos visuales registrados indicando paciente, ojo, MD, PSD y VFI.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       vf.eye,
       vf.md,
       vf.psd,
       vf.vfi
FROM visual_field_exams vf
INNER JOIN medical_visits mv ON vf.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY vf.exam_date, patient, vf.eye;
```



### 32.

Mostrar las paquimetrías realizadas junto con el paciente y el espesor corneal registrado.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       pe.eye,
       pe.exam_date,
       pe.thickness_um
FROM pachymetry_exams pe
INNER JOIN medical_visits mv ON pe.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY pe.exam_date, patient, pe.eye;
```



### 33.

Mostrar los tratamientos activos incluyendo nombre del paciente y medicamento.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       m.name AS medication,
       t.eye,
       t.start_date
FROM treatments t
INNER JOIN medications m ON t.medication_id = m.id
INNER JOIN medical_visits mv ON t.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
WHERE t.status = 'ACTIVO';
```



### 34.

Mostrar cada medicamento y la cantidad de tratamientos en los que ha sido utilizado.

```sql
SELECT m.name,
       COUNT(t.id) AS total_treatments
FROM medications m
LEFT JOIN treatments t ON m.id = t.medication_id
GROUP BY m.id, m.name
ORDER BY total_treatments DESC, m.name;
```



### 35.

Mostrar la cantidad total de pacientes registrados.

```sql
SELECT COUNT(*) AS total_patients
FROM patients;
```



### 36.

Mostrar la cantidad de consultas realizadas.

```sql
SELECT COUNT(*) AS total_visits
FROM medical_visits;
```



### 37.

Mostrar la cantidad de pacientes por sexo.

```sql
SELECT sex,
       COUNT(*) AS total
FROM patients
GROUP BY sex;
```



### 38.

Mostrar la cantidad de pacientes atendidos por cada profesional.

```sql
SELECT hp.first_name,
       hp.last_name,
       COUNT(DISTINCT ch.patient_id) AS total_patients
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv ON hp.id = mv.professional_id
LEFT JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
GROUP BY hp.id, hp.first_name, hp.last_name
ORDER BY total_patients DESC;
```



### 39.

Calcular el promedio general de presión intraocular.

```sql
SELECT ROUND(AVG(pressure), 2) AS average_pressure
FROM intraocular_pressures;
```



### 40.

Calcular la presión intraocular mínima y máxima registrada.

```sql
SELECT MIN(pressure) AS minimum_pressure,
       MAX(pressure) AS maximum_pressure
FROM intraocular_pressures;
```



## Nivel avanzado

### 41.

Calcular la presión intraocular promedio para OD y OI por separado.

```sql
SELECT eye,
       ROUND(AVG(pressure), 2) AS average_pressure
FROM intraocular_pressures
GROUP BY eye;
```



### 42.

Mostrar la cantidad de consultas realizadas por cada paciente.

```sql
SELECT p.id,
       p.first_name,
       p.last_name,
       COUNT(mv.id) AS total_visits
FROM patients p
LEFT JOIN clinical_histories ch ON p.id = ch.patient_id
LEFT JOIN medical_visits mv ON ch.id = mv.clinical_history_id
GROUP BY p.id, p.first_name, p.last_name
ORDER BY total_visits DESC, p.last_name;
```



### 43.

Mostrar únicamente los pacientes que tengan tres o más consultas.

```sql
SELECT p.id,
       p.first_name,
       p.last_name,
       COUNT(mv.id) AS total_visits
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(mv.id) >= 3;
```



### 44.

Mostrar cada profesional junto con la cantidad de consultas realizadas.

```sql
SELECT hp.first_name,
       hp.last_name,
       COUNT(mv.id) AS total_visits
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv ON hp.id = mv.professional_id
GROUP BY hp.id, hp.first_name, hp.last_name
ORDER BY total_visits DESC;
```



### 45.

Mostrar los profesionales que hayan realizado más de 20 consultas.

```sql
-- Devuelve 0 filas con el seed: hay 30 consultas repartidas entre 5 profesionales
-- y los que más tienen suman 10 (Laura Martínez y Andrés Rojas). Con HAVING COUNT(mv.id) > 5 aparecen 3.
SELECT hp.first_name,
       hp.last_name,
       COUNT(mv.id) AS total_visits
FROM healthcare_professionals hp
INNER JOIN medical_visits mv ON hp.id = mv.professional_id
GROUP BY hp.id, hp.first_name, hp.last_name
HAVING COUNT(mv.id) > 20;
```



### 46.

Calcular la cantidad de diagnósticos registrados por tipo de diagnóstico.

```sql
SELECT d.code,
       d.name,
       COUNT(vd.visit_id) AS total
FROM diagnoses d
LEFT JOIN visit_diagnoses vd ON d.id = vd.diagnosis_id
GROUP BY d.id, d.code, d.name
ORDER BY total DESC;
```



### 47.

Mostrar los cinco diagnósticos más frecuentes.

```sql
SELECT d.name,
       COUNT(*) AS total
FROM visit_diagnoses vd
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
GROUP BY d.id, d.name
ORDER BY total DESC
LIMIT 5;
```



### 48.

Mostrar la cantidad de estudios OCT realizados por mes.

```sql
SELECT YEAR(exam_date) AS year,
       MONTH(exam_date) AS month,
       COUNT(*) AS total_oct
FROM oct_exams
GROUP BY YEAR(exam_date), MONTH(exam_date)
ORDER BY year, month;
```



### 49.

Mostrar la cantidad de campos visuales realizados por año.

```sql
SELECT YEAR(exam_date) AS year,
       COUNT(*) AS total_visual_fields
FROM visual_field_exams
GROUP BY YEAR(exam_date)
ORDER BY year;
```



### 50.

Generar un reporte que muestre por paciente: nombre completo, número de consultas, cantidad de controles de glaucoma, promedio de PIO y fecha de última consulta.

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       (SELECT COUNT(*)
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
        WHERE ch.patient_id = p.id) AS total_visits,
       (SELECT COUNT(*)
        FROM glaucoma_controls gc
        INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
        WHERE g.patient_id = p.id) AS glaucoma_controls,
       (SELECT ROUND(AVG(ip.pressure), 2)
        FROM intraocular_pressures ip
        INNER JOIN medical_visits mv ON ip.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p.id) AS average_iop,
       (SELECT MAX(mv.visit_date)
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
        WHERE ch.patient_id = p.id) AS last_visit
FROM patients p
ORDER BY p.last_name, p.first_name;
```



# PARTE II — 50 EJERCICIOS DE SUBCONSULTAS

## Subconsultas escalares

### 1.

Mostrar los pacientes cuya edad sea superior a la edad promedio de todos los pacientes.

```sql
SELECT id,
       first_name,
       last_name,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM patients
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > (
    SELECT AVG(TIMESTAMPDIFF(YEAR, birth_date, CURDATE()))
    FROM patients
);
```



### 2.

Mostrar los pacientes cuya edad sea inferior a la edad promedio.

```sql
SELECT id,
       first_name,
       last_name,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM patients
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < (
    SELECT AVG(TIMESTAMPDIFF(YEAR, birth_date, CURDATE()))
    FROM patients
);
```



### 3.

Consultar la medición de presión intraocular más alta registrada.

```sql
SELECT (
    SELECT MAX(pressure)
    FROM intraocular_pressures
) AS max_pressure;
```



### 4.

Mostrar todas las mediciones que tengan el mismo valor que la presión máxima registrada.

```sql
SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MAX(pressure)
    FROM intraocular_pressures
);
```



### 5.

Mostrar la presión intraocular mínima registrada.

```sql
SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MIN(pressure)
    FROM intraocular_pressures
);
```



### 6.

Mostrar los estudios OCT cuyo RNFL sea inferior al promedio general.

```sql
SELECT *
FROM oct_exams
WHERE rnfl_average < (
    SELECT AVG(rnfl_average)
    FROM oct_exams
);
```



### 7.

Mostrar los estudios OCT cuyo RNFL sea superior al promedio general.

```sql
SELECT *
FROM oct_exams
WHERE rnfl_average > (
    SELECT AVG(rnfl_average)
    FROM oct_exams
);
```



### 8.

Consultar pacientes cuya cantidad de consultas sea mayor que el promedio de consultas por paciente.

```sql
SELECT p.id,
       p.first_name,
       p.last_name,
       x.total_visits
FROM patients p
INNER JOIN (
    SELECT ch.patient_id,
           COUNT(*) AS total_visits
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    GROUP BY ch.patient_id
) x ON p.id = x.patient_id
WHERE x.total_visits > (
    SELECT AVG(total_visits)
    FROM (
        SELECT COUNT(*) AS total_visits
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
        GROUP BY ch.patient_id
    ) y
);
```



### 9.

Mostrar profesionales cuya cantidad de consultas sea superior al promedio por profesional.

```sql
SELECT hp.first_name,
       hp.last_name,
       COUNT(*) AS total_visits
FROM healthcare_professionals hp
INNER JOIN medical_visits mv ON hp.id = mv.professional_id
GROUP BY hp.id, hp.first_name, hp.last_name
HAVING COUNT(*) > (
    SELECT AVG(total_visits)
    FROM (
        SELECT COUNT(*) AS total_visits
        FROM medical_visits
        GROUP BY professional_id
    ) x
);
```



### 10.

Consultar pacientes cuya última presión intraocular sea superior al promedio general.

```sql
-- La última medición se toma por fecha; si OD y OI se midieron a la misma hora salen ambas.
SELECT v.patient_id,
       v.patient,
       v.eye,
       v.pressure AS last_pressure,
       v.measured_at
FROM vw_patient_iop_history v
WHERE v.measured_at = (
        SELECT MAX(v2.measured_at)
        FROM vw_patient_iop_history v2
        WHERE v2.patient_id = v.patient_id
    )
  AND v.pressure > (
        SELECT AVG(pressure)
        FROM intraocular_pressures
    );
```



## Subconsultas con IN

### 11.

Mostrar pacientes que tengan al menos una consulta registrada.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
);
```



### 12.

Mostrar pacientes que tengan diagnóstico de glaucoma.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    WHERE vd.diagnosis_id IN (
        SELECT id
        FROM diagnoses
        WHERE is_glaucoma = TRUE
    )
);
```



### 13.

Mostrar pacientes que hayan recibido tratamiento farmacológico.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);
```



### 14.

Mostrar pacientes que tengan estudios OCT registrados.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);
```



### 15.

Mostrar pacientes que tengan campos visuales registrados.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);
```



### 16.

Mostrar medicamentos que hayan sido utilizados en al menos un tratamiento.

```sql
SELECT *
FROM medications
WHERE id IN (
    SELECT medication_id
    FROM treatments
);
```



### 17.

Mostrar profesionales que hayan atendido pacientes con glaucoma.

```sql
-- Paciente con glaucoma = tiene registro en glaucoma_records; cuenta cualquier consulta suya.
SELECT *
FROM healthcare_professionals
WHERE id IN (
    SELECT mv.professional_id
    FROM medical_visits mv
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id IN (
        SELECT patient_id
        FROM glaucoma_records
    )
);
```



### 18.

Mostrar diagnósticos utilizados en alguna consulta.

```sql
SELECT *
FROM diagnoses
WHERE id IN (
    SELECT diagnosis_id
    FROM visit_diagnoses
);
```



### 19.

Mostrar pacientes que hayan tenido algún procedimiento quirúrgico.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM procedures pr
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE pr.procedure_type_id IN (
        SELECT id
        FROM procedure_types
        WHERE category = 'QUIRURGICO'
    )
);
```



### 20.

Mostrar pacientes que tengan registros de paquimetría.

```sql
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM pachymetry_exams pe
    INNER JOIN medical_visits mv ON pe.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);
```



## Subconsultas con NOT IN / NOT EXISTS

### 21.

Mostrar pacientes que nunca hayan tenido una consulta.

```sql
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p.id
);
```



### 22.

Mostrar pacientes que nunca hayan tenido un control de glaucoma.

```sql
SELECT *
FROM patients
WHERE id NOT IN (
    SELECT g.patient_id
    FROM glaucoma_records g
    INNER JOIN glaucoma_controls gc ON gc.glaucoma_record_id = g.id
);
```



### 23.

Mostrar pacientes que no tengan estudios OCT.

```sql
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);
```



### 24.

Mostrar pacientes que no tengan campos visuales.

```sql
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);
```



### 25.

Mostrar medicamentos que nunca hayan sido utilizados.

```sql
-- Se usa NOT EXISTS porque NOT IN falla si la subconsulta devuelve algún NULL.
SELECT *
FROM medications m
WHERE NOT EXISTS (
    SELECT 1
    FROM treatments t
    WHERE t.medication_id = m.id
);
```



### 26.

Mostrar profesionales que todavía no hayan registrado consultas.

```sql
SELECT *
FROM healthcare_professionals hp
WHERE NOT EXISTS (
    SELECT 1
    FROM medical_visits mv
    WHERE mv.professional_id = hp.id
);
```



### 27.

Mostrar diagnósticos que nunca hayan sido asociados a una consulta.

```sql
SELECT *
FROM diagnoses d
WHERE NOT EXISTS (
    SELECT 1
    FROM visit_diagnoses vd
    WHERE vd.diagnosis_id = d.id
);
```



### 28.

Mostrar pacientes que no tengan tratamientos activos.

```sql
SELECT *
FROM patients
WHERE id NOT IN (
    SELECT ch.patient_id
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE t.status = 'ACTIVO'
);
```



### 29.

Mostrar pacientes que nunca hayan tenido procedimientos.

```sql
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM procedures pr
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);
```



### 30.

Mostrar pacientes sin mediciones de presión intraocular.

```sql
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p.id
);
```



## Subconsultas correlacionadas

### 31.

Mostrar las mediciones de PIO superiores al promedio del mismo paciente.

```sql
SELECT v.patient,
       v.measured_at,
       v.eye,
       v.pressure
FROM vw_patient_iop_history v
WHERE v.pressure > (
    SELECT AVG(v2.pressure)
    FROM vw_patient_iop_history v2
    WHERE v2.patient_id = v.patient_id
)
ORDER BY v.patient, v.measured_at;
```



### 32.

Mostrar los estudios OCT cuyo RNFL sea inferior al promedio del mismo paciente.

```sql
SELECT x.patient_id,
       x.id AS oct_id,
       x.eye,
       x.exam_date,
       x.rnfl_average
FROM (
    SELECT o.*, ch.patient_id
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
) x
WHERE x.rnfl_average < (
    SELECT AVG(o2.rnfl_average)
    FROM oct_exams o2
    INNER JOIN medical_visits mv2 ON o2.visit_id = mv2.id
    INNER JOIN clinical_histories ch2 ON mv2.clinical_history_id = ch2.id
    WHERE ch2.patient_id = x.patient_id
)
ORDER BY x.patient_id, x.exam_date;
```



### 33.

Mostrar las consultas posteriores a la primera consulta de cada paciente.

```sql
SELECT *
FROM medical_visits mv
WHERE mv.visit_date > (
    SELECT MIN(mv2.visit_date)
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = mv.clinical_history_id
);
```



### 34.

Mostrar la última consulta de cada paciente utilizando una subconsulta correlacionada.

```sql
SELECT p.first_name,
       p.last_name,
       mv.visit_date,
       mv.reason
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
WHERE mv.visit_date = (
    SELECT MAX(mv2.visit_date)
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = mv.clinical_history_id
);
```



### 35.

Mostrar la primera medición de PIO de cada paciente.

```sql
SELECT v.patient,
       v.eye,
       v.pressure,
       v.measured_at
FROM vw_patient_iop_history v
WHERE v.measured_at = (
    SELECT MIN(v2.measured_at)
    FROM vw_patient_iop_history v2
    WHERE v2.patient_id = v.patient_id
)
ORDER BY v.patient, v.eye;
```



### 36.

Mostrar la última medición de presión intraocular de cada paciente y ojo.

```sql
SELECT v.patient_id,
       v.patient,
       v.eye,
       v.pressure,
       v.measured_at
FROM vw_patient_iop_history v
WHERE v.measured_at = (
    SELECT MAX(v2.measured_at)
    FROM vw_patient_iop_history v2
    WHERE v2.patient_id = v.patient_id
      AND v2.eye = v.eye
)
ORDER BY v.patient_id, v.eye;
```



### 37.

Mostrar los tratamientos cuya fecha de inicio sea posterior a la primera consulta del paciente.

```sql
SELECT t.*
FROM treatments t
INNER JOIN medical_visits mv ON t.visit_id = mv.id
WHERE t.start_date > (
    SELECT DATE(MIN(mv2.visit_date))
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = mv.clinical_history_id
);
```



### 38.

Mostrar pacientes cuyo número de consultas sea mayor que el de todos los demás pacientes de su misma ciudad.

```sql
-- Se excluyen pacientes sin ciudad. Un paciente único en su ciudad cumple la condición
-- (> ALL sobre un conjunto vacío es verdadero).
WITH visits AS (
    SELECT p.id AS patient_id,
           p.first_name,
           p.last_name,
           p.city_id,
           COUNT(mv.id) AS total_visits
    FROM patients p
    LEFT JOIN clinical_histories ch ON p.id = ch.patient_id
    LEFT JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE p.city_id IS NOT NULL
    GROUP BY p.id, p.first_name, p.last_name, p.city_id
)
SELECT v.*,
       (SELECT c.name FROM cities c WHERE c.id = v.city_id) AS city
FROM visits v
WHERE v.total_visits > ALL (
    SELECT v2.total_visits
    FROM visits v2
    WHERE v2.city_id = v.city_id
      AND v2.patient_id <> v.patient_id
);
```



### 39.

Mostrar profesionales cuya cantidad de consultas sea superior al promedio de los profesionales de su especialidad.

```sql
WITH professional_visits AS (
    SELECT hp.id,
           hp.first_name,
           hp.last_name,
           hp.specialty_id,
           COUNT(mv.id) AS total_visits
    FROM healthcare_professionals hp
    LEFT JOIN medical_visits mv ON hp.id = mv.professional_id
    GROUP BY hp.id, hp.first_name, hp.last_name, hp.specialty_id
)
SELECT *
FROM professional_visits a
WHERE a.total_visits > (
    SELECT AVG(b.total_visits)
    FROM professional_visits b
    WHERE b.specialty_id = a.specialty_id
);
```



### 40.

Mostrar el estudio OCT más reciente de cada paciente.

```sql
SELECT x.patient_id,
       x.id AS oct_id,
       x.eye,
       x.rnfl_average,
       x.exam_date
FROM (
    SELECT o.*, ch.patient_id
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
) x
WHERE x.exam_date = (
    SELECT MAX(o2.exam_date)
    FROM oct_exams o2
    INNER JOIN medical_visits mv2 ON o2.visit_id = mv2.id
    INNER JOIN clinical_histories ch2 ON mv2.clinical_history_id = ch2.id
    WHERE ch2.patient_id = x.patient_id
)
ORDER BY x.patient_id, x.eye;
```



## Subconsultas avanzadas

### 41.

Mostrar pacientes cuya presión intraocular máxima sea mayor que la presión máxima promedio de todos los pacientes.

```sql
SELECT patient_id,
       patient,
       MAX(pressure) AS max_pressure
FROM vw_patient_iop_history
GROUP BY patient_id, patient
HAVING MAX(pressure) > (
    SELECT AVG(max_pressure)
    FROM (
        SELECT MAX(pressure) AS max_pressure
        FROM vw_patient_iop_history
        GROUP BY patient_id
    ) x
);
```



### 42.

Mostrar pacientes cuya cantidad de diagnósticos diferentes sea superior al promedio.

```sql
SELECT ch.patient_id,
       COUNT(DISTINCT vd.diagnosis_id) AS total_diagnoses
FROM clinical_histories ch
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
GROUP BY ch.patient_id
HAVING COUNT(DISTINCT vd.diagnosis_id) > (
    SELECT AVG(total_diagnoses)
    FROM (
        SELECT COUNT(DISTINCT vd.diagnosis_id) AS total_diagnoses
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
        INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
        GROUP BY ch.patient_id
    ) x
);
```



### 43.

Mostrar los pacientes que tengan más tratamientos activos que el promedio de tratamientos activos por paciente.

```sql
-- Promedio calculado entre los pacientes que tienen al menos un tratamiento activo.
-- Con el seed: pacientes 1, 2 y 3 tienen 2 activos frente a un promedio de 1.5.
SELECT ch.patient_id,
       COUNT(*) AS active_treatments
FROM treatments t
INNER JOIN medical_visits mv ON t.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
WHERE t.status = 'ACTIVO'
GROUP BY ch.patient_id
HAVING COUNT(*) > (
    SELECT AVG(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM treatments t2
        INNER JOIN medical_visits mv2 ON t2.visit_id = mv2.id
        INNER JOIN clinical_histories ch2 ON mv2.clinical_history_id = ch2.id
        WHERE t2.status = 'ACTIVO'
        GROUP BY ch2.patient_id
    ) x
);
```



### 44.

Mostrar el medicamento más utilizado en tratamientos.

```sql
SELECT m.name,
       COUNT(*) AS total
FROM treatments t
INNER JOIN medications m ON t.medication_id = m.id
GROUP BY m.id, m.name
HAVING COUNT(*) = (
    SELECT MAX(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM treatments
        GROUP BY medication_id
    ) x
);
```



### 45.

Mostrar el diagnóstico más frecuente utilizando subconsultas.

```sql
SELECT d.name,
       COUNT(*) AS total
FROM visit_diagnoses vd
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
GROUP BY d.id, d.name
HAVING COUNT(*) = (
    SELECT MAX(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM visit_diagnoses
        GROUP BY diagnosis_id
    ) x
);
```



### 46.

Mostrar los pacientes cuya última PIO sea inferior a su primera PIO.

```sql
SELECT p.id,
       p.first_name,
       p.last_name
FROM patients p
WHERE (
    SELECT v.pressure
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p.id
    ORDER BY v.measured_at DESC, v.iop_id DESC
    LIMIT 1
) < (
    SELECT v.pressure
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p.id
    ORDER BY v.measured_at ASC, v.iop_id ASC
    LIMIT 1
);
```



### 47.

Mostrar pacientes cuya presión promedio del ojo derecho sea mayor que la del ojo izquierdo.

```sql
SELECT p.id,
       p.first_name,
       p.last_name
FROM patients p
WHERE (
    SELECT AVG(v.pressure)
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p.id
      AND v.eye = 'OD'
) > (
    SELECT AVG(v.pressure)
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p.id
      AND v.eye = 'OI'
);
```



### 48.

Mostrar los pacientes con mayor cantidad de controles de glaucoma que el promedio general.

```sql
SELECT g.patient_id,
       COUNT(*) AS total_controls
FROM glaucoma_controls gc
INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
GROUP BY g.patient_id
HAVING COUNT(*) > (
    SELECT AVG(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM glaucoma_controls
        GROUP BY glaucoma_record_id
    ) x
);
```



### 49.

Mostrar las consultas que tengan más diagnósticos asociados que el promedio de diagnósticos por consulta.

```sql
SELECT visit_id,
       COUNT(*) AS total_diagnoses
FROM visit_diagnoses
GROUP BY visit_id
HAVING COUNT(*) > (
    SELECT AVG(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM visit_diagnoses
        GROUP BY visit_id
    ) x
);
```



### 50.

Mostrar los pacientes que tengan simultáneamente OCT, campo visual, paquimetría y control de glaucoma registrados.

```sql
SELECT *
FROM patients
WHERE id IN (SELECT ch.patient_id FROM oct_exams e
             INNER JOIN medical_visits mv ON e.visit_id = mv.id
             INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id)
  AND id IN (SELECT ch.patient_id FROM visual_field_exams e
             INNER JOIN medical_visits mv ON e.visit_id = mv.id
             INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id)
  AND id IN (SELECT ch.patient_id FROM pachymetry_exams e
             INNER JOIN medical_visits mv ON e.visit_id = mv.id
             INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id)
  AND id IN (SELECT g.patient_id FROM glaucoma_records g
             INNER JOIN glaucoma_controls gc ON gc.glaucoma_record_id = g.id);
```



# PARTE III — 50 EJERCICIOS DE PROCEDIMIENTOS ALMACENADOS

## Procedimientos básicos

### 1.

Crear un procedimiento que liste todos los pacientes.

```sql
DROP PROCEDURE IF EXISTS sp_list_patients;

DELIMITER $$

CREATE PROCEDURE sp_list_patients()
BEGIN
    SELECT p.id,
           dt.code AS document_type,
           p.document_number,
           p.first_name,
           p.last_name,
           p.birth_date,
           p.sex,
           c.name AS city
    FROM patients p
    INNER JOIN document_types dt ON p.document_type_id = dt.id
    LEFT JOIN cities c ON p.city_id = c.id
    ORDER BY p.last_name, p.first_name;
END $$

DELIMITER ;

CALL sp_list_patients();
```



### 2.

Crear un procedimiento que reciba el ID de un paciente y muestre sus datos.

```sql
DROP PROCEDURE IF EXISTS sp_get_patient_by_id;

DELIMITER $$

CREATE PROCEDURE sp_get_patient_by_id(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    SELECT p.*,
           dt.name AS document_type,
           c.name AS city,
           c.department
    FROM patients p
    INNER JOIN document_types dt ON p.document_type_id = dt.id
    LEFT JOIN cities c ON p.city_id = c.id
    WHERE p.id = p_patient_id;
END $$

DELIMITER ;

CALL sp_get_patient_by_id(1);
-- CALL sp_get_patient_by_id(999);  -- Error: El paciente no existe
```



### 3.

Crear un procedimiento que busque un paciente por número de documento.

```sql
DROP PROCEDURE IF EXISTS sp_find_patient_by_document;

DELIMITER $$

CREATE PROCEDURE sp_find_patient_by_document(
    IN p_document_number VARCHAR(20)
)
BEGIN
    SELECT *
    FROM patients
    WHERE document_number = TRIM(p_document_number);
END $$

DELIMITER ;

CALL sp_find_patient_by_document('1098456123');
```



### 4.

Crear un procedimiento que liste todas las consultas de un paciente.

```sql
DROP PROCEDURE IF EXISTS sp_list_patient_visits;

DELIMITER $$

CREATE PROCEDURE sp_list_patient_visits(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT mv.id,
           mv.visit_date,
           mv.reason,
           CONCAT(hp.first_name, ' ', hp.last_name) AS professional
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY mv.visit_date;
END $$

DELIMITER ;

CALL sp_list_patient_visits(2);
```



### 5.

Crear un procedimiento que muestre todos los profesionales.

```sql
DROP PROCEDURE IF EXISTS sp_list_professionals;

DELIMITER $$

CREATE PROCEDURE sp_list_professionals()
BEGIN
    SELECT hp.id,
           CONCAT(hp.first_name, ' ', hp.last_name) AS professional,
           s.name AS specialty,
           hp.license_number,
           hp.is_active
    FROM healthcare_professionals hp
    INNER JOIN specialties s ON hp.specialty_id = s.id
    ORDER BY hp.last_name;
END $$

DELIMITER ;

CALL sp_list_professionals();
```



### 6.

Crear un procedimiento que reciba una especialidad y muestre sus profesionales.

```sql
DROP PROCEDURE IF EXISTS sp_list_professionals_by_specialty;

DELIMITER $$

CREATE PROCEDURE sp_list_professionals_by_specialty(
    IN p_specialty VARCHAR(100)
)
BEGIN
    SELECT hp.id,
           hp.first_name,
           hp.last_name,
           s.name AS specialty
    FROM healthcare_professionals hp
    INNER JOIN specialties s ON hp.specialty_id = s.id
    WHERE s.name = p_specialty;
END $$

DELIMITER ;

CALL sp_list_professionals_by_specialty('Oftalmología');
```



### 7.

Crear un procedimiento que liste diagnósticos.

```sql
DROP PROCEDURE IF EXISTS sp_list_diagnoses;

DELIMITER $$

CREATE PROCEDURE sp_list_diagnoses()
BEGIN
    SELECT id, code, name, is_glaucoma
    FROM diagnoses
    ORDER BY code;
END $$

DELIMITER ;

CALL sp_list_diagnoses();
```



### 8.

Crear un procedimiento que muestre medicamentos activos.

```sql
DROP PROCEDURE IF EXISTS sp_list_active_medications;

DELIMITER $$

CREATE PROCEDURE sp_list_active_medications()
BEGIN
    SELECT id, name, active_ingredient, presentation
    FROM medications
    WHERE is_active = TRUE
    ORDER BY name;
END $$

DELIMITER ;

CALL sp_list_active_medications();
```



### 9.

Crear un procedimiento que liste procedimientos clínicos realizados a un paciente.

```sql
DROP PROCEDURE IF EXISTS sp_list_patient_procedures;

DELIMITER $$

CREATE PROCEDURE sp_list_patient_procedures(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT pr.id,
           pt.name AS procedure_name,
           pt.category,
           pr.eye,
           pr.performed_at,
           pr.notes
    FROM procedures pr
    INNER JOIN procedure_types pt ON pr.procedure_type_id = pt.id
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY pr.performed_at;
END $$

DELIMITER ;

CALL sp_list_patient_procedures(3);
```



### 10.

Crear un procedimiento para consultar todos los controles de glaucoma de un paciente.

```sql
DROP PROCEDURE IF EXISTS sp_list_glaucoma_controls;

DELIMITER $$

CREATE PROCEDURE sp_list_glaucoma_controls(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT gc.id,
           gc.control_date,
           gc.progression_detected,
           gc.notes,
           gc.visit_id
    FROM glaucoma_controls gc
    INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
    WHERE g.patient_id = p_patient_id
    ORDER BY gc.control_date;
END $$

DELIMITER ;

CALL sp_list_glaucoma_controls(2);
```



## Procedimientos de inserción

### 11.

Crear un procedimiento para registrar un nuevo paciente.

```sql
DROP PROCEDURE IF EXISTS sp_register_patient;

DELIMITER $$

CREATE PROCEDURE sp_register_patient(
    IN p_document_type_id TINYINT,
    IN p_document_number VARCHAR(20),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_birth_date DATE,
    IN p_sex CHAR(1),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(20),
    IN p_address VARCHAR(200),
    IN p_city_id INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM patients WHERE document_number = p_document_number) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un paciente con ese número de documento';
    END IF;

    INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date,
                          sex, email, phone, address, city_id)
    VALUES (p_document_type_id, p_document_number, p_first_name, p_last_name, p_birth_date,
            p_sex, p_email, p_phone, p_address, p_city_id);

    SELECT LAST_INSERT_ID() AS patient_id;
END $$

DELIMITER ;

CALL sp_register_patient(1, '1098777888', 'Andrea', 'Becerra', '1983-05-17', 'F',
                         'andrea.becerra@gmail.com', '3051231234', 'Calle 10 # 20-30', 1);
-- CALL sp_register_patient(1, '1098456123', 'X', 'Y', '1990-01-01', 'M', NULL, NULL, NULL, NULL);
--   Error: Ya existe un paciente con ese número de documento
```



### 12.

Crear un procedimiento para crear una historia clínica.

```sql
-- Si no se envía número, se genera como HC- + id del paciente con 6 dígitos.
DROP PROCEDURE IF EXISTS sp_create_clinical_history;

DELIMITER $$

CREATE PROCEDURE sp_create_clinical_history(
    IN p_patient_id BIGINT,
    IN p_history_number VARCHAR(20)
)
BEGIN
    INSERT INTO clinical_histories (patient_id, history_number)
    VALUES (p_patient_id, IFNULL(p_history_number, CONCAT('HC-', LPAD(p_patient_id, 6, '0'))));

    SELECT LAST_INSERT_ID() AS clinical_history_id;
END $$

DELIMITER ;

-- El paciente 20 (Daniela Carrillo) no tiene historia clínica en el seed.
CALL sp_create_clinical_history(20, NULL);
```



### 13.

Crear un procedimiento para registrar una consulta médica.

```sql
DROP PROCEDURE IF EXISTS sp_register_medical_visit;

DELIMITER $$

CREATE PROCEDURE sp_register_medical_visit(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255)
)
BEGIN
    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, IFNULL(p_visit_date, NOW()), p_reason);

    SELECT LAST_INSERT_ID() AS visit_id;
END $$

DELIMITER ;

-- Historia 20 creada en el ejercicio 12 → genera la consulta 31.
CALL sp_register_medical_visit(20, 1, '2026-10-01 09:00:00', 'Primera consulta por antecedente familiar de glaucoma');
```



### 14.

Crear un procedimiento para registrar un diagnóstico asociado a una consulta.

```sql
DROP PROCEDURE IF EXISTS sp_register_visit_diagnosis;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_diagnosis(
    IN p_visit_id BIGINT,
    IN p_diagnosis_id INT,
    IN p_eye VARCHAR(2),
    IN p_is_primary BOOLEAN
)
BEGIN
    INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary)
    VALUES (p_visit_id, p_diagnosis_id, p_eye, IFNULL(p_is_primary, FALSE));
END $$

DELIMITER ;

CALL sp_register_visit_diagnosis(31, 3, 'AO', TRUE);
SELECT * FROM visit_diagnoses WHERE visit_id = 31;
```



### 15.

Crear un procedimiento para registrar una medición de PIO.

```sql
DROP PROCEDURE IF EXISTS sp_register_iop_measurement;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_measurement(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_method VARCHAR(10),
    IN p_measured_at DATETIME
)
BEGIN
    INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, IFNULL(p_method, 'GOLDMANN'), IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_measurement(31, 'OD', 19.0, 'GOLDMANN', '2026-10-01 09:10:00');
```



### 16.

Crear un procedimiento para registrar un control de glaucoma.

```sql
DROP PROCEDURE IF EXISTS sp_register_glaucoma_control;

DELIMITER $$

CREATE PROCEDURE sp_register_glaucoma_control(
    IN p_glaucoma_record_id BIGINT,
    IN p_visit_id BIGINT,
    IN p_control_date DATE,
    IN p_progression BOOLEAN,
    IN p_notes TEXT
)
BEGIN
    INSERT INTO glaucoma_controls (glaucoma_record_id, visit_id, control_date, progression_detected, notes)
    VALUES (p_glaucoma_record_id, p_visit_id, p_control_date, IFNULL(p_progression, FALSE), p_notes);

    SELECT LAST_INSERT_ID() AS control_id;
END $$

DELIMITER ;

-- La consulta 17 (Ana Lucía Gómez) no tiene control asociado en el seed.
CALL sp_register_glaucoma_control(6, 17, '2025-12-09', FALSE, 'Control inicial registrado tardíamente');
```



### 17.

Crear un procedimiento para registrar un examen OCT.

```sql
DROP PROCEDURE IF EXISTS sp_register_oct;

DELIMITER $$

CREATE PROCEDURE sp_register_oct(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_rnfl_average DECIMAL(5,1),
    IN p_cup_disc_ratio DECIMAL(3,2),
    IN p_interpretation TEXT,
    IN p_exam_date DATE
)
BEGIN
    INSERT INTO oct_exams (visit_id, eye, rnfl_average, cup_disc_ratio, interpretation, exam_date)
    VALUES (p_visit_id, p_eye, p_rnfl_average, p_cup_disc_ratio, p_interpretation, p_exam_date);

    SELECT LAST_INSERT_ID() AS oct_id;
END $$

DELIMITER ;

CALL sp_register_oct(31, 'OD', 94.0, 0.45, 'Capa de fibras nerviosas dentro de límites normales', '2026-10-01');
```



### 18.

Crear un procedimiento para registrar un campo visual.

```sql
DROP PROCEDURE IF EXISTS sp_register_visual_field;

DELIMITER $$

CREATE PROCEDURE sp_register_visual_field(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_md DECIMAL(5,2),
    IN p_psd DECIMAL(5,2),
    IN p_vfi TINYINT,
    IN p_reliability VARCHAR(5),
    IN p_interpretation TEXT,
    IN p_exam_date DATE
)
BEGIN
    INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, reliability, interpretation, exam_date)
    VALUES (p_visit_id, p_eye, p_md, p_psd, p_vfi, IFNULL(p_reliability, 'ALTA'), p_interpretation, p_exam_date);

    SELECT LAST_INSERT_ID() AS visual_field_id;
END $$

DELIMITER ;

CALL sp_register_visual_field(31, 'OD', -0.8, 1.4, 99, 'ALTA', 'Campo visual sin defectos significativos', '2026-10-01');
```



### 19.

Crear un procedimiento para registrar una paquimetría.

```sql
DROP PROCEDURE IF EXISTS sp_register_pachymetry;

DELIMITER $$

CREATE PROCEDURE sp_register_pachymetry(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_thickness_um SMALLINT,
    IN p_exam_date DATE
)
BEGIN
    INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date)
    VALUES (p_visit_id, p_eye, p_thickness_um, p_exam_date);

    SELECT LAST_INSERT_ID() AS pachymetry_id;
END $$

DELIMITER ;

CALL sp_register_pachymetry(31, 'OD', 551, '2026-10-01');
```



### 20.

Crear un procedimiento para registrar un tratamiento.

```sql
DROP PROCEDURE IF EXISTS sp_register_treatment;

DELIMITER $$

CREATE PROCEDURE sp_register_treatment(
    IN p_visit_id BIGINT,
    IN p_medication_id INT,
    IN p_eye VARCHAR(2),
    IN p_dosage VARCHAR(100),
    IN p_frequency VARCHAR(100),
    IN p_start_date DATE
)
BEGIN
    INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date)
    VALUES (p_visit_id, p_medication_id, p_eye, p_dosage, p_frequency, IFNULL(p_start_date, CURDATE()));

    SELECT LAST_INSERT_ID() AS treatment_id;
END $$

DELIMITER ;

CALL sp_register_treatment(31, 1, 'AO', '1 gota', 'Cada noche', '2026-10-01');
```



## Procedimientos de modificación

### 21.

Crear un procedimiento para actualizar teléfono y correo de un paciente.

```sql
DROP PROCEDURE IF EXISTS sp_update_patient_contact;

DELIMITER $$

CREATE PROCEDURE sp_update_patient_contact(
    IN p_patient_id BIGINT,
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(150)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    UPDATE patients
    SET phone = p_phone,
        email = LOWER(TRIM(p_email))
    WHERE id = p_patient_id;

    SELECT id, phone, email FROM patients WHERE id = p_patient_id;
END $$

DELIMITER ;

CALL sp_update_patient_contact(20, '3029998877', 'Daniela.Carrillo@Gmail.com');
```



### 22.

Crear un procedimiento para modificar el estado de una historia clínica.

```sql
DROP PROCEDURE IF EXISTS sp_update_history_status;

DELIMITER $$

CREATE PROCEDURE sp_update_history_status(
    IN p_history_id BIGINT,
    IN p_status VARCHAR(10)
)
BEGIN
    IF p_status NOT IN ('ACTIVA', 'CERRADA') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no válido: use ACTIVA o CERRADA';
    END IF;

    UPDATE clinical_histories
    SET status = p_status
    WHERE id = p_history_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La historia clínica no existe';
    END IF;
END $$

DELIMITER ;

CALL sp_update_history_status(19, 'CERRADA');
SELECT id, history_number, status FROM clinical_histories WHERE id = 19;
-- CALL sp_update_history_status(19, 'ARCHIVADA');  -- Error: Estado no válido: use ACTIVA o CERRADA
```



### 23.

Crear un procedimiento para actualizar observaciones de una consulta.

```sql
DROP PROCEDURE IF EXISTS sp_update_visit_observations;

DELIMITER $$

CREATE PROCEDURE sp_update_visit_observations(
    IN p_visit_id BIGINT,
    IN p_observations TEXT
)
BEGIN
    UPDATE medical_visits
    SET observations = p_observations
    WHERE id = p_visit_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta no existe o no hubo cambios';
    END IF;
END $$

DELIMITER ;

CALL sp_update_visit_observations(14, 'Se programa SLT bilateral y control en 3 meses');
```



### 24.

Crear un procedimiento para modificar la presión objetivo de un paciente con glaucoma.

```sql
DROP PROCEDURE IF EXISTS sp_update_target_pressure;

DELIMITER $$

CREATE PROCEDURE sp_update_target_pressure(
    IN p_patient_id BIGINT,
    IN p_target_pressure DECIMAL(4,1)
)
BEGIN
    IF p_target_pressure IS NULL OR p_target_pressure <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La presión objetivo debe ser mayor que cero';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM glaucoma_records WHERE patient_id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene registro de glaucoma';
    END IF;

    UPDATE glaucoma_records
    SET target_pressure = p_target_pressure
    WHERE patient_id = p_patient_id;
END $$

DELIMITER ;

CALL sp_update_target_pressure(4, 11.0);
-- CALL sp_update_target_pressure(10, 15.0);  -- Error: El paciente no tiene registro de glaucoma
```



### 25.

Crear un procedimiento para finalizar un tratamiento.

```sql
DROP PROCEDURE IF EXISTS sp_finish_treatment;

DELIMITER $$

CREATE PROCEDURE sp_finish_treatment(
    IN p_treatment_id BIGINT,
    IN p_end_date DATE
)
BEGIN
    DECLARE v_start DATE;
    DECLARE v_status VARCHAR(10);

    SELECT start_date, status INTO v_start, v_status
    FROM treatments
    WHERE id = p_treatment_id;

    IF v_start IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tratamiento no existe';
    END IF;

    IF v_status <> 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se puede finalizar un tratamiento activo';
    END IF;

    IF IFNULL(p_end_date, CURDATE()) < v_start THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final no puede ser anterior a la inicial';
    END IF;

    UPDATE treatments
    SET status = 'FINALIZADO',
        end_date = IFNULL(p_end_date, CURDATE())
    WHERE id = p_treatment_id;
END $$

DELIMITER ;

CALL sp_finish_treatment(2, '2026-02-12');
SELECT id, status, start_date, end_date FROM treatments WHERE id = 2;
-- CALL sp_finish_treatment(1, '2026-01-01');  -- Error: Solo se puede finalizar un tratamiento activo
```



### 26.

Crear un procedimiento para cambiar el medicamento de un tratamiento.

```sql
DROP PROCEDURE IF EXISTS sp_change_treatment_medication;

DELIMITER $$

CREATE PROCEDURE sp_change_treatment_medication(
    IN p_treatment_id BIGINT,
    IN p_medication_id INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM medications WHERE id = p_medication_id AND is_active = TRUE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El medicamento no existe o no está activo';
    END IF;

    UPDATE treatments
    SET medication_id = p_medication_id
    WHERE id = p_treatment_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tratamiento no existe o ya usa ese medicamento';
    END IF;
END $$

DELIMITER ;

CALL sp_change_treatment_medication(3, 4);
-- CALL sp_change_treatment_medication(3, 8);  -- Error: El medicamento no existe o no está activo (Pilocarpina)
```



### 27.

Crear un procedimiento para actualizar el estado clínico del glaucoma.

```sql
DROP PROCEDURE IF EXISTS sp_update_glaucoma_status;

DELIMITER $$

CREATE PROCEDURE sp_update_glaucoma_status(
    IN p_patient_id BIGINT,
    IN p_status VARCHAR(20)
)
BEGIN
    IF p_status NOT IN ('CONTROLADO', 'NO_CONTROLADO', 'EN_PROGRESION', 'ESTABLE') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no válido: CONTROLADO, NO_CONTROLADO, EN_PROGRESION o ESTABLE';
    END IF;

    UPDATE glaucoma_records
    SET clinical_status = p_status
    WHERE patient_id = p_patient_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene registro de glaucoma o ya tiene ese estado';
    END IF;
END $$

DELIMITER ;

CALL sp_update_glaucoma_status(6, 'CONTROLADO');
```



### 28.

Crear un procedimiento para actualizar información de un profesional.

```sql
-- Los parámetros NULL conservan el valor actual.
DROP PROCEDURE IF EXISTS sp_update_professional;

DELIMITER $$

CREATE PROCEDURE sp_update_professional(
    IN p_professional_id BIGINT,
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(20),
    IN p_specialty_id INT,
    IN p_is_active BOOLEAN
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM healthcare_professionals WHERE id = p_professional_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesional no existe';
    END IF;

    UPDATE healthcare_professionals
    SET email = IFNULL(p_email, email),
        phone = IFNULL(p_phone, phone),
        specialty_id = IFNULL(p_specialty_id, specialty_id),
        is_active = IFNULL(p_is_active, is_active)
    WHERE id = p_professional_id;

    SELECT * FROM healthcare_professionals WHERE id = p_professional_id;
END $$

DELIMITER ;

CALL sp_update_professional(5, NULL, '3005005099', NULL, NULL);
```



### 29.

Crear un procedimiento para modificar la interpretación de un OCT.

```sql
DROP PROCEDURE IF EXISTS sp_update_oct_interpretation;

DELIMITER $$

CREATE PROCEDURE sp_update_oct_interpretation(
    IN p_oct_id BIGINT,
    IN p_interpretation TEXT
)
BEGIN
    UPDATE oct_exams
    SET interpretation = p_interpretation
    WHERE id = p_oct_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El OCT no existe o no hubo cambios';
    END IF;
END $$

DELIMITER ;

-- OCT 13 = consulta 14 (sin validar).
CALL sp_update_oct_interpretation(13, 'Adelgazamiento progresivo de la capa de fibras nerviosas en OD');
```



### 30.

Crear un procedimiento para actualizar la interpretación de un campo visual.

```sql
DROP PROCEDURE IF EXISTS sp_update_visual_field_interpretation;

DELIMITER $$

CREATE PROCEDURE sp_update_visual_field_interpretation(
    IN p_visual_field_id BIGINT,
    IN p_interpretation TEXT
)
BEGIN
    UPDATE visual_field_exams
    SET interpretation = p_interpretation
    WHERE id = p_visual_field_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El campo visual no existe o no hubo cambios';
    END IF;
END $$

DELIMITER ;

CALL sp_update_visual_field_interpretation(13, 'Defecto arciforme superior y escalón nasal en OD');
```



## Procedimientos con validaciones

### 31.

Crear un procedimiento que registre una PIO únicamente si el paciente existe.

```sql
-- Valida además que la consulta pertenezca a ese paciente.
DROP PROCEDURE IF EXISTS sp_register_iop_for_patient;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_for_patient(
    IN p_patient_id BIGINT,
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_measured_at DATETIME
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM medical_visits mv
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE mv.id = p_visit_id AND ch.patient_id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta no pertenece al paciente';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_for_patient(20, 31, 'OI', 18.0, '2026-10-01 09:12:00');
-- CALL sp_register_iop_for_patient(999, 31, 'OI', 18, NULL);  -- Error: El paciente no existe
-- CALL sp_register_iop_for_patient(1, 31, 'OI', 18, NULL);    -- Error: La consulta no pertenece al paciente
```



### 32.

Crear un procedimiento que registre una consulta solo si existe la historia clínica.

```sql
DROP PROCEDURE IF EXISTS sp_register_visit_if_history;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_if_history(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM clinical_histories WHERE id = p_clinical_history_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La historia clínica no existe';
    END IF;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, p_visit_date, p_reason);

    SELECT LAST_INSERT_ID() AS visit_id;
END $$

DELIMITER ;

CALL sp_register_visit_if_history(18, 5, '2026-09-28 10:00:00', 'Valoración optométrica de rutina');
-- CALL sp_register_visit_if_history(999, 1, NOW(), 'X');  -- Error: La historia clínica no existe
```



### 33.

Crear un procedimiento que impida registrar un tratamiento con fecha final anterior a la inicial.

```sql
DROP PROCEDURE IF EXISTS sp_register_treatment_with_dates;

DELIMITER $$

CREATE PROCEDURE sp_register_treatment_with_dates(
    IN p_visit_id BIGINT,
    IN p_medication_id INT,
    IN p_eye VARCHAR(2),
    IN p_dosage VARCHAR(100),
    IN p_frequency VARCHAR(100),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    IF p_end_date IS NOT NULL AND p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final no puede ser anterior a la inicial';
    END IF;

    INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date, end_date, status)
    VALUES (p_visit_id, p_medication_id, p_eye, p_dosage, p_frequency, p_start_date, p_end_date,
            IF(p_end_date IS NULL, 'ACTIVO', 'FINALIZADO'));

    SELECT LAST_INSERT_ID() AS treatment_id;
END $$

DELIMITER ;

CALL sp_register_treatment_with_dates(17, 2, 'AO', '1 gota', 'Cada 12 horas', '2025-12-09', '2026-06-30');
-- CALL sp_register_treatment_with_dates(17, 2, 'AO', '1 gota', 'Cada 12 horas', '2026-06-30', '2025-12-09');
--   Error: La fecha final no puede ser anterior a la inicial
```



### 34.

Crear un procedimiento que impida registrar valores negativos de PIO.

```sql
DROP PROCEDURE IF EXISTS sp_register_iop_non_negative;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_non_negative(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_measured_at DATETIME
)
BEGIN
    IF p_pressure IS NULL OR p_pressure < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO no puede ser negativa';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_non_negative(29, 'OD', 16.0, '2026-09-01 07:40:00');
-- CALL sp_register_iop_non_negative(29, 'OD', -4, NULL);  -- Error: La PIO no puede ser negativa
```



### 35.

Crear un procedimiento que valide que el ojo recibido sea `OD` u `OI`.

```sql
DROP PROCEDURE IF EXISTS sp_register_iop_valid_eye;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_valid_eye(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_measured_at DATETIME
)
BEGIN
    IF p_eye IS NULL OR UPPER(p_eye) NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (p_visit_id, UPPER(p_eye), p_pressure, IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_valid_eye(29, 'oi', 15.0, '2026-09-01 07:41:00');
-- CALL sp_register_iop_valid_eye(29, 'AO', 15, NULL);  -- Error: El ojo debe ser OD u OI
```



### 36.

Crear un procedimiento que impida crear dos historias clínicas para el mismo paciente.

```sql
DROP PROCEDURE IF EXISTS sp_create_unique_history;

DELIMITER $$

CREATE PROCEDURE sp_create_unique_history(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    IF EXISTS (SELECT 1 FROM clinical_histories WHERE patient_id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente ya tiene una historia clínica';
    END IF;

    INSERT INTO clinical_histories (patient_id, history_number)
    VALUES (p_patient_id, CONCAT('HC-', LPAD(p_patient_id, 6, '0')));

    SELECT LAST_INSERT_ID() AS clinical_history_id;
END $$

DELIMITER ;

-- El paciente 21 se creó en el ejercicio 11 y aún no tiene historia.
CALL sp_create_unique_history(21);
-- CALL sp_create_unique_history(1);  -- Error: El paciente ya tiene una historia clínica
```



### 37.

Crear un procedimiento que registre un diagnóstico solo si existe en el catálogo.

```sql
-- Recibe el código CIE-10 en lugar del id.
DROP PROCEDURE IF EXISTS sp_register_diagnosis_by_code;

DELIMITER $$

CREATE PROCEDURE sp_register_diagnosis_by_code(
    IN p_visit_id BIGINT,
    IN p_code VARCHAR(10),
    IN p_eye VARCHAR(2),
    IN p_is_primary BOOLEAN
)
BEGIN
    DECLARE v_diagnosis_id INT;

    SELECT id INTO v_diagnosis_id
    FROM diagnoses
    WHERE code = p_code;

    IF v_diagnosis_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El diagnóstico no existe en el catálogo';
    END IF;

    INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary)
    VALUES (p_visit_id, v_diagnosis_id, p_eye, IFNULL(p_is_primary, FALSE));
END $$

DELIMITER ;

CALL sp_register_diagnosis_by_code(31, 'H52.1', 'AO', FALSE);
-- CALL sp_register_diagnosis_by_code(31, 'Z99.9', 'AO', FALSE);  -- Error: El diagnóstico no existe en el catálogo
```



### 38.

Crear un procedimiento que valide que el profesional se encuentre activo antes de registrar una consulta.

```sql
DROP PROCEDURE IF EXISTS sp_register_visit_active_professional;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_active_professional(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM healthcare_professionals WHERE id = p_professional_id AND is_active = TRUE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesional no existe o no está activo';
    END IF;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, p_visit_date, p_reason);

    SELECT LAST_INSERT_ID() AS visit_id;
END $$

DELIMITER ;

CALL sp_register_visit_active_professional(13, 3, '2026-09-30 15:00:00', 'Control de ojo rojo');
-- CALL sp_register_visit_active_professional(13, 4, NOW(), 'X');  -- Error: El profesional no existe o no está activo (Jorge Castillo)
```



### 39.

Crear un procedimiento que registre un campo visual validando que VFI esté entre 0 y 100.

```sql
DROP PROCEDURE IF EXISTS sp_register_visual_field_checked;

DELIMITER $$

CREATE PROCEDURE sp_register_visual_field_checked(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_md DECIMAL(5,2),
    IN p_psd DECIMAL(5,2),
    IN p_vfi INT,
    IN p_exam_date DATE
)
BEGIN
    IF p_vfi IS NULL OR p_vfi < 0 OR p_vfi > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El VFI debe estar entre 0 y 100';
    END IF;

    INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, exam_date)
    VALUES (p_visit_id, p_eye, p_md, p_psd, p_vfi, p_exam_date);

    SELECT LAST_INSERT_ID() AS visual_field_id;
END $$

DELIMITER ;

CALL sp_register_visual_field_checked(31, 'OI', -1.0, 1.5, 98, '2026-10-01');
-- CALL sp_register_visual_field_checked(31, 'OI', -1.0, 1.5, 120, '2026-10-01');  -- Error: El VFI debe estar entre 0 y 100
```



### 40.

Crear un procedimiento que registre una paquimetría validando que el valor sea positivo.

```sql
DROP PROCEDURE IF EXISTS sp_register_pachymetry_checked;

DELIMITER $$

CREATE PROCEDURE sp_register_pachymetry_checked(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_thickness_um INT,
    IN p_exam_date DATE
)
BEGIN
    IF p_thickness_um IS NULL OR p_thickness_um <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espesor corneal debe ser un valor positivo';
    END IF;

    INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date)
    VALUES (p_visit_id, p_eye, p_thickness_um, p_exam_date);

    SELECT LAST_INSERT_ID() AS pachymetry_id;
END $$

DELIMITER ;

CALL sp_register_pachymetry_checked(31, 'OI', 549, '2026-10-01');
-- CALL sp_register_pachymetry_checked(31, 'OI', 0, '2026-10-01');  -- Error: El espesor corneal debe ser un valor positivo
```



## Procedimientos avanzados

### 41.

Crear un procedimiento que devuelva un resumen completo de la historia clínica de un paciente.

```sql
-- Devuelve varios conjuntos de resultados: datos, antecedentes, consultas, PIO y tratamientos.
DROP PROCEDURE IF EXISTS sp_patient_history_summary;

DELIMITER $$

CREATE PROCEDURE sp_patient_history_summary(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    SELECT p.id,
           CONCAT(p.first_name, ' ', p.last_name) AS patient,
           p.document_number,
           TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) AS age,
           ch.history_number,
           ch.status AS history_status,
           gt.name AS glaucoma_type,
           g.clinical_status,
           g.target_pressure
    FROM patients p
    LEFT JOIN clinical_histories ch ON ch.patient_id = p.id
    LEFT JOIN glaucoma_records g ON g.patient_id = p.id
    LEFT JOIN glaucoma_types gt ON g.glaucoma_type_id = gt.id
    WHERE p.id = p_patient_id;

    SELECT 'Alergia' AS type, a.name AS detail, pa.reaction AS extra
    FROM patient_allergies pa
    INNER JOIN allergens a ON pa.allergen_id = a.id
    WHERE pa.patient_id = p_patient_id
    UNION ALL
    SELECT 'Familiar', d.name, pf.relationship
    FROM patient_family_histories pf
    INNER JOIN diagnoses d ON pf.diagnosis_id = d.id
    WHERE pf.patient_id = p_patient_id
    UNION ALL
    SELECT 'Personal', ht.name, pp.description
    FROM patient_personal_histories pp
    INNER JOIN history_types ht ON pp.history_type_id = ht.id
    WHERE pp.patient_id = p_patient_id;

    SELECT mv.id AS visit_id,
           mv.visit_date,
           mv.reason,
           GROUP_CONCAT(d.code ORDER BY vd.is_primary DESC SEPARATOR ', ') AS diagnoses
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    LEFT JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    LEFT JOIN diagnoses d ON vd.diagnosis_id = d.id
    WHERE ch.patient_id = p_patient_id
    GROUP BY mv.id, mv.visit_date, mv.reason
    ORDER BY mv.visit_date;

    SELECT measured_at, eye, pressure, method
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
    ORDER BY measured_at, eye;

    SELECT m.name AS medication, t.eye, t.frequency, t.start_date, t.end_date, t.status
    FROM treatments t
    INNER JOIN medications m ON t.medication_id = m.id
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY t.start_date;
END $$

DELIMITER ;

CALL sp_patient_history_summary(1);
```



### 42.

Crear un procedimiento que muestre la evolución de PIO de un paciente entre dos fechas.

```sql
DROP PROCEDURE IF EXISTS sp_iop_evolution_between;

DELIMITER $$

CREATE PROCEDURE sp_iop_evolution_between(
    IN p_patient_id BIGINT,
    IN p_from DATE,
    IN p_to DATE
)
BEGIN
    IF p_from > p_to THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha inicial no puede ser mayor que la final';
    END IF;

    SELECT DATE(measured_at) AS date,
           MAX(CASE WHEN eye = 'OD' THEN pressure END) AS iop_od,
           MAX(CASE WHEN eye = 'OI' THEN pressure END) AS iop_oi
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at >= p_from
      AND measured_at < p_to + INTERVAL 1 DAY
    GROUP BY DATE(measured_at)
    ORDER BY date;
END $$

DELIMITER ;

CALL sp_iop_evolution_between(1, '2025-01-01', '2026-12-31');
```



### 43.

Crear un procedimiento que reciba paciente y ojo y muestre todas sus mediciones cronológicamente.

```sql
DROP PROCEDURE IF EXISTS sp_iop_by_patient_eye;

DELIMITER $$

CREATE PROCEDURE sp_iop_by_patient_eye(
    IN p_patient_id BIGINT,
    IN p_eye VARCHAR(2)
)
BEGIN
    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    SELECT measured_at, pressure, method, professional
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = p_eye
    ORDER BY measured_at;
END $$

DELIMITER ;

CALL sp_iop_by_patient_eye(2, 'OD');
```



### 44.

Crear un procedimiento que genere estadísticas mensuales de consultas.

```sql
-- p_year NULL = todos los años.
DROP PROCEDURE IF EXISTS sp_monthly_visit_stats;

DELIMITER $$

CREATE PROCEDURE sp_monthly_visit_stats(
    IN p_year INT
)
BEGIN
    SELECT YEAR(mv.visit_date) AS year,
           MONTH(mv.visit_date) AS month,
           COUNT(*) AS total_visits,
           COUNT(DISTINCT mv.clinical_history_id) AS distinct_patients,
           COUNT(DISTINCT mv.professional_id) AS professionals
    FROM medical_visits mv
    WHERE p_year IS NULL OR YEAR(mv.visit_date) = p_year
    GROUP BY YEAR(mv.visit_date), MONTH(mv.visit_date)
    ORDER BY year, month;
END $$

DELIMITER ;

CALL sp_monthly_visit_stats(2026);
```



### 45.

Crear un procedimiento que calcule la cantidad de pacientes atendidos por cada especialista.

```sql
DROP PROCEDURE IF EXISTS sp_patients_per_specialist;

DELIMITER $$

CREATE PROCEDURE sp_patients_per_specialist()
BEGIN
    SELECT CONCAT(hp.first_name, ' ', hp.last_name) AS professional,
           s.name AS specialty,
           COUNT(DISTINCT mv.clinical_history_id) AS patients_attended,
           COUNT(mv.id) AS total_visits
    FROM healthcare_professionals hp
    INNER JOIN specialties s ON hp.specialty_id = s.id
    LEFT JOIN medical_visits mv ON mv.professional_id = hp.id
    GROUP BY hp.id, hp.first_name, hp.last_name, s.name
    ORDER BY patients_attended DESC;
END $$

DELIMITER ;

CALL sp_patients_per_specialist();
```



### 46.

Crear un procedimiento que determine pacientes sin consulta durante un número de meses recibido como parámetro.

```sql
-- Incluye pacientes que nunca han tenido consulta (last_visit NULL).
DROP PROCEDURE IF EXISTS sp_patients_without_visit;

DELIMITER $$

CREATE PROCEDURE sp_patients_without_visit(
    IN p_months INT
)
BEGIN
    IF p_months IS NULL OR p_months <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El número de meses debe ser mayor que cero';
    END IF;

    SELECT p.id,
           CONCAT(p.first_name, ' ', p.last_name) AS patient,
           MAX(mv.visit_date) AS last_visit
    FROM patients p
    LEFT JOIN clinical_histories ch ON ch.patient_id = p.id
    LEFT JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    GROUP BY p.id, p.first_name, p.last_name
    HAVING MAX(mv.visit_date) IS NULL
        OR MAX(mv.visit_date) < NOW() - INTERVAL p_months MONTH
    ORDER BY last_visit;
END $$

DELIMITER ;

CALL sp_patients_without_visit(6);
```



### 47.

Crear un procedimiento que genere un resumen de diagnósticos por paciente.

```sql
-- p_patient_id NULL = todos los pacientes.
DROP PROCEDURE IF EXISTS sp_diagnosis_summary_by_patient;

DELIMITER $$

CREATE PROCEDURE sp_diagnosis_summary_by_patient(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT ch.patient_id,
           CONCAT(p.first_name, ' ', p.last_name) AS patient,
           d.code,
           d.name AS diagnosis,
           COUNT(*) AS times_registered,
           MIN(mv.visit_date) AS first_time,
           MAX(mv.visit_date) AS last_time
    FROM visit_diagnoses vd
    INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
    INNER JOIN medical_visits mv ON vd.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    INNER JOIN patients p ON ch.patient_id = p.id
    WHERE p_patient_id IS NULL OR ch.patient_id = p_patient_id
    GROUP BY ch.patient_id, p.first_name, p.last_name, d.id, d.code, d.name
    ORDER BY ch.patient_id, times_registered DESC;
END $$

DELIMITER ;

CALL sp_diagnosis_summary_by_patient(1);
```



### 48.

Crear un procedimiento que devuelva el último OCT, último campo visual y última PIO de un paciente.

```sql
DROP PROCEDURE IF EXISTS sp_latest_exams;

DELIMITER $$

CREATE PROCEDURE sp_latest_exams(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT 'OCT' AS exam, o.eye, o.exam_date AS date, CONCAT('RNFL ', o.rnfl_average, ' µm') AS result
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND o.exam_date = (
          SELECT MAX(o2.exam_date)
          FROM oct_exams o2
          INNER JOIN medical_visits mv2 ON o2.visit_id = mv2.id
          WHERE mv2.clinical_history_id = ch.id)
    UNION ALL
    SELECT 'Campo visual', vf.eye, vf.exam_date, CONCAT('MD ', vf.md, ' / VFI ', vf.vfi, '%')
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND vf.exam_date = (
          SELECT MAX(vf2.exam_date)
          FROM visual_field_exams vf2
          INNER JOIN medical_visits mv2 ON vf2.visit_id = mv2.id
          WHERE mv2.clinical_history_id = ch.id)
    UNION ALL
    SELECT 'PIO', v.eye, DATE(v.measured_at), CONCAT(v.pressure, ' mmHg')
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p_patient_id
      AND v.measured_at = (
          SELECT MAX(v2.measured_at)
          FROM vw_patient_iop_history v2
          WHERE v2.patient_id = v.patient_id AND v2.eye = v.eye)
    ORDER BY exam, eye;
END $$

DELIMITER ;

CALL sp_latest_exams(1);
```



### 49.

Crear un procedimiento que registre en una sola transacción una consulta, un diagnóstico y una medición de PIO.

```sql
-- Si cualquier paso falla, el HANDLER deshace todo con ROLLBACK y relanza el error.
DROP PROCEDURE IF EXISTS sp_register_visit_with_diagnosis_iop;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_with_diagnosis_iop(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255),
    IN p_diagnosis_id INT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1)
)
BEGIN
    DECLARE v_visit_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, p_visit_date, p_reason);

    SET v_visit_id = LAST_INSERT_ID();

    INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary)
    VALUES (v_visit_id, p_diagnosis_id, p_eye, TRUE);

    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO debe registrarse para OD u OI';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (v_visit_id, p_eye, p_pressure, p_visit_date);

    COMMIT;

    SELECT v_visit_id AS visit_id;
END $$

DELIMITER ;

CALL sp_register_visit_with_diagnosis_iop(7, 3, '2026-09-29 10:00:00', 'Seguimiento de sospecha de glaucoma', 3, 'OD', 21.0);
-- Falla en el tercer paso (PIO 95 viola el CHECK y el trigger): no queda ni la consulta ni el diagnóstico.
-- CALL sp_register_visit_with_diagnosis_iop(7, 3, '2026-09-30 10:00:00', 'Prueba rollback', 3, 'OD', 95);
--   Error: La PIO debe estar entre 0 y 80 mmHg
-- SELECT COUNT(*) FROM medical_visits WHERE reason = 'Prueba rollback';  -- 0
```



### 50.

Crear un procedimiento transaccional que registre un control completo de glaucoma y ejecute `ROLLBACK` si alguna operación falla.

```sql
-- Registra consulta, PIO de ambos ojos y control; si hay progresión, actualiza el estado a EN_PROGRESION.
DROP PROCEDURE IF EXISTS sp_register_full_glaucoma_control;

DELIMITER $$

CREATE PROCEDURE sp_register_full_glaucoma_control(
    IN p_patient_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_iop_od DECIMAL(4,1),
    IN p_iop_oi DECIMAL(4,1),
    IN p_progression BOOLEAN,
    IN p_notes TEXT
)
BEGIN
    DECLARE v_history_id BIGINT;
    DECLARE v_record_id BIGINT;
    DECLARE v_visit_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT ch.id, g.id INTO v_history_id, v_record_id
    FROM clinical_histories ch
    LEFT JOIN glaucoma_records g ON g.patient_id = ch.patient_id
    WHERE ch.patient_id = p_patient_id;

    IF v_history_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene historia clínica';
    END IF;

    IF v_record_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene registro de glaucoma';
    END IF;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason, observations)
    VALUES (v_history_id, p_professional_id, p_visit_date, 'Control de glaucoma', p_notes);

    SET v_visit_id = LAST_INSERT_ID();

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (v_visit_id, 'OD', p_iop_od, p_visit_date),
           (v_visit_id, 'OI', p_iop_oi, p_visit_date);

    INSERT INTO glaucoma_controls (glaucoma_record_id, visit_id, control_date, progression_detected, notes)
    VALUES (v_record_id, v_visit_id, DATE(p_visit_date), IFNULL(p_progression, FALSE), p_notes);

    IF p_progression THEN
        UPDATE glaucoma_records
        SET clinical_status = 'EN_PROGRESION'
        WHERE id = v_record_id;
    END IF;

    COMMIT;

    SELECT v_visit_id AS visit_id, v_record_id AS glaucoma_record_id;
END $$

DELIMITER ;

CALL sp_register_full_glaucoma_control(3, 2, '2026-10-02 09:00:00', 17.0, 15.0, FALSE, 'Control estable, PIO cerca de la meta');
-- Falla en la PIO OI (-1): se deshace también la consulta ya insertada.
-- CALL sp_register_full_glaucoma_control(3, 2, '2026-10-03 09:00:00', 17.0, -1, FALSE, 'Prueba rollback');
--   Error: La PIO debe estar entre 0 y 80 mmHg
-- CALL sp_register_full_glaucoma_control(10, 2, '2026-10-03 09:00:00', 17, 16, FALSE, NULL);
--   Error: El paciente no tiene registro de glaucoma
```



# PARTE IV — 50 EJERCICIOS DE TRIGGERS

```sql
-- Preparación: no se requiere ningún ALTER TABLE ni tabla adicional.
-- El esquema real (sql/01_schema.sql) ya incluye audit_logs.old_values,
-- audit_logs.new_values, audit_logs.changed_by, patients.updated_at,
-- medical_visits.updated_at, medical_visits.is_closed, oct_exams.is_validated
-- y la tabla clinical_alerts para las notificaciones internas.
-- Cargar en orden: sql/01_schema.sql a sql/07_events.sql y luego
-- ejercicios/parte4_triggers.sql.
```




## BEFORE INSERT

### 1.

Crear un trigger que elimine espacios externos de los nombres de pacientes antes de insertarlos.

```sql
DROP TRIGGER IF EXISTS trg_patients_bi_trim_names;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_trim_names
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    SET NEW.first_name = TRIM(NEW.first_name);
    SET NEW.last_name = TRIM(NEW.last_name);
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex, email) VALUES (1, '1001001001', '  Juan  ', '  Pérez ', '1990-01-01', 'M', 'Juan.Perez@Gmail.COM');
-- PRUEBA: SELECT CONCAT('[', first_name, '][', last_name, ']') AS names FROM patients WHERE document_number = '1001001001';
-- ESPERADO: [Juan][Pérez]
```



### 2.

Convertir automáticamente el correo del paciente a minúsculas.

```sql
-- Comparte BEFORE INSERT en patients con los ejercicios 1, 3 y 4; no dependen del orden.
DROP TRIGGER IF EXISTS trg_patients_bi_lower_email;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_lower_email
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(TRIM(NEW.email));
END $$

DELIMITER ;

-- PRUEBA: SELECT email FROM patients WHERE document_number = '1001001001';
-- ESPERADO: juan.perez@gmail.com (insertado como Juan.Perez@Gmail.COM en la prueba 1)
```



### 3.

Convertir el número de documento a mayúsculas cuando contenga caracteres.

```sql
DROP TRIGGER IF EXISTS trg_patients_bi_upper_document;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_upper_document
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    IF NEW.document_number REGEXP '[A-Za-z]' THEN
        SET NEW.document_number = UPPER(NEW.document_number);
    END IF;
    SET NEW.document_number = TRIM(NEW.document_number);
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (3, 'e555abc', 'Paolo', 'Bianchi', '1987-02-02', 'M');
-- PRUEBA: SELECT document_number FROM patients WHERE first_name = 'Paolo';
-- ESPERADO: E555ABC
```



### 4.

Impedir registrar una fecha de nacimiento futura.

```sql
DROP TRIGGER IF EXISTS trg_patients_bi_birth_date;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_birth_date
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de nacimiento no puede ser futura';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (1, '1001001002', 'Futuro', 'Paciente', '2099-01-01', 'F');
-- ESPERADO: ERROR 1644 La fecha de nacimiento no puede ser futura
```



### 5.

Impedir registrar una presión intraocular negativa.

```sql
-- Choque: trg_iop_before_insert_validate (06_triggers.sql) también es BEFORE INSERT en
-- intraocular_pressures y rechaza < 0 con otro mensaje. Con PRECEDES este trigger se
-- ejecuta antes, así el usuario ve el mensaje específico de valor negativo.
DROP TRIGGER IF EXISTS trg_iop_bi_non_negative;

DELIMITER $$

CREATE TRIGGER trg_iop_bi_non_negative
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
PRECEDES trg_iop_before_insert_validate
BEGIN
    IF NEW.pressure < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La presión intraocular no puede ser negativa';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'OD', -2, 'GOLDMANN', '2026-07-20 09:00:00');
-- ESPERADO: ERROR 1644 La presión intraocular no puede ser negativa
-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'OD', 16.5, 'GOLDMANN', '2026-07-20 09:05:00');
-- ESPERADO: 1 fila insertada
```



### 6.

Impedir registrar una PIO superior a un límite definido para datos plausibles.

```sql
-- Límite académico: 60 mmHg (el CHECK de la tabla permite hasta 80).
-- Choque: tercer BEFORE INSERT en intraocular_pressures; se ejecuta después del 06 (orden de creación).
DROP TRIGGER IF EXISTS trg_iop_bi_plausible_limit;

DELIMITER $$

CREATE TRIGGER trg_iop_bi_plausible_limit
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.pressure > 60 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO supera el límite plausible de 60 mmHg';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'OD', 65, 'GOLDMANN', '2026-07-20 09:10:00');
-- ESPERADO: ERROR 1644 La PIO supera el límite plausible de 60 mmHg
```



### 7.

Validar que el campo `eye` solo admita `OD` u `OI`.

```sql
-- Observación: eye es ENUM('OD','OI'). Con el sql_mode estricto (por defecto en MariaDB/XAMPP)
-- un valor como 'AO' se rechaza ANTES de ejecutar el trigger (Error 1265 Data truncated).
-- Si el modo no es estricto, MariaDB convierte el valor inválido en '' y entonces es el
-- trigger el que lo detecta. El trigger protege la regla aunque cambie el sql_mode.
-- Choque: cuarto BEFORE INSERT en intraocular_pressures.
DROP TRIGGER IF EXISTS trg_iop_bi_valid_eye;

DELIMITER $$

CREATE TRIGGER trg_iop_bi_valid_eye
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.eye IS NULL OR NEW.eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'AO', 15, 'GOLDMANN', '2026-07-20 09:15:00');
-- ESPERADO: ERROR 1265 Data truncated for column 'eye' (modo estricto)
-- PRUEBA: SET SESSION sql_mode = ''; INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'AO', 15, 'GOLDMANN', '2026-07-20 09:15:00');
-- ESPERADO: ERROR 1644 El ojo debe ser OD u OI (modo no estricto)
```



### 8.

Impedir que un tratamiento tenga fecha final anterior a la inicial.

```sql
DROP TRIGGER IF EXISTS trg_treatments_bi_dates;

DELIMITER $$

CREATE TRIGGER trg_treatments_bi_dates
BEFORE INSERT ON treatments
FOR EACH ROW
BEGIN
    IF NEW.end_date IS NOT NULL AND NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final del tratamiento no puede ser anterior a la inicial';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date, end_date, status) VALUES (4, 2, 'AO', '1 gota', 'Cada 12 horas', '2026-07-20', '2026-01-01', 'FINALIZADO');
-- ESPERADO: ERROR 1644 La fecha final del tratamiento no puede ser anterior a la inicial
```



### 9.

Validar que el VFI de un campo visual esté entre 0 y 100.

```sql
-- vfi es TINYINT (-128..127): un valor fuera de ese rango lo rechaza el tipo antes del trigger.
DROP TRIGGER IF EXISTS trg_visual_field_bi_vfi;

DELIMITER $$

CREATE TRIGGER trg_visual_field_bi_vfi
BEFORE INSERT ON visual_field_exams
FOR EACH ROW
BEGIN
    IF NEW.vfi < 0 OR NEW.vfi > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El VFI debe estar entre 0 y 100';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, exam_date) VALUES (4, 'OD', -5, 4, 110, '2026-07-20');
-- ESPERADO: ERROR 1644 El VFI debe estar entre 0 y 100
```



### 10.

Validar que la paquimetría sea mayor que cero.

```sql
DROP TRIGGER IF EXISTS trg_pachymetry_bi_positive;

DELIMITER $$

CREATE TRIGGER trg_pachymetry_bi_positive
BEFORE INSERT ON pachymetry_exams
FOR EACH ROW
BEGIN
    IF NEW.thickness_um <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espesor corneal debe ser mayor que cero';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date) VALUES (4, 'OD', 0, '2026-07-20');
-- ESPERADO: ERROR 1644 El espesor corneal debe ser mayor que cero
```



## AFTER INSERT

### 11.

Registrar en auditoría la creación de un nuevo paciente.

```sql
-- Choque: el ejercicio 50 crea otro AFTER INSERT en patients (auditoría completa). Ambos
-- escriben en audit_logs; en un sistema real se dejaría solo uno.
DROP TRIGGER IF EXISTS trg_patients_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_patients_ai_audit
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('patients', NEW.id, 'INSERT',
            JSON_OBJECT('document_number', NEW.document_number, 'first_name', NEW.first_name,
                        'last_name', NEW.last_name, 'birth_date', NEW.birth_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (1, '1001001003', 'Marta', 'León', '1970-03-03', 'F');
-- PRUEBA: SELECT action, new_values FROM audit_logs WHERE table_name = 'patients' AND action = 'INSERT' ORDER BY id DESC LIMIT 1;
-- ESPERADO: INSERT con los datos de Marta León
```



### 12.

Registrar en auditoría la creación de una historia clínica.

```sql
DROP TRIGGER IF EXISTS trg_clinical_histories_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_clinical_histories_ai_audit
AFTER INSERT ON clinical_histories
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('clinical_histories', NEW.id, 'INSERT',
            JSON_OBJECT('patient_id', NEW.patient_id, 'history_number', NEW.history_number, 'status', NEW.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO clinical_histories (patient_id, history_number) VALUES (20, 'HC-000020');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'clinical_histories';
-- ESPERADO: 1 fila con history_number HC-000020
```



### 13.

Registrar automáticamente en auditoría cada nueva consulta.

```sql
DROP TRIGGER IF EXISTS trg_medical_visits_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_ai_audit
AFTER INSERT ON medical_visits
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('medical_visits', NEW.id, 'INSERT',
            JSON_OBJECT('clinical_history_id', NEW.clinical_history_id, 'professional_id', NEW.professional_id,
                        'visit_date', NEW.visit_date, 'reason', NEW.reason),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason) VALUES (20, 1, '2026-10-01 08:00:00', 'Primera consulta');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'medical_visits';
-- ESPERADO: 1 fila con record_id 31
```



### 14.

Registrar cada nuevo diagnóstico asociado a una consulta.

```sql
-- visit_diagnoses tiene PK compuesta: record_id guarda visit_id y el JSON el diagnosis_id.
DROP TRIGGER IF EXISTS trg_visit_diagnoses_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_visit_diagnoses_ai_audit
AFTER INSERT ON visit_diagnoses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('visit_diagnoses', NEW.visit_id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'diagnosis_id', NEW.diagnosis_id,
                        'eye', NEW.eye, 'is_primary', NEW.is_primary),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary) VALUES (31, 3, 'AO', TRUE);
-- PRUEBA: SELECT new_values FROM audit_logs WHERE table_name = 'visit_diagnoses';
-- ESPERADO: {"visit_id": 31, "diagnosis_id": 3, "eye": "AO", "is_primary": 1}
```



### 15.

Registrar cada nueva medición de presión intraocular.

```sql
-- Choque: además existe trg_iop_after_insert_alert (06_triggers.sql) y el ejercicio 20,
-- ambos AFTER INSERT en intraocular_pressures; cada uno escribe en una tabla distinta.
DROP TRIGGER IF EXISTS trg_iop_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_iop_ai_audit
AFTER INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('intraocular_pressures', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'eye', NEW.eye, 'pressure', NEW.pressure,
                        'method', NEW.method, 'measured_at', NEW.measured_at),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (31, 'OD', 17, 'GOLDMANN', '2026-10-01 08:10:00');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'intraocular_pressures' AND record_id = (SELECT MAX(id) FROM intraocular_pressures);
-- ESPERADO: 1 fila con pressure 17.0
```



### 16.

Registrar cada nuevo tratamiento.

```sql
DROP TRIGGER IF EXISTS trg_treatments_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_treatments_ai_audit
AFTER INSERT ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('treatments', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'medication_id', NEW.medication_id, 'eye', NEW.eye,
                        'frequency', NEW.frequency, 'start_date', NEW.start_date, 'status', NEW.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date) VALUES (31, 1, 'AO', '1 gota', 'Cada noche', '2026-10-01');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'treatments' AND action = 'INSERT';
-- ESPERADO: 1 fila con record_id 16
```



### 17.

Registrar cada nuevo procedimiento.

```sql
DROP TRIGGER IF EXISTS trg_procedures_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_procedures_ai_audit
AFTER INSERT ON procedures
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('procedures', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'procedure_type_id', NEW.procedure_type_id,
                        'eye', NEW.eye, 'performed_at', NEW.performed_at),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO procedures (visit_id, procedure_type_id, eye, performed_at, notes) VALUES (18, 2, 'AO', '2026-07-10', 'SLT bilateral');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'procedures';
-- ESPERADO: 1 fila con record_id 8
```



### 18.

Registrar en auditoría cada nuevo estudio OCT.

```sql
DROP TRIGGER IF EXISTS trg_oct_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_oct_ai_audit
AFTER INSERT ON oct_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('oct_exams', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'eye', NEW.eye, 'rnfl_average', NEW.rnfl_average,
                        'exam_date', NEW.exam_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO oct_exams (visit_id, eye, rnfl_average, cup_disc_ratio, exam_date) VALUES (31, 'OD', 93.0, 0.45, '2026-10-01');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'oct_exams';
-- ESPERADO: 1 fila con record_id 21
```



### 19.

Registrar cada campo visual creado.

```sql
DROP TRIGGER IF EXISTS trg_visual_field_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_visual_field_ai_audit
AFTER INSERT ON visual_field_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('visual_field_exams', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'eye', NEW.eye, 'md', NEW.md, 'psd', NEW.psd,
                        'vfi', NEW.vfi, 'exam_date', NEW.exam_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, exam_date) VALUES (31, 'OD', -0.9, 1.5, 99, '2026-10-01');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'visual_field_exams';
-- ESPERADO: 1 fila con record_id 21
```



### 20.

Crear una notificación interna cuando se registre una PIO mayor que un valor determinado.

```sql
-- Umbral: 30 mmHg (PIO muy elevada), independiente de la presión objetivo del paciente.
-- Choque: tercer AFTER INSERT en intraocular_pressures (ver ejercicio 15).
DROP TRIGGER IF EXISTS trg_iop_ai_critical_alert;

DELIMITER $$

CREATE TRIGGER trg_iop_ai_critical_alert
AFTER INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.pressure > 30 THEN
        INSERT INTO clinical_alerts (patient_id, alert_type, message)
        SELECT ch.patient_id,
               'PIO_CRITICA',
               CONCAT('PIO ', NEW.eye, ' de ', NEW.pressure, ' mmHg, mayor que el umbral de 30 mmHg')
        FROM medical_visits mv
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE mv.id = NEW.visit_id;
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (16, 'OD', 32, 'GOLDMANN', '2026-08-04 15:00:00');
-- PRUEBA: SELECT patient_id, alert_type, message FROM clinical_alerts WHERE alert_type = 'PIO_CRITICA';
-- ESPERADO: alerta PIO_CRITICA para el paciente 5 (y también una PIO_ALTA del trigger del 06)
```



## BEFORE UPDATE

### 21.

Actualizar automáticamente `updated_at` antes de modificar un paciente.

```sql
-- updated_at ya tiene ON UPDATE CURRENT_TIMESTAMP; el trigger lo hace explícito y además
-- funciona si alguien quita esa cláusula de la columna.
DROP TRIGGER IF EXISTS trg_patients_bu_updated_at;

DELIMITER $$

CREATE TRIGGER trg_patients_bu_updated_at
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET updated_at = '2000-01-01', phone = '3001112233' WHERE id = 3;
-- PRUEBA: SELECT updated_at > '2025-01-01' AS updated FROM patients WHERE id = 3;
-- ESPERADO: 1 (el trigger reemplaza la fecha enviada por NOW())
```



### 22.

Actualizar `updated_at` antes de modificar una consulta.

```sql
DROP TRIGGER IF EXISTS trg_medical_visits_bu_updated_at;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_updated_at
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET updated_at = '2000-01-01', plan = 'SLT bilateral programada' WHERE id = 14;
-- PRUEBA: SELECT updated_at > '2025-01-01' AS updated FROM medical_visits WHERE id = 14;
-- ESPERADO: 1
```



### 23.

Impedir modificar el número de documento una vez creada la historia clínica.

```sql
-- Comparte BEFORE UPDATE en patients con el ejercicio 21 (independientes).
DROP TRIGGER IF EXISTS trg_patients_bu_lock_document;

DELIMITER $$

CREATE TRIGGER trg_patients_bu_lock_document
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NEW.document_number <> OLD.document_number
       AND EXISTS (SELECT 1 FROM clinical_histories WHERE patient_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede cambiar el documento de un paciente con historia clínica';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET document_number = '9999999999' WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede cambiar el documento de un paciente con historia clínica
-- PRUEBA: UPDATE patients SET document_number = '1001001009' WHERE document_number = '1001001003';
-- ESPERADO: 1 fila modificada (Marta León no tiene historia)
```



### 24.

Impedir asignar una fecha de consulta futura no permitida.

```sql
-- Regla académica: al modificar, la fecha no puede quedar en el futuro.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_no_future;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_no_future
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    IF NEW.visit_date > NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de la consulta no puede ser futura';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET visit_date = '2099-01-01 08:00:00' WHERE id = 14;
-- ESPERADO: ERROR 1644 La fecha de la consulta no puede ser futura
```



### 25.

Validar que una nueva presión objetivo sea positiva.

```sql
DROP TRIGGER IF EXISTS trg_glaucoma_records_bu_target;

DELIMITER $$

CREATE TRIGGER trg_glaucoma_records_bu_target
BEFORE UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
    IF NEW.target_pressure IS NULL OR NEW.target_pressure <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La presión objetivo debe ser positiva';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE glaucoma_records SET target_pressure = 0 WHERE id = 1;
-- ESPERADO: ERROR 1644 La presión objetivo debe ser positiva
```



### 26.

Impedir establecer una fecha final de tratamiento anterior a su inicio.

```sql
DROP TRIGGER IF EXISTS trg_treatments_bu_dates;

DELIMITER $$

CREATE TRIGGER trg_treatments_bu_dates
BEFORE UPDATE ON treatments
FOR EACH ROW
BEGIN
    IF NEW.end_date IS NOT NULL AND NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final del tratamiento no puede ser anterior a su inicio';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE treatments SET end_date = '2020-01-01' WHERE id = 2;
-- ESPERADO: ERROR 1644 La fecha final del tratamiento no puede ser anterior a su inicio
```



### 27.

Evitar modificar un examen OCT que haya sido marcado como validado.

```sql
DROP TRIGGER IF EXISTS trg_oct_bu_lock_validated;

DELIMITER $$

CREATE TRIGGER trg_oct_bu_lock_validated
BEFORE UPDATE ON oct_exams
FOR EACH ROW
BEGIN
    IF OLD.is_validated = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede modificar un OCT validado';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE oct_exams SET interpretation = 'Cambio' WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede modificar un OCT validado
-- PRUEBA: UPDATE oct_exams SET is_validated = TRUE WHERE id = 3;
-- ESPERADO: 1 fila modificada (el OCT 3 no estaba validado)
```



### 28.

Evitar modificar una consulta marcada como cerrada.

```sql
-- Se permite solo reabrirla (is_closed de TRUE a FALSE) para corregirla de forma explícita.
-- Choque: tercer BEFORE UPDATE en medical_visits (ejercicios 22 y 24); independientes.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_lock_closed;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_lock_closed
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    IF OLD.is_closed = TRUE AND NEW.is_closed = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta está cerrada y no se puede modificar';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET reason = 'Cambio' WHERE id = 1;
-- ESPERADO: ERROR 1644 La consulta está cerrada y no se puede modificar
```



### 29.

Validar valores del campo visual antes de una actualización.

```sql
-- Rangos: VFI 0–100, PSD >= 0 y MD entre -35 y 5 dB.
DROP TRIGGER IF EXISTS trg_visual_field_bu_validate;

DELIMITER $$

CREATE TRIGGER trg_visual_field_bu_validate
BEFORE UPDATE ON visual_field_exams
FOR EACH ROW
BEGIN
    IF NEW.vfi < 0 OR NEW.vfi > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El VFI debe estar entre 0 y 100';
    END IF;
    IF NEW.psd < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El PSD no puede ser negativo';
    END IF;
    IF NEW.md < -35 OR NEW.md > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El MD debe estar entre -35 y 5 dB';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE visual_field_exams SET md = -40 WHERE id = 1;
-- ESPERADO: ERROR 1644 El MD debe estar entre -35 y 5 dB
```



### 30.

Normalizar observaciones eliminando espacios innecesarios antes de actualizar.

```sql
-- Quita espacios externos y reduce espacios repetidos a uno. Cuarto BEFORE UPDATE en medical_visits.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_clean_observations;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_clean_observations
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    IF NEW.observations IS NOT NULL THEN
        SET NEW.observations = TRIM(REGEXP_REPLACE(NEW.observations, '[[:space:]]{2,}', ' '));
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET observations = '   Paciente   refiere   mejoría   ' WHERE id = 14;
-- PRUEBA: SELECT CONCAT('[', observations, ']') FROM medical_visits WHERE id = 14;
-- ESPERADO: [Paciente refiere mejoría]
```



## AFTER UPDATE

### 31.

Registrar cambios de datos personales del paciente.

```sql
-- Solo registra si cambió algún dato personal. Choque: AFTER UPDATE en patients junto con
-- trg_patients_after_update_audit (06), el ejercicio 32 y el 50.
DROP TRIGGER IF EXISTS trg_patients_au_personal_data;

DELIMITER $$

CREATE TRIGGER trg_patients_au_personal_data
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NOT (OLD.first_name <=> NEW.first_name AND OLD.last_name <=> NEW.last_name
            AND OLD.birth_date <=> NEW.birth_date AND OLD.sex <=> NEW.sex
            AND OLD.address <=> NEW.address AND OLD.city_id <=> NEW.city_id
            AND OLD.phone <=> NEW.phone) THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('patients', NEW.id, 'UPDATE',
                JSON_OBJECT('first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                            'sex', OLD.sex, 'address', OLD.address, 'city_id', OLD.city_id, 'phone', OLD.phone),
                JSON_OBJECT('first_name', NEW.first_name, 'last_name', NEW.last_name, 'birth_date', NEW.birth_date,
                            'sex', NEW.sex, 'address', NEW.address, 'city_id', NEW.city_id, 'phone', NEW.phone),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET address = 'Cra 30 # 50-10' WHERE id = 2;
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.address') AS old_address, JSON_VALUE(new_values, '$.address') AS new_address FROM audit_logs WHERE table_name = 'patients' AND record_id = 2 AND JSON_EXISTS(old_values, '$.sex') AND NOT JSON_EXISTS(new_values, '$.audit');
-- ESPERADO: Calle 56 # 31-22 → Cra 30 # 50-10
```



### 32.

Guardar valor anterior y nuevo del correo del paciente.

```sql
DROP TRIGGER IF EXISTS trg_patients_au_email;

DELIMITER $$

CREATE TRIGGER trg_patients_au_email
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NOT (OLD.email <=> NEW.email) THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('patients', NEW.id, 'UPDATE',
                JSON_OBJECT('email', OLD.email),
                JSON_OBJECT('email', NEW.email),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET email = 'mafe.rueda@gmail.com' WHERE id = 2;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE record_id = 2 AND JSON_LENGTH(old_values) = 1;
-- ESPERADO: {"email": "mafe.rueda@hotmail.com"} → {"email": "mafe.rueda@gmail.com"}
```



### 33.

Registrar cambios en la presión objetivo.

```sql
DROP TRIGGER IF EXISTS trg_glaucoma_records_au_target;

DELIMITER $$

CREATE TRIGGER trg_glaucoma_records_au_target
AFTER UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
    IF OLD.target_pressure <> NEW.target_pressure THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('glaucoma_records', NEW.id, 'UPDATE',
                JSON_OBJECT('target_pressure', OLD.target_pressure),
                JSON_OBJECT('target_pressure', NEW.target_pressure),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE glaucoma_records SET target_pressure = 15 WHERE id = 2;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'glaucoma_records' AND JSON_EXISTS(old_values, '$.target_pressure');
-- ESPERADO: 18.0 → 15.0
```



### 34.

Auditar cambios en el estado del glaucoma.

```sql
-- Comparte AFTER UPDATE en glaucoma_records con el ejercicio 33 (independientes).
DROP TRIGGER IF EXISTS trg_glaucoma_records_au_status;

DELIMITER $$

CREATE TRIGGER trg_glaucoma_records_au_status
AFTER UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
    IF OLD.clinical_status <> NEW.clinical_status THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('glaucoma_records', NEW.id, 'UPDATE',
                JSON_OBJECT('clinical_status', OLD.clinical_status),
                JSON_OBJECT('clinical_status', NEW.clinical_status),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE glaucoma_records SET clinical_status = 'EN_PROGRESION' WHERE id = 2;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'glaucoma_records' AND JSON_EXISTS(old_values, '$.clinical_status');
-- ESPERADO: NO_CONTROLADO → EN_PROGRESION
```



### 35.

Registrar cambios en tratamientos.

```sql
DROP TRIGGER IF EXISTS trg_treatments_au_audit;

DELIMITER $$

CREATE TRIGGER trg_treatments_au_audit
AFTER UPDATE ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('treatments', NEW.id, 'UPDATE',
            JSON_OBJECT('medication_id', OLD.medication_id, 'dosage', OLD.dosage, 'frequency', OLD.frequency,
                        'end_date', OLD.end_date, 'status', OLD.status),
            JSON_OBJECT('medication_id', NEW.medication_id, 'dosage', NEW.dosage, 'frequency', NEW.frequency,
                        'end_date', NEW.end_date, 'status', NEW.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: UPDATE treatments SET frequency = 'Cada 24 horas' WHERE id = 3;
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.frequency'), JSON_VALUE(new_values, '$.frequency') FROM audit_logs WHERE table_name = 'treatments' AND action = 'UPDATE';
-- ESPERADO: Cada 12 horas → Cada 24 horas
```



### 36.

Registrar cambios en diagnósticos.

```sql
DROP TRIGGER IF EXISTS trg_visit_diagnoses_au_audit;

DELIMITER $$

CREATE TRIGGER trg_visit_diagnoses_au_audit
AFTER UPDATE ON visit_diagnoses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('visit_diagnoses', NEW.visit_id, 'UPDATE',
            JSON_OBJECT('diagnosis_id', OLD.diagnosis_id, 'eye', OLD.eye, 'is_primary', OLD.is_primary),
            JSON_OBJECT('diagnosis_id', NEW.diagnosis_id, 'eye', NEW.eye, 'is_primary', NEW.is_primary),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: UPDATE visit_diagnoses SET eye = 'AO' WHERE visit_id = 1 AND diagnosis_id = 5;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'visit_diagnoses' AND action = 'UPDATE';
-- ESPERADO: eye OI → AO
```



### 37.

Registrar cambios de interpretación de OCT.

```sql
DROP TRIGGER IF EXISTS trg_oct_au_interpretation;

DELIMITER $$

CREATE TRIGGER trg_oct_au_interpretation
AFTER UPDATE ON oct_exams
FOR EACH ROW
BEGIN
    IF NOT (OLD.interpretation <=> NEW.interpretation) THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('oct_exams', NEW.id, 'UPDATE',
                JSON_OBJECT('interpretation', OLD.interpretation),
                JSON_OBJECT('interpretation', NEW.interpretation),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE oct_exams SET interpretation = 'Adelgazamiento difuso de la RNFL' WHERE id = 4;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'oct_exams' AND action = 'UPDATE';
-- ESPERADO: 1 fila con la interpretación anterior y la nueva (el OCT 4 no está validado)
```



### 38.

Registrar modificaciones de campos visuales.

```sql
DROP TRIGGER IF EXISTS trg_visual_field_au_audit;

DELIMITER $$

CREATE TRIGGER trg_visual_field_au_audit
AFTER UPDATE ON visual_field_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('visual_field_exams', NEW.id, 'UPDATE',
            JSON_OBJECT('md', OLD.md, 'psd', OLD.psd, 'vfi', OLD.vfi, 'reliability', OLD.reliability,
                        'interpretation', OLD.interpretation),
            JSON_OBJECT('md', NEW.md, 'psd', NEW.psd, 'vfi', NEW.vfi, 'reliability', NEW.reliability,
                        'interpretation', NEW.interpretation),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: UPDATE visual_field_exams SET reliability = 'MEDIA' WHERE id = 2;
-- PRUEBA: SELECT record_id, JSON_VALUE(new_values, '$.reliability') FROM audit_logs WHERE table_name = 'visual_field_exams' AND action = 'UPDATE';
-- ESPERADO: record_id 2, MEDIA
```



### 39.

Generar una alerta cuando una PIO sea actualizada a un valor superior al objetivo.

```sql
DROP TRIGGER IF EXISTS trg_iop_au_target_alert;

DELIMITER $$

CREATE TRIGGER trg_iop_au_target_alert
AFTER UPDATE ON intraocular_pressures
FOR EACH ROW
BEGIN
    DECLARE v_patient_id BIGINT;
    DECLARE v_target DECIMAL(4,1);

    SELECT ch.patient_id, g.target_pressure
      INTO v_patient_id, v_target
    FROM medical_visits mv
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    INNER JOIN glaucoma_records g ON g.patient_id = ch.patient_id
    WHERE mv.id = NEW.visit_id;

    IF v_target IS NOT NULL AND NEW.pressure > v_target AND OLD.pressure <> NEW.pressure THEN
        INSERT INTO clinical_alerts (patient_id, alert_type, message)
        VALUES (v_patient_id, 'PIO_CORREGIDA_ALTA',
                CONCAT('PIO ', NEW.eye, ' corregida de ', OLD.pressure, ' a ', NEW.pressure,
                       ' mmHg, supera el objetivo de ', v_target, ' mmHg'));
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE intraocular_pressures SET pressure = 21 WHERE id = 7;
-- PRUEBA: SELECT patient_id, message FROM clinical_alerts WHERE alert_type = 'PIO_CORREGIDA_ALTA';
-- ESPERADO: alerta para el paciente 1 (16.0 → 21.0, objetivo 18.0)
```



### 40.

Registrar cuándo un tratamiento cambia de activo a finalizado.

```sql
-- Choque: segundo AFTER UPDATE en treatments (ejercicio 35); este solo actúa en la transición.
DROP TRIGGER IF EXISTS trg_treatments_au_finished;

DELIMITER $$

CREATE TRIGGER trg_treatments_au_finished
AFTER UPDATE ON treatments
FOR EACH ROW
BEGIN
    IF OLD.status = 'ACTIVO' AND NEW.status = 'FINALIZADO' THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('treatments', NEW.id, 'UPDATE',
                JSON_OBJECT('status', OLD.status, 'end_date', OLD.end_date),
                JSON_OBJECT('status', NEW.status, 'end_date', NEW.end_date, 'event', 'TRATAMIENTO_FINALIZADO'),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE treatments SET status = 'FINALIZADO', end_date = '2026-02-12' WHERE id = 2;
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE JSON_VALUE(new_values, '$.event') = 'TRATAMIENTO_FINALIZADO';
-- ESPERADO: record_id 2
```



## DELETE y auditoría

### 41.

Guardar una copia de un paciente antes de eliminarlo.

```sql
DROP TRIGGER IF EXISTS trg_patients_bd_backup;

DELIMITER $$

CREATE TRIGGER trg_patients_bd_backup
BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('patients', OLD.id, 'DELETE',
            JSON_OBJECT('document_type_id', OLD.document_type_id, 'document_number', OLD.document_number,
                        'first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                        'sex', OLD.sex, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address,
                        'city_id', OLD.city_id, 'created_at', OLD.created_at),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM patients WHERE first_name = 'Paolo';
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.document_number') FROM audit_logs WHERE table_name = 'patients' AND action = 'DELETE' AND JSON_EXISTS(old_values, '$.created_at');
-- ESPERADO: E555ABC (copia completa del paciente borrado)
```



### 42.

Guardar una copia de una consulta eliminada.

```sql
DROP TRIGGER IF EXISTS trg_medical_visits_bd_backup;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bd_backup
BEFORE DELETE ON medical_visits
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('medical_visits', OLD.id, 'DELETE',
            JSON_OBJECT('clinical_history_id', OLD.clinical_history_id, 'professional_id', OLD.professional_id,
                        'visit_date', OLD.visit_date, 'reason', OLD.reason, 'assessment', OLD.assessment,
                        'plan', OLD.plan, 'observations', OLD.observations, 'is_closed', OLD.is_closed),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason) VALUES (19, 3, '2026-09-30 10:00:00', 'Consulta registrada por error');
-- PRUEBA: DELETE FROM medical_visits WHERE reason = 'Consulta registrada por error';
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.reason') FROM audit_logs WHERE table_name = 'medical_visits' AND action = 'DELETE';
-- ESPERADO: Consulta registrada por error
```



### 43.

Guardar un histórico de un tratamiento eliminado.

```sql
DROP TRIGGER IF EXISTS trg_treatments_ad_history;

DELIMITER $$

CREATE TRIGGER trg_treatments_ad_history
AFTER DELETE ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('treatments', OLD.id, 'DELETE',
            JSON_OBJECT('visit_id', OLD.visit_id, 'medication_id', OLD.medication_id, 'eye', OLD.eye,
                        'dosage', OLD.dosage, 'frequency', OLD.frequency, 'start_date', OLD.start_date,
                        'end_date', OLD.end_date, 'status', OLD.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM treatments WHERE id = 15;
-- PRUEBA: SELECT old_values FROM audit_logs WHERE table_name = 'treatments' AND action = 'DELETE';
-- ESPERADO: copia del tratamiento 15 (Timolol, FINALIZADO)
```



### 44.

Registrar en auditoría la eliminación de un diagnóstico.

```sql
DROP TRIGGER IF EXISTS trg_visit_diagnoses_ad_audit;

DELIMITER $$

CREATE TRIGGER trg_visit_diagnoses_ad_audit
AFTER DELETE ON visit_diagnoses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('visit_diagnoses', OLD.visit_id, 'DELETE',
            JSON_OBJECT('visit_id', OLD.visit_id, 'diagnosis_id', OLD.diagnosis_id,
                        'eye', OLD.eye, 'is_primary', OLD.is_primary),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM visit_diagnoses WHERE visit_id = 1 AND diagnosis_id = 10;
-- PRUEBA: SELECT old_values FROM audit_logs WHERE table_name = 'visit_diagnoses' AND action = 'DELETE';
-- ESPERADO: {"visit_id": 1, "diagnosis_id": 10, "eye": null, "is_primary": 0}
```



### 45.

Impedir eliminar pacientes que tengan historia clínica.

```sql
-- Choque: segundo BEFORE DELETE en patients (ejercicio 41). Si este falla, MariaDB revierte
-- toda la sentencia, incluida la copia que el 41 ya había insertado en audit_logs.
DROP TRIGGER IF EXISTS trg_patients_bd_has_history;

DELIMITER $$

CREATE TRIGGER trg_patients_bd_has_history
BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM clinical_histories WHERE patient_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un paciente con historia clínica';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM patients WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede eliminar un paciente con historia clínica
```



### 46.

Impedir eliminar profesionales con consultas registradas.

```sql
DROP TRIGGER IF EXISTS trg_professionals_bd_has_visits;

DELIMITER $$

CREATE TRIGGER trg_professionals_bd_has_visits
BEFORE DELETE ON healthcare_professionals
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM medical_visits WHERE professional_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un profesional con consultas registradas';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM healthcare_professionals WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede eliminar un profesional con consultas registradas
-- PRUEBA: DELETE FROM healthcare_professionals WHERE id = 5;
-- ESPERADO: 1 fila eliminada (Valentina Ortiz no tiene consultas)
```



### 47.

Impedir eliminar medicamentos actualmente utilizados en tratamientos activos.

```sql
-- La FK ya impide borrar un medicamento con cualquier tratamiento; el trigger da un mensaje claro
-- para el caso de tratamientos activos.
DROP TRIGGER IF EXISTS trg_medications_bd_active_use;

DELIMITER $$

CREATE TRIGGER trg_medications_bd_active_use
BEFORE DELETE ON medications
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM treatments WHERE medication_id = OLD.id AND status = 'ACTIVO') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un medicamento con tratamientos activos';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM medications WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede eliminar un medicamento con tratamientos activos
-- PRUEBA: DELETE FROM medications WHERE id = 8;
-- ESPERADO: 1 fila eliminada (Pilocarpina no se usa)
```



### 48.

Registrar automáticamente la eliminación de un examen OCT.

```sql
DROP TRIGGER IF EXISTS trg_oct_ad_audit;

DELIMITER $$

CREATE TRIGGER trg_oct_ad_audit
AFTER DELETE ON oct_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('oct_exams', OLD.id, 'DELETE',
            JSON_OBJECT('visit_id', OLD.visit_id, 'eye', OLD.eye, 'rnfl_average', OLD.rnfl_average,
                        'cup_disc_ratio', OLD.cup_disc_ratio, 'interpretation', OLD.interpretation,
                        'is_validated', OLD.is_validated, 'exam_date', OLD.exam_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM oct_exams WHERE id = 20;
-- PRUEBA: SELECT record_id, action FROM audit_logs WHERE table_name = 'oct_exams' AND action = 'DELETE';
-- ESPERADO: record_id 20, DELETE
```



### 49.

Registrar quién eliminó un documento clínico.

```sql
-- CURRENT_USER() = cuenta con la que se autenticó; USER() = usuario y host desde donde se conectó.
DROP TRIGGER IF EXISTS trg_clinical_documents_ad_who;

DELIMITER $$

CREATE TRIGGER trg_clinical_documents_ad_who
AFTER DELETE ON clinical_documents
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('clinical_documents', OLD.id, 'DELETE',
            JSON_OBJECT('clinical_history_id', OLD.clinical_history_id, 'document_kind', OLD.document_kind,
                        'file_name', OLD.file_name, 'file_path', OLD.file_path, 'deleted_from', USER()),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM clinical_documents WHERE id = 7;
-- PRUEBA: SELECT changed_by, JSON_VALUE(old_values, '$.file_name') FROM audit_logs WHERE table_name = 'clinical_documents';
-- ESPERADO: root@localhost, epicrisis_facoemulsificacion.pdf
```



### 50.

Implementar un esquema completo de auditoría mediante triggers para `INSERT`, `UPDATE` y `DELETE` sobre la tabla `patients`.

```sql
-- Tres triggers que guardan la fila completa (antes/después) en JSON.
-- Choques documentados: AFTER INSERT con el ejercicio 11; AFTER UPDATE con el 06, el 31 y el 32.
-- Para AFTER DELETE es el único. En producción se dejaría solo este esquema y se quitarían los otros.
DROP TRIGGER IF EXISTS trg_patients_ai_full_audit;
DROP TRIGGER IF EXISTS trg_patients_au_full_audit;
DROP TRIGGER IF EXISTS trg_patients_ad_full_audit;

DELIMITER $$

CREATE TRIGGER trg_patients_ai_full_audit
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('patients', NEW.id, 'INSERT',
            JSON_OBJECT('document_type_id', NEW.document_type_id, 'document_number', NEW.document_number,
                        'first_name', NEW.first_name, 'last_name', NEW.last_name, 'birth_date', NEW.birth_date,
                        'sex', NEW.sex, 'email', NEW.email, 'phone', NEW.phone, 'address', NEW.address,
                        'city_id', NEW.city_id, 'audit', 'FULL'),
            CURRENT_USER());
END $$

CREATE TRIGGER trg_patients_au_full_audit
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('patients', NEW.id, 'UPDATE',
            JSON_OBJECT('document_type_id', OLD.document_type_id, 'document_number', OLD.document_number,
                        'first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                        'sex', OLD.sex, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address,
                        'city_id', OLD.city_id),
            JSON_OBJECT('document_type_id', NEW.document_type_id, 'document_number', NEW.document_number,
                        'first_name', NEW.first_name, 'last_name', NEW.last_name, 'birth_date', NEW.birth_date,
                        'sex', NEW.sex, 'email', NEW.email, 'phone', NEW.phone, 'address', NEW.address,
                        'city_id', NEW.city_id, 'audit', 'FULL'),
            CURRENT_USER());
END $$

CREATE TRIGGER trg_patients_ad_full_audit
AFTER DELETE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('patients', OLD.id, 'DELETE',
            JSON_OBJECT('document_type_id', OLD.document_type_id, 'document_number', OLD.document_number,
                        'first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                        'sex', OLD.sex, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address,
                        'city_id', OLD.city_id),
            JSON_OBJECT('audit', 'FULL'),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (1, '1001001010', 'Prueba', 'Auditoría', '1999-09-09', 'M');
-- PRUEBA: UPDATE patients SET phone = '3110000000' WHERE document_number = '1001001010';
-- PRUEBA: DELETE FROM patients WHERE document_number = '1001001010';
-- PRUEBA: SELECT action, COUNT(*) FROM audit_logs WHERE table_name = 'patients' AND JSON_VALUE(new_values, '$.audit') = 'FULL' AND record_id = (SELECT MAX(record_id) FROM audit_logs WHERE table_name = 'patients') GROUP BY action;
-- ESPERADO: INSERT 1, UPDATE 1, DELETE 1
```



# PARTE V — 50 EJERCICIOS DE FUNCIONES ALMACENADAS

## Funciones básicas

### 1.

Crear una función que calcule la edad de un paciente a partir de su fecha de nacimiento.

```sql
DROP FUNCTION IF EXISTS fn_age_from_birth_date;

DELIMITER $$

CREATE FUNCTION fn_age_from_birth_date(
    p_birth_date DATE
)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
END $$

DELIMITER ;

SELECT first_name, birth_date, fn_age_from_birth_date(birth_date) AS age FROM patients LIMIT 3;
```



### 2.

Crear una función que reciba nombres y apellidos y retorne el nombre completo.

```sql
DROP FUNCTION IF EXISTS fn_full_name;

DELIMITER $$

CREATE FUNCTION fn_full_name(
    p_first_name VARCHAR(100),
    p_last_name VARCHAR(100)
)
RETURNS VARCHAR(201)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT_WS(' ', NULLIF(TRIM(p_first_name), ''), NULLIF(TRIM(p_last_name), ''));
END $$

DELIMITER ;

SELECT fn_full_name(' María Fernanda ', 'Rueda') AS full_name;
```



### 3.

Crear una función que reciba un ID de paciente y retorne su número de documento.

```sql
DROP FUNCTION IF EXISTS fn_patient_document;

DELIMITER $$

CREATE FUNCTION fn_patient_document(
    p_patient_id BIGINT
)
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE v_document VARCHAR(20);

    SELECT document_number INTO v_document
    FROM patients
    WHERE id = p_patient_id;

    RETURN v_document;
END $$

DELIMITER ;

SELECT fn_patient_document(1) AS document, fn_patient_document(999) AS not_found;
-- not_found es NULL: el paciente 999 no existe.
```



### 4.

Crear una función que reciba un ID de paciente y retorne su edad.

```sql
DROP FUNCTION IF EXISTS fn_patient_age_by_id;

DELIMITER $$

CREATE FUNCTION fn_patient_age_by_id(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_birth_date DATE;

    SELECT birth_date INTO v_birth_date
    FROM patients
    WHERE id = p_patient_id;

    RETURN fn_patient_age(v_birth_date);
END $$

DELIMITER ;

SELECT fn_patient_age_by_id(9) AS age_patient_9;
```



### 5.

Crear una función que reciba el ID de una consulta y retorne su fecha.

```sql
DROP FUNCTION IF EXISTS fn_visit_date;

DELIMITER $$

CREATE FUNCTION fn_visit_date(
    p_visit_id BIGINT
)
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date DATETIME;

    SELECT visit_date INTO v_date
    FROM medical_visits
    WHERE id = p_visit_id;

    RETURN v_date;
END $$

DELIMITER ;

SELECT fn_visit_date(1) AS visit_1;
```



### 6.

Crear una función que determine cuántos años han pasado desde una fecha.

```sql
DROP FUNCTION IF EXISTS fn_years_since;

DELIMITER $$

CREATE FUNCTION fn_years_since(
    p_date DATE
)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_date, CURDATE());
END $$

DELIMITER ;

SELECT diagnosis_date, fn_years_since(diagnosis_date) AS years FROM glaucoma_records;
```



### 7.

Crear una función que reciba un valor de PIO y retorne un texto descriptivo.

```sql
-- Mismos rangos que fn_iop_category (04_functions.sql). Se compara el número y no el texto
-- que devuelve esa función para no depender de la collation de la conexión (Error 1271).
DROP FUNCTION IF EXISTS fn_iop_description;

DELIMITER $$

CREATE FUNCTION fn_iop_description(
    p_pressure DECIMAL(4,1)
)
RETURNS VARCHAR(120)
DETERMINISTIC
NO SQL
BEGIN
    IF p_pressure IS NULL THEN
        RETURN 'Sin medición de PIO';
    END IF;

    RETURN CONCAT('PIO de ', p_pressure, ' mmHg: ',
        CASE
            WHEN p_pressure < 10 THEN 'presión baja, por debajo de 10 mmHg'
            WHEN p_pressure <= 21 THEN 'presión dentro del rango normal (10 a 21 mmHg)'
            WHEN p_pressure <= 30 THEN 'presión elevada, requiere seguimiento'
            ELSE 'presión muy elevada, requiere atención prioritaria'
        END);
END $$

DELIMITER ;

SELECT fn_iop_description(8) AS low, fn_iop_description(16) AS normal, fn_iop_description(34) AS very_high;
```



### 8.

Crear una función que reciba `OD` u `OI` y devuelva `Ojo derecho` u `Ojo izquierdo`.

```sql
DROP FUNCTION IF EXISTS fn_eye_name;

DELIMITER $$

CREATE FUNCTION fn_eye_name(
    p_eye VARCHAR(2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE UPPER(p_eye)
        WHEN 'OD' THEN 'Ojo derecho'
        WHEN 'OI' THEN 'Ojo izquierdo'
        WHEN 'AO' THEN 'Ambos ojos'
        ELSE 'No especificado'
    END;
END $$

DELIMITER ;

SELECT fn_eye_name('OD') AS od, fn_eye_name('OI') AS oi;
```



### 9.

Crear una función que reciba un booleano y retorne `Activo` o `Inactivo`.

```sql
DROP FUNCTION IF EXISTS fn_active_label;

DELIMITER $$

CREATE FUNCTION fn_active_label(
    p_value BOOLEAN
)
RETURNS VARCHAR(10)
DETERMINISTIC
NO SQL
BEGIN
    RETURN IF(p_value, 'Activo', 'Inactivo');
END $$

DELIMITER ;

SELECT first_name, last_name, fn_active_label(is_active) AS status FROM healthcare_professionals;
```



### 10.

Crear una función que formatee un número de historia clínica.

```sql
-- Formato: HC- + número con 6 dígitos (ej. 25 → HC-000025).
DROP FUNCTION IF EXISTS fn_format_history_number;

DELIMITER $$

CREATE FUNCTION fn_format_history_number(
    p_number BIGINT
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT('HC-', LPAD(p_number, 6, '0'));
END $$

DELIMITER ;

SELECT fn_format_history_number(25) AS formatted;
```



## Funciones con consultas

### 11.

Crear una función que retorne la cantidad de consultas de un paciente.

```sql
DROP FUNCTION IF EXISTS fn_patient_visit_count;

DELIMITER $$

CREATE FUNCTION fn_patient_visit_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_patient_visit_count(1) AS visits_1, fn_patient_visit_count(20) AS visits_20;
-- visits_20 = 0: Daniela Carrillo no tiene historia clínica ni consultas en el seed.
```



### 12.

Crear una función que retorne la cantidad de diagnósticos de un paciente.

```sql
-- Cuenta diagnósticos distintos (un mismo diagnóstico en varias consultas cuenta una vez).
DROP FUNCTION IF EXISTS fn_patient_diagnosis_count;

DELIMITER $$

CREATE FUNCTION fn_patient_diagnosis_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(DISTINCT vd.diagnosis_id) INTO v_total
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_patient_diagnosis_count(1) AS diagnoses_1;
```



### 13.

Crear una función que retorne la cantidad de controles de glaucoma de un paciente.

```sql
DROP FUNCTION IF EXISTS fn_glaucoma_control_count;

DELIMITER $$

CREATE FUNCTION fn_glaucoma_control_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM glaucoma_controls gc
    INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
    WHERE g.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_glaucoma_control_count(2) AS controls_2;
```



### 14.

Crear una función que retorne la última fecha de consulta.

```sql
DROP FUNCTION IF EXISTS fn_last_visit_date;

DELIMITER $$

CREATE FUNCTION fn_last_visit_date(
    p_patient_id BIGINT
)
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date DATETIME;

    SELECT MAX(mv.visit_date) INTO v_date
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_date;
END $$

DELIMITER ;

SELECT fn_last_visit_date(1) AS last_visit;
```



### 15.

Crear una función que retorne la primera fecha de consulta.

```sql
DROP FUNCTION IF EXISTS fn_first_visit_date;

DELIMITER $$

CREATE FUNCTION fn_first_visit_date(
    p_patient_id BIGINT
)
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date DATETIME;

    SELECT MIN(mv.visit_date) INTO v_date
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_date;
END $$

DELIMITER ;

SELECT fn_first_visit_date(1) AS first_visit;
```



### 16.

Crear una función que retorne la presión intraocular promedio de un paciente.

```sql
DROP FUNCTION IF EXISTS fn_patient_avg_iop;

DELIMITER $$

CREATE FUNCTION fn_patient_avg_iop(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_patient_avg_iop(1) AS avg_iop_1;
```



### 17.

Crear una función que retorne la presión promedio de OD.

```sql
DROP FUNCTION IF EXISTS fn_patient_avg_iop_od;

DELIMITER $$

CREATE FUNCTION fn_patient_avg_iop_od(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = 'OD';

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_patient_avg_iop_od(3) AS avg_od_3;
```



### 18.

Crear una función que retorne la presión promedio de OI.

```sql
DROP FUNCTION IF EXISTS fn_patient_avg_iop_oi;

DELIMITER $$

CREATE FUNCTION fn_patient_avg_iop_oi(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = 'OI';

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_patient_avg_iop_oi(3) AS avg_oi_3;
```



### 19.

Crear una función que retorne la PIO máxima registrada para un paciente.

```sql
DROP FUNCTION IF EXISTS fn_patient_max_iop;

DELIMITER $$

CREATE FUNCTION fn_patient_max_iop(
    p_patient_id BIGINT
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE v_max DECIMAL(4,1);

    SELECT MAX(pressure) INTO v_max
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id;

    RETURN v_max;
END $$

DELIMITER ;

SELECT fn_patient_max_iop(3) AS max_iop_3;
```



### 20.

Crear una función que retorne la PIO mínima registrada.

```sql
DROP FUNCTION IF EXISTS fn_patient_min_iop;

DELIMITER $$

CREATE FUNCTION fn_patient_min_iop(
    p_patient_id BIGINT
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE v_min DECIMAL(4,1);

    SELECT MIN(pressure) INTO v_min
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id;

    RETURN v_min;
END $$

DELIMITER ;

SELECT fn_patient_min_iop(3) AS min_iop_3;
```



## Funciones clínicas y de clasificación

### 21.

Crear una función que clasifique una PIO según rangos definidos para fines académicos.

```sql
-- Rangos: < 10 BAJA, 10–21 NORMAL, 21.1–25 LIMÍTROFE, 25.1–30 ALTA, > 30 MUY ALTA.
-- (fn_iop_category de 04 usa 4 rangos; esta separa la zona limítrofe.)
DROP FUNCTION IF EXISTS fn_classify_iop;

DELIMITER $$

CREATE FUNCTION fn_classify_iop(
    p_pressure DECIMAL(4,1)
)
RETURNS VARCHAR(15)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE
        WHEN p_pressure IS NULL THEN NULL
        WHEN p_pressure < 10 THEN 'BAJA'
        WHEN p_pressure <= 21 THEN 'NORMAL'
        WHEN p_pressure <= 25 THEN 'LIMÍTROFE'
        WHEN p_pressure <= 30 THEN 'ALTA'
        ELSE 'MUY ALTA'
    END;
END $$

DELIMITER ;

SELECT pressure, fn_classify_iop(pressure) AS class
FROM intraocular_pressures
WHERE id IN (1, 3, 5, 17);
```



### 22.

Crear una función que indique si una PIO supera una presión objetivo recibida como parámetro.

```sql
DROP FUNCTION IF EXISTS fn_iop_exceeds_target;

DELIMITER $$

CREATE FUNCTION fn_iop_exceeds_target(
    p_pressure DECIMAL(4,1),
    p_target DECIMAL(4,1)
)
RETURNS BOOLEAN
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_pressure > p_target;
END $$

DELIMITER ;

SELECT fn_iop_exceeds_target(22, 18) AS exceeds, fn_iop_exceeds_target(16, 18) AS not_exceeds;
```



### 23.

Crear una función que determine si un paciente tiene diagnóstico de glaucoma.

```sql
-- Usa diagnoses.is_glaucoma (la sospecha de glaucoma H40.0 no cuenta).
DROP FUNCTION IF EXISTS fn_has_glaucoma_diagnosis;

DELIMITER $$

CREATE FUNCTION fn_has_glaucoma_diagnosis(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
        INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
        INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
        WHERE ch.patient_id = p_patient_id
          AND d.is_glaucoma = TRUE
    );
END $$

DELIMITER ;

SELECT fn_has_glaucoma_diagnosis(1) AS patient_1, fn_has_glaucoma_diagnosis(7) AS patient_7_suspect;
```



### 24.

Crear una función que determine si un paciente tiene tratamientos activos.

```sql
DROP FUNCTION IF EXISTS fn_has_active_treatments;

DELIMITER $$

CREATE FUNCTION fn_has_active_treatments(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM treatments t
        INNER JOIN medical_visits mv ON t.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
          AND t.status = 'ACTIVO'
    );
END $$

DELIMITER ;

SELECT fn_has_active_treatments(1) AS patient_1, fn_has_active_treatments(7) AS patient_7;
```



### 25.

Crear una función que indique si el paciente tiene al menos un OCT registrado.

```sql
DROP FUNCTION IF EXISTS fn_has_oct;

DELIMITER $$

CREATE FUNCTION fn_has_oct(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM oct_exams o
        INNER JOIN medical_visits mv ON o.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_has_oct(1) AS patient_1, fn_has_oct(8) AS patient_8;
```



### 26.

Crear una función que indique si tiene campo visual registrado.

```sql
DROP FUNCTION IF EXISTS fn_has_visual_field;

DELIMITER $$

CREATE FUNCTION fn_has_visual_field(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM visual_field_exams vf
        INNER JOIN medical_visits mv ON vf.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_has_visual_field(1) AS patient_1, fn_has_visual_field(8) AS patient_8;
```



### 27.

Crear una función que determine si tiene paquimetría.

```sql
DROP FUNCTION IF EXISTS fn_has_pachymetry;

DELIMITER $$

CREATE FUNCTION fn_has_pachymetry(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM pachymetry_exams pe
        INNER JOIN medical_visits mv ON pe.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_has_pachymetry(1) AS patient_1, fn_has_pachymetry(2) AS patient_2;
```



### 28.

Crear una función que determine si el paciente tiene controles pendientes según un número de meses.

```sql
-- Pendiente = su última consulta tiene más de p_months meses o nunca ha consultado.
DROP FUNCTION IF EXISTS fn_has_pending_control;

DELIMITER $$

CREATE FUNCTION fn_has_pending_control(
    p_patient_id BIGINT,
    p_months INT
)
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last DATETIME;

    SET v_last = fn_last_visit_date(p_patient_id);

    RETURN v_last IS NULL OR v_last < NOW() - INTERVAL p_months MONTH;
END $$

DELIMITER ;

SELECT id, fn_has_pending_control(id, 6) AS pending_6m FROM patients WHERE id IN (1, 10, 20);
```



### 29.

Crear una función que clasifique un paciente según cantidad de consultas: nuevo, recurrente o frecuente.

```sql
-- Reglas: 0–1 consultas = Nuevo, 2–3 = Recurrente, 4 o más = Frecuente.
DROP FUNCTION IF EXISTS fn_patient_visit_class;

DELIMITER $$

CREATE FUNCTION fn_patient_visit_class(
    p_patient_id BIGINT
)
RETURNS VARCHAR(12)
READS SQL DATA
BEGIN
    DECLARE v_visits INT;

    SET v_visits = fn_patient_visit_count(p_patient_id);

    RETURN CASE
        WHEN v_visits <= 1 THEN 'Nuevo'
        WHEN v_visits <= 3 THEN 'Recurrente'
        ELSE 'Frecuente'
    END;
END $$

DELIMITER ;

SELECT id, fn_patient_visit_count(id) AS visits, fn_patient_visit_class(id) AS class
FROM patients
WHERE id IN (1, 3, 6, 10);
```



### 30.

Crear una función que retorne `Completo` si el paciente tiene OCT, campo visual, PIO y paquimetría, o `Incompleto` en caso contrario.

```sql
DROP FUNCTION IF EXISTS fn_exam_completeness;

DELIMITER $$

CREATE FUNCTION fn_exam_completeness(
    p_patient_id BIGINT
)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    IF fn_has_oct(p_patient_id)
       AND fn_has_visual_field(p_patient_id)
       AND fn_has_pachymetry(p_patient_id)
       AND EXISTS (SELECT 1 FROM vw_patient_iop_history WHERE patient_id = p_patient_id) THEN
        RETURN 'Completo';
    END IF;

    RETURN 'Incompleto';
END $$

DELIMITER ;

SELECT id, fn_exam_completeness(id) AS exams FROM patients WHERE id <= 8;
```



## Funciones estadísticas

### 31.

Crear una función que calcule el promedio de PIO entre dos fechas para un paciente.

```sql
DROP FUNCTION IF EXISTS fn_avg_iop_between;

DELIMITER $$

CREATE FUNCTION fn_avg_iop_between(
    p_patient_id BIGINT,
    p_from DATE,
    p_to DATE
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at >= p_from
      AND measured_at < p_to + INTERVAL 1 DAY;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_iop_between(1, '2025-01-01', '2025-12-31') AS avg_2025,
       fn_avg_iop_between(1, '2026-01-01', '2026-12-31') AS avg_2026;
```



### 32.

Crear una función que calcule la diferencia entre la primera y última PIO.

```sql
-- Primera/última = promedio de las mediciones (OD y OI) tomadas en la primera y en la última
-- fecha-hora de medición del paciente. Resultado = última − primera (negativo = bajó).
DROP FUNCTION IF EXISTS fn_iop_first_last_diff;

DELIMITER $$

CREATE FUNCTION fn_iop_first_last_diff(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_first DECIMAL(5,2);
    DECLARE v_last DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_first
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at = (SELECT MIN(measured_at) FROM vw_patient_iop_history WHERE patient_id = p_patient_id);

    SELECT AVG(pressure) INTO v_last
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at = (SELECT MAX(measured_at) FROM vw_patient_iop_history WHERE patient_id = p_patient_id);

    RETURN v_last - v_first;
END $$

DELIMITER ;

SELECT fn_iop_first_last_diff(1) AS diff_1, fn_iop_first_last_diff(4) AS diff_4;
```



### 33.

Crear una función que retorne el número de días desde la última consulta.

```sql
DROP FUNCTION IF EXISTS fn_days_since_last_visit;

DELIMITER $$

CREATE FUNCTION fn_days_since_last_visit(
    p_patient_id BIGINT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN DATEDIFF(CURDATE(), fn_last_visit_date(p_patient_id));
END $$

DELIMITER ;

SELECT fn_days_since_last_visit(1) AS days_1, fn_days_since_last_visit(20) AS days_20;
-- days_20 es NULL: el paciente 20 no tiene consultas.
```



### 34.

Crear una función que retorne el número de meses desde el último OCT.

```sql
DROP FUNCTION IF EXISTS fn_months_since_last_oct;

DELIMITER $$

CREATE FUNCTION fn_months_since_last_oct(
    p_patient_id BIGINT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last DATE;

    SELECT MAX(o.exam_date) INTO v_last
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN TIMESTAMPDIFF(MONTH, v_last, CURDATE());
END $$

DELIMITER ;

SELECT fn_months_since_last_oct(1) AS months_1, fn_months_since_last_oct(8) AS months_8;
-- months_8 es NULL: el paciente 8 no tiene OCT.
```



### 35.

Crear una función que retorne el número de meses desde el último campo visual.

```sql
DROP FUNCTION IF EXISTS fn_months_since_last_visual_field;

DELIMITER $$

CREATE FUNCTION fn_months_since_last_visual_field(
    p_patient_id BIGINT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last DATE;

    SELECT MAX(vf.exam_date) INTO v_last
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN TIMESTAMPDIFF(MONTH, v_last, CURDATE());
END $$

DELIMITER ;

SELECT fn_months_since_last_visual_field(4) AS months_4;
```



### 36.

Crear una función que calcule el promedio de RNFL de los OCT de un paciente.

```sql
DROP FUNCTION IF EXISTS fn_avg_rnfl;

DELIMITER $$

CREATE FUNCTION fn_avg_rnfl(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,1)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,1);

    SELECT AVG(o.rnfl_average) INTO v_avg
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_rnfl(4) AS avg_rnfl_4;
```



### 37.

Crear una función que retorne el valor más reciente de RNFL.

```sql
-- Como OD y OI se miden el mismo día, retorna el promedio de ambos ojos en la fecha más reciente.
DROP FUNCTION IF EXISTS fn_last_rnfl;

DELIMITER $$

CREATE FUNCTION fn_last_rnfl(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,1)
READS SQL DATA
BEGIN
    DECLARE v_value DECIMAL(5,1);

    SELECT AVG(o.rnfl_average) INTO v_value
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND o.exam_date = (
          SELECT MAX(o2.exam_date)
          FROM oct_exams o2
          INNER JOIN medical_visits mv2 ON o2.visit_id = mv2.id
          WHERE mv2.clinical_history_id = ch.id
      );

    RETURN v_value;
END $$

DELIMITER ;

SELECT fn_last_rnfl(4) AS last_rnfl_4, fn_avg_rnfl(4) AS avg_rnfl_4;
```



### 38.

Crear una función que calcule el promedio de VFI de un paciente.

```sql
DROP FUNCTION IF EXISTS fn_avg_vfi;

DELIMITER $$

CREATE FUNCTION fn_avg_vfi(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(vf.vfi) INTO v_avg
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_vfi(4) AS avg_vfi_4;
```



### 39.

Crear una función que retorne la cantidad de tratamientos históricos.

```sql
-- Cuenta todos los tratamientos del paciente (activos, finalizados y suspendidos).
DROP FUNCTION IF EXISTS fn_treatment_count;

DELIMITER $$

CREATE FUNCTION fn_treatment_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_treatment_count(3) AS treatments_3;
```



### 40.

Crear una función que retorne la cantidad de medicamentos diferentes utilizados por un paciente.

```sql
DROP FUNCTION IF EXISTS fn_distinct_medication_count;

DELIMITER $$

CREATE FUNCTION fn_distinct_medication_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(DISTINCT t.medication_id) INTO v_total
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_distinct_medication_count(1) AS medications_1;
```



## Funciones avanzadas

### 41.

Crear una función que reciba paciente y ojo y retorne la última PIO registrada.

```sql
-- Reutiliza fn_last_iop (04_functions.sql), que ya valida el ojo y resuelve la consulta.
DROP FUNCTION IF EXISTS fn_last_iop_by_eye;

DELIMITER $$

CREATE FUNCTION fn_last_iop_by_eye(
    p_patient_id BIGINT,
    p_eye VARCHAR(2)
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    RETURN fn_last_iop(p_patient_id, p_eye);
END $$

DELIMITER ;

SELECT fn_last_iop_by_eye(2, 'OD') AS last_od_2, fn_last_iop_by_eye(2, 'OI') AS last_oi_2;
```



### 42.

Crear una función que reciba paciente y ojo y retorne la PIO promedio.

```sql
DROP FUNCTION IF EXISTS fn_avg_iop_by_eye;

DELIMITER $$

CREATE FUNCTION fn_avg_iop_by_eye(
    p_patient_id BIGINT,
    p_eye VARCHAR(2)
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = p_eye;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_iop_by_eye(5, 'OD') AS avg_od_5, fn_avg_iop_by_eye(5, 'OI') AS avg_oi_5;
```



### 43.

Crear una función que determine si la última PIO es mayor o menor que la primera.

```sql
-- Reutiliza fn_iop_first_last_diff (ejercicio 32).
DROP FUNCTION IF EXISTS fn_iop_trend;

DELIMITER $$

CREATE FUNCTION fn_iop_trend(
    p_patient_id BIGINT
)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE v_diff DECIMAL(5,2);

    SET v_diff = fn_iop_first_last_diff(p_patient_id);

    RETURN CASE
        WHEN v_diff IS NULL THEN 'SIN DATOS'
        WHEN v_diff > 0 THEN 'MAYOR'
        WHEN v_diff < 0 THEN 'MENOR'
        ELSE 'IGUAL'
    END;
END $$

DELIMITER ;

SELECT id, fn_iop_trend(id) AS trend FROM patients WHERE id IN (1, 4, 6, 20);
```



### 44.

Crear una función que retorne la diferencia porcentual entre primera y última PIO.

```sql
-- ((última − primera) / primera) × 100, con la misma definición de primera/última del ejercicio 32.
DROP FUNCTION IF EXISTS fn_iop_percent_change;

DELIMITER $$

CREATE FUNCTION fn_iop_percent_change(
    p_patient_id BIGINT
)
RETURNS DECIMAL(6,2)
READS SQL DATA
BEGIN
    DECLARE v_first DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_first
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at = (SELECT MIN(measured_at) FROM vw_patient_iop_history WHERE patient_id = p_patient_id);

    IF v_first IS NULL OR v_first = 0 THEN
        RETURN NULL;
    END IF;

    RETURN fn_iop_first_last_diff(p_patient_id) / v_first * 100;
END $$

DELIMITER ;

SELECT fn_iop_percent_change(1) AS pct_1;
```



### 45.

Crear una función que retorne el diagnóstico principal más reciente de un paciente.

```sql
DROP FUNCTION IF EXISTS fn_last_primary_diagnosis;

DELIMITER $$

CREATE FUNCTION fn_last_primary_diagnosis(
    p_patient_id BIGINT
)
RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(150);

    SELECT d.name INTO v_name
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
    WHERE ch.patient_id = p_patient_id
      AND vd.is_primary = TRUE
    ORDER BY mv.visit_date DESC
    LIMIT 1;

    RETURN v_name;
END $$

DELIMITER ;

SELECT fn_last_primary_diagnosis(3) AS diagnosis_3;
```



### 46.

Crear una función que retorne el nombre del medicamento activo más reciente.

```sql
DROP FUNCTION IF EXISTS fn_last_active_medication;

DELIMITER $$

CREATE FUNCTION fn_last_active_medication(
    p_patient_id BIGINT
)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(100);

    SELECT m.name INTO v_name
    FROM treatments t
    INNER JOIN medications m ON t.medication_id = m.id
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND t.status = 'ACTIVO'
    ORDER BY t.start_date DESC, t.id DESC
    LIMIT 1;

    RETURN v_name;
END $$

DELIMITER ;

SELECT fn_last_active_medication(1) AS medication_1, fn_last_active_medication(10) AS medication_10;
-- medication_10 es NULL: el paciente 10 no tiene tratamientos.
```



### 47.

Crear una función que retorne la cantidad de procedimientos realizados a un paciente.

```sql
DROP FUNCTION IF EXISTS fn_procedure_count;

DELIMITER $$

CREATE FUNCTION fn_procedure_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM procedures pr
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_procedure_count(3) AS procedures_3;
```



### 48.

Crear una función que determine si un profesional ha atendido alguna vez a un paciente específico.

```sql
DROP FUNCTION IF EXISTS fn_professional_attended_patient;

DELIMITER $$

CREATE FUNCTION fn_professional_attended_patient(
    p_professional_id BIGINT,
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM medical_visits mv
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE mv.professional_id = p_professional_id
          AND ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_professional_attended_patient(2, 2) AS yes_2_2, fn_professional_attended_patient(5, 1) AS no_5_1;
```



### 49.

Crear una función que calcule la cantidad total de exámenes especializados registrados para un paciente.

```sql
-- Exámenes especializados: OCT, campo visual, paquimetría y gonioscopía (cada ojo cuenta como un examen).
DROP FUNCTION IF EXISTS fn_specialized_exam_count;

DELIMITER $$

CREATE FUNCTION fn_specialized_exam_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM (
        SELECT visit_id FROM oct_exams
        UNION ALL SELECT visit_id FROM visual_field_exams
        UNION ALL SELECT visit_id FROM pachymetry_exams
        UNION ALL SELECT visit_id FROM gonioscopy_exams
    ) e
    INNER JOIN medical_visits mv ON e.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_specialized_exam_count(1) AS exams_1;
```



### 50.

Crear una función que genere un resumen textual como:

```
Paciente: Carlos Gómez
Consultas: 8
Controles glaucoma: 4
Última PIO OD: 18
Última PIO OI: 17
Tratamientos activos: 2
```

a partir del ID del paciente.

```sql
-- Reutiliza fn_patient_visit_count (11), fn_glaucoma_control_count (13) y fn_last_iop_by_eye (41).
-- El salto de línea se arma con CHAR(10).
DROP FUNCTION IF EXISTS fn_patient_summary;

DELIMITER $$

CREATE FUNCTION fn_patient_summary(
    p_patient_id BIGINT
)
RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(201);
    DECLARE v_active INT;

    SELECT CONCAT(first_name, ' ', last_name) INTO v_name
    FROM patients
    WHERE id = p_patient_id;

    IF v_name IS NULL THEN
        RETURN NULL;
    END IF;

    SELECT COUNT(*) INTO v_active
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND t.status = 'ACTIVO';

    RETURN CONCAT(
        'Paciente: ', v_name, CHAR(10),
        'Consultas: ', fn_patient_visit_count(p_patient_id), CHAR(10),
        'Controles glaucoma: ', fn_glaucoma_control_count(p_patient_id), CHAR(10),
        'Última PIO OD: ', IFNULL(TRIM(TRAILING '.0' FROM fn_last_iop_by_eye(p_patient_id, 'OD')), 'N/A'), CHAR(10),
        'Última PIO OI: ', IFNULL(TRIM(TRAILING '.0' FROM fn_last_iop_by_eye(p_patient_id, 'OI')), 'N/A'), CHAR(10),
        'Tratamientos activos: ', v_active
    );
END $$

DELIMITER ;

SELECT fn_patient_summary(1) AS summary;
```

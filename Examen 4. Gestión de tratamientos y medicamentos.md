

JAIDER POSSO

# Examen 4. Gestión de tratamientos y medicamentos

Actividad 1. Análisis del modelo relacional — 10 puntos / 10 minutos Analice las tablas treatment , treatment_medication y medication . Explique la relación existente entre tratamientos y medicamentos, identifique la función de la tabla intermedia e indique por qué los atributos dosage y frequency pertenecen a dicha relación y no al catálogo de medicamentos.

R// La relacion es de N:M, es por eso que se crea la tabla intermedia treatment_medication,   los atributos dosage y frequency pertenecen a dicha relación porque tanto medication como  treatment requieren esos atributos entonces generaria una redundancia y por  eso va a la tabla intermedia





1. Listar los medicamentos con su nombre, principio activo y concentración.

```sql
SELECT id, name AS nombre, is_active AS principio_activo, active_ingredient AS concentracion
FROM medications;
```

2. Obtener los tratamientos cuya fecha de finalización sea posterior a la fecha actual.

```sql
SELECT id, visit_id, medication_id, eye, dosage, frequency, end_date
FROM treatments
WHERE end_date > '2026-10-14';
```

3. Consultar los medicamentos cuyo nombre contenga la palabra Timolol .

```sql
SELECT *
FROM medications
WHERE name LIKE 'Timolol';
```

Actividad 3. Consultas relacionales — 20 puntos / 20 minutos

1. Mostrar los tratamientos con sus medicamentos asociados, incluyendo dosis y frecuencia. 

   ```sql
   SELECT t.id, m.name AS nombre_medicamento, dosage AS dosis, frequency AS frecuencia
   FROM treatments t
   JOIN medications m ON m.id = t.medication_id;
   ```

   

2. Obtener la cantidad de medicamentos distintos registrados en cada tratamiento

```sql
SELECT DISTINCT(m.id), m.name AS nombre_medicamento, t.dosage AS dosis, t.frequency AS frecuencia
FROM medications m
JOIN treatments t ON m.id = t.medication_id;
```

Actividad 4. Consultas avanzadas — 20 puntos / 20 minutos Desarrolle dos consultas: 

1. Mostrar los medicamentos utilizados en más de un tratamiento. 

   ```sql
   SELECT  m.name AS nombre_medicamento, t.dosage AS dosis, t.frequency AS frecuencia, COUNT(m.id) AS cantidad
   FROM medications m
   JOIN treatments t ON m.id = t.medication_id
   GROUP BY m.id, m.name, t.dosage, t.frequency;
   ```

   

2.  Obtener los tratamientos cuya cantidad de medicamentos es superior al promedio de medicamentos por tratamiento, mediante una subconsulta. Incluya los tratamientos sin medicamentos al calcular el promedio.

   ```sql
   SELECT COUNT(t.id), m.name AS nombre_medicamento
   FROM medications m
   JOIN treatments t ON m.id = t.medication_id
   GROUP BY m.id, m.name
   HAVING COUNT(t.id) > (
   SELECT AVG(total)
   FROM (
   SELECT COUNT(*) AS total
   FROM treatments
   GROUP BY medication_id) x
   );
   ```

Actividad 5. Creación de una vista — 15 puntos / 10 minutos Crear la vista vw_patient_exam_results , que muestre: Identificador del paciente. Nombre completo. Tipo de examen. Fecha de realización. Código del ojo, cuando corresponda. Nombre del parámetro evaluado. Resultado numérico. Resultado textual. La vista deberá permitir consultar los resultados disponibles sin duplicaciones artificiales.

```sql
CREATE OR REPLACE VIEW vw_patient_exam_results AS
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name)
CASE WHEN THEN
ELSE
END
FROM patients p
JOIN
```



Actividad 6. Trigger de validación — 20 puntos / 15 minutos Crear el trigger trg_validate_treatment_dates , que se ejecute antes de insertar un registro en treatment . El trigger debe impedir el registro cuando la fecha de finalización sea anterior a la fecha de inicio, siempre que ambas fechas estén informadas. Utilice SIGNAL SQLSTATE '45000' para generar un mensaje de error descriptivo. Realice dos pruebas: un tratamiento con fechas válidas y otro con fechas inválidas. Utilice identificadores de consulta y estado existentes.

```sql
DROP IF NOT EXIST trg_validate_treatment_dates 

DELIMITER $$
CREATE TRIGGER trg_validate_treatment_dates

```


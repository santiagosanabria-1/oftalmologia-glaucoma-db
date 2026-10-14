# Examen 3. Gestión de diagnósticos y antecedentes clínicos

#### Consultas básicas

1. Listar los diagnósticos registrados en el catálogo, mostrando código y nombre

```sql
SELECT code, name
FROM diagnoses
GROUP BY code;
```

2. Mostrar únicamente los diagnósticos activos

```sql
SELECT code, name
FROM diagnoses
WHERE is_active = TRUE
GROUP BY code;
```

3. Buscar los diagnósticos cuyo nombre contenga la palabra Glaucoma .

```sql
SELECT *
FROM diagnoses
WHERE name LIKE '%Glaucoma%';
```

#### Consultas relacionales 

1.  Mostrar el nombre del paciente, la fecha de consulta y los diagnósticos asociados a dicha atención

```sql
SELECT
CONCAT(p.first_name, ' ', p.last_name) AS paciente,
mv.visit_date AS fecha_consulta,
d.code AS codigo_diagnostico,
d.name AS diagnostico
FROM patients p
JOIN clinical_histories ch ON ch.patient_id = p.id
JOIN medical_visits mv ON mv.clinical_history_id = ch.id
JOIN visit_diagnoses vd ON vd.visit_id = mv.id
JOIN diagnoses d ON d.id = vd.diagnosis_id
ORDER BY paciente, mv.visit_date;
```

2. Obtener la cantidad de consultas en las que aparece cada diagnóstico, mostrando código, nombre y frecuencia.

```sql
SELECT d.code AS codigo, d.name AS nombre, COUNT(DISTINCT vd.visit_id) AS frecuencia
FROM diagnoses d
LEFT JOIN visit_diagnoses vd ON vd.diagnosis_id = d.id
GROUP BY d.id, d.code, d.name
ORDER BY frecuencia DESC, d.code;

```

#### Consultas avanzadas

1. Obtener los pacientes que han recibido más de un diagnóstico distinto, considerando todas sus consultas

```sql
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS paciente,
COUNT(DISTINCT vd.diagnosis_id) AS diagnosticos_distintos_id
FROM patients p
JOIN clinical_histories ch ON ch.patient_id = p.id
JOIN medical_visits mv ON mv.clinical_history_id = ch.id
JOIN visit_diagnoses vd ON vd.visit_id = mv.id
GROUP BY p.id, p.first_name, p.last_name 
HAVING COUNT(DISTINCT vd.diagnosis_id) > 1
ORDER BY diagnosticos_distintos_id;
```

2. Obtener los pacientes que no tienen diagnósticos registrados mediante NOT EXISTS .

```sql
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS paciente
FROM patients p
WHERE NOT EXISTS (
	SELECT *
	FROM clinical_histories ch
	JOIN medical_visits mv ON mv.clinical_history_id = ch.id
	JOIN visit_diagnoses vd ON vd.visit_id = mv.id
	WHERE ch.patient_id = p.id
)
ORDER BY p.id;
```

#### Creación de una vista

Crear la vista vw_patient_diagnoses , que muestre: Identificador del paciente. Nombre completo. Fecha de consulta. Código del diagnóstico. Nombre del diagnóstico. Tipo de diagnóstico: principal o secundario, según el valor almacenado.

```sql
CREATE OR REPLACE VIEW  vw_patient_diagnoses AS
SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS full_name,
mv.visit_date AS visit_date,
d.code AS diagnosis_code,
d.name AS diagnosis_name
CASE WHEN vd.is_primary THEN 'Principal'
	ELSE 'Secundario'
END
FROM patients p
JOIN clinical_histories ch ON ch.patient_id = p.id
JOIN medical_visits mv ON mv.clinical_history_id = ch.id
JOIN visit_diagnoses vd ON vd.diagnosis_id;
SELECT * FROM vw_patient_diagnoses
ORDER BY patient_id, visit_date;



```


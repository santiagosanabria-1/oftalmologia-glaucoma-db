# 7. Proceso de normalización (0FN → 4FN)

Se parte de la estructura no normalizada que propone el taller (sección 14) y se aplica cada forma normal paso a paso. Los datos de ejemplo son los del paciente **Carlos Gómez** (`patients.id = 1`) en `sql/02_seed.sql`, para que cada tabla resultante se pueda comprobar contra la base real.

---

## 0FN — Datos no normalizados

Una sola tabla con todo lo que se anota en papel durante la consulta:

**HISTORIA_CLINICA** (sin clave definida)

| paciente | documento | telefono | ciudad | consulta_fecha | profesional | especialidad | diagnosticos | medicamentos | presion_od | presion_oi | oct | campo_visual |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Carlos Gómez | 1098456123 | 3001234567 | Bucaramanga, Santander | 2025-03-10 | Laura Martínez | Glaucoma | H40.1 Glaucoma primario de ángulo abierto, H25.9 Catarata senil, I10 Hipertensión | Brimonidina | 28 | 26 | OD 72 / OI 75 | OD MD -6.2 / OI MD -4.8 |
| Carlos Gómez | 1098456123 | 3001234567 | Bucaramanga, Santander | 2025-09-15 | Laura Martínez | Glaucoma | H40.1 Glaucoma primario de ángulo abierto | Latanoprost | 24 | 23 | | |
| Carlos Gómez | 1098456123 | 3001234567 | Bucaramanga, Santander | 2026-02-12 | Laura Martínez | Glaucoma | H40.1 Glaucoma primario de ángulo abierto | Timolol | 19 | 18 | | OD MD -6.5 / OI MD -4.9 |

**Problemas:**

- **Valores multivaluados:** `diagnosticos` guarda tres diagnósticos en una celda; `oct` y `campo_visual` mezclan los dos ojos.
- **Atributos compuestos:** `ciudad` junta ciudad y departamento; cada diagnóstico junta código y nombre.
- **Grupos repetitivos:** `presion_od`/`presion_oi` obligan a tener columnas por ojo; si se mide dos veces en una consulta, no hay dónde guardarlo (la versión extrema del taller tiene `presion_od_1`, `presion_od_2`, `oct1`, `oct2`…).
- **Redundancia:** nombre, documento, teléfono, profesional y especialidad se repiten en cada consulta.
- **Anomalías:**
  - *Inserción:* no se puede registrar un diagnóstico nuevo en el catálogo sin inventar una consulta.
  - *Actualización:* si Carlos cambia de teléfono hay que editar todas sus filas; si una queda sin cambiar, hay inconsistencia.
  - *Eliminación:* si se borra la única consulta de un paciente, se pierden también sus datos personales.

---

## 1FN — Primera Forma Normal

**Regla:** todos los atributos atómicos, sin grupos repetitivos, una celda = un valor, y una clave que identifique cada fila.

**Cambios aplicados:**

1. Se separan los atributos compuestos: `ciudad` → `ciudad`, `departamento`; diagnóstico → `diagnostico_codigo`, `diagnostico_nombre`.
2. El ojo deja de ser parte del nombre de la columna y pasa a ser un **valor** (`ojo` = OD / OI). Una fila por medición.
3. Los valores multivaluados se convierten en filas.

Separar solo en filas dentro de una única tabla haría que cada diagnóstico se cruce con cada medición (3 diagnósticos × 2 ojos = 6 filas por consulta), así que en este paso los grupos repetitivos se sacan a tablas propias, todas con la clave de la consulta (`documento`, `consulta_fecha`):

**CONSULTA_1FN** — PK (`documento`, `consulta_fecha`)

| documento | consulta_fecha | paciente_nombre | paciente_apellido | telefono | ciudad | departamento | profesional | especialidad |
|---|---|---|---|---|---|---|---|---|
| 1098456123 | 2025-03-10 | Carlos | Gómez | 3001234567 | Bucaramanga | Santander | Laura Martínez | Glaucoma |
| 1098456123 | 2025-09-15 | Carlos | Gómez | 3001234567 | Bucaramanga | Santander | Laura Martínez | Glaucoma |
| 1098456123 | 2026-02-12 | Carlos | Gómez | 3001234567 | Bucaramanga | Santander | Laura Martínez | Glaucoma |

**CONSULTA_DIAGNOSTICO_1FN** — PK (`documento`, `consulta_fecha`, `diagnostico_codigo`)

| documento | consulta_fecha | diagnostico_codigo | diagnostico_nombre |
|---|---|---|---|
| 1098456123 | 2025-03-10 | H40.1 | Glaucoma primario de ángulo abierto |
| 1098456123 | 2025-03-10 | H25.9 | Catarata senil |
| 1098456123 | 2025-03-10 | I10 | Hipertensión arterial esencial |
| 1098456123 | 2025-09-15 | H40.1 | Glaucoma primario de ángulo abierto |
| 1098456123 | 2026-02-12 | H40.1 | Glaucoma primario de ángulo abierto |

**CONSULTA_PIO_1FN** — PK (`documento`, `consulta_fecha`, `ojo`)

| documento | consulta_fecha | ojo | presion |
|---|---|---|---|
| 1098456123 | 2025-03-10 | OD | 28 |
| 1098456123 | 2025-03-10 | OI | 26 |
| 1098456123 | 2025-09-15 | OD | 24 |
| 1098456123 | 2025-09-15 | OI | 23 |

Del mismo modo se obtienen `CONSULTA_MEDICAMENTO_1FN`, `CONSULTA_OCT_1FN` (con `ojo`, `rnfl`) y `CONSULTA_CAMPO_VISUAL_1FN` (con `ojo`, `md`, `psd`, `vfi`).

**Ya cumple 1FN**, pero persisten redundancias: el nombre del paciente se repite en cada consulta y el nombre del diagnóstico en cada uso.

---

## 2FN — Segunda Forma Normal

**Regla:** estar en 1FN y que ningún atributo no clave dependa de **solo una parte** de una clave compuesta.

**Dependencias parciales encontradas:**

| Tabla | Clave | Dependencia parcial |
|---|---|---|
| CONSULTA_1FN | (documento, consulta_fecha) | `documento → paciente_nombre, paciente_apellido, telefono, ciudad, departamento` |
| CONSULTA_DIAGNOSTICO_1FN | (documento, consulta_fecha, diagnostico_codigo) | `diagnostico_codigo → diagnostico_nombre` (es el ejemplo del taller: `diagnosis_name` depende solo de `diagnosis_id`) |
| CONSULTA_MEDICAMENTO_1FN | (documento, consulta_fecha, medicamento) | `medicamento → principio_activo, presentacion` |

**Solución:** cada grupo de atributos se lleva a la tabla de su determinante. Además se introduce una clave sustituta `id` para la consulta, porque (documento, fecha) no es estable ni cómoda como FK.

**PATIENTS** — PK `id`, `UNIQUE(document_number)`

| id | document_number | first_name | last_name | phone | ciudad | departamento |
|---|---|---|---|---|---|---|
| 1 | 1098456123 | Carlos | Gómez | 3001234567 | Bucaramanga | Santander |

**DIAGNOSES** — PK `id`, `UNIQUE(code)`

| id | code | name |
|---|---|---|
| 1 | H40.1 | Glaucoma primario de ángulo abierto |
| 5 | H25.9 | Catarata senil |
| 10 | I10 | Hipertensión arterial esencial |

**MEDICAL_VISITS** — PK `id`

| id | patient_id | visit_date | profesional | especialidad |
|---|---|---|---|---|
| 1 | 1 | 2025-03-10 08:30 | Laura Martínez | Glaucoma |
| 2 | 1 | 2025-09-15 09:00 | Laura Martínez | Glaucoma |
| 3 | 1 | 2026-02-12 10:15 | Laura Martínez | Glaucoma |

**VISIT_DIAGNOSES** — PK (`visit_id`, `diagnosis_id`): solo quedan atributos que dependen de la clave completa.

| visit_id | diagnosis_id | eye | is_primary |
|---|---|---|---|
| 1 | 1 | AO | 1 |
| 1 | 5 | OI | 0 |
| 1 | 10 | NULL | 0 |

**INTRAOCULAR_PRESSURES** — PK `id`

| id | visit_id | eye | pressure | method | measured_at |
|---|---|---|---|---|---|
| 1 | 1 | OD | 28.0 | AIRE | 2025-03-10 08:30 |
| 2 | 1 | OI | 26.0 | AIRE | 2025-03-10 08:30 |

(Igual para `MEDICATIONS` / `TREATMENTS`, `OCT_EXAMS` y `VISUAL_FIELD_EXAMS`.)

**Ya cumple 2FN.** Quedan dependencias transitivas en `PATIENTS` y `MEDICAL_VISITS`.

---

## 3FN — Tercera Forma Normal

**Regla:** estar en 2FN y que ningún atributo no clave dependa de otro atributo no clave (sin dependencias transitivas).

**Dependencias transitivas encontradas:**

| Tabla | Cadena transitiva | Solución |
|---|---|---|
| PATIENTS | `id → ciudad → departamento` | Catálogo `cities(id, name, department)`; `patients.city_id` (es el ejemplo del taller con `city_name`). |
| PATIENTS | `id → tipo_documento_codigo → tipo_documento_nombre` | Catálogo `document_types(id, code, name)`; `patients.document_type_id`. |
| MEDICAL_VISITS | `id → profesional → especialidad` | `healthcare_professionals(id, …, specialty_id)` y `specialties(id, name)`; `medical_visits.professional_id`. |
| MEDICAL_VISITS | `id → patient_id`, y la historia clínica también determina al paciente | Se crea `clinical_histories(id, patient_id UNIQUE, history_number)` y la consulta referencia `clinical_history_id`. El paciente se obtiene por la historia, no se repite. |
| Exámenes / PIO | `id → visit_id → paciente` | Los exámenes **no** guardan `patient_id`: guardarlo sería una dependencia transitiva que podría contradecir a `visit_id`. |

**Resultado (extracto con datos reales):**

**CITIES**

| id | name | department |
|---|---|---|
| 1 | Bucaramanga | Santander |
| 2 | Floridablanca | Santander |

**PATIENTS**

| id | document_type_id | document_number | first_name | last_name | city_id |
|---|---|---|---|---|---|
| 1 | 1 | 1098456123 | Carlos | Gómez | 1 |

**SPECIALTIES** / **HEALTHCARE_PROFESSIONALS**

| id | name |
|---|---|
| 1 | Glaucoma |

| id | first_name | last_name | specialty_id |
|---|---|---|---|
| 1 | Laura | Martínez | 1 |

**CLINICAL_HISTORIES** / **MEDICAL_VISITS**

| id | patient_id | history_number |
|---|---|---|
| 1 | 1 | HC-000001 |

| id | clinical_history_id | professional_id | visit_date |
|---|---|---|---|
| 1 | 1 | 1 | 2025-03-10 08:30 |

**Ya cumple 3FN.**

---

## BCNF — Forma Normal de Boyce-Codd

**Regla:** para toda dependencia funcional no trivial `X → Y`, `X` debe ser superclave.

**Revisión de las tablas con más de una clave candidata:**

| Tabla | Claves candidatas | ¿Cumple? |
|---|---|---|
| `clinical_histories` | `id`, `patient_id`, `history_number` | Sí: los tres determinantes son claves (`UNIQUE`). |
| `ophthalmologic_exams` | `id`, (`visit_id`, `eye`) | Sí: (`visit_id`, `eye`) es `UNIQUE`. |
| `glaucoma_records` | `id`, `patient_id` | Sí. |
| `glaucoma_controls` | `id`, `visit_id` | Sí. |
| `healthcare_professionals` | `id`, `document_number`, `license_number` | Sí. |

**Caso que sí violaría BCNF (y por eso no se diseñó así):** una tabla de asignaciones

**ATENCION_ESPECIALIDAD** — PK (`paciente`, `especialidad`)

| paciente | especialidad | profesional |
|---|---|---|
| Carlos Gómez | Glaucoma | Laura Martínez |
| María F. Rueda | Glaucoma | Laura Martínez |
| María F. Rueda | Oftalmología | Andrés Rojas |

Está en 3FN (`profesional` es parte de una clave candidata alternativa), pero existe `profesional → especialidad` y `profesional` **no** es superclave: si Laura cambiara de especialidad habría que actualizar varias filas. La descomposición BCNF es exactamente la del esquema: `healthcare_professionals(id, specialty_id)` + `medical_visits(clinical_history_id, professional_id)`; la especialidad se deduce del profesional.

**El esquema cumple BCNF.**

---

## 4FN — Cuarta Forma Normal

**Regla:** estar en BCNF y no tener **dependencias multivaluadas** no triviales (`X ↠ Y`) cuyo determinante no sea superclave.

### El problema: dos conjuntos independientes en una sola tabla

Carlos Gómez tiene en el seed **2 alergias** (Penicilina, Sulfas) y **2 antecedentes familiares** (Glaucoma del padre, Diabetes de la madre). Las alergias no tienen nada que ver con los antecedentes familiares. Si se guardan juntos:

**PATIENT_ALLERGY_FAMILY** — PK (`patient_id`, `allergen`, `family_diagnosis`, `relationship`)

| patient_id | allergen | family_diagnosis | relationship |
|---|---|---|---|
| 1 | Penicilina | Glaucoma primario de ángulo abierto | PADRE |
| 1 | Penicilina | Diabetes mellitus tipo 2 | MADRE |
| 1 | Sulfas | Glaucoma primario de ángulo abierto | PADRE |
| 1 | Sulfas | Diabetes mellitus tipo 2 | MADRE |

La tabla está en BCNF (no hay dependencias funcionales: toda la fila es la clave), pero tiene las dependencias multivaluadas:

```
patient_id ↠ allergen
patient_id ↠ (family_diagnosis, relationship)
```

y `patient_id` no es superclave. Consecuencias:

- **Combinaciones artificiales:** 2 × 2 = 4 filas para expresar 4 hechos; con 3 alergias y 4 antecedentes serían 12 filas para 7 hechos.
- **Inserción:** agregar una tercera alergia obliga a insertar una fila por cada antecedente familiar (2 filas), o la tabla queda inconsistente.
- **Eliminación:** un paciente con alergias y sin antecedentes familiares no se puede representar sin NULL en la clave.

### La solución: una tabla por conjunto independiente

**PATIENT_ALLERGIES** — PK (`patient_id`, `allergen_id`) — tabla real del esquema

| patient_id | allergen_id | reaction |
|---|---|---|
| 1 | 1 (Penicilina) | Urticaria generalizada |
| 1 | 2 (Sulfas) | Erupción cutánea |

**PATIENT_FAMILY_HISTORIES** — PK `id`, `UNIQUE(patient_id, diagnosis_id, relationship)` — tabla real del esquema

| id | patient_id | diagnosis_id | relationship |
|---|---|---|---|
| 1 | 1 | 1 (H40.1 Glaucoma) | PADRE |
| 2 | 1 | 9 (E11.3 Diabetes) | MADRE |

Ahora son 2 + 2 = 4 filas para 4 hechos, y cada conjunto crece de forma independiente. Al hacer el `JOIN` de ambas tablas por `patient_id` se reconstruye la tabla original sin pérdida (descomposición sin pérdida).

Comprobación en la base:

```sql
SELECT 'alergias' AS conjunto, COUNT(*) FROM patient_allergies WHERE patient_id = 1
UNION ALL
SELECT 'antecedentes familiares', COUNT(*) FROM patient_family_histories WHERE patient_id = 1;
-- alergias: 2, antecedentes familiares: 2
```

### Otros casos 4FN del proyecto

El mismo criterio se aplicó a los antecedentes personales (taller, sección 20): `patient_personal_histories(patient_id, history_type_id, description)` va separado de alergias y antecedentes familiares. Los medicamentos no se modelaron como `patient_medications`, sino como `treatments` ligados a una consulta, porque el tratamiento tiene fechas, dosis y estado propios.

**El esquema cumple 4FN.**

---

## Resumen

| Forma normal | Qué se eliminó | Tablas resultantes |
|---|---|---|
| 1FN | Valores multivaluados, atributos compuestos, columnas por ojo | Filas por diagnóstico, medicamento y medición, con `eye` como valor |
| 2FN | Dependencias parciales de la clave compuesta | `patients`, `diagnoses`, `medications`, `medical_visits`, `visit_diagnoses`, `intraocular_pressures`, `treatments`… |
| 3FN | Dependencias transitivas | `cities`, `document_types`, `specialties`, `healthcare_professionals`, `clinical_histories` |
| BCNF | Determinantes que no son superclave | Profesional → especialidad resuelto con FK |
| 4FN | Dependencias multivaluadas independientes | `patient_allergies`, `patient_family_histories`, `patient_personal_histories` |

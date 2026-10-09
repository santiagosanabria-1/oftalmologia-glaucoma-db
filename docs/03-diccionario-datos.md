# 3. Diccionario de datos

Generado a partir del esquema real (`sql/01_schema.sql`) en MariaDB 10.4. Base de datos: `oftalmologia_glaucoma`, juego de caracteres `utf8mb4`.

Los tipos se muestran como los reporta MariaDB: `BOOLEAN` aparece como `tinyint(1)` (0 = FALSE, 1 = TRUE) y `JSON` como `longtext` con validación `JSON_VALID`.

Convenciones de la columna **Clave**: `PK` = clave primaria, `FK → tabla.col` = clave foránea, `UQ` = parte de una restricción UNIQUE.

## Índice

1. [`document_types`](#document_types)
2. [`cities`](#cities)
3. [`specialties`](#specialties)
4. [`allergens`](#allergens)
5. [`history_types`](#history_types)
6. [`diagnoses`](#diagnoses)
7. [`glaucoma_types`](#glaucoma_types)
8. [`medications`](#medications)
9. [`procedure_types`](#procedure_types)
10. [`patients`](#patients)
11. [`clinical_histories`](#clinical_histories)
12. [`healthcare_professionals`](#healthcare_professionals)
13. [`patient_allergies`](#patient_allergies)
14. [`patient_family_histories`](#patient_family_histories)
15. [`patient_personal_histories`](#patient_personal_histories)
16. [`medical_visits`](#medical_visits)
17. [`visit_diagnoses`](#visit_diagnoses)
18. [`ophthalmologic_exams`](#ophthalmologic_exams)
19. [`intraocular_pressures`](#intraocular_pressures)
20. [`pachymetry_exams`](#pachymetry_exams)
21. [`gonioscopy_exams`](#gonioscopy_exams)
22. [`oct_exams`](#oct_exams)
23. [`visual_field_exams`](#visual_field_exams)
24. [`glaucoma_records`](#glaucoma_records)
25. [`glaucoma_controls`](#glaucoma_controls)
26. [`treatments`](#treatments)
27. [`procedures`](#procedures)
28. [`clinical_documents`](#clinical_documents)
29. [`audit_logs`](#audit_logs)
30. [`clinical_alerts`](#clinical_alerts)

## document_types

Catálogo de tipos de documento de identidad.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `tinyint(4)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `code` | `varchar(5)` | No | UQ |  | Código corto del tipo (CC, TI, CE, PA). Único. |
| `name` | `varchar(50)` | No |  |  | Nombre del tipo de documento. |

## cities

Catálogo de ciudades y su departamento.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(100)` | No | UQ |  | Nombre de la ciudad. |
| `department` | `varchar(100)` | No | UQ |  | Departamento. (nombre, departamento) es único. |

## specialties

Catálogo de especialidades de los profesionales.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(100)` | No | UQ |  | Nombre de la especialidad. Único. |

## allergens

Catálogo de alérgenos.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(100)` | No | UQ |  | Nombre del alérgeno. Único. |

## history_types

Catálogo de tipos de antecedente personal.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(50)` | No | UQ |  | Nombre del tipo de antecedente. Único. |

## diagnoses

Catálogo de diagnósticos (códigos CIE-10).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `code` | `varchar(10)` | No | UQ |  | Código CIE-10. Único. |
| `name` | `varchar(150)` | No |  |  | Nombre del diagnóstico. |
| `is_glaucoma` | `tinyint(1)` | No |  | 0 | TRUE si el diagnóstico es un tipo de glaucoma confirmado. |

## glaucoma_types

Catálogo de tipos de glaucoma.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(100)` | No | UQ |  | Nombre del tipo de glaucoma. Único. |

## medications

Catálogo de medicamentos.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(100)` | No | UQ |  | Nombre comercial/genérico. Único. |
| `active_ingredient` | `varchar(100)` | No |  |  | Principio activo y concentración. |
| `presentation` | `varchar(100)` | Sí |  | NULL | Presentación farmacéutica. |
| `is_active` | `tinyint(1)` | No |  | 1 | TRUE si el medicamento se puede formular. |

## procedure_types

Catálogo de tipos de procedimiento.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `int(11)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `name` | `varchar(100)` | No | UQ |  | Nombre del procedimiento. Único. |
| `category` | `enum('QUIRURGICO','LASER','DIAGNOSTICO')` | No |  |  | Categoría: QUIRURGICO, LASER o DIAGNOSTICO. |

## patients

Datos personales de los pacientes.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `document_type_id` | `tinyint(4)` | No | FK → document_types.id |  | Tipo de documento (FK a `document_types`). |
| `document_number` | `varchar(20)` | No | UQ |  | Número de documento de identidad (único). |
| `first_name` | `varchar(100)` | No |  |  | Nombres. |
| `last_name` | `varchar(100)` | No |  |  | Apellidos. |
| `birth_date` | `date` | No |  |  | Fecha de nacimiento. |
| `sex` | `enum('M','F')` | No |  |  | Sexo biológico: M o F. |
| `email` | `varchar(150)` | Sí |  | NULL | Correo electrónico. |
| `phone` | `varchar(20)` | Sí |  | NULL | Teléfono de contacto. |
| `address` | `varchar(200)` | Sí |  | NULL | Dirección de residencia. |
| `city_id` | `int(11)` | Sí | FK → cities.id | NULL | Ciudad de residencia (FK a `cities`). Opcional. |
| `created_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora de creación del registro. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## clinical_histories

Historia clínica única por paciente.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `patient_id` | `bigint(20)` | No | FK → patients.id, UQ |  | Paciente dueño de la historia (FK, único: una historia por paciente). |
| `history_number` | `varchar(20)` | No | UQ |  | Número de historia clínica (ej. HC-000001). Único. |
| `opened_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora de apertura. |
| `status` | `enum('ACTIVA','CERRADA')` | No |  | 'ACTIVA' | Estado: ACTIVA o CERRADA. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## healthcare_professionals

Profesionales de salud que atienden consultas.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `document_number` | `varchar(20)` | No | UQ |  | Número de documento de identidad (único). |
| `first_name` | `varchar(100)` | No |  |  | Nombres. |
| `last_name` | `varchar(100)` | No |  |  | Apellidos. |
| `specialty_id` | `int(11)` | No | FK → specialties.id |  | Especialidad (FK a `specialties`). |
| `license_number` | `varchar(30)` | No | UQ |  | Tarjeta profesional. Única. |
| `email` | `varchar(150)` | Sí |  | NULL | Correo electrónico. |
| `phone` | `varchar(20)` | Sí |  | NULL | Teléfono de contacto. |
| `is_active` | `tinyint(1)` | No |  | 1 | TRUE si el profesional puede atender consultas. |
| `created_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora de creación del registro. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## patient_allergies

Alergias de cada paciente (entidad asociativa paciente–alérgeno).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `patient_id` | `bigint(20)` | No | PK, FK → patients.id |  | Paciente (PK compuesta, FK a `patients`). |
| `allergen_id` | `int(11)` | No | PK, FK → allergens.id |  | Alérgeno (PK compuesta, FK a `allergens`). |
| `reaction` | `varchar(200)` | Sí |  | NULL | Reacción presentada. |

## patient_family_histories

Antecedentes familiares del paciente.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `patient_id` | `bigint(20)` | No | FK → patients.id, UQ |  | Paciente (FK a `patients`). |
| `diagnosis_id` | `int(11)` | No | FK → diagnoses.id, UQ |  | Enfermedad del familiar (FK a `diagnoses`). |
| `relationship` | `enum('PADRE','MADRE','HERMANO','HIJO','ABUELO','TIO','OTRO')` | No | UQ |  | Parentesco: PADRE, MADRE, HERMANO, HIJO, ABUELO, TIO u OTRO. |

## patient_personal_histories

Antecedentes personales del paciente.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `patient_id` | `bigint(20)` | No | FK → patients.id |  | Paciente (FK a `patients`). |
| `history_type_id` | `int(11)` | No | FK → history_types.id |  | Tipo de antecedente (FK a `history_types`). |
| `description` | `varchar(255)` | No |  |  | Descripción del antecedente. |
| `recorded_at` | `date` | Sí |  | NULL | Fecha en que se registró. |

## medical_visits

Consultas médicas registradas en una historia clínica.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `clinical_history_id` | `bigint(20)` | No | FK → clinical_histories.id |  | Historia clínica (FK a `clinical_histories`). |
| `professional_id` | `bigint(20)` | No | FK → healthcare_professionals.id |  | Profesional que atendió (FK a `healthcare_professionals`). |
| `visit_date` | `datetime` | No |  |  | Fecha y hora de la consulta. |
| `reason` | `varchar(255)` | No |  |  | Motivo de consulta. |
| `assessment` | `text` | Sí |  | NULL | Valoración / análisis clínico. |
| `plan` | `text` | Sí |  | NULL | Plan de manejo. |
| `observations` | `text` | Sí |  | NULL | Observaciones adicionales. |
| `is_closed` | `tinyint(1)` | No |  | 0 | TRUE si la consulta ya fue cerrada. |
| `created_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora de creación del registro. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## visit_diagnoses

Diagnósticos asociados a cada consulta (entidad asociativa).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `visit_id` | `bigint(20)` | No | PK, FK → medical_visits.id |  | Consulta (PK compuesta, FK a `medical_visits`). |
| `diagnosis_id` | `int(11)` | No | PK, FK → diagnoses.id |  | Diagnóstico (PK compuesta, FK a `diagnoses`). |
| `eye` | `enum('OD','OI','AO')` | Sí |  | NULL | Ojo afectado: OD, OI, AO o NULL si no aplica (diagnóstico sistémico). |
| `is_primary` | `tinyint(1)` | No |  | 0 | TRUE si es el diagnóstico principal de la consulta. |

## ophthalmologic_exams

Examen oftalmológico general por ojo y consulta.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id, UQ |  | Consulta en la que se registró (FK a `medical_visits`). |
| `eye` | `enum('OD','OI')` | No | UQ |  | Ojo: OD u OI. (visit_id, eye) es único. |
| `visual_acuity` | `varchar(10)` | Sí |  | NULL | Agudeza visual (notación Snellen, ej. 20/40). |
| `cup_disc_ratio` | `decimal(3,2)` | Sí |  | NULL | Relación copa/disco del nervio óptico (0 a 1). |
| `anterior_segment` | `text` | Sí |  | NULL | Hallazgos del segmento anterior. |
| `fundus` | `text` | Sí |  | NULL | Hallazgos del fondo de ojo. |

## intraocular_pressures

Mediciones de presión intraocular (PIO).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `eye` | `enum('OD','OI')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `pressure` | `decimal(4,1)` | No |  |  | PIO en mmHg (CHECK 0–80). |
| `method` | `enum('GOLDMANN','AIRE','ICARE','TONOPEN')` | No |  | 'GOLDMANN' | Método: GOLDMANN, AIRE, ICARE o TONOPEN. |
| `measured_at` | `datetime` | No |  |  | Fecha y hora de la medición. |

## pachymetry_exams

Paquimetrías (espesor corneal central).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `eye` | `enum('OD','OI')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `thickness_um` | `smallint(6)` | No |  |  | Espesor corneal central en micras (CHECK > 0). |
| `exam_date` | `date` | No |  |  | Fecha del examen. |

## gonioscopy_exams

Gonioscopías (amplitud del ángulo iridocorneal).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `eye` | `enum('OD','OI')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `shaffer_grade` | `tinyint(4)` | No |  |  | Grado de Shaffer 0–4 (0 = cerrado, 4 = abierto). |
| `findings` | `text` | Sí |  | NULL | Hallazgos de la gonioscopía. |
| `exam_date` | `date` | No |  |  | Fecha del examen. |

## oct_exams

Estudios de tomografía de coherencia óptica (OCT).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `eye` | `enum('OD','OI')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `rnfl_average` | `decimal(5,1)` | No |  |  | Espesor promedio de la capa de fibras nerviosas (µm, CHECK > 0). |
| `cup_disc_ratio` | `decimal(3,2)` | Sí |  | NULL | Relación copa/disco del nervio óptico (0 a 1). |
| `interpretation` | `text` | Sí |  | NULL | Interpretación clínica del resultado. |
| `is_validated` | `tinyint(1)` | No |  | 0 | TRUE si el especialista validó el informe. |
| `exam_date` | `date` | No |  |  | Fecha del examen. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## visual_field_exams

Estudios de campo visual.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `eye` | `enum('OD','OI')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `md` | `decimal(5,2)` | No |  |  | Desviación media (dB). Valores negativos indican pérdida. |
| `psd` | `decimal(5,2)` | No |  |  | Desviación estándar del patrón (dB, CHECK ≥ 0). |
| `vfi` | `tinyint(4)` | No |  |  | Índice de campo visual en % (CHECK 0–100). |
| `reliability` | `enum('ALTA','MEDIA','BAJA')` | No |  | 'ALTA' | Confiabilidad: ALTA, MEDIA o BAJA. |
| `interpretation` | `text` | Sí |  | NULL | Interpretación clínica del resultado. |
| `exam_date` | `date` | No |  |  | Fecha del examen. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## glaucoma_records

Registro de glaucoma del paciente (uno por paciente).

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `patient_id` | `bigint(20)` | No | FK → patients.id, UQ |  | Paciente (FK, único: un registro de glaucoma por paciente). |
| `glaucoma_type_id` | `int(11)` | No | FK → glaucoma_types.id |  | Tipo de glaucoma (FK a `glaucoma_types`). |
| `diagnosis_date` | `date` | No |  |  | Fecha del diagnóstico. |
| `target_pressure` | `decimal(4,1)` | No |  |  | Presión objetivo en mmHg (CHECK > 0). |
| `clinical_status` | `enum('CONTROLADO','NO_CONTROLADO','EN_PROGRESION','ESTABLE')` | No |  | 'ESTABLE' | Estado: CONTROLADO, NO_CONTROLADO, EN_PROGRESION o ESTABLE. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## glaucoma_controls

Controles de seguimiento de glaucoma.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `glaucoma_record_id` | `bigint(20)` | No | FK → glaucoma_records.id |  | Registro de glaucoma (FK a `glaucoma_records`). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id, UQ |  | Consulta del control (FK, única: un control por consulta). |
| `control_date` | `date` | No |  |  | Fecha del control. |
| `progression_detected` | `tinyint(1)` | No |  | 0 | TRUE si se detectó progresión. |
| `notes` | `text` | Sí |  | NULL | Notas u observaciones. |

## treatments

Tratamientos farmacológicos formulados en una consulta.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `medication_id` | `int(11)` | No | FK → medications.id |  | Medicamento (FK a `medications`). |
| `eye` | `enum('OD','OI','AO')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `dosage` | `varchar(100)` | No |  |  | Dosis (ej. 1 gota). |
| `frequency` | `varchar(100)` | No |  |  | Frecuencia (ej. cada 12 horas). |
| `start_date` | `date` | No |  |  | Fecha de inicio. |
| `end_date` | `date` | Sí |  | NULL | Fecha de fin; NULL mientras siga activo (CHECK ≥ start_date). |
| `status` | `enum('ACTIVO','FINALIZADO','SUSPENDIDO')` | No |  | 'ACTIVO' | Estado: ACTIVO, FINALIZADO o SUSPENDIDO. |
| `updated_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP ON UPDATE | Fecha y hora de la última modificación (se actualiza sola). |

## procedures

Procedimientos realizados al paciente.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `visit_id` | `bigint(20)` | No | FK → medical_visits.id |  | Consulta en la que se registró (FK a `medical_visits`). |
| `procedure_type_id` | `int(11)` | No | FK → procedure_types.id |  | Tipo de procedimiento (FK a `procedure_types`). |
| `eye` | `enum('OD','OI','AO')` | No |  |  | Ojo: OD = derecho, OI = izquierdo (AO = ambos, donde se permite). |
| `performed_at` | `date` | No |  |  | Fecha de realización. |
| `notes` | `text` | Sí |  | NULL | Notas u observaciones. |

## clinical_documents

Documentos adjuntos a la historia clínica.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `clinical_history_id` | `bigint(20)` | No | FK → clinical_histories.id |  | Historia clínica (FK a `clinical_histories`). |
| `document_kind` | `varchar(50)` | No |  |  | Tipo de documento (reporte OCT, consentimiento, epicrisis…). |
| `file_name` | `varchar(200)` | No |  |  | Nombre del archivo. |
| `file_path` | `varchar(255)` | No |  |  | Ruta del archivo en el repositorio documental. |
| `uploaded_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora de carga. |

## audit_logs

Bitácora de auditoría llenada por triggers.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `table_name` | `varchar(100)` | No |  |  | Tabla afectada. |
| `record_id` | `bigint(20)` | No |  |  | ID del registro afectado (sin FK, para conservar el log tras un DELETE). |
| `action` | `enum('INSERT','UPDATE','DELETE')` | No |  |  | Acción: INSERT, UPDATE o DELETE. |
| `old_values` | `longtext` | Sí |  | NULL | Valores anteriores en JSON (UPDATE/DELETE). |
| `new_values` | `longtext` | Sí |  | NULL | Valores nuevos en JSON (INSERT/UPDATE). |
| `changed_by` | `varchar(100)` | Sí |  | NULL | Usuario de base de datos que hizo el cambio. |
| `changed_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora del cambio. |

## clinical_alerts

Alertas clínicas internas por paciente.

| Columna | Tipo | Nulo | Clave | Default | Descripción |
|---|---|---|---|---|---|
| `id` | `bigint(20)` | No | PK | AUTO_INCREMENT | Identificador único (autoincremental). |
| `patient_id` | `bigint(20)` | No | FK → patients.id |  | Paciente (FK a `patients`). |
| `alert_type` | `varchar(50)` | No |  |  | Tipo de alerta (ej. PIO_ALTA, CONTROL_VENCIDO). |
| `message` | `varchar(255)` | No |  |  | Mensaje de la alerta. |
| `is_read` | `tinyint(1)` | No |  | 0 | TRUE si la alerta ya fue leída. |
| `created_at` | `datetime` | Sí |  | CURRENT_TIMESTAMP | Fecha y hora de creación del registro. |

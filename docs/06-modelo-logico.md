# 6. Modelo lógico relacional

El modelo lógico transforma las entidades del modelo conceptual en **relaciones** (tablas) con sus atributos, claves primarias y claves foráneas. Es independiente de detalles de almacenamiento, pero ya usa los nombres definitivos en inglés de `sql/01_schema.sql`.

**Notación:** `TABLA(<u>clave_primaria</u>, atributo, columna_fk (FK → tabla.columna))`. Las PK subrayadas que son más de una columna forman una **clave compuesta**. Debajo de cada relación se listan las restricciones `UNIQUE` y `CHECK`.

## Transformación conceptual → lógico

| Elemento conceptual | Regla aplicada | Resultado |
|---|---|---|
| Entidad fuerte | Una relación con PK sustituta `id` | `patients`, `medical_visits`, `diagnoses`… |
| Relación 1:N | FK en el lado N | `medical_visits.clinical_history_id`, `treatments.medication_id`… |
| Relación 1:1 | FK con `UNIQUE` en el lado dependiente | `clinical_histories.patient_id`, `glaucoma_records.patient_id`, `glaucoma_controls.visit_id` |
| Relación N:M | Relación asociativa con PK compuesta | `visit_diagnoses(visit_id, diagnosis_id)`, `patient_allergies(patient_id, allergen_id)` |
| Atributo multivaluado | Relación aparte | `patient_family_histories`, `patient_personal_histories` |
| Dominio cerrado pequeño | `ENUM` / `CHECK` | `eye`, `status`, `method`, `relationship`… |
| Dominio que puede crecer | Catálogo con FK | `cities`, `specialties`, `glaucoma_types`, `procedure_types`… |

## Relaciones

**DOCUMENT_TYPES**(<u>id</u>, code, name)

> `UNIQUE(code)`

**CITIES**(<u>id</u>, name, department)

> `UNIQUE(name, department)`

**SPECIALTIES**(<u>id</u>, name)

> `UNIQUE(name)`

**ALLERGENS**(<u>id</u>, name)

> `UNIQUE(name)`

**HISTORY_TYPES**(<u>id</u>, name)

> `UNIQUE(name)`

**DIAGNOSES**(<u>id</u>, code, name, is_glaucoma)

> `UNIQUE(code)`

**GLAUCOMA_TYPES**(<u>id</u>, name)

> `UNIQUE(name)`

**MEDICATIONS**(<u>id</u>, name, active_ingredient, presentation, is_active)

> `UNIQUE(name)`

**PROCEDURE_TYPES**(<u>id</u>, name, category)

> `UNIQUE(name)`

**PATIENTS**(<u>id</u>, document_type_id (FK → document_types.id), document_number, first_name, last_name, birth_date, sex, email, phone, address, city_id (FK → cities.id), created_at, updated_at)

> `UNIQUE(document_number)`

**CLINICAL_HISTORIES**(<u>id</u>, patient_id (FK → patients.id), history_number, opened_at, status, updated_at)

> `UNIQUE(history_number)` · `UNIQUE(patient_id)`

**HEALTHCARE_PROFESSIONALS**(<u>id</u>, document_number, first_name, last_name, specialty_id (FK → specialties.id), license_number, email, phone, is_active, created_at, updated_at)

> `UNIQUE(document_number)` · `UNIQUE(license_number)`

**PATIENT_ALLERGIES**(<u>patient_id</u> (FK → patients.id), <u>allergen_id</u> (FK → allergens.id), reaction)

**PATIENT_FAMILY_HISTORIES**(<u>id</u>, patient_id (FK → patients.id), diagnosis_id (FK → diagnoses.id), relationship)

> `UNIQUE(patient_id, diagnosis_id, relationship)`

**PATIENT_PERSONAL_HISTORIES**(<u>id</u>, patient_id (FK → patients.id), history_type_id (FK → history_types.id), description, recorded_at)

**MEDICAL_VISITS**(<u>id</u>, clinical_history_id (FK → clinical_histories.id), professional_id (FK → healthcare_professionals.id), visit_date, reason, assessment, plan, observations, is_closed, created_at, updated_at)

**VISIT_DIAGNOSES**(<u>visit_id</u> (FK → medical_visits.id), <u>diagnosis_id</u> (FK → diagnoses.id), eye, is_primary)

**OPHTHALMOLOGIC_EXAMS**(<u>id</u>, visit_id (FK → medical_visits.id), eye, visual_acuity, cup_disc_ratio, anterior_segment, fundus)

> `UNIQUE(visit_id, eye)` · `CHECK cup_disc_ratio between 0 and 1`

**INTRAOCULAR_PRESSURES**(<u>id</u>, visit_id (FK → medical_visits.id), eye, pressure, method, measured_at)

> `CHECK pressure >= 0 and pressure <= 80`

**PACHYMETRY_EXAMS**(<u>id</u>, visit_id (FK → medical_visits.id), eye, thickness_um, exam_date)

> `CHECK thickness_um > 0`

**GONIOSCOPY_EXAMS**(<u>id</u>, visit_id (FK → medical_visits.id), eye, shaffer_grade, findings, exam_date)

> `CHECK shaffer_grade between 0 and 4`

**OCT_EXAMS**(<u>id</u>, visit_id (FK → medical_visits.id), eye, rnfl_average, cup_disc_ratio, interpretation, is_validated, exam_date, updated_at)

> `CHECK rnfl_average > 0`

**VISUAL_FIELD_EXAMS**(<u>id</u>, visit_id (FK → medical_visits.id), eye, md, psd, vfi, reliability, interpretation, exam_date, updated_at)

> `CHECK vfi between 0 and 100` · `CHECK psd >= 0`

**GLAUCOMA_RECORDS**(<u>id</u>, patient_id (FK → patients.id), glaucoma_type_id (FK → glaucoma_types.id), diagnosis_date, target_pressure, clinical_status, updated_at)

> `UNIQUE(patient_id)` · `CHECK target_pressure > 0`

**GLAUCOMA_CONTROLS**(<u>id</u>, glaucoma_record_id (FK → glaucoma_records.id), visit_id (FK → medical_visits.id), control_date, progression_detected, notes)

> `UNIQUE(visit_id)`

**TREATMENTS**(<u>id</u>, visit_id (FK → medical_visits.id), medication_id (FK → medications.id), eye, dosage, frequency, start_date, end_date, status, updated_at)

> `CHECK end_date is null or end_date >= start_date`

**PROCEDURES**(<u>id</u>, visit_id (FK → medical_visits.id), procedure_type_id (FK → procedure_types.id), eye, performed_at, notes)

**CLINICAL_DOCUMENTS**(<u>id</u>, clinical_history_id (FK → clinical_histories.id), document_kind, file_name, file_path, uploaded_at)

**AUDIT_LOGS**(<u>id</u>, table_name, record_id, action, old_values, new_values, changed_by, changed_at)

> `CHECK json_valid(old_values)` · `CHECK json_valid(new_values)`

**CLINICAL_ALERTS**(<u>id</u>, patient_id (FK → patients.id), alert_type, message, is_read, created_at)

## Resumen de claves foráneas

| Tabla hija | FK | Tabla padre | Cardinalidad |
|---|---|---|---|
| patients | document_type_id | document_types | N:1 |
| patients | city_id (opcional) | cities | N:0..1 |
| clinical_histories | patient_id (único) | patients | 1:1 |
| healthcare_professionals | specialty_id | specialties | N:1 |
| patient_allergies | patient_id / allergen_id | patients / allergens | N:M |
| patient_family_histories | patient_id / diagnosis_id | patients / diagnoses | N:1 / N:1 |
| patient_personal_histories | patient_id / history_type_id | patients / history_types | N:1 / N:1 |
| medical_visits | clinical_history_id / professional_id | clinical_histories / healthcare_professionals | N:1 / N:1 |
| visit_diagnoses | visit_id / diagnosis_id | medical_visits / diagnoses | N:M |
| ophthalmologic_exams | visit_id | medical_visits | N:1 (máx. 1 por ojo) |
| intraocular_pressures | visit_id | medical_visits | N:1 |
| pachymetry_exams | visit_id | medical_visits | N:1 |
| gonioscopy_exams | visit_id | medical_visits | N:1 |
| oct_exams | visit_id | medical_visits | N:1 |
| visual_field_exams | visit_id | medical_visits | N:1 |
| glaucoma_records | patient_id (único) / glaucoma_type_id | patients / glaucoma_types | 1:1 / N:1 |
| glaucoma_controls | glaucoma_record_id / visit_id (único) | glaucoma_records / medical_visits | N:1 / 1:1 |
| treatments | visit_id / medication_id | medical_visits / medications | N:1 / N:1 |
| procedures | visit_id / procedure_type_id | medical_visits / procedure_types | N:1 / N:1 |
| clinical_documents | clinical_history_id | clinical_histories | N:1 |
| clinical_alerts | patient_id | patients | N:1 |

Todas las FK usan el comportamiento por defecto (`RESTRICT`): no se puede borrar un padre que tenga hijos. Es intencional en datos clínicos: un borrado nunca debe arrastrar en cascada consultas o exámenes.

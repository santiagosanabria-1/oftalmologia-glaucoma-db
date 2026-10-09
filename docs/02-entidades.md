# 2. Identificación de entidades

El esquema final (`sql/01_schema.sql`) tiene **30 tablas**. Las entidades preliminares del taller se validaron y refinaron así:

- `medical_histories` del taller se dividió en tres tablas para cumplir 4FN: `patient_personal_histories`, `patient_family_histories` y `patient_allergies` (ver `docs/07-normalizacion.md`).
- Se agregaron catálogos para evitar texto libre repetido: `document_types`, `cities`, `allergens`, `history_types`, `glaucoma_types` y `procedure_types`.
- Se agregó `clinical_alerts` para notificaciones internas generadas por triggers y eventos.

## Catálogos

| Entidad | Descripción | Relaciones |
|---|---|---|
| `document_types` | Tipos de documento de identidad (CC, TI, CE, PA). | 1:N con `patients`. |
| `cities` | Ciudades con su departamento. | 1:N con `patients`. |
| `specialties` | Especialidades de los profesionales (Glaucoma, Oftalmología, Retina, Optometría). | 1:N con `healthcare_professionals`. |
| `allergens` | Sustancias que pueden causar alergia. | N:M con `patients` mediante `patient_allergies`. |
| `history_types` | Tipos de antecedente personal (sistémico, ocular, quirúrgico, farmacológico). | 1:N con `patient_personal_histories`. |
| `diagnoses` | Catálogo de diagnósticos con código CIE-10 e indicador `is_glaucoma`. | N:M con `medical_visits` mediante `visit_diagnoses`; 1:N con `patient_family_histories`. |
| `glaucoma_types` | Tipos de glaucoma (ángulo abierto, cerrado, normotensivo, secundario, congénito). | 1:N con `glaucoma_records`. |
| `medications` | Medicamentos con principio activo, presentación y estado. | 1:N con `treatments`. |
| `procedure_types` | Tipos de procedimiento con categoría (QUIRURGICO, LASER, DIAGNOSTICO). | 1:N con `procedures`. |

## Personas e historia clínica

| Entidad | Descripción | Relaciones |
|---|---|---|
| `patients` | Datos personales del paciente. | N:1 con `document_types` y `cities`; 1:1 con `clinical_histories`; 1:0..1 con `glaucoma_records`; 1:N con antecedentes, alergias y alertas. |
| `clinical_histories` | Historia clínica única de cada paciente (número HC, fecha de apertura, estado). | 1:1 con `patients`; 1:N con `medical_visits` y `clinical_documents`. |
| `healthcare_professionals` | Médicos y optómetras que atienden consultas. | N:1 con `specialties`; 1:N con `medical_visits`. |

## Antecedentes

| Entidad | Descripción | Relaciones |
|---|---|---|
| `patient_allergies` | Entidad asociativa paciente–alérgeno con la reacción observada. | N:1 con `patients` y `allergens`. |
| `patient_family_histories` | Antecedentes familiares: diagnóstico y parentesco. | N:1 con `patients` y `diagnoses`. |
| `patient_personal_histories` | Antecedentes personales descritos por tipo. | N:1 con `patients` y `history_types`. |

## Atención clínica

| Entidad | Descripción | Relaciones |
|---|---|---|
| `medical_visits` | Consulta médica: fecha, motivo, valoración, plan, observaciones y si está cerrada. | N:1 con `clinical_histories` y `healthcare_professionals`; 1:N con diagnósticos, exámenes, PIO, tratamientos y procedimientos; 1:0..1 con `glaucoma_controls`. |
| `visit_diagnoses` | Entidad asociativa consulta–diagnóstico, con ojo afectado y si es el principal. | N:1 con `medical_visits` y `diagnoses`. |

## Exámenes (todos ligados a una consulta)

| Entidad | Descripción | Relaciones |
|---|---|---|
| `ophthalmologic_exams` | Examen general por ojo: agudeza visual, relación copa/disco, segmento anterior y fondo de ojo. Máximo uno por ojo y consulta. | N:1 con `medical_visits`. |
| `intraocular_pressures` | Mediciones de PIO por ojo, con método y fecha/hora. | N:1 con `medical_visits`. |
| `pachymetry_exams` | Espesor corneal central (µm) por ojo. | N:1 con `medical_visits`. |
| `gonioscopy_exams` | Grado de Shaffer (0–4) del ángulo por ojo. | N:1 con `medical_visits`. |
| `oct_exams` | Tomografía de coherencia óptica: RNFL promedio, copa/disco, interpretación y si está validado. | N:1 con `medical_visits`. |
| `visual_field_exams` | Campo visual: MD, PSD, VFI y confiabilidad. | N:1 con `medical_visits`. |

## Glaucoma

| Entidad | Descripción | Relaciones |
|---|---|---|
| `glaucoma_records` | Registro de glaucoma del paciente: tipo, fecha de diagnóstico, presión objetivo y estado clínico. Uno por paciente. | 1:1 con `patients`; N:1 con `glaucoma_types`; 1:N con `glaucoma_controls`. |
| `glaucoma_controls` | Control de seguimiento ligado a una consulta, con indicador de progresión. | N:1 con `glaucoma_records`; 1:1 con `medical_visits`. |

## Tratamientos y procedimientos

| Entidad | Descripción | Relaciones |
|---|---|---|
| `treatments` | Medicamento formulado en una consulta: ojo, dosis, frecuencia, fechas y estado. | N:1 con `medical_visits` y `medications`. |
| `procedures` | Procedimiento realizado (láser, cirugía, diagnóstico) por ojo y fecha. | N:1 con `medical_visits` y `procedure_types`. |

## Soporte

| Entidad | Descripción | Relaciones |
|---|---|---|
| `clinical_documents` | Archivos adjuntos a la historia (reportes, consentimientos, epicrisis). | N:1 con `clinical_histories`. |
| `audit_logs` | Bitácora de cambios: tabla, registro, acción y valores anterior/nuevo en JSON. La llenan los triggers. | Sin FK: guarda referencias lógicas para conservar el registro aunque la fila original se borre. |
| `clinical_alerts` | Alertas internas por paciente (PIO alta, control vencido, etc.). | N:1 con `patients`. |

## Decisión de diseño importante

Los exámenes, la PIO, los tratamientos y los procedimientos **no guardan `patient_id`**: cuelgan de `medical_visits`, y el paciente se obtiene por `medical_visits → clinical_histories → patients`. Así un dato clínico siempre queda asociado a la consulta, la fecha y el profesional que lo generó, y el paciente no se repite en cada tabla (evita la dependencia transitiva `visit_id → patient_id`).

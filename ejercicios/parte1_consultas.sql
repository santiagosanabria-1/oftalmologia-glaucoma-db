-- =====================================================================
-- PARTE I — 50 ejercicios de consultas SQL
-- Requiere: sql/01_schema.sql a sql/07_events.sql. MariaDB 10.4+.
--
-- Nota del esquema: los exámenes, la PIO, los tratamientos y los
-- procedimientos no tienen patient_id; el paciente se obtiene con
-- tabla → medical_visits → clinical_histories → patients.
-- =====================================================================

USE oftalmologia_glaucoma;

-- Ejercicio 1: Mostrar todos los pacientes registrados en la base de datos.
SELECT *
FROM patients;

-- Ejercicio 2: Mostrar únicamente el número de documento, nombres y apellidos de todos los pacientes.
SELECT document_number,
       first_name,
       last_name
FROM patients;

-- Ejercicio 3: Listar todos los profesionales de salud registrados.
SELECT *
FROM healthcare_professionals;

-- Ejercicio 4: Mostrar todos los diagnósticos disponibles en el catálogo.
SELECT *
FROM diagnoses;

-- Ejercicio 5: Consultar todas las historias clínicas registradas.
SELECT *
FROM clinical_histories;

-- Ejercicio 6: Mostrar todos los pacientes ordenados alfabéticamente por apellido.
SELECT *
FROM patients
ORDER BY last_name, first_name;

-- Ejercicio 7: Mostrar los pacientes ordenados por fecha de nacimiento desde el más joven hasta el de mayor edad.
SELECT *
FROM patients
ORDER BY birth_date DESC;

-- Ejercicio 8: Consultar los pacientes cuyo apellido sea `Gómez`.
SELECT *
FROM patients
WHERE last_name = 'Gómez';

-- Ejercicio 9: Mostrar los pacientes cuyo número de documento comience por `10`.
SELECT *
FROM patients
WHERE document_number LIKE '10%';

-- Ejercicio 10: Consultar los pacientes cuyo correo electrónico pertenezca al dominio `gmail.com`.
SELECT *
FROM patients
WHERE email LIKE '%@gmail.com';

-- Ejercicio 11: Mostrar los pacientes que no tengan correo electrónico registrado.
SELECT *
FROM patients
WHERE email IS NULL;

-- Ejercicio 12: Mostrar los profesionales cuya especialidad sea Oftalmología.
SELECT hp.first_name,
       hp.last_name,
       s.name AS specialty
FROM healthcare_professionals hp
INNER JOIN specialties s ON hp.specialty_id = s.id
WHERE s.name = 'Oftalmología';

-- Ejercicio 13: Consultar todas las consultas médicas realizadas durante el año 2026.
SELECT *
FROM medical_visits
WHERE visit_date >= '2026-01-01'
  AND visit_date < '2027-01-01';

-- Ejercicio 14: Mostrar las consultas realizadas durante un mes determinado.
-- Mes de ejemplo: junio de 2026.
SELECT *
FROM medical_visits
WHERE YEAR(visit_date) = 2026
  AND MONTH(visit_date) = 6;

-- Ejercicio 15: Consultar las mediciones de presión intraocular superiores a 20 mmHg.
SELECT *
FROM intraocular_pressures
WHERE pressure > 20;

-- Ejercicio 16: Mostrar las mediciones de presión intraocular correspondientes únicamente al ojo derecho.
SELECT *
FROM intraocular_pressures
WHERE eye = 'OD';

-- Ejercicio 17: Mostrar las mediciones correspondientes únicamente al ojo izquierdo.
SELECT *
FROM intraocular_pressures
WHERE eye = 'OI';

-- Ejercicio 18: Consultar todos los tratamientos que se encuentren activos.
SELECT *
FROM treatments
WHERE status = 'ACTIVO';

-- Ejercicio 19: Mostrar todos los tratamientos que hayan finalizado.
SELECT *
FROM treatments
WHERE status = 'FINALIZADO';

-- Ejercicio 20: Consultar los procedimientos realizados después de una fecha determinada.
-- Fecha de ejemplo: 1 de enero de 2026.
SELECT *
FROM procedures
WHERE performed_at > '2026-01-01';

-- Ejercicio 21: Mostrar cada paciente junto con el número de su historia clínica.
SELECT p.first_name,
       p.last_name,
       ch.history_number
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id;

-- Ejercicio 22: Mostrar cada consulta indicando el nombre completo del paciente.
SELECT mv.id,
       mv.visit_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient
FROM medical_visits mv
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id;

-- Ejercicio 23: Mostrar cada consulta junto con el nombre del profesional que la realizó.
SELECT mv.id,
       mv.visit_date,
       CONCAT(hp.first_name, ' ', hp.last_name) AS professional
FROM medical_visits mv
INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id;

-- Ejercicio 24: Listar todos los pacientes junto con la fecha de sus consultas.
-- LEFT JOIN para incluir también a los pacientes sin consultas (fecha NULL).
SELECT p.first_name,
       p.last_name,
       mv.visit_date
FROM patients p
LEFT JOIN clinical_histories ch ON p.id = ch.patient_id
LEFT JOIN medical_visits mv ON ch.id = mv.clinical_history_id
ORDER BY p.last_name, mv.visit_date;

-- Ejercicio 25: Mostrar los diagnósticos asociados a cada consulta.
SELECT mv.id AS visit_id,
       mv.visit_date,
       d.code,
       d.name AS diagnosis
FROM medical_visits mv
INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
ORDER BY mv.id;

-- Ejercicio 26: Mostrar nombre del paciente, fecha de consulta y diagnóstico correspondiente.
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       mv.visit_date,
       d.name AS diagnosis
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
ORDER BY patient, mv.visit_date;

-- Ejercicio 27: Consultar todos los pacientes que tengan diagnóstico de glaucoma.
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

-- Ejercicio 28: Mostrar todos los controles de glaucoma indicando el paciente correspondiente.
SELECT gc.id,
       gc.control_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient,
       gc.progression_detected,
       gc.notes
FROM glaucoma_controls gc
INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
INNER JOIN patients p ON g.patient_id = p.id
ORDER BY gc.control_date;

-- Ejercicio 29: Mostrar cada medición de presión intraocular junto con nombre del paciente, fecha y ojo.
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       ip.measured_at,
       ip.eye,
       ip.pressure
FROM intraocular_pressures ip
INNER JOIN medical_visits mv ON ip.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY p.last_name, ip.measured_at, ip.eye;

-- Ejercicio 30: Mostrar los estudios OCT realizados indicando paciente, ojo y fecha.
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       o.eye,
       o.exam_date
FROM oct_exams o
INNER JOIN medical_visits mv ON o.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY o.exam_date, patient, o.eye;

-- Ejercicio 31: Mostrar los campos visuales registrados indicando paciente, ojo, MD, PSD y VFI.
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

-- Ejercicio 32: Mostrar las paquimetrías realizadas junto con el paciente y el espesor corneal registrado.
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       pe.eye,
       pe.exam_date,
       pe.thickness_um
FROM pachymetry_exams pe
INNER JOIN medical_visits mv ON pe.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
ORDER BY pe.exam_date, patient, pe.eye;

-- Ejercicio 33: Mostrar los tratamientos activos incluyendo nombre del paciente y medicamento.
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

-- Ejercicio 34: Mostrar cada medicamento y la cantidad de tratamientos en los que ha sido utilizado.
SELECT m.name,
       COUNT(t.id) AS total_treatments
FROM medications m
LEFT JOIN treatments t ON m.id = t.medication_id
GROUP BY m.id, m.name
ORDER BY total_treatments DESC, m.name;

-- Ejercicio 35: Mostrar la cantidad total de pacientes registrados.
SELECT COUNT(*) AS total_patients
FROM patients;

-- Ejercicio 36: Mostrar la cantidad de consultas realizadas.
SELECT COUNT(*) AS total_visits
FROM medical_visits;

-- Ejercicio 37: Mostrar la cantidad de pacientes por sexo.
SELECT sex,
       COUNT(*) AS total
FROM patients
GROUP BY sex;

-- Ejercicio 38: Mostrar la cantidad de pacientes atendidos por cada profesional.
SELECT hp.first_name,
       hp.last_name,
       COUNT(DISTINCT ch.patient_id) AS total_patients
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv ON hp.id = mv.professional_id
LEFT JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
GROUP BY hp.id, hp.first_name, hp.last_name
ORDER BY total_patients DESC;

-- Ejercicio 39: Calcular el promedio general de presión intraocular.
SELECT ROUND(AVG(pressure), 2) AS average_pressure
FROM intraocular_pressures;

-- Ejercicio 40: Calcular la presión intraocular mínima y máxima registrada.
SELECT MIN(pressure) AS minimum_pressure,
       MAX(pressure) AS maximum_pressure
FROM intraocular_pressures;

-- Ejercicio 41: Calcular la presión intraocular promedio para OD y OI por separado.
SELECT eye,
       ROUND(AVG(pressure), 2) AS average_pressure
FROM intraocular_pressures
GROUP BY eye;

-- Ejercicio 42: Mostrar la cantidad de consultas realizadas por cada paciente.
SELECT p.id,
       p.first_name,
       p.last_name,
       COUNT(mv.id) AS total_visits
FROM patients p
LEFT JOIN clinical_histories ch ON p.id = ch.patient_id
LEFT JOIN medical_visits mv ON ch.id = mv.clinical_history_id
GROUP BY p.id, p.first_name, p.last_name
ORDER BY total_visits DESC, p.last_name;

-- Ejercicio 43: Mostrar únicamente los pacientes que tengan tres o más consultas.
SELECT p.id,
       p.first_name,
       p.last_name,
       COUNT(mv.id) AS total_visits
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(mv.id) >= 3;

-- Ejercicio 44: Mostrar cada profesional junto con la cantidad de consultas realizadas.
SELECT hp.first_name,
       hp.last_name,
       COUNT(mv.id) AS total_visits
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv ON hp.id = mv.professional_id
GROUP BY hp.id, hp.first_name, hp.last_name
ORDER BY total_visits DESC;

-- Ejercicio 45: Mostrar los profesionales que hayan realizado más de 20 consultas.
-- Devuelve 0 filas con el seed: hay 30 consultas repartidas entre 5 profesionales
-- y los que más tienen suman 10 (Laura Martínez y Andrés Rojas). Con HAVING COUNT(mv.id) > 5 aparecen 3.
SELECT hp.first_name,
       hp.last_name,
       COUNT(mv.id) AS total_visits
FROM healthcare_professionals hp
INNER JOIN medical_visits mv ON hp.id = mv.professional_id
GROUP BY hp.id, hp.first_name, hp.last_name
HAVING COUNT(mv.id) > 20;

-- Ejercicio 46: Calcular la cantidad de diagnósticos registrados por tipo de diagnóstico.
SELECT d.code,
       d.name,
       COUNT(vd.visit_id) AS total
FROM diagnoses d
LEFT JOIN visit_diagnoses vd ON d.id = vd.diagnosis_id
GROUP BY d.id, d.code, d.name
ORDER BY total DESC;

-- Ejercicio 47: Mostrar los cinco diagnósticos más frecuentes.
SELECT d.name,
       COUNT(*) AS total
FROM visit_diagnoses vd
INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
GROUP BY d.id, d.name
ORDER BY total DESC
LIMIT 5;

-- Ejercicio 48: Mostrar la cantidad de estudios OCT realizados por mes.
SELECT YEAR(exam_date) AS year,
       MONTH(exam_date) AS month,
       COUNT(*) AS total_oct
FROM oct_exams
GROUP BY YEAR(exam_date), MONTH(exam_date)
ORDER BY year, month;

-- Ejercicio 49: Mostrar la cantidad de campos visuales realizados por año.
SELECT YEAR(exam_date) AS year,
       COUNT(*) AS total_visual_fields
FROM visual_field_exams
GROUP BY YEAR(exam_date)
ORDER BY year;

-- Ejercicio 50: Generar un reporte que muestre por paciente: nombre completo, número de consultas, cantidad de controles de glaucoma, promedio de PIO y fecha de última consulta.
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

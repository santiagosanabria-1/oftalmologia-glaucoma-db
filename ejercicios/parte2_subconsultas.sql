-- =====================================================================
-- PARTE II — 50 ejercicios de subconsultas
-- Requiere: sql/01_schema.sql a sql/07_events.sql. MariaDB 10.4+.
--
-- Varias consultas de PIO usan la vista vw_patient_iop_history
-- (sql/03_views.sql), que ya trae el patient_id de cada medición.
-- El resto obtiene el paciente con medical_visits → clinical_histories.
-- =====================================================================

USE oftalmologia_glaucoma;

-- Ejercicio 1: Mostrar los pacientes cuya edad sea superior a la edad promedio de todos los pacientes.
SELECT id,
       first_name,
       last_name,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM patients
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > (
    SELECT AVG(TIMESTAMPDIFF(YEAR, birth_date, CURDATE()))
    FROM patients
);

-- Ejercicio 2: Mostrar los pacientes cuya edad sea inferior a la edad promedio.
SELECT id,
       first_name,
       last_name,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM patients
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < (
    SELECT AVG(TIMESTAMPDIFF(YEAR, birth_date, CURDATE()))
    FROM patients
);

-- Ejercicio 3: Consultar la medición de presión intraocular más alta registrada.
SELECT (
    SELECT MAX(pressure)
    FROM intraocular_pressures
) AS max_pressure;

-- Ejercicio 4: Mostrar todas las mediciones que tengan el mismo valor que la presión máxima registrada.
SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MAX(pressure)
    FROM intraocular_pressures
);

-- Ejercicio 5: Mostrar la presión intraocular mínima registrada.
SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MIN(pressure)
    FROM intraocular_pressures
);

-- Ejercicio 6: Mostrar los estudios OCT cuyo RNFL sea inferior al promedio general.
SELECT *
FROM oct_exams
WHERE rnfl_average < (
    SELECT AVG(rnfl_average)
    FROM oct_exams
);

-- Ejercicio 7: Mostrar los estudios OCT cuyo RNFL sea superior al promedio general.
SELECT *
FROM oct_exams
WHERE rnfl_average > (
    SELECT AVG(rnfl_average)
    FROM oct_exams
);

-- Ejercicio 8: Consultar pacientes cuya cantidad de consultas sea mayor que el promedio de consultas por paciente.
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

-- Ejercicio 9: Mostrar profesionales cuya cantidad de consultas sea superior al promedio por profesional.
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

-- Ejercicio 10: Consultar pacientes cuya última presión intraocular sea superior al promedio general.
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

-- Ejercicio 11: Mostrar pacientes que tengan al menos una consulta registrada.
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
);

-- Ejercicio 12: Mostrar pacientes que tengan diagnóstico de glaucoma.
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

-- Ejercicio 13: Mostrar pacientes que hayan recibido tratamiento farmacológico.
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);

-- Ejercicio 14: Mostrar pacientes que tengan estudios OCT registrados.
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);

-- Ejercicio 15: Mostrar pacientes que tengan campos visuales registrados.
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);

-- Ejercicio 16: Mostrar medicamentos que hayan sido utilizados en al menos un tratamiento.
SELECT *
FROM medications
WHERE id IN (
    SELECT medication_id
    FROM treatments
);

-- Ejercicio 17: Mostrar profesionales que hayan atendido pacientes con glaucoma.
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

-- Ejercicio 18: Mostrar diagnósticos utilizados en alguna consulta.
SELECT *
FROM diagnoses
WHERE id IN (
    SELECT diagnosis_id
    FROM visit_diagnoses
);

-- Ejercicio 19: Mostrar pacientes que hayan tenido algún procedimiento quirúrgico.
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

-- Ejercicio 20: Mostrar pacientes que tengan registros de paquimetría.
SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM pachymetry_exams pe
    INNER JOIN medical_visits mv ON pe.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
);

-- Ejercicio 21: Mostrar pacientes que nunca hayan tenido una consulta.
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p.id
);

-- Ejercicio 22: Mostrar pacientes que nunca hayan tenido un control de glaucoma.
SELECT *
FROM patients
WHERE id NOT IN (
    SELECT g.patient_id
    FROM glaucoma_records g
    INNER JOIN glaucoma_controls gc ON gc.glaucoma_record_id = g.id
);

-- Ejercicio 23: Mostrar pacientes que no tengan estudios OCT.
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);

-- Ejercicio 24: Mostrar pacientes que no tengan campos visuales.
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);

-- Ejercicio 25: Mostrar medicamentos que nunca hayan sido utilizados.
-- Se usa NOT EXISTS porque NOT IN falla si la subconsulta devuelve algún NULL.
SELECT *
FROM medications m
WHERE NOT EXISTS (
    SELECT 1
    FROM treatments t
    WHERE t.medication_id = m.id
);

-- Ejercicio 26: Mostrar profesionales que todavía no hayan registrado consultas.
SELECT *
FROM healthcare_professionals hp
WHERE NOT EXISTS (
    SELECT 1
    FROM medical_visits mv
    WHERE mv.professional_id = hp.id
);

-- Ejercicio 27: Mostrar diagnósticos que nunca hayan sido asociados a una consulta.
SELECT *
FROM diagnoses d
WHERE NOT EXISTS (
    SELECT 1
    FROM visit_diagnoses vd
    WHERE vd.diagnosis_id = d.id
);

-- Ejercicio 28: Mostrar pacientes que no tengan tratamientos activos.
SELECT *
FROM patients
WHERE id NOT IN (
    SELECT ch.patient_id
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE t.status = 'ACTIVO'
);

-- Ejercicio 29: Mostrar pacientes que nunca hayan tenido procedimientos.
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM procedures pr
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);

-- Ejercicio 30: Mostrar pacientes sin mediciones de presión intraocular.
SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p.id
);

-- Ejercicio 31: Mostrar las mediciones de PIO superiores al promedio del mismo paciente.
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

-- Ejercicio 32: Mostrar los estudios OCT cuyo RNFL sea inferior al promedio del mismo paciente.
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

-- Ejercicio 33: Mostrar las consultas posteriores a la primera consulta de cada paciente.
SELECT *
FROM medical_visits mv
WHERE mv.visit_date > (
    SELECT MIN(mv2.visit_date)
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = mv.clinical_history_id
);

-- Ejercicio 34: Mostrar la última consulta de cada paciente utilizando una subconsulta correlacionada.
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

-- Ejercicio 35: Mostrar la primera medición de PIO de cada paciente.
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

-- Ejercicio 36: Mostrar la última medición de presión intraocular de cada paciente y ojo.
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

-- Ejercicio 37: Mostrar los tratamientos cuya fecha de inicio sea posterior a la primera consulta del paciente.
SELECT t.*
FROM treatments t
INNER JOIN medical_visits mv ON t.visit_id = mv.id
WHERE t.start_date > (
    SELECT DATE(MIN(mv2.visit_date))
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = mv.clinical_history_id
);

-- Ejercicio 38: Mostrar pacientes cuyo número de consultas sea mayor que el de todos los demás pacientes de su misma ciudad.
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

-- Ejercicio 39: Mostrar profesionales cuya cantidad de consultas sea superior al promedio de los profesionales de su especialidad.
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

-- Ejercicio 40: Mostrar el estudio OCT más reciente de cada paciente.
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

-- Ejercicio 41: Mostrar pacientes cuya presión intraocular máxima sea mayor que la presión máxima promedio de todos los pacientes.
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

-- Ejercicio 42: Mostrar pacientes cuya cantidad de diagnósticos diferentes sea superior al promedio.
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

-- Ejercicio 43: Mostrar los pacientes que tengan más tratamientos activos que el promedio de tratamientos activos por paciente.
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

-- Ejercicio 44: Mostrar el medicamento más utilizado en tratamientos.
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

-- Ejercicio 45: Mostrar el diagnóstico más frecuente utilizando subconsultas.
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

-- Ejercicio 46: Mostrar los pacientes cuya última PIO sea inferior a su primera PIO.
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

-- Ejercicio 47: Mostrar pacientes cuya presión promedio del ojo derecho sea mayor que la del ojo izquierdo.
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

-- Ejercicio 48: Mostrar los pacientes con mayor cantidad de controles de glaucoma que el promedio general.
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

-- Ejercicio 49: Mostrar las consultas que tengan más diagnósticos asociados que el promedio de diagnósticos por consulta.
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

-- Ejercicio 50: Mostrar los pacientes que tengan simultáneamente OCT, campo visual, paquimetría y control de glaucoma registrados.
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

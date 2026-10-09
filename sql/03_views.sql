-- =====================================================================
-- 03_views.sql — Vistas para consultas recurrentes
-- Requiere: 01_schema.sql y 02_seed.sql. Compatible con MariaDB 10.4+.
-- =====================================================================

USE oftalmologia_glaucoma;

-- ---------------------------------------------------------------------
-- vw_patient_last_visit: última consulta de cada paciente (sección 37
-- del taller). Solo aparecen pacientes con al menos una consulta.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_patient_last_visit AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient,
    ch.history_number,
    COUNT(mv.id) AS total_visits,
    MAX(mv.visit_date) AS last_visit
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
GROUP BY p.id, p.first_name, p.last_name, ch.history_number;

-- ---------------------------------------------------------------------
-- vw_patient_iop_history: cada medición de PIO con su paciente, consulta
-- y profesional. Evita repetir la cadena de JOIN
-- intraocular_pressures → medical_visits → clinical_histories → patients.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_patient_iop_history AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient,
    mv.id AS visit_id,
    mv.visit_date,
    CONCAT(hp.first_name, ' ', hp.last_name) AS professional,
    ip.id AS iop_id,
    ip.eye,
    ip.pressure,
    ip.method,
    ip.measured_at
FROM intraocular_pressures ip
INNER JOIN medical_visits mv ON ip.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id;

-- ---------------------------------------------------------------------
-- vw_glaucoma_status: tablero de pacientes con glaucoma. Muestra la
-- última PIO de cada ojo y si supera la presión objetivo.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_glaucoma_status AS
SELECT
    g.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient,
    gt.name AS glaucoma_type,
    g.diagnosis_date,
    g.target_pressure,
    g.clinical_status,
    (SELECT COUNT(*) FROM glaucoma_controls gc WHERE gc.glaucoma_record_id = g.id) AS total_controls,
    (SELECT MAX(gc.control_date) FROM glaucoma_controls gc WHERE gc.glaucoma_record_id = g.id) AS last_control_date,
    x.last_iop_od,
    x.last_iop_oi,
    CASE
        WHEN GREATEST(IFNULL(x.last_iop_od, 0), IFNULL(x.last_iop_oi, 0)) > g.target_pressure THEN 'SOBRE OBJETIVO'
        ELSE 'EN OBJETIVO'
    END AS iop_vs_target
FROM glaucoma_records g
INNER JOIN patients p ON g.patient_id = p.id
INNER JOIN glaucoma_types gt ON g.glaucoma_type_id = gt.id
LEFT JOIN (
    SELECT
        ch.patient_id,
        (SELECT ip.pressure
         FROM intraocular_pressures ip
         INNER JOIN medical_visits mv ON ip.visit_id = mv.id
         WHERE mv.clinical_history_id = ch.id AND ip.eye = 'OD'
         ORDER BY ip.measured_at DESC, ip.id DESC
         LIMIT 1) AS last_iop_od,
        (SELECT ip.pressure
         FROM intraocular_pressures ip
         INNER JOIN medical_visits mv ON ip.visit_id = mv.id
         WHERE mv.clinical_history_id = ch.id AND ip.eye = 'OI'
         ORDER BY ip.measured_at DESC, ip.id DESC
         LIMIT 1) AS last_iop_oi
    FROM clinical_histories ch
) x ON x.patient_id = g.patient_id;

-- ---------------------------------------------------------------------
-- vw_active_treatments: tratamientos activos con paciente, medicamento
-- y profesional que los formuló.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_active_treatments AS
SELECT
    t.id AS treatment_id,
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient,
    m.name AS medication,
    m.active_ingredient,
    t.eye,
    t.dosage,
    t.frequency,
    t.start_date,
    DATEDIFF(CURDATE(), t.start_date) AS days_on_treatment,
    CONCAT(hp.first_name, ' ', hp.last_name) AS prescribed_by
FROM treatments t
INNER JOIN medications m ON t.medication_id = m.id
INNER JOIN medical_visits mv ON t.visit_id = mv.id
INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
INNER JOIN patients p ON ch.patient_id = p.id
INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id
WHERE t.status = 'ACTIVO';

-- Pruebas rápidas
SELECT * FROM vw_patient_last_visit ORDER BY last_visit DESC;
SELECT * FROM vw_patient_iop_history WHERE patient_id = 1 ORDER BY measured_at, eye;
SELECT * FROM vw_glaucoma_status;
SELECT * FROM vw_active_treatments ORDER BY patient, start_date;

-- =====================================================================
-- 05_procedures.sql — Procedimientos almacenados del proyecto
-- Requiere: 01_schema.sql y 02_seed.sql. Compatible con MariaDB 10.4+.
-- =====================================================================

USE oftalmologia_glaucoma;

-- ---------------------------------------------------------------------
-- sp_get_patient_visits: consultas de un paciente, de la más reciente a
-- la más antigua, con profesional y diagnóstico principal (sección 32
-- del taller, ampliado).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_get_patient_visits;

DELIMITER $$

CREATE PROCEDURE sp_get_patient_visits(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    SELECT
        mv.id AS visit_id,
        mv.visit_date,
        mv.reason,
        CONCAT(hp.first_name, ' ', hp.last_name) AS professional,
        (SELECT d.name
         FROM visit_diagnoses vd
         INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
         WHERE vd.visit_id = mv.id AND vd.is_primary = TRUE
         LIMIT 1) AS primary_diagnosis,
        mv.is_closed
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY mv.visit_date DESC;
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- sp_register_iop: registra una medición de PIO validando consulta, ojo,
-- rango y método. Si p_measured_at es NULL se usa la fecha de la consulta.
-- Devuelve el id generado.
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_register_iop;

DELIMITER $$

CREATE PROCEDURE sp_register_iop(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_method VARCHAR(10),
    IN p_measured_at DATETIME
)
BEGIN
    DECLARE v_visit_date DATETIME;

    SELECT visit_date INTO v_visit_date
    FROM medical_visits
    WHERE id = p_visit_id;

    IF v_visit_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta no existe';
    END IF;

    IF p_eye IS NULL OR p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    IF p_pressure IS NULL OR p_pressure < 0 OR p_pressure > 80 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO debe estar entre 0 y 80 mmHg';
    END IF;

    IF p_method IS NULL OR p_method NOT IN ('GOLDMANN', 'AIRE', 'ICARE', 'TONOPEN') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Método no válido: use GOLDMANN, AIRE, ICARE o TONOPEN';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, p_method, IFNULL(p_measured_at, v_visit_date));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- sp_generate_control_alerts: crea una alerta CONTROL_VENCIDO para cada
-- paciente con glaucoma cuya última consulta tenga más de p_months meses.
-- No duplica alertas: omite pacientes que ya tienen una sin leer.
-- La invoca el evento ev_daily_glaucoma_followup (07_events.sql).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_generate_control_alerts;

DELIMITER $$

CREATE PROCEDURE sp_generate_control_alerts(
    IN p_months INT
)
BEGIN
    IF p_months IS NULL OR p_months <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El número de meses debe ser mayor que cero';
    END IF;

    INSERT INTO clinical_alerts (patient_id, alert_type, message)
    SELECT
        g.patient_id,
        'CONTROL_VENCIDO',
        CONCAT('Sin control de glaucoma desde ', DATE_FORMAT(MAX(mv.visit_date), '%Y-%m-%d'),
               ' (más de ', p_months, ' meses)')
    FROM glaucoma_records g
    INNER JOIN clinical_histories ch ON ch.patient_id = g.patient_id
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    WHERE NOT EXISTS (
        SELECT 1
        FROM clinical_alerts a
        WHERE a.patient_id = g.patient_id
          AND a.alert_type = 'CONTROL_VENCIDO'
          AND a.is_read = FALSE
    )
    GROUP BY g.patient_id
    HAVING MAX(mv.visit_date) < DATE_SUB(NOW(), INTERVAL p_months MONTH);

    SELECT ROW_COUNT() AS alerts_created;
END $$

DELIMITER ;

-- Prueba rápida (solo lectura)
CALL sp_get_patient_visits(1);

-- Pruebas que modifican datos (comentadas para que cargar el script no
-- altere el seed). Verificadas en MariaDB 10.4:
-- CALL sp_register_iop(14, 'OD', 15.5, 'GOLDMANN', NULL);  -- devuelve el nuevo iop_id
-- CALL sp_generate_control_alerts(3);                      -- crea 2 alertas (pacientes 3 y 6)
-- SELECT * FROM clinical_alerts WHERE alert_type = 'CONTROL_VENCIDO';

-- Pruebas de validación (comentadas porque detienen el script):
-- CALL sp_get_patient_visits(999);                         -- Error: El paciente no existe
-- CALL sp_register_iop(999, 'OD', 15, 'GOLDMANN', NULL);   -- Error: La consulta no existe
-- CALL sp_register_iop(14, 'AO', 15, 'GOLDMANN', NULL);    -- Error: El ojo debe ser OD u OI
-- CALL sp_register_iop(14, 'OD', -3, 'GOLDMANN', NULL);    -- Error: La PIO debe estar entre 0 y 80 mmHg
-- CALL sp_generate_control_alerts(0);                      -- Error: El número de meses debe ser mayor que cero

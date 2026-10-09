-- =====================================================================
-- 04_functions.sql — Funciones almacenadas del proyecto
-- Requiere: 01_schema.sql y 02_seed.sql. Compatible con MariaDB 10.4+.
-- =====================================================================

USE oftalmologia_glaucoma;

-- ---------------------------------------------------------------------
-- fn_patient_age: edad en años cumplidos a partir de la fecha de
-- nacimiento (sección 33 del taller). Se declara NOT DETERMINISTIC
-- porque depende de CURDATE(): el mismo parámetro da otro resultado
-- al día siguiente de un cumpleaños.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_patient_age;

DELIMITER $$

CREATE FUNCTION fn_patient_age(
    p_birth_date DATE
)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- fn_last_iop: última PIO registrada de un paciente para un ojo.
-- Devuelve NULL si el paciente no tiene mediciones en ese ojo.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_last_iop;

DELIMITER $$

CREATE FUNCTION fn_last_iop(
    p_patient_id BIGINT,
    p_eye VARCHAR(2)
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE v_pressure DECIMAL(4,1) DEFAULT NULL;

    IF p_eye IS NULL OR p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    SELECT ip.pressure INTO v_pressure
    FROM intraocular_pressures ip
    INNER JOIN medical_visits mv ON ip.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND ip.eye = p_eye
    ORDER BY ip.measured_at DESC, ip.id DESC
    LIMIT 1;

    RETURN v_pressure;
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- fn_iop_category: clasifica un valor de PIO (mmHg) con rangos de uso
-- académico: < 10 BAJA, 10–21 NORMAL, > 21–30 ELEVADA, > 30 MUY ELEVADA.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_iop_category;

DELIMITER $$

CREATE FUNCTION fn_iop_category(
    p_pressure DECIMAL(4,1)
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE
        WHEN p_pressure IS NULL THEN 'SIN DATO'
        WHEN p_pressure < 10 THEN 'BAJA'
        WHEN p_pressure <= 21 THEN 'NORMAL'
        WHEN p_pressure <= 30 THEN 'ELEVADA'
        ELSE 'MUY ELEVADA'
    END;
END $$

DELIMITER ;

-- Pruebas rápidas
SELECT first_name, last_name, birth_date, fn_patient_age(birth_date) AS age
FROM patients
ORDER BY birth_date
LIMIT 5;

SELECT p.id,
       CONCAT(p.first_name, ' ', p.last_name) AS patient,
       fn_last_iop(p.id, 'OD') AS last_iop_od,
       fn_iop_category(fn_last_iop(p.id, 'OD')) AS category_od,
       fn_last_iop(p.id, 'OI') AS last_iop_oi,
       fn_iop_category(fn_last_iop(p.id, 'OI')) AS category_oi
FROM patients p
WHERE p.id <= 6;

-- =====================================================================
-- PARTE V — 50 ejercicios de funciones almacenadas
-- Requiere: sql/01_schema.sql a sql/07_events.sql. MariaDB 10.4+.
--
-- Las funciones que leen tablas se declaran READS SQL DATA; las que solo
-- calculan, NO SQL. Las que dependen de CURDATE()/NOW() son NOT
-- DETERMINISTIC porque su resultado cambia con el tiempo.
-- Varias funciones de PIO leen la vista vw_patient_iop_history.
-- Los nombres no repiten los de sql/04_functions.sql (fn_patient_age,
-- fn_last_iop, fn_iop_category); los ejercicios 4 y 41 reutilizan las
-- funciones existentes.
-- =====================================================================

USE oftalmologia_glaucoma;

-- Ejercicio 1: Crear una función que calcule la edad de un paciente a partir de su fecha de nacimiento.
DROP FUNCTION IF EXISTS fn_age_from_birth_date;

DELIMITER $$

CREATE FUNCTION fn_age_from_birth_date(
    p_birth_date DATE
)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
END $$

DELIMITER ;

SELECT first_name, birth_date, fn_age_from_birth_date(birth_date) AS age FROM patients LIMIT 3;

-- Ejercicio 2: Crear una función que reciba nombres y apellidos y retorne el nombre completo.
DROP FUNCTION IF EXISTS fn_full_name;

DELIMITER $$

CREATE FUNCTION fn_full_name(
    p_first_name VARCHAR(100),
    p_last_name VARCHAR(100)
)
RETURNS VARCHAR(201)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT_WS(' ', NULLIF(TRIM(p_first_name), ''), NULLIF(TRIM(p_last_name), ''));
END $$

DELIMITER ;

SELECT fn_full_name(' María Fernanda ', 'Rueda') AS full_name;

-- Ejercicio 3: Crear una función que reciba un ID de paciente y retorne su número de documento.
DROP FUNCTION IF EXISTS fn_patient_document;

DELIMITER $$

CREATE FUNCTION fn_patient_document(
    p_patient_id BIGINT
)
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE v_document VARCHAR(20);

    SELECT document_number INTO v_document
    FROM patients
    WHERE id = p_patient_id;

    RETURN v_document;
END $$

DELIMITER ;

SELECT fn_patient_document(1) AS document, fn_patient_document(999) AS not_found;
-- not_found es NULL: el paciente 999 no existe.

-- Ejercicio 4: Crear una función que reciba un ID de paciente y retorne su edad.
DROP FUNCTION IF EXISTS fn_patient_age_by_id;

DELIMITER $$

CREATE FUNCTION fn_patient_age_by_id(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_birth_date DATE;

    SELECT birth_date INTO v_birth_date
    FROM patients
    WHERE id = p_patient_id;

    RETURN fn_patient_age(v_birth_date);
END $$

DELIMITER ;

SELECT fn_patient_age_by_id(9) AS age_patient_9;

-- Ejercicio 5: Crear una función que reciba el ID de una consulta y retorne su fecha.
DROP FUNCTION IF EXISTS fn_visit_date;

DELIMITER $$

CREATE FUNCTION fn_visit_date(
    p_visit_id BIGINT
)
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date DATETIME;

    SELECT visit_date INTO v_date
    FROM medical_visits
    WHERE id = p_visit_id;

    RETURN v_date;
END $$

DELIMITER ;

SELECT fn_visit_date(1) AS visit_1;

-- Ejercicio 6: Crear una función que determine cuántos años han pasado desde una fecha.
DROP FUNCTION IF EXISTS fn_years_since;

DELIMITER $$

CREATE FUNCTION fn_years_since(
    p_date DATE
)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_date, CURDATE());
END $$

DELIMITER ;

SELECT diagnosis_date, fn_years_since(diagnosis_date) AS years FROM glaucoma_records;

-- Ejercicio 7: Crear una función que reciba un valor de PIO y retorne un texto descriptivo.
-- Mismos rangos que fn_iop_category (04_functions.sql). Se compara el número y no el texto
-- que devuelve esa función para no depender de la collation de la conexión (Error 1271).
DROP FUNCTION IF EXISTS fn_iop_description;

DELIMITER $$

CREATE FUNCTION fn_iop_description(
    p_pressure DECIMAL(4,1)
)
RETURNS VARCHAR(120)
DETERMINISTIC
NO SQL
BEGIN
    IF p_pressure IS NULL THEN
        RETURN 'Sin medición de PIO';
    END IF;

    RETURN CONCAT('PIO de ', p_pressure, ' mmHg: ',
        CASE
            WHEN p_pressure < 10 THEN 'presión baja, por debajo de 10 mmHg'
            WHEN p_pressure <= 21 THEN 'presión dentro del rango normal (10 a 21 mmHg)'
            WHEN p_pressure <= 30 THEN 'presión elevada, requiere seguimiento'
            ELSE 'presión muy elevada, requiere atención prioritaria'
        END);
END $$

DELIMITER ;

SELECT fn_iop_description(8) AS low, fn_iop_description(16) AS normal, fn_iop_description(34) AS very_high;

-- Ejercicio 8: Crear una función que reciba `OD` u `OI` y devuelva `Ojo derecho` u `Ojo izquierdo`.
DROP FUNCTION IF EXISTS fn_eye_name;

DELIMITER $$

CREATE FUNCTION fn_eye_name(
    p_eye VARCHAR(2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE UPPER(p_eye)
        WHEN 'OD' THEN 'Ojo derecho'
        WHEN 'OI' THEN 'Ojo izquierdo'
        WHEN 'AO' THEN 'Ambos ojos'
        ELSE 'No especificado'
    END;
END $$

DELIMITER ;

SELECT fn_eye_name('OD') AS od, fn_eye_name('OI') AS oi;

-- Ejercicio 9: Crear una función que reciba un booleano y retorne `Activo` o `Inactivo`.
DROP FUNCTION IF EXISTS fn_active_label;

DELIMITER $$

CREATE FUNCTION fn_active_label(
    p_value BOOLEAN
)
RETURNS VARCHAR(10)
DETERMINISTIC
NO SQL
BEGIN
    RETURN IF(p_value, 'Activo', 'Inactivo');
END $$

DELIMITER ;

SELECT first_name, last_name, fn_active_label(is_active) AS status FROM healthcare_professionals;

-- Ejercicio 10: Crear una función que formatee un número de historia clínica.
-- Formato: HC- + número con 6 dígitos (ej. 25 → HC-000025).
DROP FUNCTION IF EXISTS fn_format_history_number;

DELIMITER $$

CREATE FUNCTION fn_format_history_number(
    p_number BIGINT
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT('HC-', LPAD(p_number, 6, '0'));
END $$

DELIMITER ;

SELECT fn_format_history_number(25) AS formatted;

-- Ejercicio 11: Crear una función que retorne la cantidad de consultas de un paciente.
DROP FUNCTION IF EXISTS fn_patient_visit_count;

DELIMITER $$

CREATE FUNCTION fn_patient_visit_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_patient_visit_count(1) AS visits_1, fn_patient_visit_count(20) AS visits_20;
-- visits_20 = 0: Daniela Carrillo no tiene historia clínica ni consultas en el seed.

-- Ejercicio 12: Crear una función que retorne la cantidad de diagnósticos de un paciente.
-- Cuenta diagnósticos distintos (un mismo diagnóstico en varias consultas cuenta una vez).
DROP FUNCTION IF EXISTS fn_patient_diagnosis_count;

DELIMITER $$

CREATE FUNCTION fn_patient_diagnosis_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(DISTINCT vd.diagnosis_id) INTO v_total
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_patient_diagnosis_count(1) AS diagnoses_1;

-- Ejercicio 13: Crear una función que retorne la cantidad de controles de glaucoma de un paciente.
DROP FUNCTION IF EXISTS fn_glaucoma_control_count;

DELIMITER $$

CREATE FUNCTION fn_glaucoma_control_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM glaucoma_controls gc
    INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
    WHERE g.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_glaucoma_control_count(2) AS controls_2;

-- Ejercicio 14: Crear una función que retorne la última fecha de consulta.
DROP FUNCTION IF EXISTS fn_last_visit_date;

DELIMITER $$

CREATE FUNCTION fn_last_visit_date(
    p_patient_id BIGINT
)
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date DATETIME;

    SELECT MAX(mv.visit_date) INTO v_date
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_date;
END $$

DELIMITER ;

SELECT fn_last_visit_date(1) AS last_visit;

-- Ejercicio 15: Crear una función que retorne la primera fecha de consulta.
DROP FUNCTION IF EXISTS fn_first_visit_date;

DELIMITER $$

CREATE FUNCTION fn_first_visit_date(
    p_patient_id BIGINT
)
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date DATETIME;

    SELECT MIN(mv.visit_date) INTO v_date
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_date;
END $$

DELIMITER ;

SELECT fn_first_visit_date(1) AS first_visit;

-- Ejercicio 16: Crear una función que retorne la presión intraocular promedio de un paciente.
DROP FUNCTION IF EXISTS fn_patient_avg_iop;

DELIMITER $$

CREATE FUNCTION fn_patient_avg_iop(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_patient_avg_iop(1) AS avg_iop_1;

-- Ejercicio 17: Crear una función que retorne la presión promedio de OD.
DROP FUNCTION IF EXISTS fn_patient_avg_iop_od;

DELIMITER $$

CREATE FUNCTION fn_patient_avg_iop_od(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = 'OD';

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_patient_avg_iop_od(3) AS avg_od_3;

-- Ejercicio 18: Crear una función que retorne la presión promedio de OI.
DROP FUNCTION IF EXISTS fn_patient_avg_iop_oi;

DELIMITER $$

CREATE FUNCTION fn_patient_avg_iop_oi(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = 'OI';

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_patient_avg_iop_oi(3) AS avg_oi_3;

-- Ejercicio 19: Crear una función que retorne la PIO máxima registrada para un paciente.
DROP FUNCTION IF EXISTS fn_patient_max_iop;

DELIMITER $$

CREATE FUNCTION fn_patient_max_iop(
    p_patient_id BIGINT
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE v_max DECIMAL(4,1);

    SELECT MAX(pressure) INTO v_max
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id;

    RETURN v_max;
END $$

DELIMITER ;

SELECT fn_patient_max_iop(3) AS max_iop_3;

-- Ejercicio 20: Crear una función que retorne la PIO mínima registrada.
DROP FUNCTION IF EXISTS fn_patient_min_iop;

DELIMITER $$

CREATE FUNCTION fn_patient_min_iop(
    p_patient_id BIGINT
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE v_min DECIMAL(4,1);

    SELECT MIN(pressure) INTO v_min
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id;

    RETURN v_min;
END $$

DELIMITER ;

SELECT fn_patient_min_iop(3) AS min_iop_3;

-- Ejercicio 21: Crear una función que clasifique una PIO según rangos definidos para fines académicos.
-- Rangos: < 10 BAJA, 10–21 NORMAL, 21.1–25 LIMÍTROFE, 25.1–30 ALTA, > 30 MUY ALTA.
-- (fn_iop_category de 04 usa 4 rangos; esta separa la zona limítrofe.)
DROP FUNCTION IF EXISTS fn_classify_iop;

DELIMITER $$

CREATE FUNCTION fn_classify_iop(
    p_pressure DECIMAL(4,1)
)
RETURNS VARCHAR(15)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE
        WHEN p_pressure IS NULL THEN NULL
        WHEN p_pressure < 10 THEN 'BAJA'
        WHEN p_pressure <= 21 THEN 'NORMAL'
        WHEN p_pressure <= 25 THEN 'LIMÍTROFE'
        WHEN p_pressure <= 30 THEN 'ALTA'
        ELSE 'MUY ALTA'
    END;
END $$

DELIMITER ;

SELECT pressure, fn_classify_iop(pressure) AS class
FROM intraocular_pressures
WHERE id IN (1, 3, 5, 17);

-- Ejercicio 22: Crear una función que indique si una PIO supera una presión objetivo recibida como parámetro.
DROP FUNCTION IF EXISTS fn_iop_exceeds_target;

DELIMITER $$

CREATE FUNCTION fn_iop_exceeds_target(
    p_pressure DECIMAL(4,1),
    p_target DECIMAL(4,1)
)
RETURNS BOOLEAN
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_pressure > p_target;
END $$

DELIMITER ;

SELECT fn_iop_exceeds_target(22, 18) AS exceeds, fn_iop_exceeds_target(16, 18) AS not_exceeds;

-- Ejercicio 23: Crear una función que determine si un paciente tiene diagnóstico de glaucoma.
-- Usa diagnoses.is_glaucoma (la sospecha de glaucoma H40.0 no cuenta).
DROP FUNCTION IF EXISTS fn_has_glaucoma_diagnosis;

DELIMITER $$

CREATE FUNCTION fn_has_glaucoma_diagnosis(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
        INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
        INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
        WHERE ch.patient_id = p_patient_id
          AND d.is_glaucoma = TRUE
    );
END $$

DELIMITER ;

SELECT fn_has_glaucoma_diagnosis(1) AS patient_1, fn_has_glaucoma_diagnosis(7) AS patient_7_suspect;

-- Ejercicio 24: Crear una función que determine si un paciente tiene tratamientos activos.
DROP FUNCTION IF EXISTS fn_has_active_treatments;

DELIMITER $$

CREATE FUNCTION fn_has_active_treatments(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM treatments t
        INNER JOIN medical_visits mv ON t.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
          AND t.status = 'ACTIVO'
    );
END $$

DELIMITER ;

SELECT fn_has_active_treatments(1) AS patient_1, fn_has_active_treatments(7) AS patient_7;

-- Ejercicio 25: Crear una función que indique si el paciente tiene al menos un OCT registrado.
DROP FUNCTION IF EXISTS fn_has_oct;

DELIMITER $$

CREATE FUNCTION fn_has_oct(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM oct_exams o
        INNER JOIN medical_visits mv ON o.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_has_oct(1) AS patient_1, fn_has_oct(8) AS patient_8;

-- Ejercicio 26: Crear una función que indique si tiene campo visual registrado.
DROP FUNCTION IF EXISTS fn_has_visual_field;

DELIMITER $$

CREATE FUNCTION fn_has_visual_field(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM visual_field_exams vf
        INNER JOIN medical_visits mv ON vf.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_has_visual_field(1) AS patient_1, fn_has_visual_field(8) AS patient_8;

-- Ejercicio 27: Crear una función que determine si tiene paquimetría.
DROP FUNCTION IF EXISTS fn_has_pachymetry;

DELIMITER $$

CREATE FUNCTION fn_has_pachymetry(
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM pachymetry_exams pe
        INNER JOIN medical_visits mv ON pe.visit_id = mv.id
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_has_pachymetry(1) AS patient_1, fn_has_pachymetry(2) AS patient_2;

-- Ejercicio 28: Crear una función que determine si el paciente tiene controles pendientes según un número de meses.
-- Pendiente = su última consulta tiene más de p_months meses o nunca ha consultado.
DROP FUNCTION IF EXISTS fn_has_pending_control;

DELIMITER $$

CREATE FUNCTION fn_has_pending_control(
    p_patient_id BIGINT,
    p_months INT
)
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last DATETIME;

    SET v_last = fn_last_visit_date(p_patient_id);

    RETURN v_last IS NULL OR v_last < NOW() - INTERVAL p_months MONTH;
END $$

DELIMITER ;

SELECT id, fn_has_pending_control(id, 6) AS pending_6m FROM patients WHERE id IN (1, 10, 20);

-- Ejercicio 29: Crear una función que clasifique un paciente según cantidad de consultas: nuevo, recurrente o frecuente.
-- Reglas: 0–1 consultas = Nuevo, 2–3 = Recurrente, 4 o más = Frecuente.
DROP FUNCTION IF EXISTS fn_patient_visit_class;

DELIMITER $$

CREATE FUNCTION fn_patient_visit_class(
    p_patient_id BIGINT
)
RETURNS VARCHAR(12)
READS SQL DATA
BEGIN
    DECLARE v_visits INT;

    SET v_visits = fn_patient_visit_count(p_patient_id);

    RETURN CASE
        WHEN v_visits <= 1 THEN 'Nuevo'
        WHEN v_visits <= 3 THEN 'Recurrente'
        ELSE 'Frecuente'
    END;
END $$

DELIMITER ;

SELECT id, fn_patient_visit_count(id) AS visits, fn_patient_visit_class(id) AS class
FROM patients
WHERE id IN (1, 3, 6, 10);

-- Ejercicio 30: Crear una función que retorne `Completo` si el paciente tiene OCT, campo visual, PIO y paquimetría, o `Incompleto` en caso contrario.
DROP FUNCTION IF EXISTS fn_exam_completeness;

DELIMITER $$

CREATE FUNCTION fn_exam_completeness(
    p_patient_id BIGINT
)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    IF fn_has_oct(p_patient_id)
       AND fn_has_visual_field(p_patient_id)
       AND fn_has_pachymetry(p_patient_id)
       AND EXISTS (SELECT 1 FROM vw_patient_iop_history WHERE patient_id = p_patient_id) THEN
        RETURN 'Completo';
    END IF;

    RETURN 'Incompleto';
END $$

DELIMITER ;

SELECT id, fn_exam_completeness(id) AS exams FROM patients WHERE id <= 8;

-- Ejercicio 31: Crear una función que calcule el promedio de PIO entre dos fechas para un paciente.
DROP FUNCTION IF EXISTS fn_avg_iop_between;

DELIMITER $$

CREATE FUNCTION fn_avg_iop_between(
    p_patient_id BIGINT,
    p_from DATE,
    p_to DATE
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at >= p_from
      AND measured_at < p_to + INTERVAL 1 DAY;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_iop_between(1, '2025-01-01', '2025-12-31') AS avg_2025,
       fn_avg_iop_between(1, '2026-01-01', '2026-12-31') AS avg_2026;

-- Ejercicio 32: Crear una función que calcule la diferencia entre la primera y última PIO.
-- Primera/última = promedio de las mediciones (OD y OI) tomadas en la primera y en la última
-- fecha-hora de medición del paciente. Resultado = última − primera (negativo = bajó).
DROP FUNCTION IF EXISTS fn_iop_first_last_diff;

DELIMITER $$

CREATE FUNCTION fn_iop_first_last_diff(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_first DECIMAL(5,2);
    DECLARE v_last DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_first
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at = (SELECT MIN(measured_at) FROM vw_patient_iop_history WHERE patient_id = p_patient_id);

    SELECT AVG(pressure) INTO v_last
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at = (SELECT MAX(measured_at) FROM vw_patient_iop_history WHERE patient_id = p_patient_id);

    RETURN v_last - v_first;
END $$

DELIMITER ;

SELECT fn_iop_first_last_diff(1) AS diff_1, fn_iop_first_last_diff(4) AS diff_4;

-- Ejercicio 33: Crear una función que retorne el número de días desde la última consulta.
DROP FUNCTION IF EXISTS fn_days_since_last_visit;

DELIMITER $$

CREATE FUNCTION fn_days_since_last_visit(
    p_patient_id BIGINT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN DATEDIFF(CURDATE(), fn_last_visit_date(p_patient_id));
END $$

DELIMITER ;

SELECT fn_days_since_last_visit(1) AS days_1, fn_days_since_last_visit(20) AS days_20;
-- days_20 es NULL: el paciente 20 no tiene consultas.

-- Ejercicio 34: Crear una función que retorne el número de meses desde el último OCT.
DROP FUNCTION IF EXISTS fn_months_since_last_oct;

DELIMITER $$

CREATE FUNCTION fn_months_since_last_oct(
    p_patient_id BIGINT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last DATE;

    SELECT MAX(o.exam_date) INTO v_last
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN TIMESTAMPDIFF(MONTH, v_last, CURDATE());
END $$

DELIMITER ;

SELECT fn_months_since_last_oct(1) AS months_1, fn_months_since_last_oct(8) AS months_8;
-- months_8 es NULL: el paciente 8 no tiene OCT.

-- Ejercicio 35: Crear una función que retorne el número de meses desde el último campo visual.
DROP FUNCTION IF EXISTS fn_months_since_last_visual_field;

DELIMITER $$

CREATE FUNCTION fn_months_since_last_visual_field(
    p_patient_id BIGINT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_last DATE;

    SELECT MAX(vf.exam_date) INTO v_last
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN TIMESTAMPDIFF(MONTH, v_last, CURDATE());
END $$

DELIMITER ;

SELECT fn_months_since_last_visual_field(4) AS months_4;

-- Ejercicio 36: Crear una función que calcule el promedio de RNFL de los OCT de un paciente.
DROP FUNCTION IF EXISTS fn_avg_rnfl;

DELIMITER $$

CREATE FUNCTION fn_avg_rnfl(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,1)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,1);

    SELECT AVG(o.rnfl_average) INTO v_avg
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_rnfl(4) AS avg_rnfl_4;

-- Ejercicio 37: Crear una función que retorne el valor más reciente de RNFL.
-- Como OD y OI se miden el mismo día, retorna el promedio de ambos ojos en la fecha más reciente.
DROP FUNCTION IF EXISTS fn_last_rnfl;

DELIMITER $$

CREATE FUNCTION fn_last_rnfl(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,1)
READS SQL DATA
BEGIN
    DECLARE v_value DECIMAL(5,1);

    SELECT AVG(o.rnfl_average) INTO v_value
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND o.exam_date = (
          SELECT MAX(o2.exam_date)
          FROM oct_exams o2
          INNER JOIN medical_visits mv2 ON o2.visit_id = mv2.id
          WHERE mv2.clinical_history_id = ch.id
      );

    RETURN v_value;
END $$

DELIMITER ;

SELECT fn_last_rnfl(4) AS last_rnfl_4, fn_avg_rnfl(4) AS avg_rnfl_4;

-- Ejercicio 38: Crear una función que calcule el promedio de VFI de un paciente.
DROP FUNCTION IF EXISTS fn_avg_vfi;

DELIMITER $$

CREATE FUNCTION fn_avg_vfi(
    p_patient_id BIGINT
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    SELECT AVG(vf.vfi) INTO v_avg
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_vfi(4) AS avg_vfi_4;

-- Ejercicio 39: Crear una función que retorne la cantidad de tratamientos históricos.
-- Cuenta todos los tratamientos del paciente (activos, finalizados y suspendidos).
DROP FUNCTION IF EXISTS fn_treatment_count;

DELIMITER $$

CREATE FUNCTION fn_treatment_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_treatment_count(3) AS treatments_3;

-- Ejercicio 40: Crear una función que retorne la cantidad de medicamentos diferentes utilizados por un paciente.
DROP FUNCTION IF EXISTS fn_distinct_medication_count;

DELIMITER $$

CREATE FUNCTION fn_distinct_medication_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(DISTINCT t.medication_id) INTO v_total
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_distinct_medication_count(1) AS medications_1;

-- Ejercicio 41: Crear una función que reciba paciente y ojo y retorne la última PIO registrada.
-- Reutiliza fn_last_iop (04_functions.sql), que ya valida el ojo y resuelve la consulta.
DROP FUNCTION IF EXISTS fn_last_iop_by_eye;

DELIMITER $$

CREATE FUNCTION fn_last_iop_by_eye(
    p_patient_id BIGINT,
    p_eye VARCHAR(2)
)
RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    RETURN fn_last_iop(p_patient_id, p_eye);
END $$

DELIMITER ;

SELECT fn_last_iop_by_eye(2, 'OD') AS last_od_2, fn_last_iop_by_eye(2, 'OI') AS last_oi_2;

-- Ejercicio 42: Crear una función que reciba paciente y ojo y retorne la PIO promedio.
DROP FUNCTION IF EXISTS fn_avg_iop_by_eye;

DELIMITER $$

CREATE FUNCTION fn_avg_iop_by_eye(
    p_patient_id BIGINT,
    p_eye VARCHAR(2)
)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_avg DECIMAL(5,2);

    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    SELECT AVG(pressure) INTO v_avg
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = p_eye;

    RETURN v_avg;
END $$

DELIMITER ;

SELECT fn_avg_iop_by_eye(5, 'OD') AS avg_od_5, fn_avg_iop_by_eye(5, 'OI') AS avg_oi_5;

-- Ejercicio 43: Crear una función que determine si la última PIO es mayor o menor que la primera.
-- Reutiliza fn_iop_first_last_diff (ejercicio 32).
DROP FUNCTION IF EXISTS fn_iop_trend;

DELIMITER $$

CREATE FUNCTION fn_iop_trend(
    p_patient_id BIGINT
)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE v_diff DECIMAL(5,2);

    SET v_diff = fn_iop_first_last_diff(p_patient_id);

    RETURN CASE
        WHEN v_diff IS NULL THEN 'SIN DATOS'
        WHEN v_diff > 0 THEN 'MAYOR'
        WHEN v_diff < 0 THEN 'MENOR'
        ELSE 'IGUAL'
    END;
END $$

DELIMITER ;

SELECT id, fn_iop_trend(id) AS trend FROM patients WHERE id IN (1, 4, 6, 20);

-- Ejercicio 44: Crear una función que retorne la diferencia porcentual entre primera y última PIO.
-- ((última − primera) / primera) × 100, con la misma definición de primera/última del ejercicio 32.
DROP FUNCTION IF EXISTS fn_iop_percent_change;

DELIMITER $$

CREATE FUNCTION fn_iop_percent_change(
    p_patient_id BIGINT
)
RETURNS DECIMAL(6,2)
READS SQL DATA
BEGIN
    DECLARE v_first DECIMAL(5,2);

    SELECT AVG(pressure) INTO v_first
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at = (SELECT MIN(measured_at) FROM vw_patient_iop_history WHERE patient_id = p_patient_id);

    IF v_first IS NULL OR v_first = 0 THEN
        RETURN NULL;
    END IF;

    RETURN fn_iop_first_last_diff(p_patient_id) / v_first * 100;
END $$

DELIMITER ;

SELECT fn_iop_percent_change(1) AS pct_1;

-- Ejercicio 45: Crear una función que retorne el diagnóstico principal más reciente de un paciente.
DROP FUNCTION IF EXISTS fn_last_primary_diagnosis;

DELIMITER $$

CREATE FUNCTION fn_last_primary_diagnosis(
    p_patient_id BIGINT
)
RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(150);

    SELECT d.name INTO v_name
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
    WHERE ch.patient_id = p_patient_id
      AND vd.is_primary = TRUE
    ORDER BY mv.visit_date DESC
    LIMIT 1;

    RETURN v_name;
END $$

DELIMITER ;

SELECT fn_last_primary_diagnosis(3) AS diagnosis_3;

-- Ejercicio 46: Crear una función que retorne el nombre del medicamento activo más reciente.
DROP FUNCTION IF EXISTS fn_last_active_medication;

DELIMITER $$

CREATE FUNCTION fn_last_active_medication(
    p_patient_id BIGINT
)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(100);

    SELECT m.name INTO v_name
    FROM treatments t
    INNER JOIN medications m ON t.medication_id = m.id
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND t.status = 'ACTIVO'
    ORDER BY t.start_date DESC, t.id DESC
    LIMIT 1;

    RETURN v_name;
END $$

DELIMITER ;

SELECT fn_last_active_medication(1) AS medication_1, fn_last_active_medication(10) AS medication_10;
-- medication_10 es NULL: el paciente 10 no tiene tratamientos.

-- Ejercicio 47: Crear una función que retorne la cantidad de procedimientos realizados a un paciente.
DROP FUNCTION IF EXISTS fn_procedure_count;

DELIMITER $$

CREATE FUNCTION fn_procedure_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM procedures pr
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_procedure_count(3) AS procedures_3;

-- Ejercicio 48: Crear una función que determine si un profesional ha atendido alguna vez a un paciente específico.
DROP FUNCTION IF EXISTS fn_professional_attended_patient;

DELIMITER $$

CREATE FUNCTION fn_professional_attended_patient(
    p_professional_id BIGINT,
    p_patient_id BIGINT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM medical_visits mv
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE mv.professional_id = p_professional_id
          AND ch.patient_id = p_patient_id
    );
END $$

DELIMITER ;

SELECT fn_professional_attended_patient(2, 2) AS yes_2_2, fn_professional_attended_patient(5, 1) AS no_5_1;

-- Ejercicio 49: Crear una función que calcule la cantidad total de exámenes especializados registrados para un paciente.
-- Exámenes especializados: OCT, campo visual, paquimetría y gonioscopía (cada ojo cuenta como un examen).
DROP FUNCTION IF EXISTS fn_specialized_exam_count;

DELIMITER $$

CREATE FUNCTION fn_specialized_exam_count(
    p_patient_id BIGINT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM (
        SELECT visit_id FROM oct_exams
        UNION ALL SELECT visit_id FROM visual_field_exams
        UNION ALL SELECT visit_id FROM pachymetry_exams
        UNION ALL SELECT visit_id FROM gonioscopy_exams
    ) e
    INNER JOIN medical_visits mv ON e.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id;

    RETURN v_total;
END $$

DELIMITER ;

SELECT fn_specialized_exam_count(1) AS exams_1;

-- Ejercicio 50: Crear una función que genere un resumen textual como:
-- Reutiliza fn_patient_visit_count (11), fn_glaucoma_control_count (13) y fn_last_iop_by_eye (41).
-- El salto de línea se arma con CHAR(10).
DROP FUNCTION IF EXISTS fn_patient_summary;

DELIMITER $$

CREATE FUNCTION fn_patient_summary(
    p_patient_id BIGINT
)
RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(201);
    DECLARE v_active INT;

    SELECT CONCAT(first_name, ' ', last_name) INTO v_name
    FROM patients
    WHERE id = p_patient_id;

    IF v_name IS NULL THEN
        RETURN NULL;
    END IF;

    SELECT COUNT(*) INTO v_active
    FROM treatments t
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND t.status = 'ACTIVO';

    RETURN CONCAT(
        'Paciente: ', v_name, CHAR(10),
        'Consultas: ', fn_patient_visit_count(p_patient_id), CHAR(10),
        'Controles glaucoma: ', fn_glaucoma_control_count(p_patient_id), CHAR(10),
        'Última PIO OD: ', IFNULL(TRIM(TRAILING '.0' FROM fn_last_iop_by_eye(p_patient_id, 'OD')), 'N/A'), CHAR(10),
        'Última PIO OI: ', IFNULL(TRIM(TRAILING '.0' FROM fn_last_iop_by_eye(p_patient_id, 'OI')), 'N/A'), CHAR(10),
        'Tratamientos activos: ', v_active
    );
END $$

DELIMITER ;

SELECT fn_patient_summary(1) AS summary;

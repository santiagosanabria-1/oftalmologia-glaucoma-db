-- =====================================================================
-- PARTE III — 50 ejercicios de procedimientos almacenados
-- Requiere: sql/01_schema.sql a sql/07_events.sql. MariaDB 10.4+.
--
-- Cada ejercicio crea su procedimiento (con DROP ... IF EXISTS) y lo
-- prueba con un CALL válido. Los CALL inválidos van comentados porque
-- detienen el script; el error esperado se indica al lado.
-- Los CALL de inserción y modificación se encadenan: el ejercicio 13
-- usa la historia creada en el 12, el 14 usa la consulta del 13, etc.
-- Para repetir las pruebas, recrear la base con 01_schema + 02_seed.
-- =====================================================================

USE oftalmologia_glaucoma;

-- Ejercicio 1: Crear un procedimiento que liste todos los pacientes.
DROP PROCEDURE IF EXISTS sp_list_patients;

DELIMITER $$

CREATE PROCEDURE sp_list_patients()
BEGIN
    SELECT p.id,
           dt.code AS document_type,
           p.document_number,
           p.first_name,
           p.last_name,
           p.birth_date,
           p.sex,
           c.name AS city
    FROM patients p
    INNER JOIN document_types dt ON p.document_type_id = dt.id
    LEFT JOIN cities c ON p.city_id = c.id
    ORDER BY p.last_name, p.first_name;
END $$

DELIMITER ;

CALL sp_list_patients();

-- Ejercicio 2: Crear un procedimiento que reciba el ID de un paciente y muestre sus datos.
DROP PROCEDURE IF EXISTS sp_get_patient_by_id;

DELIMITER $$

CREATE PROCEDURE sp_get_patient_by_id(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    SELECT p.*,
           dt.name AS document_type,
           c.name AS city,
           c.department
    FROM patients p
    INNER JOIN document_types dt ON p.document_type_id = dt.id
    LEFT JOIN cities c ON p.city_id = c.id
    WHERE p.id = p_patient_id;
END $$

DELIMITER ;

CALL sp_get_patient_by_id(1);
-- CALL sp_get_patient_by_id(999);  -- Error: El paciente no existe

-- Ejercicio 3: Crear un procedimiento que busque un paciente por número de documento.
DROP PROCEDURE IF EXISTS sp_find_patient_by_document;

DELIMITER $$

CREATE PROCEDURE sp_find_patient_by_document(
    IN p_document_number VARCHAR(20)
)
BEGIN
    SELECT *
    FROM patients
    WHERE document_number = TRIM(p_document_number);
END $$

DELIMITER ;

CALL sp_find_patient_by_document('1098456123');

-- Ejercicio 4: Crear un procedimiento que liste todas las consultas de un paciente.
DROP PROCEDURE IF EXISTS sp_list_patient_visits;

DELIMITER $$

CREATE PROCEDURE sp_list_patient_visits(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT mv.id,
           mv.visit_date,
           mv.reason,
           CONCAT(hp.first_name, ' ', hp.last_name) AS professional
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    INNER JOIN healthcare_professionals hp ON mv.professional_id = hp.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY mv.visit_date;
END $$

DELIMITER ;

CALL sp_list_patient_visits(2);

-- Ejercicio 5: Crear un procedimiento que muestre todos los profesionales.
DROP PROCEDURE IF EXISTS sp_list_professionals;

DELIMITER $$

CREATE PROCEDURE sp_list_professionals()
BEGIN
    SELECT hp.id,
           CONCAT(hp.first_name, ' ', hp.last_name) AS professional,
           s.name AS specialty,
           hp.license_number,
           hp.is_active
    FROM healthcare_professionals hp
    INNER JOIN specialties s ON hp.specialty_id = s.id
    ORDER BY hp.last_name;
END $$

DELIMITER ;

CALL sp_list_professionals();

-- Ejercicio 6: Crear un procedimiento que reciba una especialidad y muestre sus profesionales.
DROP PROCEDURE IF EXISTS sp_list_professionals_by_specialty;

DELIMITER $$

CREATE PROCEDURE sp_list_professionals_by_specialty(
    IN p_specialty VARCHAR(100)
)
BEGIN
    SELECT hp.id,
           hp.first_name,
           hp.last_name,
           s.name AS specialty
    FROM healthcare_professionals hp
    INNER JOIN specialties s ON hp.specialty_id = s.id
    WHERE s.name = p_specialty;
END $$

DELIMITER ;

CALL sp_list_professionals_by_specialty('Oftalmología');

-- Ejercicio 7: Crear un procedimiento que liste diagnósticos.
DROP PROCEDURE IF EXISTS sp_list_diagnoses;

DELIMITER $$

CREATE PROCEDURE sp_list_diagnoses()
BEGIN
    SELECT id, code, name, is_glaucoma
    FROM diagnoses
    ORDER BY code;
END $$

DELIMITER ;

CALL sp_list_diagnoses();

-- Ejercicio 8: Crear un procedimiento que muestre medicamentos activos.
DROP PROCEDURE IF EXISTS sp_list_active_medications;

DELIMITER $$

CREATE PROCEDURE sp_list_active_medications()
BEGIN
    SELECT id, name, active_ingredient, presentation
    FROM medications
    WHERE is_active = TRUE
    ORDER BY name;
END $$

DELIMITER ;

CALL sp_list_active_medications();

-- Ejercicio 9: Crear un procedimiento que liste procedimientos clínicos realizados a un paciente.
DROP PROCEDURE IF EXISTS sp_list_patient_procedures;

DELIMITER $$

CREATE PROCEDURE sp_list_patient_procedures(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT pr.id,
           pt.name AS procedure_name,
           pt.category,
           pr.eye,
           pr.performed_at,
           pr.notes
    FROM procedures pr
    INNER JOIN procedure_types pt ON pr.procedure_type_id = pt.id
    INNER JOIN medical_visits mv ON pr.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY pr.performed_at;
END $$

DELIMITER ;

CALL sp_list_patient_procedures(3);

-- Ejercicio 10: Crear un procedimiento para consultar todos los controles de glaucoma de un paciente.
DROP PROCEDURE IF EXISTS sp_list_glaucoma_controls;

DELIMITER $$

CREATE PROCEDURE sp_list_glaucoma_controls(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT gc.id,
           gc.control_date,
           gc.progression_detected,
           gc.notes,
           gc.visit_id
    FROM glaucoma_controls gc
    INNER JOIN glaucoma_records g ON gc.glaucoma_record_id = g.id
    WHERE g.patient_id = p_patient_id
    ORDER BY gc.control_date;
END $$

DELIMITER ;

CALL sp_list_glaucoma_controls(2);

-- Ejercicio 11: Crear un procedimiento para registrar un nuevo paciente.
DROP PROCEDURE IF EXISTS sp_register_patient;

DELIMITER $$

CREATE PROCEDURE sp_register_patient(
    IN p_document_type_id TINYINT,
    IN p_document_number VARCHAR(20),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_birth_date DATE,
    IN p_sex CHAR(1),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(20),
    IN p_address VARCHAR(200),
    IN p_city_id INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM patients WHERE document_number = p_document_number) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un paciente con ese número de documento';
    END IF;

    INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date,
                          sex, email, phone, address, city_id)
    VALUES (p_document_type_id, p_document_number, p_first_name, p_last_name, p_birth_date,
            p_sex, p_email, p_phone, p_address, p_city_id);

    SELECT LAST_INSERT_ID() AS patient_id;
END $$

DELIMITER ;

CALL sp_register_patient(1, '1098777888', 'Andrea', 'Becerra', '1983-05-17', 'F',
                         'andrea.becerra@gmail.com', '3051231234', 'Calle 10 # 20-30', 1);
-- CALL sp_register_patient(1, '1098456123', 'X', 'Y', '1990-01-01', 'M', NULL, NULL, NULL, NULL);
--   Error: Ya existe un paciente con ese número de documento

-- Ejercicio 12: Crear un procedimiento para crear una historia clínica.
-- Si no se envía número, se genera como HC- + id del paciente con 6 dígitos.
DROP PROCEDURE IF EXISTS sp_create_clinical_history;

DELIMITER $$

CREATE PROCEDURE sp_create_clinical_history(
    IN p_patient_id BIGINT,
    IN p_history_number VARCHAR(20)
)
BEGIN
    INSERT INTO clinical_histories (patient_id, history_number)
    VALUES (p_patient_id, IFNULL(p_history_number, CONCAT('HC-', LPAD(p_patient_id, 6, '0'))));

    SELECT LAST_INSERT_ID() AS clinical_history_id;
END $$

DELIMITER ;

-- El paciente 20 (Daniela Carrillo) no tiene historia clínica en el seed.
CALL sp_create_clinical_history(20, NULL);

-- Ejercicio 13: Crear un procedimiento para registrar una consulta médica.
DROP PROCEDURE IF EXISTS sp_register_medical_visit;

DELIMITER $$

CREATE PROCEDURE sp_register_medical_visit(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255)
)
BEGIN
    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, IFNULL(p_visit_date, NOW()), p_reason);

    SELECT LAST_INSERT_ID() AS visit_id;
END $$

DELIMITER ;

-- Historia 20 creada en el ejercicio 12 → genera la consulta 31.
CALL sp_register_medical_visit(20, 1, '2026-10-01 09:00:00', 'Primera consulta por antecedente familiar de glaucoma');

-- Ejercicio 14: Crear un procedimiento para registrar un diagnóstico asociado a una consulta.
DROP PROCEDURE IF EXISTS sp_register_visit_diagnosis;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_diagnosis(
    IN p_visit_id BIGINT,
    IN p_diagnosis_id INT,
    IN p_eye VARCHAR(2),
    IN p_is_primary BOOLEAN
)
BEGIN
    INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary)
    VALUES (p_visit_id, p_diagnosis_id, p_eye, IFNULL(p_is_primary, FALSE));
END $$

DELIMITER ;

CALL sp_register_visit_diagnosis(31, 3, 'AO', TRUE);
SELECT * FROM visit_diagnoses WHERE visit_id = 31;

-- Ejercicio 15: Crear un procedimiento para registrar una medición de PIO.
DROP PROCEDURE IF EXISTS sp_register_iop_measurement;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_measurement(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_method VARCHAR(10),
    IN p_measured_at DATETIME
)
BEGIN
    INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, IFNULL(p_method, 'GOLDMANN'), IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_measurement(31, 'OD', 19.0, 'GOLDMANN', '2026-10-01 09:10:00');

-- Ejercicio 16: Crear un procedimiento para registrar un control de glaucoma.
DROP PROCEDURE IF EXISTS sp_register_glaucoma_control;

DELIMITER $$

CREATE PROCEDURE sp_register_glaucoma_control(
    IN p_glaucoma_record_id BIGINT,
    IN p_visit_id BIGINT,
    IN p_control_date DATE,
    IN p_progression BOOLEAN,
    IN p_notes TEXT
)
BEGIN
    INSERT INTO glaucoma_controls (glaucoma_record_id, visit_id, control_date, progression_detected, notes)
    VALUES (p_glaucoma_record_id, p_visit_id, p_control_date, IFNULL(p_progression, FALSE), p_notes);

    SELECT LAST_INSERT_ID() AS control_id;
END $$

DELIMITER ;

-- La consulta 17 (Ana Lucía Gómez) no tiene control asociado en el seed.
CALL sp_register_glaucoma_control(6, 17, '2025-12-09', FALSE, 'Control inicial registrado tardíamente');

-- Ejercicio 17: Crear un procedimiento para registrar un examen OCT.
DROP PROCEDURE IF EXISTS sp_register_oct;

DELIMITER $$

CREATE PROCEDURE sp_register_oct(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_rnfl_average DECIMAL(5,1),
    IN p_cup_disc_ratio DECIMAL(3,2),
    IN p_interpretation TEXT,
    IN p_exam_date DATE
)
BEGIN
    INSERT INTO oct_exams (visit_id, eye, rnfl_average, cup_disc_ratio, interpretation, exam_date)
    VALUES (p_visit_id, p_eye, p_rnfl_average, p_cup_disc_ratio, p_interpretation, p_exam_date);

    SELECT LAST_INSERT_ID() AS oct_id;
END $$

DELIMITER ;

CALL sp_register_oct(31, 'OD', 94.0, 0.45, 'Capa de fibras nerviosas dentro de límites normales', '2026-10-01');

-- Ejercicio 18: Crear un procedimiento para registrar un campo visual.
DROP PROCEDURE IF EXISTS sp_register_visual_field;

DELIMITER $$

CREATE PROCEDURE sp_register_visual_field(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_md DECIMAL(5,2),
    IN p_psd DECIMAL(5,2),
    IN p_vfi TINYINT,
    IN p_reliability VARCHAR(5),
    IN p_interpretation TEXT,
    IN p_exam_date DATE
)
BEGIN
    INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, reliability, interpretation, exam_date)
    VALUES (p_visit_id, p_eye, p_md, p_psd, p_vfi, IFNULL(p_reliability, 'ALTA'), p_interpretation, p_exam_date);

    SELECT LAST_INSERT_ID() AS visual_field_id;
END $$

DELIMITER ;

CALL sp_register_visual_field(31, 'OD', -0.8, 1.4, 99, 'ALTA', 'Campo visual sin defectos significativos', '2026-10-01');

-- Ejercicio 19: Crear un procedimiento para registrar una paquimetría.
DROP PROCEDURE IF EXISTS sp_register_pachymetry;

DELIMITER $$

CREATE PROCEDURE sp_register_pachymetry(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_thickness_um SMALLINT,
    IN p_exam_date DATE
)
BEGIN
    INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date)
    VALUES (p_visit_id, p_eye, p_thickness_um, p_exam_date);

    SELECT LAST_INSERT_ID() AS pachymetry_id;
END $$

DELIMITER ;

CALL sp_register_pachymetry(31, 'OD', 551, '2026-10-01');

-- Ejercicio 20: Crear un procedimiento para registrar un tratamiento.
DROP PROCEDURE IF EXISTS sp_register_treatment;

DELIMITER $$

CREATE PROCEDURE sp_register_treatment(
    IN p_visit_id BIGINT,
    IN p_medication_id INT,
    IN p_eye VARCHAR(2),
    IN p_dosage VARCHAR(100),
    IN p_frequency VARCHAR(100),
    IN p_start_date DATE
)
BEGIN
    INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date)
    VALUES (p_visit_id, p_medication_id, p_eye, p_dosage, p_frequency, IFNULL(p_start_date, CURDATE()));

    SELECT LAST_INSERT_ID() AS treatment_id;
END $$

DELIMITER ;

CALL sp_register_treatment(31, 1, 'AO', '1 gota', 'Cada noche', '2026-10-01');

-- Ejercicio 21: Crear un procedimiento para actualizar teléfono y correo de un paciente.
DROP PROCEDURE IF EXISTS sp_update_patient_contact;

DELIMITER $$

CREATE PROCEDURE sp_update_patient_contact(
    IN p_patient_id BIGINT,
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(150)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    UPDATE patients
    SET phone = p_phone,
        email = LOWER(TRIM(p_email))
    WHERE id = p_patient_id;

    SELECT id, phone, email FROM patients WHERE id = p_patient_id;
END $$

DELIMITER ;

CALL sp_update_patient_contact(20, '3029998877', 'Daniela.Carrillo@Gmail.com');

-- Ejercicio 22: Crear un procedimiento para modificar el estado de una historia clínica.
DROP PROCEDURE IF EXISTS sp_update_history_status;

DELIMITER $$

CREATE PROCEDURE sp_update_history_status(
    IN p_history_id BIGINT,
    IN p_status VARCHAR(10)
)
BEGIN
    IF p_status NOT IN ('ACTIVA', 'CERRADA') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no válido: use ACTIVA o CERRADA';
    END IF;

    UPDATE clinical_histories
    SET status = p_status
    WHERE id = p_history_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La historia clínica no existe';
    END IF;
END $$

DELIMITER ;

CALL sp_update_history_status(19, 'CERRADA');
SELECT id, history_number, status FROM clinical_histories WHERE id = 19;
-- CALL sp_update_history_status(19, 'ARCHIVADA');  -- Error: Estado no válido: use ACTIVA o CERRADA

-- Ejercicio 23: Crear un procedimiento para actualizar observaciones de una consulta.
DROP PROCEDURE IF EXISTS sp_update_visit_observations;

DELIMITER $$

CREATE PROCEDURE sp_update_visit_observations(
    IN p_visit_id BIGINT,
    IN p_observations TEXT
)
BEGIN
    UPDATE medical_visits
    SET observations = p_observations
    WHERE id = p_visit_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta no existe o no hubo cambios';
    END IF;
END $$

DELIMITER ;

CALL sp_update_visit_observations(14, 'Se programa SLT bilateral y control en 3 meses');

-- Ejercicio 24: Crear un procedimiento para modificar la presión objetivo de un paciente con glaucoma.
DROP PROCEDURE IF EXISTS sp_update_target_pressure;

DELIMITER $$

CREATE PROCEDURE sp_update_target_pressure(
    IN p_patient_id BIGINT,
    IN p_target_pressure DECIMAL(4,1)
)
BEGIN
    IF p_target_pressure IS NULL OR p_target_pressure <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La presión objetivo debe ser mayor que cero';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM glaucoma_records WHERE patient_id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene registro de glaucoma';
    END IF;

    UPDATE glaucoma_records
    SET target_pressure = p_target_pressure
    WHERE patient_id = p_patient_id;
END $$

DELIMITER ;

CALL sp_update_target_pressure(4, 11.0);
-- CALL sp_update_target_pressure(10, 15.0);  -- Error: El paciente no tiene registro de glaucoma

-- Ejercicio 25: Crear un procedimiento para finalizar un tratamiento.
DROP PROCEDURE IF EXISTS sp_finish_treatment;

DELIMITER $$

CREATE PROCEDURE sp_finish_treatment(
    IN p_treatment_id BIGINT,
    IN p_end_date DATE
)
BEGIN
    DECLARE v_start DATE;
    DECLARE v_status VARCHAR(10);

    SELECT start_date, status INTO v_start, v_status
    FROM treatments
    WHERE id = p_treatment_id;

    IF v_start IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tratamiento no existe';
    END IF;

    IF v_status <> 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se puede finalizar un tratamiento activo';
    END IF;

    IF IFNULL(p_end_date, CURDATE()) < v_start THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final no puede ser anterior a la inicial';
    END IF;

    UPDATE treatments
    SET status = 'FINALIZADO',
        end_date = IFNULL(p_end_date, CURDATE())
    WHERE id = p_treatment_id;
END $$

DELIMITER ;

CALL sp_finish_treatment(2, '2026-02-12');
SELECT id, status, start_date, end_date FROM treatments WHERE id = 2;
-- CALL sp_finish_treatment(1, '2026-01-01');  -- Error: Solo se puede finalizar un tratamiento activo

-- Ejercicio 26: Crear un procedimiento para cambiar el medicamento de un tratamiento.
DROP PROCEDURE IF EXISTS sp_change_treatment_medication;

DELIMITER $$

CREATE PROCEDURE sp_change_treatment_medication(
    IN p_treatment_id BIGINT,
    IN p_medication_id INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM medications WHERE id = p_medication_id AND is_active = TRUE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El medicamento no existe o no está activo';
    END IF;

    UPDATE treatments
    SET medication_id = p_medication_id
    WHERE id = p_treatment_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tratamiento no existe o ya usa ese medicamento';
    END IF;
END $$

DELIMITER ;

CALL sp_change_treatment_medication(3, 4);
-- CALL sp_change_treatment_medication(3, 8);  -- Error: El medicamento no existe o no está activo (Pilocarpina)

-- Ejercicio 27: Crear un procedimiento para actualizar el estado clínico del glaucoma.
DROP PROCEDURE IF EXISTS sp_update_glaucoma_status;

DELIMITER $$

CREATE PROCEDURE sp_update_glaucoma_status(
    IN p_patient_id BIGINT,
    IN p_status VARCHAR(20)
)
BEGIN
    IF p_status NOT IN ('CONTROLADO', 'NO_CONTROLADO', 'EN_PROGRESION', 'ESTABLE') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no válido: CONTROLADO, NO_CONTROLADO, EN_PROGRESION o ESTABLE';
    END IF;

    UPDATE glaucoma_records
    SET clinical_status = p_status
    WHERE patient_id = p_patient_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene registro de glaucoma o ya tiene ese estado';
    END IF;
END $$

DELIMITER ;

CALL sp_update_glaucoma_status(6, 'CONTROLADO');

-- Ejercicio 28: Crear un procedimiento para actualizar información de un profesional.
-- Los parámetros NULL conservan el valor actual.
DROP PROCEDURE IF EXISTS sp_update_professional;

DELIMITER $$

CREATE PROCEDURE sp_update_professional(
    IN p_professional_id BIGINT,
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(20),
    IN p_specialty_id INT,
    IN p_is_active BOOLEAN
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM healthcare_professionals WHERE id = p_professional_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesional no existe';
    END IF;

    UPDATE healthcare_professionals
    SET email = IFNULL(p_email, email),
        phone = IFNULL(p_phone, phone),
        specialty_id = IFNULL(p_specialty_id, specialty_id),
        is_active = IFNULL(p_is_active, is_active)
    WHERE id = p_professional_id;

    SELECT * FROM healthcare_professionals WHERE id = p_professional_id;
END $$

DELIMITER ;

CALL sp_update_professional(5, NULL, '3005005099', NULL, NULL);

-- Ejercicio 29: Crear un procedimiento para modificar la interpretación de un OCT.
DROP PROCEDURE IF EXISTS sp_update_oct_interpretation;

DELIMITER $$

CREATE PROCEDURE sp_update_oct_interpretation(
    IN p_oct_id BIGINT,
    IN p_interpretation TEXT
)
BEGIN
    UPDATE oct_exams
    SET interpretation = p_interpretation
    WHERE id = p_oct_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El OCT no existe o no hubo cambios';
    END IF;
END $$

DELIMITER ;

-- OCT 13 = consulta 14 (sin validar).
CALL sp_update_oct_interpretation(13, 'Adelgazamiento progresivo de la capa de fibras nerviosas en OD');

-- Ejercicio 30: Crear un procedimiento para actualizar la interpretación de un campo visual.
DROP PROCEDURE IF EXISTS sp_update_visual_field_interpretation;

DELIMITER $$

CREATE PROCEDURE sp_update_visual_field_interpretation(
    IN p_visual_field_id BIGINT,
    IN p_interpretation TEXT
)
BEGIN
    UPDATE visual_field_exams
    SET interpretation = p_interpretation
    WHERE id = p_visual_field_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El campo visual no existe o no hubo cambios';
    END IF;
END $$

DELIMITER ;

CALL sp_update_visual_field_interpretation(13, 'Defecto arciforme superior y escalón nasal en OD');

-- Ejercicio 31: Crear un procedimiento que registre una PIO únicamente si el paciente existe.
-- Valida además que la consulta pertenezca a ese paciente.
DROP PROCEDURE IF EXISTS sp_register_iop_for_patient;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_for_patient(
    IN p_patient_id BIGINT,
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_measured_at DATETIME
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM medical_visits mv
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE mv.id = p_visit_id AND ch.patient_id = p_patient_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta no pertenece al paciente';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_for_patient(20, 31, 'OI', 18.0, '2026-10-01 09:12:00');
-- CALL sp_register_iop_for_patient(999, 31, 'OI', 18, NULL);  -- Error: El paciente no existe
-- CALL sp_register_iop_for_patient(1, 31, 'OI', 18, NULL);    -- Error: La consulta no pertenece al paciente

-- Ejercicio 32: Crear un procedimiento que registre una consulta solo si existe la historia clínica.
DROP PROCEDURE IF EXISTS sp_register_visit_if_history;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_if_history(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM clinical_histories WHERE id = p_clinical_history_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La historia clínica no existe';
    END IF;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, p_visit_date, p_reason);

    SELECT LAST_INSERT_ID() AS visit_id;
END $$

DELIMITER ;

CALL sp_register_visit_if_history(18, 5, '2026-09-28 10:00:00', 'Valoración optométrica de rutina');
-- CALL sp_register_visit_if_history(999, 1, NOW(), 'X');  -- Error: La historia clínica no existe

-- Ejercicio 33: Crear un procedimiento que impida registrar un tratamiento con fecha final anterior a la inicial.
DROP PROCEDURE IF EXISTS sp_register_treatment_with_dates;

DELIMITER $$

CREATE PROCEDURE sp_register_treatment_with_dates(
    IN p_visit_id BIGINT,
    IN p_medication_id INT,
    IN p_eye VARCHAR(2),
    IN p_dosage VARCHAR(100),
    IN p_frequency VARCHAR(100),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    IF p_end_date IS NOT NULL AND p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final no puede ser anterior a la inicial';
    END IF;

    INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date, end_date, status)
    VALUES (p_visit_id, p_medication_id, p_eye, p_dosage, p_frequency, p_start_date, p_end_date,
            IF(p_end_date IS NULL, 'ACTIVO', 'FINALIZADO'));

    SELECT LAST_INSERT_ID() AS treatment_id;
END $$

DELIMITER ;

CALL sp_register_treatment_with_dates(17, 2, 'AO', '1 gota', 'Cada 12 horas', '2025-12-09', '2026-06-30');
-- CALL sp_register_treatment_with_dates(17, 2, 'AO', '1 gota', 'Cada 12 horas', '2026-06-30', '2025-12-09');
--   Error: La fecha final no puede ser anterior a la inicial

-- Ejercicio 34: Crear un procedimiento que impida registrar valores negativos de PIO.
DROP PROCEDURE IF EXISTS sp_register_iop_non_negative;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_non_negative(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_measured_at DATETIME
)
BEGIN
    IF p_pressure IS NULL OR p_pressure < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO no puede ser negativa';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (p_visit_id, p_eye, p_pressure, IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_non_negative(29, 'OD', 16.0, '2026-09-01 07:40:00');
-- CALL sp_register_iop_non_negative(29, 'OD', -4, NULL);  -- Error: La PIO no puede ser negativa

-- Ejercicio 35: Crear un procedimiento que valide que el ojo recibido sea `OD` u `OI`.
DROP PROCEDURE IF EXISTS sp_register_iop_valid_eye;

DELIMITER $$

CREATE PROCEDURE sp_register_iop_valid_eye(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1),
    IN p_measured_at DATETIME
)
BEGIN
    IF p_eye IS NULL OR UPPER(p_eye) NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (p_visit_id, UPPER(p_eye), p_pressure, IFNULL(p_measured_at, NOW()));

    SELECT LAST_INSERT_ID() AS iop_id;
END $$

DELIMITER ;

CALL sp_register_iop_valid_eye(29, 'oi', 15.0, '2026-09-01 07:41:00');
-- CALL sp_register_iop_valid_eye(29, 'AO', 15, NULL);  -- Error: El ojo debe ser OD u OI

-- Ejercicio 36: Crear un procedimiento que impida crear dos historias clínicas para el mismo paciente.
DROP PROCEDURE IF EXISTS sp_create_unique_history;

DELIMITER $$

CREATE PROCEDURE sp_create_unique_history(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    IF EXISTS (SELECT 1 FROM clinical_histories WHERE patient_id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente ya tiene una historia clínica';
    END IF;

    INSERT INTO clinical_histories (patient_id, history_number)
    VALUES (p_patient_id, CONCAT('HC-', LPAD(p_patient_id, 6, '0')));

    SELECT LAST_INSERT_ID() AS clinical_history_id;
END $$

DELIMITER ;

-- El paciente 21 se creó en el ejercicio 11 y aún no tiene historia.
CALL sp_create_unique_history(21);
-- CALL sp_create_unique_history(1);  -- Error: El paciente ya tiene una historia clínica

-- Ejercicio 37: Crear un procedimiento que registre un diagnóstico solo si existe en el catálogo.
-- Recibe el código CIE-10 en lugar del id.
DROP PROCEDURE IF EXISTS sp_register_diagnosis_by_code;

DELIMITER $$

CREATE PROCEDURE sp_register_diagnosis_by_code(
    IN p_visit_id BIGINT,
    IN p_code VARCHAR(10),
    IN p_eye VARCHAR(2),
    IN p_is_primary BOOLEAN
)
BEGIN
    DECLARE v_diagnosis_id INT;

    SELECT id INTO v_diagnosis_id
    FROM diagnoses
    WHERE code = p_code;

    IF v_diagnosis_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El diagnóstico no existe en el catálogo';
    END IF;

    INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary)
    VALUES (p_visit_id, v_diagnosis_id, p_eye, IFNULL(p_is_primary, FALSE));
END $$

DELIMITER ;

CALL sp_register_diagnosis_by_code(31, 'H52.1', 'AO', FALSE);
-- CALL sp_register_diagnosis_by_code(31, 'Z99.9', 'AO', FALSE);  -- Error: El diagnóstico no existe en el catálogo

-- Ejercicio 38: Crear un procedimiento que valide que el profesional se encuentre activo antes de registrar una consulta.
DROP PROCEDURE IF EXISTS sp_register_visit_active_professional;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_active_professional(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM healthcare_professionals WHERE id = p_professional_id AND is_active = TRUE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesional no existe o no está activo';
    END IF;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, p_visit_date, p_reason);

    SELECT LAST_INSERT_ID() AS visit_id;
END $$

DELIMITER ;

CALL sp_register_visit_active_professional(13, 3, '2026-09-30 15:00:00', 'Control de ojo rojo');
-- CALL sp_register_visit_active_professional(13, 4, NOW(), 'X');  -- Error: El profesional no existe o no está activo (Jorge Castillo)

-- Ejercicio 39: Crear un procedimiento que registre un campo visual validando que VFI esté entre 0 y 100.
DROP PROCEDURE IF EXISTS sp_register_visual_field_checked;

DELIMITER $$

CREATE PROCEDURE sp_register_visual_field_checked(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_md DECIMAL(5,2),
    IN p_psd DECIMAL(5,2),
    IN p_vfi INT,
    IN p_exam_date DATE
)
BEGIN
    IF p_vfi IS NULL OR p_vfi < 0 OR p_vfi > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El VFI debe estar entre 0 y 100';
    END IF;

    INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, exam_date)
    VALUES (p_visit_id, p_eye, p_md, p_psd, p_vfi, p_exam_date);

    SELECT LAST_INSERT_ID() AS visual_field_id;
END $$

DELIMITER ;

CALL sp_register_visual_field_checked(31, 'OI', -1.0, 1.5, 98, '2026-10-01');
-- CALL sp_register_visual_field_checked(31, 'OI', -1.0, 1.5, 120, '2026-10-01');  -- Error: El VFI debe estar entre 0 y 100

-- Ejercicio 40: Crear un procedimiento que registre una paquimetría validando que el valor sea positivo.
DROP PROCEDURE IF EXISTS sp_register_pachymetry_checked;

DELIMITER $$

CREATE PROCEDURE sp_register_pachymetry_checked(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_thickness_um INT,
    IN p_exam_date DATE
)
BEGIN
    IF p_thickness_um IS NULL OR p_thickness_um <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espesor corneal debe ser un valor positivo';
    END IF;

    INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date)
    VALUES (p_visit_id, p_eye, p_thickness_um, p_exam_date);

    SELECT LAST_INSERT_ID() AS pachymetry_id;
END $$

DELIMITER ;

CALL sp_register_pachymetry_checked(31, 'OI', 549, '2026-10-01');
-- CALL sp_register_pachymetry_checked(31, 'OI', 0, '2026-10-01');  -- Error: El espesor corneal debe ser un valor positivo

-- Ejercicio 41: Crear un procedimiento que devuelva un resumen completo de la historia clínica de un paciente.
-- Devuelve varios conjuntos de resultados: datos, antecedentes, consultas, PIO y tratamientos.
DROP PROCEDURE IF EXISTS sp_patient_history_summary;

DELIMITER $$

CREATE PROCEDURE sp_patient_history_summary(
    IN p_patient_id BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    SELECT p.id,
           CONCAT(p.first_name, ' ', p.last_name) AS patient,
           p.document_number,
           TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) AS age,
           ch.history_number,
           ch.status AS history_status,
           gt.name AS glaucoma_type,
           g.clinical_status,
           g.target_pressure
    FROM patients p
    LEFT JOIN clinical_histories ch ON ch.patient_id = p.id
    LEFT JOIN glaucoma_records g ON g.patient_id = p.id
    LEFT JOIN glaucoma_types gt ON g.glaucoma_type_id = gt.id
    WHERE p.id = p_patient_id;

    SELECT 'Alergia' AS type, a.name AS detail, pa.reaction AS extra
    FROM patient_allergies pa
    INNER JOIN allergens a ON pa.allergen_id = a.id
    WHERE pa.patient_id = p_patient_id
    UNION ALL
    SELECT 'Familiar', d.name, pf.relationship
    FROM patient_family_histories pf
    INNER JOIN diagnoses d ON pf.diagnosis_id = d.id
    WHERE pf.patient_id = p_patient_id
    UNION ALL
    SELECT 'Personal', ht.name, pp.description
    FROM patient_personal_histories pp
    INNER JOIN history_types ht ON pp.history_type_id = ht.id
    WHERE pp.patient_id = p_patient_id;

    SELECT mv.id AS visit_id,
           mv.visit_date,
           mv.reason,
           GROUP_CONCAT(d.code ORDER BY vd.is_primary DESC SEPARATOR ', ') AS diagnoses
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id
    LEFT JOIN visit_diagnoses vd ON mv.id = vd.visit_id
    LEFT JOIN diagnoses d ON vd.diagnosis_id = d.id
    WHERE ch.patient_id = p_patient_id
    GROUP BY mv.id, mv.visit_date, mv.reason
    ORDER BY mv.visit_date;

    SELECT measured_at, eye, pressure, method
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
    ORDER BY measured_at, eye;

    SELECT m.name AS medication, t.eye, t.frequency, t.start_date, t.end_date, t.status
    FROM treatments t
    INNER JOIN medications m ON t.medication_id = m.id
    INNER JOIN medical_visits mv ON t.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY t.start_date;
END $$

DELIMITER ;

CALL sp_patient_history_summary(1);

-- Ejercicio 42: Crear un procedimiento que muestre la evolución de PIO de un paciente entre dos fechas.
DROP PROCEDURE IF EXISTS sp_iop_evolution_between;

DELIMITER $$

CREATE PROCEDURE sp_iop_evolution_between(
    IN p_patient_id BIGINT,
    IN p_from DATE,
    IN p_to DATE
)
BEGIN
    IF p_from > p_to THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha inicial no puede ser mayor que la final';
    END IF;

    SELECT DATE(measured_at) AS date,
           MAX(CASE WHEN eye = 'OD' THEN pressure END) AS iop_od,
           MAX(CASE WHEN eye = 'OI' THEN pressure END) AS iop_oi
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND measured_at >= p_from
      AND measured_at < p_to + INTERVAL 1 DAY
    GROUP BY DATE(measured_at)
    ORDER BY date;
END $$

DELIMITER ;

CALL sp_iop_evolution_between(1, '2025-01-01', '2026-12-31');

-- Ejercicio 43: Crear un procedimiento que reciba paciente y ojo y muestre todas sus mediciones cronológicamente.
DROP PROCEDURE IF EXISTS sp_iop_by_patient_eye;

DELIMITER $$

CREATE PROCEDURE sp_iop_by_patient_eye(
    IN p_patient_id BIGINT,
    IN p_eye VARCHAR(2)
)
BEGIN
    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    SELECT measured_at, pressure, method, professional
    FROM vw_patient_iop_history
    WHERE patient_id = p_patient_id
      AND eye = p_eye
    ORDER BY measured_at;
END $$

DELIMITER ;

CALL sp_iop_by_patient_eye(2, 'OD');

-- Ejercicio 44: Crear un procedimiento que genere estadísticas mensuales de consultas.
-- p_year NULL = todos los años.
DROP PROCEDURE IF EXISTS sp_monthly_visit_stats;

DELIMITER $$

CREATE PROCEDURE sp_monthly_visit_stats(
    IN p_year INT
)
BEGIN
    SELECT YEAR(mv.visit_date) AS year,
           MONTH(mv.visit_date) AS month,
           COUNT(*) AS total_visits,
           COUNT(DISTINCT mv.clinical_history_id) AS distinct_patients,
           COUNT(DISTINCT mv.professional_id) AS professionals
    FROM medical_visits mv
    WHERE p_year IS NULL OR YEAR(mv.visit_date) = p_year
    GROUP BY YEAR(mv.visit_date), MONTH(mv.visit_date)
    ORDER BY year, month;
END $$

DELIMITER ;

CALL sp_monthly_visit_stats(2026);

-- Ejercicio 45: Crear un procedimiento que calcule la cantidad de pacientes atendidos por cada especialista.
DROP PROCEDURE IF EXISTS sp_patients_per_specialist;

DELIMITER $$

CREATE PROCEDURE sp_patients_per_specialist()
BEGIN
    SELECT CONCAT(hp.first_name, ' ', hp.last_name) AS professional,
           s.name AS specialty,
           COUNT(DISTINCT mv.clinical_history_id) AS patients_attended,
           COUNT(mv.id) AS total_visits
    FROM healthcare_professionals hp
    INNER JOIN specialties s ON hp.specialty_id = s.id
    LEFT JOIN medical_visits mv ON mv.professional_id = hp.id
    GROUP BY hp.id, hp.first_name, hp.last_name, s.name
    ORDER BY patients_attended DESC;
END $$

DELIMITER ;

CALL sp_patients_per_specialist();

-- Ejercicio 46: Crear un procedimiento que determine pacientes sin consulta durante un número de meses recibido como parámetro.
-- Incluye pacientes que nunca han tenido consulta (last_visit NULL).
DROP PROCEDURE IF EXISTS sp_patients_without_visit;

DELIMITER $$

CREATE PROCEDURE sp_patients_without_visit(
    IN p_months INT
)
BEGIN
    IF p_months IS NULL OR p_months <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El número de meses debe ser mayor que cero';
    END IF;

    SELECT p.id,
           CONCAT(p.first_name, ' ', p.last_name) AS patient,
           MAX(mv.visit_date) AS last_visit
    FROM patients p
    LEFT JOIN clinical_histories ch ON ch.patient_id = p.id
    LEFT JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    GROUP BY p.id, p.first_name, p.last_name
    HAVING MAX(mv.visit_date) IS NULL
        OR MAX(mv.visit_date) < NOW() - INTERVAL p_months MONTH
    ORDER BY last_visit;
END $$

DELIMITER ;

CALL sp_patients_without_visit(6);

-- Ejercicio 47: Crear un procedimiento que genere un resumen de diagnósticos por paciente.
-- p_patient_id NULL = todos los pacientes.
DROP PROCEDURE IF EXISTS sp_diagnosis_summary_by_patient;

DELIMITER $$

CREATE PROCEDURE sp_diagnosis_summary_by_patient(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT ch.patient_id,
           CONCAT(p.first_name, ' ', p.last_name) AS patient,
           d.code,
           d.name AS diagnosis,
           COUNT(*) AS times_registered,
           MIN(mv.visit_date) AS first_time,
           MAX(mv.visit_date) AS last_time
    FROM visit_diagnoses vd
    INNER JOIN diagnoses d ON vd.diagnosis_id = d.id
    INNER JOIN medical_visits mv ON vd.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    INNER JOIN patients p ON ch.patient_id = p.id
    WHERE p_patient_id IS NULL OR ch.patient_id = p_patient_id
    GROUP BY ch.patient_id, p.first_name, p.last_name, d.id, d.code, d.name
    ORDER BY ch.patient_id, times_registered DESC;
END $$

DELIMITER ;

CALL sp_diagnosis_summary_by_patient(1);

-- Ejercicio 48: Crear un procedimiento que devuelva el último OCT, último campo visual y última PIO de un paciente.
DROP PROCEDURE IF EXISTS sp_latest_exams;

DELIMITER $$

CREATE PROCEDURE sp_latest_exams(
    IN p_patient_id BIGINT
)
BEGIN
    SELECT 'OCT' AS exam, o.eye, o.exam_date AS date, CONCAT('RNFL ', o.rnfl_average, ' µm') AS result
    FROM oct_exams o
    INNER JOIN medical_visits mv ON o.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND o.exam_date = (
          SELECT MAX(o2.exam_date)
          FROM oct_exams o2
          INNER JOIN medical_visits mv2 ON o2.visit_id = mv2.id
          WHERE mv2.clinical_history_id = ch.id)
    UNION ALL
    SELECT 'Campo visual', vf.eye, vf.exam_date, CONCAT('MD ', vf.md, ' / VFI ', vf.vfi, '%')
    FROM visual_field_exams vf
    INNER JOIN medical_visits mv ON vf.visit_id = mv.id
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
      AND vf.exam_date = (
          SELECT MAX(vf2.exam_date)
          FROM visual_field_exams vf2
          INNER JOIN medical_visits mv2 ON vf2.visit_id = mv2.id
          WHERE mv2.clinical_history_id = ch.id)
    UNION ALL
    SELECT 'PIO', v.eye, DATE(v.measured_at), CONCAT(v.pressure, ' mmHg')
    FROM vw_patient_iop_history v
    WHERE v.patient_id = p_patient_id
      AND v.measured_at = (
          SELECT MAX(v2.measured_at)
          FROM vw_patient_iop_history v2
          WHERE v2.patient_id = v.patient_id AND v2.eye = v.eye)
    ORDER BY exam, eye;
END $$

DELIMITER ;

CALL sp_latest_exams(1);

-- Ejercicio 49: Crear un procedimiento que registre en una sola transacción una consulta, un diagnóstico y una medición de PIO.
-- Si cualquier paso falla, el HANDLER deshace todo con ROLLBACK y relanza el error.
DROP PROCEDURE IF EXISTS sp_register_visit_with_diagnosis_iop;

DELIMITER $$

CREATE PROCEDURE sp_register_visit_with_diagnosis_iop(
    IN p_clinical_history_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_reason VARCHAR(255),
    IN p_diagnosis_id INT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(4,1)
)
BEGIN
    DECLARE v_visit_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason)
    VALUES (p_clinical_history_id, p_professional_id, p_visit_date, p_reason);

    SET v_visit_id = LAST_INSERT_ID();

    INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary)
    VALUES (v_visit_id, p_diagnosis_id, p_eye, TRUE);

    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO debe registrarse para OD u OI';
    END IF;

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (v_visit_id, p_eye, p_pressure, p_visit_date);

    COMMIT;

    SELECT v_visit_id AS visit_id;
END $$

DELIMITER ;

CALL sp_register_visit_with_diagnosis_iop(7, 3, '2026-09-29 10:00:00', 'Seguimiento de sospecha de glaucoma', 3, 'OD', 21.0);
-- Falla en el tercer paso (PIO 95 viola el CHECK y el trigger): no queda ni la consulta ni el diagnóstico.
-- CALL sp_register_visit_with_diagnosis_iop(7, 3, '2026-09-30 10:00:00', 'Prueba rollback', 3, 'OD', 95);
--   Error: La PIO debe estar entre 0 y 80 mmHg
-- SELECT COUNT(*) FROM medical_visits WHERE reason = 'Prueba rollback';  -- 0

-- Ejercicio 50: Crear un procedimiento transaccional que registre un control completo de glaucoma y ejecute `ROLLBACK` si alguna operación falla.
-- Registra consulta, PIO de ambos ojos y control; si hay progresión, actualiza el estado a EN_PROGRESION.
DROP PROCEDURE IF EXISTS sp_register_full_glaucoma_control;

DELIMITER $$

CREATE PROCEDURE sp_register_full_glaucoma_control(
    IN p_patient_id BIGINT,
    IN p_professional_id BIGINT,
    IN p_visit_date DATETIME,
    IN p_iop_od DECIMAL(4,1),
    IN p_iop_oi DECIMAL(4,1),
    IN p_progression BOOLEAN,
    IN p_notes TEXT
)
BEGIN
    DECLARE v_history_id BIGINT;
    DECLARE v_record_id BIGINT;
    DECLARE v_visit_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT ch.id, g.id INTO v_history_id, v_record_id
    FROM clinical_histories ch
    LEFT JOIN glaucoma_records g ON g.patient_id = ch.patient_id
    WHERE ch.patient_id = p_patient_id;

    IF v_history_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene historia clínica';
    END IF;

    IF v_record_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El paciente no tiene registro de glaucoma';
    END IF;

    INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason, observations)
    VALUES (v_history_id, p_professional_id, p_visit_date, 'Control de glaucoma', p_notes);

    SET v_visit_id = LAST_INSERT_ID();

    INSERT INTO intraocular_pressures (visit_id, eye, pressure, measured_at)
    VALUES (v_visit_id, 'OD', p_iop_od, p_visit_date),
           (v_visit_id, 'OI', p_iop_oi, p_visit_date);

    INSERT INTO glaucoma_controls (glaucoma_record_id, visit_id, control_date, progression_detected, notes)
    VALUES (v_record_id, v_visit_id, DATE(p_visit_date), IFNULL(p_progression, FALSE), p_notes);

    IF p_progression THEN
        UPDATE glaucoma_records
        SET clinical_status = 'EN_PROGRESION'
        WHERE id = v_record_id;
    END IF;

    COMMIT;

    SELECT v_visit_id AS visit_id, v_record_id AS glaucoma_record_id;
END $$

DELIMITER ;

CALL sp_register_full_glaucoma_control(3, 2, '2026-10-02 09:00:00', 17.0, 15.0, FALSE, 'Control estable, PIO cerca de la meta');
-- Falla en la PIO OI (-1): se deshace también la consulta ya insertada.
-- CALL sp_register_full_glaucoma_control(3, 2, '2026-10-03 09:00:00', 17.0, -1, FALSE, 'Prueba rollback');
--   Error: La PIO debe estar entre 0 y 80 mmHg
-- CALL sp_register_full_glaucoma_control(10, 2, '2026-10-03 09:00:00', 17, 16, FALSE, NULL);
--   Error: El paciente no tiene registro de glaucoma

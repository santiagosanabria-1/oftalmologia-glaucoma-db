-- =====================================================================
-- PARTE IV — 50 ejercicios de triggers
-- Requiere: sql/01_schema.sql a sql/07_events.sql. MariaDB 10.4+.
--
-- Nombres: trg_<tabla>_<momento>_<propósito>, con momento
--   bi = BEFORE INSERT, ai = AFTER INSERT, bu = BEFORE UPDATE,
--   au = AFTER UPDATE,  bd = BEFORE DELETE, ad = AFTER DELETE.
--
-- MariaDB (desde 10.2.3) permite varios triggers con el mismo evento y
-- momento sobre una tabla; se ejecutan en orden de creación salvo que se
-- indique FOLLOWS/PRECEDES. Cada choque se documenta en su ejercicio.
--
-- Las "copias" e "históricos" de los ejercicios 41–43 se guardan en
-- audit_logs.old_values como JSON, porque el esquema no tiene tablas de
-- histórico y no se crearon tablas nuevas.
--
-- Pruebas: debajo de cada trigger, comentadas para que el script cargue
-- sin errores. Formato:  -- PRUEBA: <sql>   -- ESPERADO: <resultado>.
-- Están pensadas para ejecutarse en orden sobre una base recién creada
-- (01 a 07 + este archivo). Todas se verificaron en MariaDB 10.4.
-- =====================================================================

USE oftalmologia_glaucoma;

-- Ejercicio 1: Crear un trigger que elimine espacios externos de los nombres de pacientes antes de insertarlos.
DROP TRIGGER IF EXISTS trg_patients_bi_trim_names;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_trim_names
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    SET NEW.first_name = TRIM(NEW.first_name);
    SET NEW.last_name = TRIM(NEW.last_name);
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex, email) VALUES (1, '1001001001', '  Juan  ', '  Pérez ', '1990-01-01', 'M', 'Juan.Perez@Gmail.COM');
-- PRUEBA: SELECT CONCAT('[', first_name, '][', last_name, ']') AS names FROM patients WHERE document_number = '1001001001';
-- ESPERADO: [Juan][Pérez]

-- Ejercicio 2: Convertir automáticamente el correo del paciente a minúsculas.
-- Comparte BEFORE INSERT en patients con los ejercicios 1, 3 y 4; no dependen del orden.
DROP TRIGGER IF EXISTS trg_patients_bi_lower_email;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_lower_email
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(TRIM(NEW.email));
END $$

DELIMITER ;

-- PRUEBA: SELECT email FROM patients WHERE document_number = '1001001001';
-- ESPERADO: juan.perez@gmail.com (insertado como Juan.Perez@Gmail.COM en la prueba 1)

-- Ejercicio 3: Convertir el número de documento a mayúsculas cuando contenga caracteres.
DROP TRIGGER IF EXISTS trg_patients_bi_upper_document;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_upper_document
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    IF NEW.document_number REGEXP '[A-Za-z]' THEN
        SET NEW.document_number = UPPER(NEW.document_number);
    END IF;
    SET NEW.document_number = TRIM(NEW.document_number);
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (3, 'e555abc', 'Paolo', 'Bianchi', '1987-02-02', 'M');
-- PRUEBA: SELECT document_number FROM patients WHERE first_name = 'Paolo';
-- ESPERADO: E555ABC

-- Ejercicio 4: Impedir registrar una fecha de nacimiento futura.
DROP TRIGGER IF EXISTS trg_patients_bi_birth_date;

DELIMITER $$

CREATE TRIGGER trg_patients_bi_birth_date
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de nacimiento no puede ser futura';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (1, '1001001002', 'Futuro', 'Paciente', '2099-01-01', 'F');
-- ESPERADO: ERROR 1644 La fecha de nacimiento no puede ser futura

-- Ejercicio 5: Impedir registrar una presión intraocular negativa.
-- Choque: trg_iop_before_insert_validate (06_triggers.sql) también es BEFORE INSERT en
-- intraocular_pressures y rechaza < 0 con otro mensaje. Con PRECEDES este trigger se
-- ejecuta antes, así el usuario ve el mensaje específico de valor negativo.
DROP TRIGGER IF EXISTS trg_iop_bi_non_negative;

DELIMITER $$

CREATE TRIGGER trg_iop_bi_non_negative
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
PRECEDES trg_iop_before_insert_validate
BEGIN
    IF NEW.pressure < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La presión intraocular no puede ser negativa';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'OD', -2, 'GOLDMANN', '2026-07-20 09:00:00');
-- ESPERADO: ERROR 1644 La presión intraocular no puede ser negativa
-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'OD', 16.5, 'GOLDMANN', '2026-07-20 09:05:00');
-- ESPERADO: 1 fila insertada

-- Ejercicio 6: Impedir registrar una PIO superior a un límite definido para datos plausibles.
-- Límite académico: 60 mmHg (el CHECK de la tabla permite hasta 80).
-- Choque: tercer BEFORE INSERT en intraocular_pressures; se ejecuta después del 06 (orden de creación).
DROP TRIGGER IF EXISTS trg_iop_bi_plausible_limit;

DELIMITER $$

CREATE TRIGGER trg_iop_bi_plausible_limit
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.pressure > 60 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO supera el límite plausible de 60 mmHg';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'OD', 65, 'GOLDMANN', '2026-07-20 09:10:00');
-- ESPERADO: ERROR 1644 La PIO supera el límite plausible de 60 mmHg

-- Ejercicio 7: Validar que el campo `eye` solo admita `OD` u `OI`.
-- Observación: eye es ENUM('OD','OI'). Con el sql_mode estricto (por defecto en MariaDB/XAMPP)
-- un valor como 'AO' se rechaza ANTES de ejecutar el trigger (Error 1265 Data truncated).
-- Si el modo no es estricto, MariaDB convierte el valor inválido en '' y entonces es el
-- trigger el que lo detecta. El trigger protege la regla aunque cambie el sql_mode.
-- Choque: cuarto BEFORE INSERT en intraocular_pressures.
DROP TRIGGER IF EXISTS trg_iop_bi_valid_eye;

DELIMITER $$

CREATE TRIGGER trg_iop_bi_valid_eye
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.eye IS NULL OR NEW.eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'AO', 15, 'GOLDMANN', '2026-07-20 09:15:00');
-- ESPERADO: ERROR 1265 Data truncated for column 'eye' (modo estricto)
-- PRUEBA: SET SESSION sql_mode = ''; INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (4, 'AO', 15, 'GOLDMANN', '2026-07-20 09:15:00');
-- ESPERADO: ERROR 1644 El ojo debe ser OD u OI (modo no estricto)

-- Ejercicio 8: Impedir que un tratamiento tenga fecha final anterior a la inicial.
DROP TRIGGER IF EXISTS trg_treatments_bi_dates;

DELIMITER $$

CREATE TRIGGER trg_treatments_bi_dates
BEFORE INSERT ON treatments
FOR EACH ROW
BEGIN
    IF NEW.end_date IS NOT NULL AND NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final del tratamiento no puede ser anterior a la inicial';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date, end_date, status) VALUES (4, 2, 'AO', '1 gota', 'Cada 12 horas', '2026-07-20', '2026-01-01', 'FINALIZADO');
-- ESPERADO: ERROR 1644 La fecha final del tratamiento no puede ser anterior a la inicial

-- Ejercicio 9: Validar que el VFI de un campo visual esté entre 0 y 100.
-- vfi es TINYINT (-128..127): un valor fuera de ese rango lo rechaza el tipo antes del trigger.
DROP TRIGGER IF EXISTS trg_visual_field_bi_vfi;

DELIMITER $$

CREATE TRIGGER trg_visual_field_bi_vfi
BEFORE INSERT ON visual_field_exams
FOR EACH ROW
BEGIN
    IF NEW.vfi < 0 OR NEW.vfi > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El VFI debe estar entre 0 y 100';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, exam_date) VALUES (4, 'OD', -5, 4, 110, '2026-07-20');
-- ESPERADO: ERROR 1644 El VFI debe estar entre 0 y 100

-- Ejercicio 10: Validar que la paquimetría sea mayor que cero.
DROP TRIGGER IF EXISTS trg_pachymetry_bi_positive;

DELIMITER $$

CREATE TRIGGER trg_pachymetry_bi_positive
BEFORE INSERT ON pachymetry_exams
FOR EACH ROW
BEGIN
    IF NEW.thickness_um <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espesor corneal debe ser mayor que cero';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date) VALUES (4, 'OD', 0, '2026-07-20');
-- ESPERADO: ERROR 1644 El espesor corneal debe ser mayor que cero

-- Ejercicio 11: Registrar en auditoría la creación de un nuevo paciente.
-- Choque: el ejercicio 50 crea otro AFTER INSERT en patients (auditoría completa). Ambos
-- escriben en audit_logs; en un sistema real se dejaría solo uno.
DROP TRIGGER IF EXISTS trg_patients_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_patients_ai_audit
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('patients', NEW.id, 'INSERT',
            JSON_OBJECT('document_number', NEW.document_number, 'first_name', NEW.first_name,
                        'last_name', NEW.last_name, 'birth_date', NEW.birth_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (1, '1001001003', 'Marta', 'León', '1970-03-03', 'F');
-- PRUEBA: SELECT action, new_values FROM audit_logs WHERE table_name = 'patients' AND action = 'INSERT' ORDER BY id DESC LIMIT 1;
-- ESPERADO: INSERT con los datos de Marta León

-- Ejercicio 12: Registrar en auditoría la creación de una historia clínica.
DROP TRIGGER IF EXISTS trg_clinical_histories_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_clinical_histories_ai_audit
AFTER INSERT ON clinical_histories
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('clinical_histories', NEW.id, 'INSERT',
            JSON_OBJECT('patient_id', NEW.patient_id, 'history_number', NEW.history_number, 'status', NEW.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO clinical_histories (patient_id, history_number) VALUES (20, 'HC-000020');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'clinical_histories';
-- ESPERADO: 1 fila con history_number HC-000020

-- Ejercicio 13: Registrar automáticamente en auditoría cada nueva consulta.
DROP TRIGGER IF EXISTS trg_medical_visits_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_ai_audit
AFTER INSERT ON medical_visits
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('medical_visits', NEW.id, 'INSERT',
            JSON_OBJECT('clinical_history_id', NEW.clinical_history_id, 'professional_id', NEW.professional_id,
                        'visit_date', NEW.visit_date, 'reason', NEW.reason),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason) VALUES (20, 1, '2026-10-01 08:00:00', 'Primera consulta');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'medical_visits';
-- ESPERADO: 1 fila con record_id 31

-- Ejercicio 14: Registrar cada nuevo diagnóstico asociado a una consulta.
-- visit_diagnoses tiene PK compuesta: record_id guarda visit_id y el JSON el diagnosis_id.
DROP TRIGGER IF EXISTS trg_visit_diagnoses_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_visit_diagnoses_ai_audit
AFTER INSERT ON visit_diagnoses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('visit_diagnoses', NEW.visit_id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'diagnosis_id', NEW.diagnosis_id,
                        'eye', NEW.eye, 'is_primary', NEW.is_primary),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary) VALUES (31, 3, 'AO', TRUE);
-- PRUEBA: SELECT new_values FROM audit_logs WHERE table_name = 'visit_diagnoses';
-- ESPERADO: {"visit_id": 31, "diagnosis_id": 3, "eye": "AO", "is_primary": 1}

-- Ejercicio 15: Registrar cada nueva medición de presión intraocular.
-- Choque: además existe trg_iop_after_insert_alert (06_triggers.sql) y el ejercicio 20,
-- ambos AFTER INSERT en intraocular_pressures; cada uno escribe en una tabla distinta.
DROP TRIGGER IF EXISTS trg_iop_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_iop_ai_audit
AFTER INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('intraocular_pressures', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'eye', NEW.eye, 'pressure', NEW.pressure,
                        'method', NEW.method, 'measured_at', NEW.measured_at),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (31, 'OD', 17, 'GOLDMANN', '2026-10-01 08:10:00');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'intraocular_pressures' AND record_id = (SELECT MAX(id) FROM intraocular_pressures);
-- ESPERADO: 1 fila con pressure 17.0

-- Ejercicio 16: Registrar cada nuevo tratamiento.
DROP TRIGGER IF EXISTS trg_treatments_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_treatments_ai_audit
AFTER INSERT ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('treatments', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'medication_id', NEW.medication_id, 'eye', NEW.eye,
                        'frequency', NEW.frequency, 'start_date', NEW.start_date, 'status', NEW.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date) VALUES (31, 1, 'AO', '1 gota', 'Cada noche', '2026-10-01');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'treatments' AND action = 'INSERT';
-- ESPERADO: 1 fila con record_id 16

-- Ejercicio 17: Registrar cada nuevo procedimiento.
DROP TRIGGER IF EXISTS trg_procedures_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_procedures_ai_audit
AFTER INSERT ON procedures
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('procedures', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'procedure_type_id', NEW.procedure_type_id,
                        'eye', NEW.eye, 'performed_at', NEW.performed_at),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO procedures (visit_id, procedure_type_id, eye, performed_at, notes) VALUES (18, 2, 'AO', '2026-07-10', 'SLT bilateral');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'procedures';
-- ESPERADO: 1 fila con record_id 8

-- Ejercicio 18: Registrar en auditoría cada nuevo estudio OCT.
DROP TRIGGER IF EXISTS trg_oct_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_oct_ai_audit
AFTER INSERT ON oct_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('oct_exams', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'eye', NEW.eye, 'rnfl_average', NEW.rnfl_average,
                        'exam_date', NEW.exam_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO oct_exams (visit_id, eye, rnfl_average, cup_disc_ratio, exam_date) VALUES (31, 'OD', 93.0, 0.45, '2026-10-01');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'oct_exams';
-- ESPERADO: 1 fila con record_id 21

-- Ejercicio 19: Registrar cada campo visual creado.
DROP TRIGGER IF EXISTS trg_visual_field_ai_audit;

DELIMITER $$

CREATE TRIGGER trg_visual_field_ai_audit
AFTER INSERT ON visual_field_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('visual_field_exams', NEW.id, 'INSERT',
            JSON_OBJECT('visit_id', NEW.visit_id, 'eye', NEW.eye, 'md', NEW.md, 'psd', NEW.psd,
                        'vfi', NEW.vfi, 'exam_date', NEW.exam_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, exam_date) VALUES (31, 'OD', -0.9, 1.5, 99, '2026-10-01');
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE table_name = 'visual_field_exams';
-- ESPERADO: 1 fila con record_id 21

-- Ejercicio 20: Crear una notificación interna cuando se registre una PIO mayor que un valor determinado.
-- Umbral: 30 mmHg (PIO muy elevada), independiente de la presión objetivo del paciente.
-- Choque: tercer AFTER INSERT en intraocular_pressures (ver ejercicio 15).
DROP TRIGGER IF EXISTS trg_iop_ai_critical_alert;

DELIMITER $$

CREATE TRIGGER trg_iop_ai_critical_alert
AFTER INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.pressure > 30 THEN
        INSERT INTO clinical_alerts (patient_id, alert_type, message)
        SELECT ch.patient_id,
               'PIO_CRITICA',
               CONCAT('PIO ', NEW.eye, ' de ', NEW.pressure, ' mmHg, mayor que el umbral de 30 mmHg')
        FROM medical_visits mv
        INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
        WHERE mv.id = NEW.visit_id;
    END IF;
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES (16, 'OD', 32, 'GOLDMANN', '2026-08-04 15:00:00');
-- PRUEBA: SELECT patient_id, alert_type, message FROM clinical_alerts WHERE alert_type = 'PIO_CRITICA';
-- ESPERADO: alerta PIO_CRITICA para el paciente 5 (y también una PIO_ALTA del trigger del 06)

-- Ejercicio 21: Actualizar automáticamente `updated_at` antes de modificar un paciente.
-- updated_at ya tiene ON UPDATE CURRENT_TIMESTAMP; el trigger lo hace explícito y además
-- funciona si alguien quita esa cláusula de la columna.
DROP TRIGGER IF EXISTS trg_patients_bu_updated_at;

DELIMITER $$

CREATE TRIGGER trg_patients_bu_updated_at
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET updated_at = '2000-01-01', phone = '3001112233' WHERE id = 3;
-- PRUEBA: SELECT updated_at > '2025-01-01' AS updated FROM patients WHERE id = 3;
-- ESPERADO: 1 (el trigger reemplaza la fecha enviada por NOW())

-- Ejercicio 22: Actualizar `updated_at` antes de modificar una consulta.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_updated_at;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_updated_at
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET updated_at = '2000-01-01', plan = 'SLT bilateral programada' WHERE id = 14;
-- PRUEBA: SELECT updated_at > '2025-01-01' AS updated FROM medical_visits WHERE id = 14;
-- ESPERADO: 1

-- Ejercicio 23: Impedir modificar el número de documento una vez creada la historia clínica.
-- Comparte BEFORE UPDATE en patients con el ejercicio 21 (independientes).
DROP TRIGGER IF EXISTS trg_patients_bu_lock_document;

DELIMITER $$

CREATE TRIGGER trg_patients_bu_lock_document
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NEW.document_number <> OLD.document_number
       AND EXISTS (SELECT 1 FROM clinical_histories WHERE patient_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede cambiar el documento de un paciente con historia clínica';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET document_number = '9999999999' WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede cambiar el documento de un paciente con historia clínica
-- PRUEBA: UPDATE patients SET document_number = '1001001009' WHERE document_number = '1001001003';
-- ESPERADO: 1 fila modificada (Marta León no tiene historia)

-- Ejercicio 24: Impedir asignar una fecha de consulta futura no permitida.
-- Regla académica: al modificar, la fecha no puede quedar en el futuro.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_no_future;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_no_future
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    IF NEW.visit_date > NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de la consulta no puede ser futura';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET visit_date = '2099-01-01 08:00:00' WHERE id = 14;
-- ESPERADO: ERROR 1644 La fecha de la consulta no puede ser futura

-- Ejercicio 25: Validar que una nueva presión objetivo sea positiva.
DROP TRIGGER IF EXISTS trg_glaucoma_records_bu_target;

DELIMITER $$

CREATE TRIGGER trg_glaucoma_records_bu_target
BEFORE UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
    IF NEW.target_pressure IS NULL OR NEW.target_pressure <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La presión objetivo debe ser positiva';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE glaucoma_records SET target_pressure = 0 WHERE id = 1;
-- ESPERADO: ERROR 1644 La presión objetivo debe ser positiva

-- Ejercicio 26: Impedir establecer una fecha final de tratamiento anterior a su inicio.
DROP TRIGGER IF EXISTS trg_treatments_bu_dates;

DELIMITER $$

CREATE TRIGGER trg_treatments_bu_dates
BEFORE UPDATE ON treatments
FOR EACH ROW
BEGIN
    IF NEW.end_date IS NOT NULL AND NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha final del tratamiento no puede ser anterior a su inicio';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE treatments SET end_date = '2020-01-01' WHERE id = 2;
-- ESPERADO: ERROR 1644 La fecha final del tratamiento no puede ser anterior a su inicio

-- Ejercicio 27: Evitar modificar un examen OCT que haya sido marcado como validado.
DROP TRIGGER IF EXISTS trg_oct_bu_lock_validated;

DELIMITER $$

CREATE TRIGGER trg_oct_bu_lock_validated
BEFORE UPDATE ON oct_exams
FOR EACH ROW
BEGIN
    IF OLD.is_validated = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede modificar un OCT validado';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE oct_exams SET interpretation = 'Cambio' WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede modificar un OCT validado
-- PRUEBA: UPDATE oct_exams SET is_validated = TRUE WHERE id = 3;
-- ESPERADO: 1 fila modificada (el OCT 3 no estaba validado)

-- Ejercicio 28: Evitar modificar una consulta marcada como cerrada.
-- Se permite solo reabrirla (is_closed de TRUE a FALSE) para corregirla de forma explícita.
-- Choque: tercer BEFORE UPDATE en medical_visits (ejercicios 22 y 24); independientes.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_lock_closed;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_lock_closed
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    IF OLD.is_closed = TRUE AND NEW.is_closed = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La consulta está cerrada y no se puede modificar';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET reason = 'Cambio' WHERE id = 1;
-- ESPERADO: ERROR 1644 La consulta está cerrada y no se puede modificar

-- Ejercicio 29: Validar valores del campo visual antes de una actualización.
-- Rangos: VFI 0–100, PSD >= 0 y MD entre -35 y 5 dB.
DROP TRIGGER IF EXISTS trg_visual_field_bu_validate;

DELIMITER $$

CREATE TRIGGER trg_visual_field_bu_validate
BEFORE UPDATE ON visual_field_exams
FOR EACH ROW
BEGIN
    IF NEW.vfi < 0 OR NEW.vfi > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El VFI debe estar entre 0 y 100';
    END IF;
    IF NEW.psd < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El PSD no puede ser negativo';
    END IF;
    IF NEW.md < -35 OR NEW.md > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El MD debe estar entre -35 y 5 dB';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE visual_field_exams SET md = -40 WHERE id = 1;
-- ESPERADO: ERROR 1644 El MD debe estar entre -35 y 5 dB

-- Ejercicio 30: Normalizar observaciones eliminando espacios innecesarios antes de actualizar.
-- Quita espacios externos y reduce espacios repetidos a uno. Cuarto BEFORE UPDATE en medical_visits.
DROP TRIGGER IF EXISTS trg_medical_visits_bu_clean_observations;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bu_clean_observations
BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
    IF NEW.observations IS NOT NULL THEN
        SET NEW.observations = TRIM(REGEXP_REPLACE(NEW.observations, '[[:space:]]{2,}', ' '));
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE medical_visits SET observations = '   Paciente   refiere   mejoría   ' WHERE id = 14;
-- PRUEBA: SELECT CONCAT('[', observations, ']') FROM medical_visits WHERE id = 14;
-- ESPERADO: [Paciente refiere mejoría]

-- Ejercicio 31: Registrar cambios de datos personales del paciente.
-- Solo registra si cambió algún dato personal. Choque: AFTER UPDATE en patients junto con
-- trg_patients_after_update_audit (06), el ejercicio 32 y el 50.
DROP TRIGGER IF EXISTS trg_patients_au_personal_data;

DELIMITER $$

CREATE TRIGGER trg_patients_au_personal_data
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NOT (OLD.first_name <=> NEW.first_name AND OLD.last_name <=> NEW.last_name
            AND OLD.birth_date <=> NEW.birth_date AND OLD.sex <=> NEW.sex
            AND OLD.address <=> NEW.address AND OLD.city_id <=> NEW.city_id
            AND OLD.phone <=> NEW.phone) THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('patients', NEW.id, 'UPDATE',
                JSON_OBJECT('first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                            'sex', OLD.sex, 'address', OLD.address, 'city_id', OLD.city_id, 'phone', OLD.phone),
                JSON_OBJECT('first_name', NEW.first_name, 'last_name', NEW.last_name, 'birth_date', NEW.birth_date,
                            'sex', NEW.sex, 'address', NEW.address, 'city_id', NEW.city_id, 'phone', NEW.phone),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET address = 'Cra 30 # 50-10' WHERE id = 2;
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.address') AS old_address, JSON_VALUE(new_values, '$.address') AS new_address FROM audit_logs WHERE table_name = 'patients' AND record_id = 2 AND JSON_CONTAINS_PATH(old_values, 'one', '$.sex') AND NOT JSON_CONTAINS_PATH(new_values, 'one', '$.audit');
-- ESPERADO: Calle 56 # 31-22 → Cra 30 # 50-10

-- Ejercicio 32: Guardar valor anterior y nuevo del correo del paciente.
DROP TRIGGER IF EXISTS trg_patients_au_email;

DELIMITER $$

CREATE TRIGGER trg_patients_au_email
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NOT (OLD.email <=> NEW.email) THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('patients', NEW.id, 'UPDATE',
                JSON_OBJECT('email', OLD.email),
                JSON_OBJECT('email', NEW.email),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE patients SET email = 'mafe.rueda@gmail.com' WHERE id = 2;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE record_id = 2 AND JSON_LENGTH(old_values) = 1;
-- ESPERADO: {"email": "mafe.rueda@hotmail.com"} → {"email": "mafe.rueda@gmail.com"}

-- Ejercicio 33: Registrar cambios en la presión objetivo.
DROP TRIGGER IF EXISTS trg_glaucoma_records_au_target;

DELIMITER $$

CREATE TRIGGER trg_glaucoma_records_au_target
AFTER UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
    IF OLD.target_pressure <> NEW.target_pressure THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('glaucoma_records', NEW.id, 'UPDATE',
                JSON_OBJECT('target_pressure', OLD.target_pressure),
                JSON_OBJECT('target_pressure', NEW.target_pressure),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE glaucoma_records SET target_pressure = 15 WHERE id = 2;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'glaucoma_records' AND JSON_CONTAINS_PATH(old_values, 'one', '$.target_pressure');
-- ESPERADO: 18.0 → 15.0

-- Ejercicio 34: Auditar cambios en el estado del glaucoma.
-- Comparte AFTER UPDATE en glaucoma_records con el ejercicio 33 (independientes).
DROP TRIGGER IF EXISTS trg_glaucoma_records_au_status;

DELIMITER $$

CREATE TRIGGER trg_glaucoma_records_au_status
AFTER UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
    IF OLD.clinical_status <> NEW.clinical_status THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('glaucoma_records', NEW.id, 'UPDATE',
                JSON_OBJECT('clinical_status', OLD.clinical_status),
                JSON_OBJECT('clinical_status', NEW.clinical_status),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE glaucoma_records SET clinical_status = 'EN_PROGRESION' WHERE id = 2;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'glaucoma_records' AND JSON_CONTAINS_PATH(old_values, 'one', '$.clinical_status');
-- ESPERADO: NO_CONTROLADO → EN_PROGRESION

-- Ejercicio 35: Registrar cambios en tratamientos.
DROP TRIGGER IF EXISTS trg_treatments_au_audit;

DELIMITER $$

CREATE TRIGGER trg_treatments_au_audit
AFTER UPDATE ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('treatments', NEW.id, 'UPDATE',
            JSON_OBJECT('medication_id', OLD.medication_id, 'dosage', OLD.dosage, 'frequency', OLD.frequency,
                        'end_date', OLD.end_date, 'status', OLD.status),
            JSON_OBJECT('medication_id', NEW.medication_id, 'dosage', NEW.dosage, 'frequency', NEW.frequency,
                        'end_date', NEW.end_date, 'status', NEW.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: UPDATE treatments SET frequency = 'Cada 24 horas' WHERE id = 3;
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.frequency'), JSON_VALUE(new_values, '$.frequency') FROM audit_logs WHERE table_name = 'treatments' AND action = 'UPDATE';
-- ESPERADO: Cada 12 horas → Cada 24 horas

-- Ejercicio 36: Registrar cambios en diagnósticos.
DROP TRIGGER IF EXISTS trg_visit_diagnoses_au_audit;

DELIMITER $$

CREATE TRIGGER trg_visit_diagnoses_au_audit
AFTER UPDATE ON visit_diagnoses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('visit_diagnoses', NEW.visit_id, 'UPDATE',
            JSON_OBJECT('diagnosis_id', OLD.diagnosis_id, 'eye', OLD.eye, 'is_primary', OLD.is_primary),
            JSON_OBJECT('diagnosis_id', NEW.diagnosis_id, 'eye', NEW.eye, 'is_primary', NEW.is_primary),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: UPDATE visit_diagnoses SET eye = 'AO' WHERE visit_id = 1 AND diagnosis_id = 5;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'visit_diagnoses' AND action = 'UPDATE';
-- ESPERADO: eye OI → AO

-- Ejercicio 37: Registrar cambios de interpretación de OCT.
DROP TRIGGER IF EXISTS trg_oct_au_interpretation;

DELIMITER $$

CREATE TRIGGER trg_oct_au_interpretation
AFTER UPDATE ON oct_exams
FOR EACH ROW
BEGIN
    IF NOT (OLD.interpretation <=> NEW.interpretation) THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('oct_exams', NEW.id, 'UPDATE',
                JSON_OBJECT('interpretation', OLD.interpretation),
                JSON_OBJECT('interpretation', NEW.interpretation),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE oct_exams SET interpretation = 'Adelgazamiento difuso de la RNFL' WHERE id = 4;
-- PRUEBA: SELECT old_values, new_values FROM audit_logs WHERE table_name = 'oct_exams' AND action = 'UPDATE';
-- ESPERADO: 1 fila con la interpretación anterior y la nueva (el OCT 4 no está validado)

-- Ejercicio 38: Registrar modificaciones de campos visuales.
DROP TRIGGER IF EXISTS trg_visual_field_au_audit;

DELIMITER $$

CREATE TRIGGER trg_visual_field_au_audit
AFTER UPDATE ON visual_field_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('visual_field_exams', NEW.id, 'UPDATE',
            JSON_OBJECT('md', OLD.md, 'psd', OLD.psd, 'vfi', OLD.vfi, 'reliability', OLD.reliability,
                        'interpretation', OLD.interpretation),
            JSON_OBJECT('md', NEW.md, 'psd', NEW.psd, 'vfi', NEW.vfi, 'reliability', NEW.reliability,
                        'interpretation', NEW.interpretation),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: UPDATE visual_field_exams SET reliability = 'MEDIA' WHERE id = 2;
-- PRUEBA: SELECT record_id, JSON_VALUE(new_values, '$.reliability') FROM audit_logs WHERE table_name = 'visual_field_exams' AND action = 'UPDATE';
-- ESPERADO: record_id 2, MEDIA

-- Ejercicio 39: Generar una alerta cuando una PIO sea actualizada a un valor superior al objetivo.
DROP TRIGGER IF EXISTS trg_iop_au_target_alert;

DELIMITER $$

CREATE TRIGGER trg_iop_au_target_alert
AFTER UPDATE ON intraocular_pressures
FOR EACH ROW
BEGIN
    DECLARE v_patient_id BIGINT;
    DECLARE v_target DECIMAL(4,1);

    SELECT ch.patient_id, g.target_pressure
      INTO v_patient_id, v_target
    FROM medical_visits mv
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    INNER JOIN glaucoma_records g ON g.patient_id = ch.patient_id
    WHERE mv.id = NEW.visit_id;

    IF v_target IS NOT NULL AND NEW.pressure > v_target AND OLD.pressure <> NEW.pressure THEN
        INSERT INTO clinical_alerts (patient_id, alert_type, message)
        VALUES (v_patient_id, 'PIO_CORREGIDA_ALTA',
                CONCAT('PIO ', NEW.eye, ' corregida de ', OLD.pressure, ' a ', NEW.pressure,
                       ' mmHg, supera el objetivo de ', v_target, ' mmHg'));
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE intraocular_pressures SET pressure = 21 WHERE id = 7;
-- PRUEBA: SELECT patient_id, message FROM clinical_alerts WHERE alert_type = 'PIO_CORREGIDA_ALTA';
-- ESPERADO: alerta para el paciente 1 (16.0 → 21.0, objetivo 18.0)

-- Ejercicio 40: Registrar cuándo un tratamiento cambia de activo a finalizado.
-- Choque: segundo AFTER UPDATE en treatments (ejercicio 35); este solo actúa en la transición.
DROP TRIGGER IF EXISTS trg_treatments_au_finished;

DELIMITER $$

CREATE TRIGGER trg_treatments_au_finished
AFTER UPDATE ON treatments
FOR EACH ROW
BEGIN
    IF OLD.status = 'ACTIVO' AND NEW.status = 'FINALIZADO' THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES ('treatments', NEW.id, 'UPDATE',
                JSON_OBJECT('status', OLD.status, 'end_date', OLD.end_date),
                JSON_OBJECT('status', NEW.status, 'end_date', NEW.end_date, 'event', 'TRATAMIENTO_FINALIZADO'),
                CURRENT_USER());
    END IF;
END $$

DELIMITER ;

-- PRUEBA: UPDATE treatments SET status = 'FINALIZADO', end_date = '2026-02-12' WHERE id = 2;
-- PRUEBA: SELECT record_id, new_values FROM audit_logs WHERE JSON_VALUE(new_values, '$.event') = 'TRATAMIENTO_FINALIZADO';
-- ESPERADO: record_id 2

-- Ejercicio 41: Guardar una copia de un paciente antes de eliminarlo.
DROP TRIGGER IF EXISTS trg_patients_bd_backup;

DELIMITER $$

CREATE TRIGGER trg_patients_bd_backup
BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('patients', OLD.id, 'DELETE',
            JSON_OBJECT('document_type_id', OLD.document_type_id, 'document_number', OLD.document_number,
                        'first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                        'sex', OLD.sex, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address,
                        'city_id', OLD.city_id, 'created_at', OLD.created_at),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM patients WHERE first_name = 'Paolo';
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.document_number') FROM audit_logs WHERE table_name = 'patients' AND action = 'DELETE' AND JSON_CONTAINS_PATH(old_values, 'one', '$.created_at');
-- ESPERADO: E555ABC (copia completa del paciente borrado)

-- Ejercicio 42: Guardar una copia de una consulta eliminada.
DROP TRIGGER IF EXISTS trg_medical_visits_bd_backup;

DELIMITER $$

CREATE TRIGGER trg_medical_visits_bd_backup
BEFORE DELETE ON medical_visits
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('medical_visits', OLD.id, 'DELETE',
            JSON_OBJECT('clinical_history_id', OLD.clinical_history_id, 'professional_id', OLD.professional_id,
                        'visit_date', OLD.visit_date, 'reason', OLD.reason, 'assessment', OLD.assessment,
                        'plan', OLD.plan, 'observations', OLD.observations, 'is_closed', OLD.is_closed),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO medical_visits (clinical_history_id, professional_id, visit_date, reason) VALUES (19, 3, '2026-09-30 10:00:00', 'Consulta registrada por error');
-- PRUEBA: DELETE FROM medical_visits WHERE reason = 'Consulta registrada por error';
-- PRUEBA: SELECT JSON_VALUE(old_values, '$.reason') FROM audit_logs WHERE table_name = 'medical_visits' AND action = 'DELETE';
-- ESPERADO: Consulta registrada por error

-- Ejercicio 43: Guardar un histórico de un tratamiento eliminado.
DROP TRIGGER IF EXISTS trg_treatments_ad_history;

DELIMITER $$

CREATE TRIGGER trg_treatments_ad_history
AFTER DELETE ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('treatments', OLD.id, 'DELETE',
            JSON_OBJECT('visit_id', OLD.visit_id, 'medication_id', OLD.medication_id, 'eye', OLD.eye,
                        'dosage', OLD.dosage, 'frequency', OLD.frequency, 'start_date', OLD.start_date,
                        'end_date', OLD.end_date, 'status', OLD.status),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM treatments WHERE id = 15;
-- PRUEBA: SELECT old_values FROM audit_logs WHERE table_name = 'treatments' AND action = 'DELETE';
-- ESPERADO: copia del tratamiento 15 (Timolol, FINALIZADO)

-- Ejercicio 44: Registrar en auditoría la eliminación de un diagnóstico.
DROP TRIGGER IF EXISTS trg_visit_diagnoses_ad_audit;

DELIMITER $$

CREATE TRIGGER trg_visit_diagnoses_ad_audit
AFTER DELETE ON visit_diagnoses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('visit_diagnoses', OLD.visit_id, 'DELETE',
            JSON_OBJECT('visit_id', OLD.visit_id, 'diagnosis_id', OLD.diagnosis_id,
                        'eye', OLD.eye, 'is_primary', OLD.is_primary),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM visit_diagnoses WHERE visit_id = 1 AND diagnosis_id = 10;
-- PRUEBA: SELECT old_values FROM audit_logs WHERE table_name = 'visit_diagnoses' AND action = 'DELETE';
-- ESPERADO: {"visit_id": 1, "diagnosis_id": 10, "eye": null, "is_primary": 0}

-- Ejercicio 45: Impedir eliminar pacientes que tengan historia clínica.
-- Choque: segundo BEFORE DELETE en patients (ejercicio 41). Si este falla, MariaDB revierte
-- toda la sentencia, incluida la copia que el 41 ya había insertado en audit_logs.
DROP TRIGGER IF EXISTS trg_patients_bd_has_history;

DELIMITER $$

CREATE TRIGGER trg_patients_bd_has_history
BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM clinical_histories WHERE patient_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un paciente con historia clínica';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM patients WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede eliminar un paciente con historia clínica

-- Ejercicio 46: Impedir eliminar profesionales con consultas registradas.
DROP TRIGGER IF EXISTS trg_professionals_bd_has_visits;

DELIMITER $$

CREATE TRIGGER trg_professionals_bd_has_visits
BEFORE DELETE ON healthcare_professionals
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM medical_visits WHERE professional_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un profesional con consultas registradas';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM healthcare_professionals WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede eliminar un profesional con consultas registradas
-- PRUEBA: DELETE FROM healthcare_professionals WHERE id = 5;
-- ESPERADO: 1 fila eliminada (Valentina Ortiz no tiene consultas)

-- Ejercicio 47: Impedir eliminar medicamentos actualmente utilizados en tratamientos activos.
-- La FK ya impide borrar un medicamento con cualquier tratamiento; el trigger da un mensaje claro
-- para el caso de tratamientos activos.
DROP TRIGGER IF EXISTS trg_medications_bd_active_use;

DELIMITER $$

CREATE TRIGGER trg_medications_bd_active_use
BEFORE DELETE ON medications
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM treatments WHERE medication_id = OLD.id AND status = 'ACTIVO') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un medicamento con tratamientos activos';
    END IF;
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM medications WHERE id = 1;
-- ESPERADO: ERROR 1644 No se puede eliminar un medicamento con tratamientos activos
-- PRUEBA: DELETE FROM medications WHERE id = 8;
-- ESPERADO: 1 fila eliminada (Pilocarpina no se usa)

-- Ejercicio 48: Registrar automáticamente la eliminación de un examen OCT.
DROP TRIGGER IF EXISTS trg_oct_ad_audit;

DELIMITER $$

CREATE TRIGGER trg_oct_ad_audit
AFTER DELETE ON oct_exams
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('oct_exams', OLD.id, 'DELETE',
            JSON_OBJECT('visit_id', OLD.visit_id, 'eye', OLD.eye, 'rnfl_average', OLD.rnfl_average,
                        'cup_disc_ratio', OLD.cup_disc_ratio, 'interpretation', OLD.interpretation,
                        'is_validated', OLD.is_validated, 'exam_date', OLD.exam_date),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM oct_exams WHERE id = 20;
-- PRUEBA: SELECT record_id, action FROM audit_logs WHERE table_name = 'oct_exams' AND action = 'DELETE';
-- ESPERADO: record_id 20, DELETE

-- Ejercicio 49: Registrar quién eliminó un documento clínico.
-- CURRENT_USER() = cuenta con la que se autenticó; USER() = usuario y host desde donde se conectó.
DROP TRIGGER IF EXISTS trg_clinical_documents_ad_who;

DELIMITER $$

CREATE TRIGGER trg_clinical_documents_ad_who
AFTER DELETE ON clinical_documents
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
    VALUES ('clinical_documents', OLD.id, 'DELETE',
            JSON_OBJECT('clinical_history_id', OLD.clinical_history_id, 'document_kind', OLD.document_kind,
                        'file_name', OLD.file_name, 'file_path', OLD.file_path, 'deleted_from', USER()),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: DELETE FROM clinical_documents WHERE id = 7;
-- PRUEBA: SELECT changed_by, JSON_VALUE(old_values, '$.file_name') FROM audit_logs WHERE table_name = 'clinical_documents';
-- ESPERADO: root@localhost, epicrisis_facoemulsificacion.pdf

-- Ejercicio 50: Implementar un esquema completo de auditoría mediante triggers para `INSERT`, `UPDATE` y `DELETE` sobre la tabla `patients`.
-- Tres triggers que guardan la fila completa (antes/después) en JSON.
-- Choques documentados: AFTER INSERT con el ejercicio 11; AFTER UPDATE con el 06, el 31 y el 32.
-- Para AFTER DELETE es el único. En producción se dejaría solo este esquema y se quitarían los otros.
DROP TRIGGER IF EXISTS trg_patients_ai_full_audit;
DROP TRIGGER IF EXISTS trg_patients_au_full_audit;
DROP TRIGGER IF EXISTS trg_patients_ad_full_audit;

DELIMITER $$

CREATE TRIGGER trg_patients_ai_full_audit
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
    VALUES ('patients', NEW.id, 'INSERT',
            JSON_OBJECT('document_type_id', NEW.document_type_id, 'document_number', NEW.document_number,
                        'first_name', NEW.first_name, 'last_name', NEW.last_name, 'birth_date', NEW.birth_date,
                        'sex', NEW.sex, 'email', NEW.email, 'phone', NEW.phone, 'address', NEW.address,
                        'city_id', NEW.city_id, 'audit', 'FULL'),
            CURRENT_USER());
END $$

CREATE TRIGGER trg_patients_au_full_audit
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('patients', NEW.id, 'UPDATE',
            JSON_OBJECT('document_type_id', OLD.document_type_id, 'document_number', OLD.document_number,
                        'first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                        'sex', OLD.sex, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address,
                        'city_id', OLD.city_id),
            JSON_OBJECT('document_type_id', NEW.document_type_id, 'document_number', NEW.document_number,
                        'first_name', NEW.first_name, 'last_name', NEW.last_name, 'birth_date', NEW.birth_date,
                        'sex', NEW.sex, 'email', NEW.email, 'phone', NEW.phone, 'address', NEW.address,
                        'city_id', NEW.city_id, 'audit', 'FULL'),
            CURRENT_USER());
END $$

CREATE TRIGGER trg_patients_ad_full_audit
AFTER DELETE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('patients', OLD.id, 'DELETE',
            JSON_OBJECT('document_type_id', OLD.document_type_id, 'document_number', OLD.document_number,
                        'first_name', OLD.first_name, 'last_name', OLD.last_name, 'birth_date', OLD.birth_date,
                        'sex', OLD.sex, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address,
                        'city_id', OLD.city_id),
            JSON_OBJECT('audit', 'FULL'),
            CURRENT_USER());
END $$

DELIMITER ;

-- PRUEBA: INSERT INTO patients (document_type_id, document_number, first_name, last_name, birth_date, sex) VALUES (1, '1001001010', 'Prueba', 'Auditoría', '1999-09-09', 'M');
-- PRUEBA: UPDATE patients SET phone = '3110000000' WHERE document_number = '1001001010';
-- PRUEBA: DELETE FROM patients WHERE document_number = '1001001010';
-- PRUEBA: SELECT action, COUNT(*) FROM audit_logs WHERE table_name = 'patients' AND JSON_VALUE(new_values, '$.audit') = 'FULL' AND record_id = (SELECT MAX(record_id) FROM audit_logs WHERE table_name = 'patients') GROUP BY action;
-- ESPERADO: INSERT 1, UPDATE 1, DELETE 1

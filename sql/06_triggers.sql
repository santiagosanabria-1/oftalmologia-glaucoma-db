-- =====================================================================
-- 06_triggers.sql — Triggers del proyecto
-- Requiere: 01_schema.sql y 02_seed.sql. Compatible con MariaDB 10.4+.
-- Se cargan después del seed, así que los datos de prueba no disparan
-- alertas ni auditoría.
-- =====================================================================

USE oftalmologia_glaucoma;

-- ---------------------------------------------------------------------
-- trg_iop_before_insert_validate: valida la PIO antes de insertarla.
-- El CHECK chk_iop_range ya limita 0–80, pero el trigger da un mensaje
-- claro en español e impide además fechas de medición futuras.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_iop_before_insert_validate;

DELIMITER $$

CREATE TRIGGER trg_iop_before_insert_validate
BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    IF NEW.pressure < 0 OR NEW.pressure > 80 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO debe estar entre 0 y 80 mmHg';
    END IF;

    IF NEW.measured_at > NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de medición de la PIO no puede ser futura';
    END IF;
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- trg_iop_after_insert_alert: si el paciente tiene registro de glaucoma
-- y la nueva PIO supera su presión objetivo, crea una alerta PIO_ALTA.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_iop_after_insert_alert;

DELIMITER $$

CREATE TRIGGER trg_iop_after_insert_alert
AFTER INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    DECLARE v_patient_id BIGINT;
    DECLARE v_target DECIMAL(4,1);

    SELECT ch.patient_id, g.target_pressure
      INTO v_patient_id, v_target
    FROM medical_visits mv
    INNER JOIN clinical_histories ch ON mv.clinical_history_id = ch.id
    LEFT JOIN glaucoma_records g ON g.patient_id = ch.patient_id
    WHERE mv.id = NEW.visit_id;

    IF v_target IS NOT NULL AND NEW.pressure > v_target THEN
        INSERT INTO clinical_alerts (patient_id, alert_type, message)
        VALUES (v_patient_id, 'PIO_ALTA',
                CONCAT('PIO ', NEW.eye, ' de ', NEW.pressure, ' mmHg supera la presión objetivo (', v_target, ' mmHg)'));
    END IF;
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- trg_patients_after_update_audit: auditoría de cambios en pacientes.
-- Guarda en audit_logs los valores anterior y nuevo en JSON y el
-- usuario de base de datos que hizo el cambio.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_patients_after_update_audit;

DELIMITER $$

CREATE TRIGGER trg_patients_after_update_audit
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES (
        'patients',
        NEW.id,
        'UPDATE',
        JSON_OBJECT('document_number', OLD.document_number, 'first_name', OLD.first_name,
                    'last_name', OLD.last_name, 'email', OLD.email, 'phone', OLD.phone,
                    'address', OLD.address, 'city_id', OLD.city_id),
        JSON_OBJECT('document_number', NEW.document_number, 'first_name', NEW.first_name,
                    'last_name', NEW.last_name, 'email', NEW.email, 'phone', NEW.phone,
                    'address', NEW.address, 'city_id', NEW.city_id),
        CURRENT_USER()
    );
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Pruebas (comentadas para no alterar los datos al cargar el script).
-- Resultados verificados en MariaDB 10.4:
--
-- Válida: inserta y, como 25 > 18 (objetivo de Carlos Gómez), crea una alerta PIO_ALTA.
-- INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at)
-- VALUES (4, 'OD', 25, 'GOLDMANN', '2026-07-20 09:00:00');
-- SELECT * FROM clinical_alerts WHERE alert_type = 'PIO_ALTA';
--
-- Inválida: Error 1644 'La PIO debe estar entre 0 y 80 mmHg'
-- INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at)
-- VALUES (4, 'OD', 95, 'GOLDMANN', '2026-07-20 09:00:00');
--
-- Inválida: Error 1644 'La fecha de medición de la PIO no puede ser futura'
-- INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at)
-- VALUES (4, 'OD', 15, 'GOLDMANN', '2099-01-01 08:00:00');
--
-- Auditoría: deja una fila UPDATE en audit_logs con old_values y new_values.
-- UPDATE patients SET phone = '3000000000' WHERE id = 1;
-- SELECT * FROM audit_logs WHERE table_name = 'patients';
-- ---------------------------------------------------------------------

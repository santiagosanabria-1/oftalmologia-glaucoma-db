-- =====================================================================
-- 07_events.sql — Evento programado del proyecto
-- Requiere: 05_procedures.sql (sp_generate_control_alerts).
-- Compatible con MariaDB 10.4+.
--
-- IMPORTANTE: el evento solo se ejecuta si el programador de eventos
-- está encendido. En XAMPP viene apagado por defecto. Para activarlo
-- (como root, se pierde al reiniciar MariaDB):
--
--     SET GLOBAL event_scheduler = ON;
--
-- Para dejarlo fijo, agregar en C:\xampp\mysql\bin\my.ini, sección
-- [mysqld], la línea:  event_scheduler = ON
--
-- Verificar con:  SHOW VARIABLES LIKE 'event_scheduler';
-- Aunque el programador esté apagado, el evento se crea sin error.
-- =====================================================================

USE oftalmologia_glaucoma;

-- ---------------------------------------------------------------------
-- ev_daily_glaucoma_followup: todos los días a las 06:00 genera alertas
-- CONTROL_VENCIDO para pacientes con glaucoma sin consulta en más de
-- 6 meses. El procedimiento no duplica alertas sin leer.
-- ---------------------------------------------------------------------
DROP EVENT IF EXISTS ev_daily_glaucoma_followup;

CREATE EVENT ev_daily_glaucoma_followup
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY + INTERVAL 6 HOUR)
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Alertas diarias de controles de glaucoma vencidos (más de 6 meses)'
DO
    CALL sp_generate_control_alerts(6);

-- Comprobación
SELECT EVENT_NAME, STATUS, INTERVAL_VALUE, INTERVAL_FIELD, STARTS, EVENT_COMMENT
FROM information_schema.EVENTS
WHERE EVENT_SCHEMA = 'oftalmologia_glaucoma';

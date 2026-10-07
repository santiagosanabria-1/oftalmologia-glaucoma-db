
USE oftalmologia_glaucoma;

SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO document_types (id, code, name) VALUES
    (1, 'CC', 'Cédula de ciudadanía'),
    (2, 'TI', 'Tarjeta de identidad'),
    (3, 'CE', 'Cédula de extranjería'),
    (4, 'PA', 'Pasaporte');

INSERT INTO cities (id, name, department) VALUES
    (1, 'Bucaramanga', 'Santander'),
    (2, 'Floridablanca', 'Santander'),
    (3, 'Girón', 'Santander'),
    (4, 'Piedecuesta', 'Santander'),
    (5, 'Bogotá', 'Cundinamarca');

INSERT INTO specialties (id, name) VALUES
    (1, 'Glaucoma'),
    (2, 'Oftalmología'),
    (3, 'Retina'),
    (4, 'Optometría');

INSERT INTO allergens (id, name) VALUES
    (1, 'Penicilina'),
    (2, 'Sulfas'),
    (3, 'Látex'),
    (4, 'Yodo'),
    (5, 'AINES');

INSERT INTO history_types (id, name) VALUES
    (1, 'Sistémico'),
    (2, 'Ocular'),
    (3, 'Quirúrgico'),
    (4, 'Farmacológico');

INSERT INTO diagnoses (id, code, name, is_glaucoma) VALUES
    (1, 'H40.1', 'Glaucoma primario de ángulo abierto', TRUE),
    (2, 'H40.2', 'Glaucoma primario de ángulo cerrado', TRUE),
    (3, 'H40.0', 'Sospecha de glaucoma', FALSE),
    (4, 'H40.5', 'Glaucoma secundario a otros trastornos del ojo', TRUE),
    (5, 'H25.9', 'Catarata senil', FALSE),
    (6, 'H52.1', 'Miopía', FALSE),
    (7, 'H52.0', 'Hipermetropía', FALSE),
    (8, 'H04.1', 'Síndrome de ojo seco', FALSE),
    (9, 'E11.3', 'Diabetes mellitus tipo 2 con complicaciones oftálmicas', FALSE),
    (10, 'I10', 'Hipertensión arterial esencial', FALSE),
    (11, 'H35.3', 'Degeneración macular', FALSE),
    (12, 'H33.0', 'Desprendimiento de retina', FALSE);

INSERT INTO glaucoma_types (id, name) VALUES
    (1, 'Ángulo abierto'),
    (2, 'Ángulo cerrado'),
    (3, 'Normotensivo'),
    (4, 'Secundario'),
    (5, 'Congénito');

INSERT INTO medications (id, name, active_ingredient, presentation, is_active) VALUES
    (1, 'Latanoprost', 'Latanoprost 0.005%', 'Gotas oftálmicas 2.5 ml', TRUE),
    (2, 'Timolol', 'Maleato de timolol 0.5%', 'Gotas oftálmicas 5 ml', TRUE),
    (3, 'Brimonidina', 'Tartrato de brimonidina 0.2%', 'Gotas oftálmicas 5 ml', TRUE),
    (4, 'Dorzolamida', 'Dorzolamida 2%', 'Gotas oftálmicas 5 ml', TRUE),
    (5, 'Bimatoprost', 'Bimatoprost 0.01%', 'Gotas oftálmicas 3 ml', TRUE),
    (6, 'Travoprost', 'Travoprost 0.004%', 'Gotas oftálmicas 2.5 ml', TRUE),
    (7, 'Acetazolamida', 'Acetazolamida 250 mg', 'Tabletas', TRUE),
    (8, 'Pilocarpina', 'Pilocarpina 2%', 'Gotas oftálmicas 15 ml', FALSE);

INSERT INTO procedure_types (id, name, category) VALUES
    (1, 'Trabeculectomía', 'QUIRURGICO'),
    (2, 'Trabeculoplastia láser selectiva (SLT)', 'LASER'),
    (3, 'Iridotomía láser', 'LASER'),
    (4, 'Facoemulsificación', 'QUIRURGICO'),
    (5, 'Implante de válvula de Ahmed', 'QUIRURGICO'),
    (6, 'Ciclofotocoagulación', 'LASER');



INSERT INTO patients (id, document_type_id, document_number, first_name, last_name, birth_date, sex, email, phone, address, city_id) VALUES
    (1, 1, '1098456123', 'Carlos', 'Gómez', '1958-04-12', 'M', 'carlos.gomez@gmail.com', '3001234567', 'Cra 27 # 45-10', 1),
    (2, 1, '63345678', 'María Fernanda', 'Rueda', '1962-09-30', 'F', 'mafe.rueda@hotmail.com', '3109876543', 'Calle 56 # 31-22', 1),
    (3, 1, '1095789012', 'Luis Alberto', 'Gómez', '1970-01-25', 'M', NULL, '3157654321', 'Calle 200 # 12-30', 2),
    (4, 1, '37890123', 'Rosa Elena', 'Pinzón', '1955-06-18', 'F', 'rosa.pinzon@gmail.com', '3168889900', 'Cra 25 # 30-15', 3),
    (5, 1, '91234567', 'Jorge Enrique', 'Díaz', '1949-11-03', 'M', NULL, '3176543210', 'Calle 8 # 5-40', 4),
    (6, 1, '1098765432', 'Ana Lucía', 'Gómez', '1975-03-08', 'F', 'ana.gomez@gmail.com', '3012223344', 'Cra 33 # 48-05', 1),
    (7, 1, '1005432198', 'Pedro Pablo', 'Suárez', '1980-07-21', 'M', 'pedro.suarez@outlook.com', '3045556677', 'Calle 30 # 9-18', 2),
    (8, 1, '1102345678', 'Camila Andrea', 'Torres', '1992-12-14', 'F', 'camila.torres@gmail.com', '3128887766', 'Av. Calle 26 # 68-20', 5),
    (9, 2, '1097123456', 'Sofía Valentina', 'Mantilla', '2010-05-09', 'F', NULL, '3189990011', 'Calle 45 # 22-11', 1),
    (10, 1, '13456789', 'Hernando', 'Quintero', '1945-02-27', 'M', NULL, '6076341122', 'Cra 15 # 36-50', 1),
    (11, 3, 'E987654', 'Marco', 'Rossi', '1985-08-30', 'M', 'marco.rossi@yahoo.com', '3201112233', 'Calle 52 # 35-60', 1),
    (12, 1, '28123456', 'Gloria Patricia', 'Serrano', '1960-10-11', 'F', 'gloria.serrano@gmail.com', '3134445566', 'Cra 22 # 28-14', 3),
    (13, 1, '1096234567', 'Diego Fernando', 'Ardila', '1988-04-02', 'M', 'diego.ardila@hotmail.com', '3006667788', 'Calle 4 # 10-25', 2),
    (14, 1, '1099876543', 'Natalia', 'Ortiz', '1995-01-19', 'F', 'natalia.ortiz@gmail.com', '3117778899', 'Cra 6 # 3-45', 4),
    (15, 1, '5678901', 'Álvaro', 'Méndez', '1952-08-08', 'M', NULL, '3148889900', 'Calle 36 # 27-33', 1),
    (16, 1, '63987654', 'Luz Marina', 'Villamizar', '1958-11-25', 'F', 'luz.villamizar@hotmail.com', '3192223344', 'Cra 29 # 41-07', 1),
    (17, 4, 'AB123456', 'Lucas', 'Fernández', '1979-03-15', 'M', 'lucas.fernandez@gmail.com', '3221234567', 'Calle 93 # 15-40', 5),
    (18, 1, '1098111222', 'Juliana', 'Prada', '2000-06-06', 'F', 'juliana.prada@gmail.com', '3002345678', 'Calle 61 # 2W-15', 1),
    (19, 1, '1095333444', 'Sebastián', 'Rincón', '1990-09-09', 'M', NULL, '3013456789', 'Calle 147 # 24-08', 2),
    (20, 1, '1098555666', 'Daniela', 'Carrillo', '1998-02-14', 'F', 'daniela.carrillo@gmail.com', '3024567890', NULL, NULL);

INSERT INTO clinical_histories (id, patient_id, history_number, opened_at, status) VALUES
    (1, 1, 'HC-000001', '2025-01-15 08:00:00', 'ACTIVA'),
    (2, 2, 'HC-000002', '2025-01-15 08:00:00', 'ACTIVA'),
    (3, 3, 'HC-000003', '2025-01-15 08:00:00', 'ACTIVA'),
    (4, 4, 'HC-000004', '2025-01-15 08:00:00', 'ACTIVA'),
    (5, 5, 'HC-000005', '2025-01-15 08:00:00', 'ACTIVA'),
    (6, 6, 'HC-000006', '2025-01-15 08:00:00', 'ACTIVA'),
    (7, 7, 'HC-000007', '2025-01-15 08:00:00', 'ACTIVA'),
    (8, 8, 'HC-000008', '2025-01-15 08:00:00', 'ACTIVA'),
    (9, 9, 'HC-000009', '2025-03-01 08:00:00', 'ACTIVA'),
    (10, 10, 'HC-000010', '2025-03-01 08:00:00', 'ACTIVA'),
    (11, 11, 'HC-000011', '2025-03-01 08:00:00', 'ACTIVA'),
    (12, 12, 'HC-000012', '2025-03-01 08:00:00', 'ACTIVA'),
    (13, 13, 'HC-000013', '2025-03-01 08:00:00', 'ACTIVA'),
    (14, 14, 'HC-000014', '2025-03-01 08:00:00', 'ACTIVA'),
    (15, 15, 'HC-000015', '2025-03-01 08:00:00', 'ACTIVA'),
    (16, 16, 'HC-000016', '2025-03-01 08:00:00', 'ACTIVA'),
    (17, 17, 'HC-000017', '2025-03-01 08:00:00', 'ACTIVA'),
    (18, 18, 'HC-000018', '2025-03-01 08:00:00', 'ACTIVA'),
    (19, 19, 'HC-000019', '2025-03-01 08:00:00', 'ACTIVA');

INSERT INTO healthcare_professionals (id, document_number, first_name, last_name, specialty_id, license_number, email, phone, is_active) VALUES
    (1, '1098001001', 'Laura', 'Martínez', 1, 'TP-68-10234', 'laura.martinez@clinicavision.co', '3001001001', TRUE),
    (2, '1098002002', 'Andrés', 'Rojas', 2, 'TP-68-11567', 'andres.rojas@clinicavision.co', '3002002002', TRUE),
    (3, '1098003003', 'Diana', 'Pérez', 2, 'TP-68-12890', 'diana.perez@clinicavision.co', '3003003003', TRUE),
    (4, '1098004004', 'Jorge', 'Castillo', 3, 'TP-68-09876', 'jorge.castillo@clinicavision.co', '3004004004', FALSE),
    (5, '1098005005', 'Valentina', 'Ortiz', 4, 'TP-68-13456', 'valentina.ortiz@clinicavision.co', '3005005005', TRUE);


INSERT INTO patient_allergies (patient_id, allergen_id, reaction) VALUES
    (1, 1, 'Urticaria generalizada'),
    (1, 2, 'Erupción cutánea'),
    (2, 3, 'Dermatitis de contacto'),
    (5, 4, 'Edema facial'),
    (8, 5, 'Broncoespasmo'),
    (10, 1, 'Anafilaxia');

INSERT INTO patient_family_histories (patient_id, diagnosis_id, relationship) VALUES
    (1, 1, 'PADRE'),
    (1, 9, 'MADRE'),
    (2, 1, 'MADRE'),
    (3, 10, 'PADRE'),
    (4, 1, 'HERMANO'),
    (6, 10, 'ABUELO'),
    (7, 1, 'TIO');

INSERT INTO patient_personal_histories (patient_id, history_type_id, description, recorded_at) VALUES
    (1, 1, 'Hipertensión arterial en tratamiento con losartán', '2025-03-10'),
    (2, 2, 'Uso de lentes correctivos desde los 40 años', '2025-05-06'),
    (4, 1, 'Episodios de hipotensión nocturna', '2025-10-02'),
    (5, 3, 'Cirugía de catarata en ojo izquierdo en 2019', '2026-02-24'),
    (5, 2, 'Trauma ocular contuso en ojo derecho', '2026-02-24'),
    (10, 1, 'Diabetes mellitus tipo 2', '2025-04-22'),
    (12, 1, 'Diabetes mellitus tipo 2', '2026-05-12'),
    (12, 4, 'Uso crónico de corticoides inhalados', '2026-05-12');


INSERT INTO medical_visits (id, clinical_history_id, professional_id, visit_date, reason, assessment, plan, observations, is_closed) VALUES
    (1, 1, 1, '2025-03-10 08:30:00', 'Control de glaucoma de ángulo abierto', 'Excavación papilar aumentada, PIO por encima de la meta', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (2, 1, 1, '2025-09-15 09:00:00', 'Control de glaucoma y ajuste de tratamiento', 'Excavación papilar aumentada, PIO por encima de la meta', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (3, 1, 1, '2026-02-12 10:15:00', 'Control de glaucoma', 'Excavación papilar aumentada, PIO por encima de la meta', 'Continuar tratamiento y control en 6 meses', NULL, TRUE),
    (4, 1, 1, '2026-07-20 08:45:00', 'Control de glaucoma semestral', 'Excavación papilar aumentada, PIO por encima de la meta', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (5, 2, 1, '2025-05-06 14:00:00', 'Visión borrosa y antecedente familiar de glaucoma', 'Nervio óptico con daño glaucomatoso moderado', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (6, 2, 1, '2025-11-18 15:30:00', 'Control de glaucoma, PIO elevada', 'Nervio óptico con daño glaucomatoso moderado', 'Continuar tratamiento y control en 6 meses', NULL, TRUE),
    (7, 2, 2, '2026-03-03 11:00:00', 'Control posquirúrgico de trabeculectomía', 'Nervio óptico con daño glaucomatoso moderado', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (8, 2, 1, '2026-08-25 09:30:00', 'Control de glaucoma', 'Nervio óptico con daño glaucomatoso moderado', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (9, 3, 2, '2025-08-12 07:45:00', 'Dolor ocular intenso y halos alrededor de las luces', 'Ángulo estrecho con cierre parcial', 'Continuar tratamiento y control en 6 meses', NULL, TRUE),
    (10, 3, 2, '2026-01-20 10:00:00', 'Control tras iridotomía', 'Ángulo estrecho con cierre parcial', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (11, 3, 2, '2026-06-15 16:00:00', 'Control de glaucoma de ángulo cerrado', 'Ángulo estrecho con cierre parcial', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (12, 4, 1, '2025-10-02 08:00:00', 'Hallazgo de excavación papilar en control rutinario', 'Daño glaucomatoso con PIO en rango normal', 'Continuar tratamiento y control en 6 meses', NULL, TRUE),
    (13, 4, 1, '2026-04-08 09:45:00', 'Control de glaucoma normotensivo', 'Daño glaucomatoso con PIO en rango normal', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (14, 4, 1, '2026-09-14 10:30:00', 'Control, sospecha de progresión', 'Daño glaucomatoso con PIO en rango normal', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', FALSE),
    (15, 5, 2, '2026-02-24 11:15:00', 'PIO elevada en ojo derecho tras trauma', 'Glaucoma secundario postraumático', 'Continuar tratamiento y control en 6 meses', NULL, TRUE),
    (16, 5, 2, '2026-08-04 14:45:00', 'Control posterior a válvula de Ahmed', 'Glaucoma secundario postraumático', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (17, 6, 3, '2025-12-09 15:00:00', 'Remisión por PIO elevada', 'Glaucoma de ángulo abierto en estadio leve', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (18, 6, 3, '2026-06-30 08:15:00', 'Control de glaucoma', 'Glaucoma de ángulo abierto en estadio leve', 'Continuar tratamiento y control en 6 meses', NULL, TRUE),
    (19, 7, 3, '2026-01-14 09:00:00', 'Antecedente familiar de glaucoma', 'Papila sospechosa, PIO limítrofe', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (20, 7, 3, '2026-07-07 10:45:00', 'Seguimiento de sospecha de glaucoma', 'Papila sospechosa, PIO limítrofe', 'Continuar tratamiento y control en 6 meses', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (21, 8, 4, '2025-06-19 16:30:00', 'Ardor y sensación de arena en los ojos', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', NULL, TRUE),
    (22, 8, 3, '2026-05-21 11:30:00', 'Control de ojo seco', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (23, 9, 2, '2026-03-17 15:15:00', 'Dificultad para ver el tablero', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (24, 10, 4, '2025-04-22 08:00:00', 'Disminución progresiva de la visión', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', NULL, TRUE),
    (25, 11, 3, '2026-04-29 13:30:00', 'Dificultad para leer de cerca', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (26, 12, 2, '2026-05-12 10:00:00', 'Control oftalmológico por diabetes', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (27, 13, 3, '2026-06-02 16:45:00', 'Ojo rojo e irritación', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', NULL, TRUE),
    (28, 14, 2, '2026-08-11 09:15:00', 'Revisión de fórmula de lentes', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', 'Paciente colaborador, se explican signos de alarma', TRUE),
    (29, 15, 3, '2026-09-01 07:30:00', 'Control oftalmológico por hipertensión', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', 'Paciente colaborador, se explican signos de alarma', FALSE),
    (30, 16, 2, '2026-09-22 14:00:00', 'Visión nublada en ojo derecho', 'Hallazgos acordes al motivo de consulta', 'Manejo ambulatorio y control según evolución', NULL, FALSE);

INSERT INTO visit_diagnoses (visit_id, diagnosis_id, eye, is_primary) VALUES
    (1, 1, 'AO', TRUE),
    (2, 1, 'AO', TRUE),
    (3, 1, 'AO', TRUE),
    (4, 1, 'AO', TRUE),
    (5, 1, 'AO', TRUE),
    (6, 1, 'AO', TRUE),
    (7, 1, 'AO', TRUE),
    (8, 1, 'AO', TRUE),
    (9, 2, 'OD', TRUE),
    (10, 2, 'OD', TRUE),
    (11, 2, 'OD', TRUE),
    (12, 1, 'AO', TRUE),
    (13, 1, 'AO', TRUE),
    (14, 1, 'AO', TRUE),
    (15, 4, 'OD', TRUE),
    (16, 4, 'OD', TRUE),
    (17, 1, 'AO', TRUE),
    (18, 1, 'AO', TRUE),
    (19, 3, 'AO', TRUE),
    (20, 3, 'AO', TRUE),
    (1, 10, NULL, FALSE),
    (1, 5, 'OI', FALSE),
    (5, 5, 'AO', FALSE),
    (21, 8, 'AO', TRUE),
    (22, 8, 'AO', TRUE),
    (23, 6, 'AO', TRUE),
    (24, 5, 'OD', TRUE),
    (25, 7, 'AO', TRUE),
    (26, 9, 'AO', TRUE),
    (26, 5, 'AO', FALSE),
    (26, 8, 'AO', FALSE),
    (27, 8, 'AO', TRUE),
    (28, 6, 'AO', TRUE),
    (29, 10, NULL, TRUE),
    (30, 5, 'OD', TRUE);



INSERT INTO ophthalmologic_exams (visit_id, eye, visual_acuity, cup_disc_ratio, anterior_segment, fundus) VALUES
    (1, 'OD', '20/25', 0.7, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (1, 'OI', '20/30', 0.65, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (5, 'OD', '20/30', 0.65, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (5, 'OI', '20/40', 0.6, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (9, 'OD', '20/40', 0.55, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (9, 'OI', '20/50', 0.4, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (12, 'OD', '20/50', 0.75, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (12, 'OI', '20/60', 0.7, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (15, 'OD', '20/60', 0.7, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (15, 'OI', '20/80', 0.35, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (17, 'OD', '20/80', 0.6, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (17, 'OI', '20/100', 0.6, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (19, 'OD', '20/100', 0.5, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (19, 'OI', '20/20', 0.5, 'Córnea clara, cámara anterior formada', 'Excavación papilar aumentada'),
    (21, 'OD', '20/20', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (21, 'OI', '20/25', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (23, 'OD', '20/25', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (23, 'OI', '20/30', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (24, 'OD', '20/30', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (24, 'OI', '20/40', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (25, 'OD', '20/40', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (25, 'OI', '20/50', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (26, 'OD', '20/50', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (26, 'OI', '20/60', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (27, 'OD', '20/60', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (27, 'OI', '20/80', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (28, 'OD', '20/80', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (28, 'OI', '20/100', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (29, 'OD', '20/100', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (29, 'OI', '20/20', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (30, 'OD', '20/20', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones'),
    (30, 'OI', '20/25', 0.3, 'Córnea clara, cámara anterior formada', 'Papila de bordes nítidos, mácula sin alteraciones');

INSERT INTO intraocular_pressures (visit_id, eye, pressure, method, measured_at) VALUES
    (1, 'OD', 28, 'AIRE', '2025-03-10 08:30:00'),
    (1, 'OI', 26, 'AIRE', '2025-03-10 08:30:00'),
    (2, 'OD', 24, 'ICARE', '2025-09-15 09:00:00'),
    (2, 'OI', 23, 'ICARE', '2025-09-15 09:00:00'),
    (3, 'OD', 19, 'GOLDMANN', '2026-02-12 10:15:00'),
    (3, 'OI', 18, 'GOLDMANN', '2026-02-12 10:15:00'),
    (4, 'OD', 16, 'GOLDMANN', '2026-07-20 08:45:00'),
    (4, 'OI', 17, 'GOLDMANN', '2026-07-20 08:45:00'),
    (5, 'OD', 25, 'ICARE', '2025-05-06 14:00:00'),
    (5, 'OI', 22, 'ICARE', '2025-05-06 14:00:00'),
    (6, 'OD', 23, 'GOLDMANN', '2025-11-18 15:30:00'),
    (6, 'OI', 21, 'GOLDMANN', '2025-11-18 15:30:00'),
    (7, 'OD', 21, 'GOLDMANN', '2026-03-03 11:00:00'),
    (7, 'OI', 20, 'GOLDMANN', '2026-03-03 11:00:00'),
    (8, 'OD', 22, 'AIRE', '2026-08-25 09:30:00'),
    (8, 'OI', 19, 'AIRE', '2026-08-25 09:30:00'),
    (9, 'OD', 34, 'GOLDMANN', '2025-08-12 07:45:00'),
    (9, 'OI', 18, 'GOLDMANN', '2025-08-12 07:45:00'),
    (10, 'OD', 22, 'GOLDMANN', '2026-01-20 10:00:00'),
    (10, 'OI', 17, 'GOLDMANN', '2026-01-20 10:00:00'),
    (11, 'OD', 18, 'AIRE', '2026-06-15 16:00:00'),
    (11, 'OI', 16, 'AIRE', '2026-06-15 16:00:00'),
    (12, 'OD', 15, 'GOLDMANN', '2025-10-02 08:00:00'),
    (12, 'OI', 14, 'GOLDMANN', '2025-10-02 08:00:00'),
    (13, 'OD', 16, 'AIRE', '2026-04-08 09:45:00'),
    (13, 'OI', 15, 'AIRE', '2026-04-08 09:45:00'),
    (14, 'OD', 14, 'ICARE', '2026-09-14 10:30:00'),
    (14, 'OI', 15, 'ICARE', '2026-09-14 10:30:00'),
    (15, 'OD', 30, 'AIRE', '2026-02-24 11:15:00'),
    (15, 'OI', 27, 'AIRE', '2026-02-24 11:15:00'),
    (16, 'OD', 24, 'ICARE', '2026-08-04 14:45:00'),
    (16, 'OI', 22, 'ICARE', '2026-08-04 14:45:00'),
    (17, 'OD', 23, 'ICARE', '2025-12-09 15:00:00'),
    (17, 'OI', 24, 'ICARE', '2025-12-09 15:00:00'),
    (18, 'OD', 20, 'GOLDMANN', '2026-06-30 08:15:00'),
    (18, 'OI', 21, 'GOLDMANN', '2026-06-30 08:15:00'),
    (19, 'OD', 22, 'GOLDMANN', '2026-01-14 09:00:00'),
    (19, 'OI', 21, 'GOLDMANN', '2026-01-14 09:00:00'),
    (20, 'OD', 21, 'GOLDMANN', '2026-07-07 10:45:00'),
    (20, 'OI', 20, 'GOLDMANN', '2026-07-07 10:45:00'),
    (22, 'OD', 14, 'AIRE', '2026-05-21 11:30:00'),
    (22, 'OI', 15, 'AIRE', '2026-05-21 11:30:00'),
    (23, 'OD', 16, 'AIRE', '2026-03-17 15:15:00'),
    (23, 'OI', 15, 'AIRE', '2026-03-17 15:15:00'),
    (24, 'OD', 17, 'ICARE', '2025-04-22 08:00:00'),
    (24, 'OI', 17, 'ICARE', '2025-04-22 08:00:00'),
    (25, 'OD', 13, 'GOLDMANN', '2026-04-29 13:30:00'),
    (25, 'OI', 14, 'GOLDMANN', '2026-04-29 13:30:00'),
    (26, 'OD', 18, 'GOLDMANN', '2026-05-12 10:00:00'),
    (26, 'OI', 17, 'GOLDMANN', '2026-05-12 10:00:00');

INSERT INTO pachymetry_exams (visit_id, eye, thickness_um, exam_date) VALUES
    (1, 'OD', 535, '2025-03-10'),
    (1, 'OI', 540, '2025-03-10'),
    (5, 'OD', 548, '2025-05-06'),
    (5, 'OI', 552, '2025-05-06'),
    (9, 'OD', 560, '2025-08-12'),
    (9, 'OI', 556, '2025-08-12'),
    (12, 'OD', 495, '2025-10-02'),
    (12, 'OI', 498, '2025-10-02'),
    (19, 'OD', 570, '2026-01-14'),
    (19, 'OI', 566, '2026-01-14'),
    (23, 'OD', 545, '2026-03-17'),
    (23, 'OI', 547, '2026-03-17');

INSERT INTO gonioscopy_exams (visit_id, eye, shaffer_grade, findings, exam_date) VALUES
    (1, 'OD', 4, 'Ángulo abierto, todas las estructuras visibles', '2025-03-10'),
    (1, 'OI', 4, 'Ángulo abierto, todas las estructuras visibles', '2025-03-10'),
    (5, 'OD', 3, 'Ángulo abierto, pigmentación moderada de la malla', '2025-05-06'),
    (5, 'OI', 3, 'Ángulo abierto, pigmentación moderada de la malla', '2025-05-06'),
    (9, 'OD', 1, 'Ángulo estrecho con sinequias en OD', '2025-08-12'),
    (9, 'OI', 2, 'Ángulo estrecho con sinequias en OD', '2025-08-12'),
    (17, 'OD', 3, 'Ángulo abierto', '2025-12-09'),
    (17, 'OI', 3, 'Ángulo abierto', '2025-12-09');

INSERT INTO oct_exams (visit_id, eye, rnfl_average, cup_disc_ratio, interpretation, is_validated, exam_date) VALUES
    (1, 'OD', 72.0, 0.7, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2025-03-10'),
    (1, 'OI', 75.0, 0.65, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2025-03-10'),
    (4, 'OD', 70.0, 0.72, 'Adelgazamiento de la capa de fibras nerviosas', FALSE, '2026-07-20'),
    (4, 'OI', 74.0, 0.66, 'Adelgazamiento de la capa de fibras nerviosas', FALSE, '2026-07-20'),
    (5, 'OD', 78.0, 0.65, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2025-05-06'),
    (5, 'OI', 80.0, 0.6, 'Capa de fibras nerviosas dentro de límites normales', TRUE, '2025-05-06'),
    (7, 'OD', 76.0, 0.66, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2026-03-03'),
    (7, 'OI', 79.0, 0.61, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2026-03-03'),
    (10, 'OD', 85.0, 0.55, 'Capa de fibras nerviosas dentro de límites normales', TRUE, '2026-01-20'),
    (10, 'OI', 92.0, 0.4, 'Capa de fibras nerviosas dentro de límites normales', TRUE, '2026-01-20'),
    (12, 'OD', 68.0, 0.75, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2025-10-02'),
    (12, 'OI', 70.0, 0.7, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2025-10-02'),
    (14, 'OD', 63.0, 0.8, 'Adelgazamiento de la capa de fibras nerviosas', FALSE, '2026-09-14'),
    (14, 'OI', 66.0, 0.75, 'Adelgazamiento de la capa de fibras nerviosas', FALSE, '2026-09-14'),
    (15, 'OD', 74.0, 0.7, 'Adelgazamiento de la capa de fibras nerviosas', TRUE, '2026-02-24'),
    (15, 'OI', 88.0, 0.35, 'Capa de fibras nerviosas dentro de límites normales', TRUE, '2026-02-24'),
    (18, 'OD', 82.0, 0.6, 'Capa de fibras nerviosas dentro de límites normales', FALSE, '2026-06-30'),
    (18, 'OI', 80.0, 0.6, 'Capa de fibras nerviosas dentro de límites normales', FALSE, '2026-06-30'),
    (19, 'OD', 88.0, 0.5, 'Capa de fibras nerviosas dentro de límites normales', TRUE, '2026-01-14'),
    (19, 'OI', 90.0, 0.5, 'Capa de fibras nerviosas dentro de límites normales', TRUE, '2026-01-14');

INSERT INTO visual_field_exams (visit_id, eye, md, psd, vfi, reliability, interpretation, exam_date) VALUES
    (1, 'OD', -6.2, 5.1, 85, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2025-03-10'),
    (1, 'OI', -4.8, 4.2, 89, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2025-03-10'),
    (3, 'OD', -6.5, 5.3, 84, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-02-12'),
    (3, 'OI', -4.9, 4.3, 89, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-02-12'),
    (6, 'OD', -5.1, 4.6, 88, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2025-11-18'),
    (6, 'OI', -3.2, 3.1, 93, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2025-11-18'),
    (8, 'OD', -5.8, 4.9, 86, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-08-25'),
    (8, 'OI', -3.4, 3.2, 92, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-08-25'),
    (10, 'OD', -3.9, 3.5, 91, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-01-20'),
    (10, 'OI', -1.1, 1.6, 98, 'ALTA', 'Campo visual sin defectos significativos', '2026-01-20'),
    (12, 'OD', -8.4, 7.2, 78, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2025-10-02'),
    (12, 'OI', -7.1, 6.5, 81, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2025-10-02'),
    (14, 'OD', -10.2, 8.1, 72, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-09-14'),
    (14, 'OI', -8.6, 7.0, 77, 'ALTA', 'Defecto arciforme compatible con glaucoma', '2026-09-14'),
    (16, 'OD', -9.5, 7.8, 74, 'MEDIA', 'Defecto arciforme compatible con glaucoma', '2026-08-04'),
    (16, 'OI', -1.5, 1.9, 97, 'MEDIA', 'Campo visual sin defectos significativos', '2026-08-04'),
    (17, 'OD', -2.8, 2.7, 94, 'ALTA', 'Campo visual sin defectos significativos', '2025-12-09'),
    (17, 'OI', -3.0, 2.9, 93, 'ALTA', 'Campo visual sin defectos significativos', '2025-12-09'),
    (20, 'OD', -1.2, 1.8, 98, 'ALTA', 'Campo visual sin defectos significativos', '2026-07-07'),
    (20, 'OI', -0.9, 1.5, 99, 'ALTA', 'Campo visual sin defectos significativos', '2026-07-07');


INSERT INTO glaucoma_records (id, patient_id, glaucoma_type_id, diagnosis_date, target_pressure, clinical_status) VALUES
    (1, 1, 1, '2025-03-10', 18.0, 'CONTROLADO'),
    (2, 2, 1, '2025-05-06', 18.0, 'NO_CONTROLADO'),
    (3, 3, 2, '2025-08-12', 16.0, 'ESTABLE'),
    (4, 4, 3, '2025-10-02', 12.0, 'EN_PROGRESION'),
    (5, 5, 4, '2026-02-24', 17.0, 'CONTROLADO'),
    (6, 6, 1, '2025-12-09', 19.0, 'ESTABLE');

INSERT INTO glaucoma_controls (glaucoma_record_id, visit_id, control_date, progression_detected, notes) VALUES
    (1, 1, '2025-03-10', FALSE, 'Sin cambios significativos'),
    (1, 2, '2025-09-15', FALSE, 'Sin cambios significativos'),
    (1, 3, '2026-02-12', FALSE, 'Sin cambios significativos'),
    (1, 4, '2026-07-20', FALSE, 'Sin cambios significativos'),
    (2, 5, '2025-05-06', FALSE, 'Sin cambios significativos'),
    (2, 6, '2025-11-18', TRUE, 'Se detecta progresión del daño'),
    (2, 7, '2026-03-03', FALSE, 'Sin cambios significativos'),
    (2, 8, '2026-08-25', FALSE, 'Sin cambios significativos'),
    (3, 9, '2025-08-12', FALSE, 'Sin cambios significativos'),
    (3, 10, '2026-01-20', FALSE, 'Sin cambios significativos'),
    (3, 11, '2026-06-15', FALSE, 'Sin cambios significativos'),
    (4, 12, '2025-10-02', FALSE, 'Sin cambios significativos'),
    (4, 13, '2026-04-08', TRUE, 'Se detecta progresión del daño'),
    (4, 14, '2026-09-14', TRUE, 'Se detecta progresión del daño'),
    (5, 15, '2026-02-24', FALSE, 'Sin cambios significativos'),
    (5, 16, '2026-08-04', FALSE, 'Sin cambios significativos'),
    (6, 18, '2026-06-30', FALSE, 'Primer control formal de glaucoma');


INSERT INTO treatments (visit_id, medication_id, eye, dosage, frequency, start_date, end_date, status) VALUES
    (1, 3, 'AO', '1 gota', 'Cada 12 horas', '2025-03-10', '2025-09-15', 'FINALIZADO'),
    (2, 1, 'AO', '1 gota', 'Cada noche', '2025-09-15', NULL, 'ACTIVO'),
    (3, 2, 'AO', '1 gota', 'Cada 12 horas', '2026-02-12', NULL, 'ACTIVO'),
    (5, 4, 'AO', '1 gota', 'Cada 8 horas', '2025-05-06', '2025-11-18', 'FINALIZADO'),
    (6, 1, 'AO', '1 gota', 'Cada noche', '2025-11-18', NULL, 'ACTIVO'),
    (8, 3, 'AO', '1 gota', 'Cada 12 horas', '2026-08-25', NULL, 'ACTIVO'),
    (9, 2, 'OD', '1 gota', 'Cada 12 horas', '2025-08-12', NULL, 'ACTIVO'),
    (9, 4, 'OD', '1 gota', 'Cada 8 horas', '2025-08-12', '2025-10-01', 'SUSPENDIDO'),
    (10, 3, 'OD', '1 gota', 'Cada 12 horas', '2026-01-20', NULL, 'ACTIVO'),
    (12, 2, 'AO', '1 gota', 'Cada 12 horas', '2025-10-02', '2026-04-08', 'FINALIZADO'),
    (13, 5, 'AO', '1 gota', 'Cada noche', '2026-04-08', NULL, 'ACTIVO'),
    (15, 1, 'AO', '1 gota', 'Cada noche', '2026-02-24', '2026-08-04', 'FINALIZADO'),
    (16, 6, 'AO', '1 gota', 'Cada noche', '2026-08-04', NULL, 'ACTIVO'),
    (18, 1, 'AO', '1 gota', 'Cada noche', '2026-06-30', NULL, 'ACTIVO'),
    (19, 2, 'AO', '1 gota', 'Cada 12 horas', '2026-01-14', '2026-07-07', 'FINALIZADO');


INSERT INTO procedures (visit_id, procedure_type_id, eye, performed_at, notes) VALUES
    (2, 2, 'OD', '2025-09-29', 'SLT 360 grados sin complicaciones'),
    (6, 1, 'OD', '2025-12-02', 'Trabeculectomía con mitomicina C'),
    (9, 3, 'OD', '2025-08-13', 'Iridotomía periférica superior'),
    (10, 3, 'OI', '2026-01-27', 'Iridotomía profiláctica en ojo contralateral'),
    (14, 2, 'AO', '2026-09-21', 'SLT bilateral'),
    (15, 5, 'OD', '2026-03-10', 'Implante de válvula de Ahmed sin complicaciones'),
    (24, 4, 'OD', '2025-05-06', 'Facoemulsificación con lente intraocular');



INSERT INTO clinical_documents (clinical_history_id, document_kind, file_name, file_path, uploaded_at) VALUES
    (1, 'Reporte OCT', 'oct_carlos_gomez_2025-03.pdf', '/docs/hc-000001/oct_2025-03.pdf', '2025-03-10 12:00:00'),
    (1, 'Consentimiento informado', 'consentimiento_slt.pdf', '/docs/hc-000001/consentimiento_slt.pdf', '2025-09-15 10:00:00'),
    (2, 'Consentimiento informado', 'consentimiento_trabeculectomia.pdf', '/docs/hc-000002/consentimiento_trab.pdf', '2025-11-18 16:00:00'),
    (3, 'Reporte campo visual', 'cv_luis_gomez_2026-01.pdf', '/docs/hc-000003/cv_2026-01.pdf', '2026-01-20 11:00:00'),
    (4, 'Reporte OCT', 'oct_rosa_pinzon_2026-09.pdf', '/docs/hc-000004/oct_2026-09.pdf', '2026-09-14 12:30:00'),
    (5, 'Consentimiento informado', 'consentimiento_ahmed.pdf', '/docs/hc-000005/consentimiento_ahmed.pdf', '2026-02-24 12:00:00'),
    (10, 'Epicrisis', 'epicrisis_facoemulsificacion.pdf', '/docs/hc-000010/epicrisis_faco.pdf', '2025-05-06 18:00:00');

SELECT 'patients' AS tabla, COUNT(*) AS total FROM patients
UNION ALL SELECT 'clinical_histories', COUNT(*) FROM clinical_histories
UNION ALL SELECT 'healthcare_professionals', COUNT(*) FROM healthcare_professionals
UNION ALL SELECT 'diagnoses', COUNT(*) FROM diagnoses
UNION ALL SELECT 'medical_visits', COUNT(*) FROM medical_visits
UNION ALL SELECT 'intraocular_pressures', COUNT(*) FROM intraocular_pressures
UNION ALL SELECT 'oct_exams', COUNT(*) FROM oct_exams
UNION ALL SELECT 'visual_field_exams', COUNT(*) FROM visual_field_exams
UNION ALL SELECT 'treatments', COUNT(*) FROM treatments
UNION ALL SELECT 'glaucoma_controls', COUNT(*) FROM glaucoma_controls;
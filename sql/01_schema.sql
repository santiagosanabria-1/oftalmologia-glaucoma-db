

DROP DATABASE IF EXISTS oftalmologia_glaucoma;
CREATE DATABASE oftalmologia_glaucoma
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE oftalmologia_glaucoma;


CREATE TABLE document_types (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(5) NOT NULL,              
    name VARCHAR(50) NOT NULL,

    CONSTRAINT uq_document_type_code UNIQUE (code)
);

CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,

    CONSTRAINT uq_city UNIQUE (name, department)
);

CREATE TABLE specialties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,

    CONSTRAINT uq_specialty_name UNIQUE (name)
);

CREATE TABLE allergens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,

    CONSTRAINT uq_allergen_name UNIQUE (name)
);

CREATE TABLE history_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,             

    CONSTRAINT uq_history_type_name UNIQUE (name)
);

CREATE TABLE diagnoses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL,            
    name VARCHAR(150) NOT NULL,
    is_glaucoma BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT uq_diagnosis_code UNIQUE (code)
);

CREATE TABLE glaucoma_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,         

    CONSTRAINT uq_glaucoma_type_name UNIQUE (name)
);

CREATE TABLE medications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,          
    active_ingredient VARCHAR(100) NOT NULL,
    presentation VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT uq_medication_name UNIQUE (name)
);

CREATE TABLE procedure_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,            
    category ENUM('QUIRURGICO', 'LASER', 'DIAGNOSTICO') NOT NULL,

    CONSTRAINT uq_procedure_type_name UNIQUE (name)
);


CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_type_id TINYINT NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    sex ENUM('M', 'F') NOT NULL,
    email VARCHAR(150),                   
    phone VARCHAR(20),
    address VARCHAR(200),
    city_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_patient_document UNIQUE (document_number),
    CONSTRAINT fk_patient_document_type FOREIGN KEY (document_type_id) REFERENCES document_types(id),
    CONSTRAINT fk_patient_city FOREIGN KEY (city_id) REFERENCES cities(id)
);


CREATE TABLE clinical_histories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    history_number VARCHAR(20) NOT NULL, 
    opened_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVA', 'CERRADA') NOT NULL DEFAULT 'ACTIVA',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_history_patient UNIQUE (patient_id),
    CONSTRAINT uq_history_number UNIQUE (history_number),
    CONSTRAINT fk_history_patient FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE healthcare_professionals (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_number VARCHAR(20) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialty_id INT NOT NULL,
    license_number VARCHAR(30) NOT NULL,   
    email VARCHAR(150),
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_professional_document UNIQUE (document_number),
    CONSTRAINT uq_professional_license UNIQUE (license_number),
    CONSTRAINT fk_professional_specialty FOREIGN KEY (specialty_id) REFERENCES specialties(id)
);



CREATE TABLE patient_allergies (
    patient_id BIGINT NOT NULL,
    allergen_id INT NOT NULL,
    reaction VARCHAR(200),

    PRIMARY KEY (patient_id, allergen_id),
    CONSTRAINT fk_allergy_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_allergy_allergen FOREIGN KEY (allergen_id) REFERENCES allergens(id)
);

CREATE TABLE patient_family_histories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    diagnosis_id INT NOT NULL,
    relationship ENUM('PADRE', 'MADRE', 'HERMANO', 'HIJO', 'ABUELO', 'TIO', 'OTRO') NOT NULL,

    CONSTRAINT uq_family_history UNIQUE (patient_id, diagnosis_id, relationship),
    CONSTRAINT fk_family_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_family_diagnosis FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(id)
);

CREATE TABLE patient_personal_histories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    history_type_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    recorded_at DATE,

    CONSTRAINT fk_personal_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_personal_type FOREIGN KEY (history_type_id) REFERENCES history_types(id)
);


CREATE TABLE medical_visits (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    clinical_history_id BIGINT NOT NULL,
    professional_id BIGINT NOT NULL,
    visit_date DATETIME NOT NULL,
    reason VARCHAR(255) NOT NULL,
    assessment TEXT,
    plan TEXT,
    observations TEXT,
    is_closed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_visit_history FOREIGN KEY (clinical_history_id) REFERENCES clinical_histories(id),
    CONSTRAINT fk_visit_professional FOREIGN KEY (professional_id) REFERENCES healthcare_professionals(id)
);


CREATE TABLE visit_diagnoses (
    visit_id BIGINT NOT NULL,
    diagnosis_id INT NOT NULL,
    eye ENUM('OD', 'OI', 'AO'),          
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (visit_id, diagnosis_id),
    CONSTRAINT fk_vd_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT fk_vd_diagnosis FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(id)
);


CREATE TABLE ophthalmologic_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD', 'OI') NOT NULL,
    visual_acuity VARCHAR(10),             
    cup_disc_ratio DECIMAL(3,2),        
    anterior_segment TEXT,
    fundus TEXT,

    CONSTRAINT uq_ophth_exam UNIQUE (visit_id, eye),
    CONSTRAINT chk_ophth_cd CHECK (cup_disc_ratio BETWEEN 0 AND 1),
    CONSTRAINT fk_ophth_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE intraocular_pressures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD', 'OI') NOT NULL,
    pressure DECIMAL(4,1) NOT NULL,        
    method ENUM('GOLDMANN', 'AIRE', 'ICARE', 'TONOPEN') NOT NULL DEFAULT 'GOLDMANN',
    measured_at DATETIME NOT NULL,

    CONSTRAINT chk_iop_range CHECK (pressure >= 0 AND pressure <= 80),
    CONSTRAINT fk_iop_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE pachymetry_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD', 'OI') NOT NULL,
    thickness_um SMALLINT NOT NULL,        
    exam_date DATE NOT NULL,

    CONSTRAINT chk_pachy_positive CHECK (thickness_um > 0),
    CONSTRAINT fk_pachy_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE gonioscopy_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD', 'OI') NOT NULL,
    shaffer_grade TINYINT NOT NULL,        
    findings TEXT,
    exam_date DATE NOT NULL,

    CONSTRAINT chk_gonio_grade CHECK (shaffer_grade BETWEEN 0 AND 4),
    CONSTRAINT fk_gonio_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE oct_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD', 'OI') NOT NULL,
    rnfl_average DECIMAL(5,1) NOT NULL,   
    cup_disc_ratio DECIMAL(3,2),
    interpretation TEXT,
    is_validated BOOLEAN NOT NULL DEFAULT FALSE,
    exam_date DATE NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_oct_rnfl CHECK (rnfl_average > 0),
    CONSTRAINT fk_oct_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE visual_field_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD', 'OI') NOT NULL,
    md DECIMAL(5,2) NOT NULL,              
    psd DECIMAL(5,2) NOT NULL,          
    vfi TINYINT NOT NULL,                  
    reliability ENUM('ALTA', 'MEDIA', 'BAJA') NOT NULL DEFAULT 'ALTA',
    interpretation TEXT,
    exam_date DATE NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_vf_vfi CHECK (vfi BETWEEN 0 AND 100),
    CONSTRAINT chk_vf_psd CHECK (psd >= 0),
    CONSTRAINT fk_vf_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE glaucoma_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    glaucoma_type_id INT NOT NULL,
    diagnosis_date DATE NOT NULL,
    target_pressure DECIMAL(4,1) NOT NULL,
    clinical_status ENUM('CONTROLADO', 'NO_CONTROLADO', 'EN_PROGRESION', 'ESTABLE')
        NOT NULL DEFAULT 'ESTABLE',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_glaucoma_patient UNIQUE (patient_id),
    CONSTRAINT chk_target_pressure CHECK (target_pressure > 0),
    CONSTRAINT fk_glaucoma_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_glaucoma_type FOREIGN KEY (glaucoma_type_id) REFERENCES glaucoma_types(id)
);

CREATE TABLE glaucoma_controls (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    glaucoma_record_id BIGINT NOT NULL,
    visit_id BIGINT NOT NULL,
    control_date DATE NOT NULL,
    progression_detected BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT,

    CONSTRAINT uq_control_visit UNIQUE (visit_id),
    CONSTRAINT fk_control_record FOREIGN KEY (glaucoma_record_id) REFERENCES glaucoma_records(id),
    CONSTRAINT fk_control_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);



CREATE TABLE treatments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    medication_id INT NOT NULL,
    eye ENUM('OD', 'OI', 'AO') NOT NULL,
    dosage VARCHAR(100) NOT NULL,          -- ej. 1 gota
    frequency VARCHAR(100) NOT NULL,       -- ej. cada 12 horas
    start_date DATE NOT NULL,
    end_date DATE,                         -- NULL mientras siga activo
    status ENUM('ACTIVO', 'FINALIZADO', 'SUSPENDIDO') NOT NULL DEFAULT 'ACTIVO',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_treatment_dates CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_treatment_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT fk_treatment_medication FOREIGN KEY (medication_id) REFERENCES medications(id)
);

CREATE TABLE procedures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    procedure_type_id INT NOT NULL,
    eye ENUM('OD', 'OI', 'AO') NOT NULL,
    performed_at DATE NOT NULL,
    notes TEXT,

    CONSTRAINT fk_procedure_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT fk_procedure_type FOREIGN KEY (procedure_type_id) REFERENCES procedure_types(id)
);



CREATE TABLE clinical_documents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    clinical_history_id BIGINT NOT NULL,
    document_kind VARCHAR(50) NOT NULL,   
    file_name VARCHAR(200) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_document_history FOREIGN KEY (clinical_history_id) REFERENCES clinical_histories(id)
);

CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON,
    new_values JSON,
    changed_by VARCHAR(100),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clinical_alerts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    alert_type VARCHAR(50) NOT NULL,  
    message VARCHAR(255) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_alert_patient FOREIGN KEY (patient_id) REFERENCES patients(id)
);
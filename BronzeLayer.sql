USE WAREHOUSE HCLPROJECTS;
USE DATABASE hospital_db;
USE SCHEMA bronze;

SELECT CURRENT_ROLE();

-- Create Staging Tables (Bronze)
-- ehr_raw
CREATE OR REPLACE TABLE bronze.ehr_raw (
    patient_id INT,
    name STRING,
    age INT,
    gender STRING
);

-- vitals_raw
CREATE OR REPLACE TABLE bronze.vitals_raw (
    patientId STRING,
    hr STRING,
    ox STRING,
    sys STRING,
    dia STRING,
    timestamp STRING
);

-- labs_raw
CREATE OR REPLACE TABLE bronze.labs_raw (
    patientId STRING,
    test STRING,
    value STRING,
    timestamp STRING
);


-- Create Production Tables (Silver)
-- clean_vitals

CREATE OR REPLACE TABLE silver.clean_vitals (
    patient_id INT,
    hr FLOAT,
    ox FLOAT,
    sys FLOAT,
    dia FLOAT,
    ts TIMESTAMP
);

-- clean_labs
CREATE OR REPLACE TABLE silver.clean_labs (
    patient_id INT,
    lab_test STRING,
    lab_value FLOAT,
    ts TIMESTAMP
);

-- patient_master
CREATE OR REPLACE TABLE silver.patient_master (
    patient_id INT,
    name STRING,
    age INT,
    gender STRING,
    hr FLOAT,
    ox FLOAT,
    sys FLOAT,
    dia FLOAT,
    lab_test STRING,
    lab_value FLOAT
);


-- Create Gold Table
-- anomalies
CREATE OR REPLACE TABLE gold.anomalies (
    patient_id INT,
    name STRING,
    age INT,
    gender STRING,
    hr FLOAT,
    ox FLOAT,
    sys FLOAT,
    dia FLOAT,
    lab_test STRING,
    lab_value FLOAT,
    high_hr BOOLEAN,
    low_ox BOOLEAN,
    high_bp BOOLEAN
);



-- File format
CREATE OR REPLACE FILE FORMAT hospital_csv_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1
NULL_IF = ('NULL', 'null');

SHOW FILE FORMATS;

CREATE OR REPLACE STAGE hospital_stage
FILE_FORMAT = hospital_csv_format;

SHOW STAGES;
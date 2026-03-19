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



-- Synthetic data generation 

-- Generate Data for ehr_raw
INSERT INTO bronze.ehr_raw
SELECT
    seq4() + 1 AS patient_id,
    'Patient_' || (seq4() + 1) AS name,
    UNIFORM(18, 80, RANDOM()) AS age,
    CASE 
        WHEN UNIFORM(1, 2, RANDOM()) = 1 THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM TABLE(GENERATOR(ROWCOUNT => 50));



-- Generate Data for vitals_raw
INSERT INTO bronze.vitals_raw
SELECT
    TO_VARCHAR(UNIFORM(1, 50, RANDOM())) AS patientId,
    TO_VARCHAR(UNIFORM(60, 140, RANDOM())) AS hr,   -- heart rate
    TO_VARCHAR(UNIFORM(85, 100, RANDOM())) AS ox,   -- oxygen
    TO_VARCHAR(UNIFORM(100, 180, RANDOM())) AS sys, -- systolic
    TO_VARCHAR(UNIFORM(60, 120, RANDOM())) AS dia,  -- diastolic
    TO_VARCHAR(CURRENT_TIMESTAMP()) AS timestamp
FROM TABLE(GENERATOR(ROWCOUNT => 200));


-- Generate Data for labs_raw
INSERT INTO bronze.labs_raw
SELECT
    TO_VARCHAR(UNIFORM(1, 50, RANDOM())) AS patientId,
    CASE 
        WHEN UNIFORM(1, 3, RANDOM()) = 1 THEN 'Glucose'
        WHEN UNIFORM(1, 3, RANDOM()) = 2 THEN 'Cholesterol'
        ELSE 'Hemoglobin'
    END AS test,
    TO_VARCHAR(UNIFORM(50, 200, RANDOM())) AS value,
    TO_VARCHAR(CURRENT_TIMESTAMP()) AS timestamp
FROM TABLE(GENERATOR(ROWCOUNT => 150));


-- Verify Data 
SELECT * FROM bronze.ehr_raw LIMIT 10;
SELECT * FROM bronze.vitals_raw LIMIT 10;
SELECT * FROM bronze.labs_raw LIMIT 10;





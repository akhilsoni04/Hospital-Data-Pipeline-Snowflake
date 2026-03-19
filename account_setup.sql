-- warehouse creation 
CREATE WAREHOUSE HCLPROJECTS
WITH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- First we create a separate database for the hospital pipeline.
CREATE DATABASE hospital_db;

-- Use it
USE DATABASE hospital_db;

-- schema creation 
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

-- role 
CREATE ROLE hospital_role;


-- grant PRIVILEGES 
-- Database level
GRANT ALL PRIVILEGES ON DATABASE hospital_db TO ROLE hospital_role;

-- All schemas
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE hospital_db TO ROLE hospital_role;

-- Future schemas
GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE hospital_db TO ROLE hospital_role;

-- All tables
GRANT ALL PRIVILEGES ON ALL TABLES IN DATABASE hospital_db TO ROLE hospital_role;

-- Future tables
GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE hospital_db TO ROLE hospital_role;

-- Warehouse
GRANT ALL PRIVILEGES ON WAREHOUSE HCLPROJECTS TO ROLE hospital_role;


-- user creation 
CREATE USER akhil PASSWORD = 'Akhil@123' DEFAULT_ROLE = hospital_role MUST_CHANGE_PASSWORD = TRUE;
CREATE USER ayush PASSWORD = 'Ayush@123' DEFAULT_ROLE = hospital_role MUST_CHANGE_PASSWORD = TRUE;
CREATE USER samarth PASSWORD = 'Samarth@123' DEFAULT_ROLE = hospital_role MUST_CHANGE_PASSWORD = TRUE;
CREATE USER ravi PASSWORD = 'Ravi@123' DEFAULT_ROLE = hospital_role MUST_CHANGE_PASSWORD = TRUE;

-- grant roles to user
GRANT ROLE hospital_role TO USER akhil;
GRANT ROLE hospital_role TO USER ayush;
GRANT ROLE hospital_role TO USER samarth;
GRANT ROLE hospital_role TO USER ravi;






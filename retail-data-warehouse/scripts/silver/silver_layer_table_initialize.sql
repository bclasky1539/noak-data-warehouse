/*
=============================================================
DDL Script: Drop and re-create Silver Tables
=============================================================
Overview
    This script will re-define the DDL structure of the silver tables.
	
CAUTION:
    Executing this script will completely remove the silver tables if they exist exists.
	This action is irreversible and will erase all contained data. Before proceeding, verify you have appropriate
	backups in place.
*/

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info(
 cst_id INT,
 cst_key NVARCHAR(100),
 cst_firstname NVARCHAR(100),
 cst_lastname NVARCHAR(100),
 cst_marital_status NVARCHAR(10),
 cst_gndr NVARCHAR(10),
 cst_create_date DATE,
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
   DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
 prd_id INT,
 cat_id NVARCHAR(100),
 prd_key NVARCHAR(100),
 prd_nm NVARCHAR(100),
 prd_cost DECIMAL(10,2),
 prd_line NVARCHAR(50),
 prd_start_dt DATE,
 prd_end_dt DATE,
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
   DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
 sls_ord_num NVARCHAR(100),
 sls_prd_key NVARCHAR(100),
 sls_cust_id INT,
 sls_order_dt DATE,
 sls_ship_dt DATE,
 sls_due_dt DATE,
 sls_sales DECIMAL(10,2),
 sls_quantity INT,
 sls_price DECIMAL(10,2),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
   DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
 cid NVARCHAR(100),
 bdate DATE,
 gen NVARCHAR(50),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
   DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
 cid NVARCHAR(100),
 cntry_variant NVARCHAR(100),
 cntry NVARCHAR(100),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
   DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
 id  NVARCHAR(50),
 cat  NVARCHAR(100),
 subcat  NVARCHAR(100),
 maintenance  NVARCHAR(50),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);


-- Helper tables
IF OBJECT_ID ('silver.gender_info', 'U') IS NOT NULL
   DROP TABLE silver.gender_info;
CREATE TABLE silver.gender_info(
 gndr_id INT,
 gndr_key NVARCHAR(100),
 gndr_description NVARCHAR(100),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.marital_status_info', 'U') IS NOT NULL
   DROP TABLE silver.marital_status_info;
CREATE TABLE silver.marital_status_info(
 marital_status_id INT,
 marital_status_key NVARCHAR(100),
 marital_status_description NVARCHAR(100),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.prd_line_info', 'U') IS NOT NULL
   DROP TABLE silver.prd_line_info;
CREATE TABLE silver.prd_line_info(
 prd_line_id INT,
 prd_line_key NVARCHAR(100),
 prd_line_description NVARCHAR(100),
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);

IF OBJECT_ID ('silver.cntry_info', 'U') IS NOT NULL
   DROP TABLE silver.cntry_info;
CREATE TABLE silver.cntry_info(
 cntry_id INT,
 cntry_variant NVARCHAR(100) NOT NULL,
 standard_cntry_name NVARCHAR(100) NOT NULL,
 cntry_code NCHAR(2) NULL,
 is_validated BIT DEFAULT 0,
 validation_date DATETIME2,
 dwh_create_date DATETIME2 DEFAULT GETDATE(),
 dwh_update_date DATETIME2,
 dwh_source_system NVARCHAR(100)
);


-- Populate Helper tables
INSERT INTO silver.gender_info (gndr_id, gndr_key, gndr_description) VALUES (1, 'F', 'Female');
INSERT INTO silver.gender_info (gndr_id, gndr_key, gndr_description) VALUES (2, 'M', 'Male');
INSERT INTO silver.gender_info (gndr_id, gndr_key, gndr_description) VALUES (3, 'U', 'Unknown');

INSERT INTO silver.marital_status_info (marital_status_id, marital_status_key, marital_status_description) VALUES (1, 'S', 'Single');
INSERT INTO silver.marital_status_info (marital_status_id, marital_status_key, marital_status_description) VALUES (2, 'M', 'Married');
INSERT INTO silver.marital_status_info (marital_status_id, marital_status_key, marital_status_description) VALUES (3, 'W', 'Widowed');
INSERT INTO silver.marital_status_info (marital_status_id, marital_status_key, marital_status_description) VALUES (4, 'U', 'Unknown');

INSERT INTO silver.prd_line_info (prd_line_id, prd_line_key, prd_line_description) VALUES (1, 'M', 'Mountain');
INSERT INTO silver.prd_line_info (prd_line_id, prd_line_key, prd_line_description) VALUES (1, 'R', 'Road');
INSERT INTO silver.prd_line_info (prd_line_id, prd_line_key, prd_line_description) VALUES (1, 'S', 'Other Sales');
INSERT INTO silver.prd_line_info (prd_line_id, prd_line_key, prd_line_description) VALUES (1, 'T', 'Touring');
INSERT INTO silver.prd_line_info (prd_line_id, prd_line_key, prd_line_description) VALUES (1, 'U', 'Unknown');

INSERT INTO silver.cntry_info (cntry_id, cntry_variant, standard_cntry_name, cntry_code, is_validated, validation_date) VALUES
(1,'U', 'Unknown', 'U', 1, GETDATE()),
(2,'US', 'United States', 'US', 1, GETDATE()),
(3,'USA', 'United States', 'US', 1, GETDATE()),
(4,'United States', 'United States', 'US', 1, GETDATE()),
(5,'DE', 'Germany', 'DE', 1, GETDATE()),
(6,'Germany', 'Germany', 'DE', 1, GETDATE()),
(7,'Australia', 'Australia', 'AU', 1, GETDATE()),
(8,'United Kingdom', 'United Kingdom', 'GB', 1, GETDATE()),
(9,'UK', 'United Kingdom', 'GB', 1, GETDATE()),
(10,'Canada', 'Canada', 'CA', 1, GETDATE()),
(11,'France', 'France', 'FR', 1, GETDATE());


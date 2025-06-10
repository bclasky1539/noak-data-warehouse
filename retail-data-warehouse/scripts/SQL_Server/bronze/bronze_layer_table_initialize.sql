/*
=============================================================
DDL Script: Drop and re-create Bronze Tables
=============================================================
Overview
    This script will re-define the DDL structure of the bronze tables.
	
CAUTION:
    Executing this script will completely remove the bronze tables if they exist exists.
	This action is irreversible and will erase all contained data. Before proceeding, verify you have appropriate
	backups in place.
*/

IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
 cst_id INT,
 cst_key NVARCHAR(100),
 cst_firstname NVARCHAR(100),
 cst_lastname NVARCHAR(100),
 cst_marital_status NVARCHAR(10),
 cst_gndr NVARCHAR(10),
 cst_create_date DATE
);

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
   DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
 prd_id INT,
 prd_key NVARCHAR(100),
 prd_nm NVARCHAR(100),
 prd_cost DECIMAL(10,2),
 prd_line NVARCHAR(50),
 prd_start_dt DATETIME,
 prd_end_dt DATETIME
);

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
   DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
 sls_ord_num NVARCHAR(100),
 sls_prd_key NVARCHAR(100),
 sls_cust_id INT,
 sls_order_dt INT,
 sls_ship_dt INT,
 sls_due_dt INT,
 sls_sales DECIMAL(10,2),
 sls_quantity INT,
 sls_price DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
   DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
 cid NVARCHAR(100),
 bdate DATE,
 gen NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
   DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
 cid NVARCHAR(100),
 cntry NVARCHAR(100)
);

IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
   DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
 id  NVARCHAR(50),
 cat  NVARCHAR(100),
 subcat  NVARCHAR(100),
 maintenance  NVARCHAR(50)
);


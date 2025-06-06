/*
=============================================================
Execution Script: Load Bronze Layer (Source -> Bronze)
=============================================================
Overview
    This script executes the stored procedure bronze.sp_load_bronze_data to load the data from sources into the bronze tables.
	It also does data validation
*/

EXEC bronze.sp_load_bronze_data;


-- Data validation
SELECT * FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_cust_info;

-- Data validation
SELECT * FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_prd_info;

-- Data validation
SELECT * FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.crm_sales_details;

-- Data validation
SELECT * FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_cust_az12;

-- Data validation
SELECT * FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_loc_a101;

-- Data validation
SELECT * FROM bronze.erp_px_cat_g1v2;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;




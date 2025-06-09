/*
=============================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
=============================================================
Overview
    This script defines the stored procedure silver.sp_load_silver_data to load the data from the bronze tables into the silver tables.
	Steps:
		1) Truncates the silver tables before loading
		2) Uses the INSERT command to load the data from the bronze tables into the silver tables
	
Parameters:
    None
	This stored procedure does not accept any parameters or return any values

Usage Example:
    EXEC silver.sp_load_silver_data;
*/

CREATE OR ALTER PROCEDURE silver.sp_load_silver_data AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
	    SET @batch_start_time = GETDATE();
		PRINT '======================================================================';
		PRINT 'Loading Silver Layer';
		PRINT '======================================================================';
		PRINT '';
		PRINT '======================================================================';
		PRINT 'Loading CRM Tables';
		PRINT '======================================================================';

		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: silver.crm_cust_info !!!!';
		TRUNCATE TABLE silver.crm_cust_info;

		PRINT '!!!! Loading table: silver.crm_cust_info !!!!';
        INSERT INTO silver.crm_cust_info (
           cst_id,
           cst_key,
           cst_firstname,
           cst_lastname,
           cst_marital_status,
           cst_gndr,
           cst_create_date
        )
        select
           cst_id,
           cst_key,
           cst_firstname,
           cst_lastname,
           cst_marital_status,
           cst_gndr,
           cst_create_date
        
        from 
        (
        	select c.cst_id,
        	   c.cst_key,
               TRIM(c.cst_firstname) AS cst_firstname,
               TRIM(c.cst_lastname) AS cst_lastname,
        	   m.marital_status_description AS cst_marital_status,
        	   g.gndr_description AS cst_gndr,
               c.cst_create_date,
        	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
        	from bronze.crm_cust_info c
        		left outer join silver.gender_info g
        		  on UPPER(COALESCE(TRIM(c.cst_gndr), 'U')) = g.gndr_key
        		left outer join silver.marital_status_info m
        		  on UPPER(COALESCE(TRIM(c.cst_marital_status), 'U')) = m.marital_status_key
        	where c.cst_id IS NOT NULL
        ) t
        where flag_last = 1;
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
        SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: silver.crm_prd_info !!!!';
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '!!!! Loading table: silver.crm_prd_info !!!!';
        INSERT INTO silver.crm_prd_info (
          prd_id,
          cat_id,
          prd_key,
          prd_nm,
          prd_cost,
          prd_line,
          prd_start_dt,
          prd_end_dt
        )
        SELECT c.prd_id,
        	  REPLACE(SUBSTRING(c.prd_key, 1, 5), '-', '_') AS cat_id,
        	  SUBSTRING(c.prd_key, 7, LEN(prd_key)) AS prd_key,
              c.prd_nm,
        	  COALESCE(c.prd_cost, 0.00) prd_cost,
        	  p.prd_line_description prd_line,
              CAST (c.prd_start_dt AS DATE) AS prd_start_dt,
        	  CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
          FROM bronze.crm_prd_info c
        		left outer join silver.prd_line_info p
        		  on UPPER(COALESCE(TRIM(c.prd_line), 'U')) = p.prd_line_key
        ;
        SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
        SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: silver.crm_sales_details !!!!';
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT '!!!! Loading table: silver.crm_sales_details !!!!';
        INSERT INTO silver.crm_sales_details (
          sls_ord_num,
          sls_prd_key,
          sls_cust_id,
          sls_order_dt,
          sls_ship_dt,
          sls_due_dt,
          sls_sales,
          sls_quantity,
          sls_price
        )
        SELECT sls_ord_num,
              sls_prd_key,
              sls_cust_id,
              CASE 
                WHEN sls_order_dt = 0 OR sls_order_dt IS NULL THEN NULL
                ELSE TRY_CAST(RIGHT('00000000' + CAST(sls_order_dt AS VARCHAR(8)), 8) AS DATE)
              END AS sls_order_dt,
        	  CASE 
                WHEN sls_ship_dt = 0 OR sls_ship_dt IS NULL THEN NULL
                ELSE TRY_CAST(RIGHT('00000000' + CAST(sls_ship_dt AS VARCHAR(8)), 8) AS DATE)
              END AS sls_ship_dt,
        	  CASE 
                WHEN sls_due_dt = 0 OR sls_due_dt IS NULL THEN NULL
                ELSE TRY_CAST(RIGHT('00000000' + CAST(sls_due_dt AS VARCHAR(8)), 8) AS DATE)
              END AS sls_due_dt,
        	  CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
        		     THEN sls_quantity * ABS(sls_price)
        	     ELSE sls_sales
        	  END AS sls_sales,
              sls_quantity,
        	  CASE WHEN sls_price IS NULL OR sls_price <= 0
        		     THEN sls_sales / NULLIF(sls_quantity, 0) -- Avoids divide by zero
                 ELSE sls_price
        	  END AS sls_price
          FROM bronze.crm_sales_details
        ;
        SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
		PRINT '';
		PRINT '======================================================================';
		PRINT 'Loading ERP Tables';
		PRINT '======================================================================';

        SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: silver.erp_cust_az12 !!!!';
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT '!!!! Loading table: silver.erp_cust_az12 !!!!';
        INSERT INTO silver.erp_cust_az12 (
          cid,
          bdate,
          gen
        )
        select 
           CASE WHEN TRIM(e.cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(e.cid), 4, LEN(e.cid))
               ELSE TRIM(e.cid)
           END AS cid,
           CASE WHEN e.bdate > GETDATE() THEN NULL
               ELSE e.bdate
           END AS bdate,
           g.gndr_description AS gen_corr
        from bronze.erp_cust_az12 e
                left outer join silver.gender_info g
        		  on UPPER(COALESCE(NULLIF(SUBSTRING(TRIM(e.gen), 1, 1), ''), 'U')) = g.gndr_key
        ;
        SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

        SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: silver.erp_loc_a101 !!!!';
		TRUNCATE TABLE silver.erp_loc_a101;

		PRINT '!!!! Loading table: silver.erp_loc_a101 !!!!';
        INSERT INTO silver.erp_loc_a101 (
          cid,
          cntry_variant,
          cntry
        )
        select
           REPLACE(TRIM(e.cid), '-', '') cid,
           e.cntry AS cntry_variant,
           COALESCE(cl.standard_cntry_name, 'Unknown') AS cntry
        from bronze.erp_loc_a101 e
          LEFT JOIN silver.cntry_info cl
            ON UPPER(COALESCE(NULLIF(TRIM(ISNULL(e.cntry, '')), ''), 'U')) = UPPER(cl.cntry_variant)
            AND cl.is_validated = 1
        ;
        SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

        SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: silver.erp_px_cat_g1v2 !!!!';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;

		PRINT '!!!! Loading table: silver.erp_px_cat_g1v2 !!!!';
        INSERT INTO silver.erp_px_cat_g1v2(
          id,
          cat,
          subcat,
          maintenance
        )
        select id,
        cat,
        subcat,
        maintenance
        from bronze.erp_px_cat_g1v2
        ;
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @batch_end_time = GETDATE();
		PRINT '';
		PRINT '';
		PRINT '======================================================================';
		PRINT 'Loading of Silver Layer is Complete';
		PRINT 'Start time: ' + CAST(@batch_start_time AS NVARCHAR);
		PRINT 'End time: ' + CAST(@batch_end_time AS NVARCHAR);
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '======================================================================';
	END TRY
	BEGIN CATCH
		PRINT '======================================================================';
		PRINT 'ERROR OCCURRED DURING LOADING OF SILVER LAYER';
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State:' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================================';
	END CATCH
END


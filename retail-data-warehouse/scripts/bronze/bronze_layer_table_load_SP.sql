/*
=============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================
Overview
    This script defines the stored procedure bronze.sp_load_bronze_data to load the data from sources into the bronze tables.
	Keep in mind that the path for each source needs to be defined in the stored procedure before execution
	Steps:
		1) Truncates the tables before loading
		2) Uses the BULK INSERT command to load the data from the sources into the tables
	
Parameters:
    None
	This stored procedure does not accept any parameters or return any values

Usage Example:
    EXEC bronze.sp_load_bronze_data;
*/

CREATE OR ALTER PROCEDURE bronze.sp_load_bronze_data AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
	    SET @batch_start_time = GETDATE();
		PRINT '======================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '======================================================================';
		PRINT '';
		PRINT '======================================================================';
		PRINT 'Loading CRM Tables';
		PRINT '======================================================================';

		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: bronze.crm_cust_info !!!!';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '!!!! Loading table: bronze.crm_cust_info !!!!';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\bdeveloper\source\repos\noak-data-warehouse\retail-data-warehouse\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2, -- Ignore header record
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: bronze.crm_prd_info !!!!';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '!!!! Loading table: bronze.crm_prd_info !!!!';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\bdeveloper\source\repos\noak-data-warehouse\retail-data-warehouse\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2, -- Ignore header record
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: bronze.crm_sales_details !!!!';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '!!!! Loading table: bronze.crm_sales_details !!!!';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\bdeveloper\source\repos\noak-data-warehouse\retail-data-warehouse\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2, -- Ignore header record
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
		PRINT '';
		PRINT '======================================================================';
		PRINT 'Loading ERP Tables';
		PRINT '======================================================================';

		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: bronze.erp_cust_az12 !!!!';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '!!!! Loading table: bronze.erp_cust_az12 !!!!';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\bdeveloper\source\repos\noak-data-warehouse\retail-data-warehouse\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2, -- Ignore header record
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: bronze.erp_loc_a101 !!!!';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '!!!! Loading table: bronze.erp_loc_a101 !!!!';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\bdeveloper\source\repos\noak-data-warehouse\retail-data-warehouse\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2, -- Ignore header record
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '';
		SET @start_time = GETDATE();
		PRINT '!!!! Truncating table: bronze.erp_px_cat_g1v2 !!!!';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '!!!! Loading table: bronze.erp_px_cat_g1v2 !!!!';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\bdeveloper\source\repos\noak-data-warehouse\retail-data-warehouse\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2, -- Ignore header record
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '!!!! Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @batch_end_time = GETDATE();
		PRINT '';
		PRINT '';
		PRINT '======================================================================';
		PRINT 'Loading of Bronze Layer is Complete';
		PRINT 'Start time: ' + CAST(@batch_start_time AS NVARCHAR);
		PRINT 'End time: ' + CAST(@batch_end_time AS NVARCHAR);
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '======================================================================';
	END TRY
	BEGIN CATCH
		PRINT '======================================================================';
		PRINT 'ERROR OCCURRED DURING LOADING OF BRONZE LAYER';
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State:' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================================';
	END CATCH
END



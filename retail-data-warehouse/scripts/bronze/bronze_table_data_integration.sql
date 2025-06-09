SELECT TOP (1000) [cst_id]
      ,[cst_key]
      ,[cst_firstname]
      ,[cst_lastname]
      ,[cst_marital_status]
      ,[cst_gndr]
      ,[cst_create_date]
  FROM [retail_data_warehouse].[bronze].[crm_cust_info];

SELECT TOP (1000) [cid]
      ,[bdate]
      ,[gen]
  FROM [retail_data_warehouse].[bronze].[erp_cust_az12];

SELECT TOP (1000) [cid]
      ,[cntry]
  FROM [retail_data_warehouse].[bronze].[erp_loc_a101];

SELECT TOP (1000) [prd_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [retail_data_warehouse].[bronze].[crm_prd_info];

SELECT TOP (1000) [id]
      ,[cat]
      ,[subcat]
      ,[maintenance]
  FROM [retail_data_warehouse].[bronze].[erp_px_cat_g1v2];

SELECT TOP (1000) [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
  FROM [retail_data_warehouse].[bronze].[crm_sales_details];



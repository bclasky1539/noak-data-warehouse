/*
=============================================================
Quality Checks: Bronze Layer
=============================================================
Overview
    This script performs various quality checks for data consistency,
	accuracy, and standardization across the Bronze schemas.
	It includes checks for:
	- Null or duplicate primary keys
	- Unwanted spaces in string fields
	- Data standardization and consistency
	- Invalid date ranges and orders
	- Data consistency between related fields
	
Usage Notes:
    - Run these checks after data is loaded into the Bronze Layer
	- Investigate and resolve any discrepancies found during the checks
*/

-- Bronze table - bronze.crm_cust_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
select cst_id, count(*) AS cst_count
from bronze.crm_cust_info
group by cst_id
having count(*)>1 OR cst_id IS NULL;
cst_id	cst_count
29449	2
29473	2
29433	2
NULL	3
29483	2
29466	3

-- Check strings that are padded right or left
-- Expectation: No Results
select cst_firstname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

select cst_lastname
from bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

select cst_marital_status
from bronze.crm_cust_info
where cst_marital_status != TRIM(cst_marital_status);

select cst_gndr
from bronze.crm_cust_info
where cst_gndr != TRIM(cst_gndr);

-- Check Data Standardization and Consistency
select distinct cst_gndr
from bronze.crm_cust_info;
cst_gndr
NULL
F
M

select *
from silver.gender_info;

select *
from silver.marital_status_info;

select distinct cst_marital_status
from bronze.crm_cust_info;



-- Bronze table - bronze.crm_prd_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
select prd_id, count(*) AS prd_count
from bronze.crm_prd_info
group by prd_id
having count(*)>1 OR prd_id IS NULL;

-- Check parts of prd_key
SELECT prd_id,
      prd_key,
	  REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	  SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
      prd_nm,
      prd_cost,
      prd_line,
      prd_start_dt,
      prd_end_dt
  FROM bronze.crm_prd_info
--  WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN
--  (SELECT distinct id from bronze.erp_px_cat_g1v2);
--  WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN
--  (SELECT distinct sls_prd_key from bronze.crm_sales_details)
;

-- Check strings that are padded right or left
-- Expectation: No Results
select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm);

-- Check strings that are padded right or left
-- Expectation: No Results
select prd_cost
from bronze.crm_prd_info
where prd_cost < 0 or prd_cost is null;


-- Check Data Standardization and Consistency
select distinct prd_line
from bronze.crm_prd_info;

select *
from silver.prd_line_info;


-- Check for Invalid Date Orders
-- End Date must not be earlier than the start date
-- We can use the LEAD windows function to resolve any invalid date orders
select prd_id,
      prd_key,
      prd_nm,
	  prd_start_dt,
	  prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_ld
from bronze.crm_prd_info
where COALESCE(prd_end_dt, '1970-1-1') < prd_start_dt
--and prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')
order by prd_key;



-- Bronze table - bronze.crm_sales_details
-- Check strings that are padded right or left
-- Expectation: No Results
SELECT sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_dt,
      sls_ship_dt,
      sls_due_dt,
      sls_sales,
      sls_quantity,
      sls_price
  FROM bronze.crm_sales_details
where sls_ord_num != TRIM(sls_ord_num);

-- Check strings in the table are in their related table
-- Expectation: No Results
SELECT sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_dt,
      sls_ship_dt,
      sls_due_dt,
      sls_sales,
      sls_quantity,
      sls_price
  FROM bronze.crm_sales_details
--  WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
  WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)
;

-- Check date fields for invalid values
-- If invalid set to NULL
SELECT sls_order_dt, --NULLIF(sls_order_dt, 0) sls_order_dt2, TRY_CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE) sls_order_dt3,
      CASE 
        WHEN sls_order_dt = 0 OR sls_order_dt IS NULL THEN NULL
        ELSE TRY_CAST(RIGHT('00000000' + CAST(sls_order_dt AS VARCHAR(8)), 8) AS DATE)
      END AS sls_order_dt_cor,
      sls_ship_dt,
	  CASE 
        WHEN sls_ship_dt = 0 OR sls_ship_dt IS NULL THEN NULL
        ELSE TRY_CAST(RIGHT('00000000' + CAST(sls_ship_dt AS VARCHAR(8)), 8) AS DATE)
      END AS sls_ship_dt_cor,
      sls_due_dt,
	  CASE 
        WHEN sls_due_dt = 0 OR sls_due_dt IS NULL THEN NULL
        ELSE TRY_CAST(RIGHT('00000000' + CAST(sls_due_dt AS VARCHAR(8)), 8) AS DATE)
      END AS sls_due_dt_cor
  FROM bronze.crm_sales_details
--WHERE sls_order_dt != 0
--AND LEN(sls_order_dt) != 8
;

-- Check for Invalid Date Orders
-- Order Date must always be earlier than the shipping date or due date
select sls_ord_num,
      sls_prd_key,
      sls_cust_id,
	  sls_order_dt,
	  sls_ship_dt,
	  sls_due_dt
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt
or sls_order_dt > sls_due_dt
order by sls_ord_num;

-- Check Date Consistency between sale, quantity and price
-- Sale = Quantity * Price
-- Values must not be NULL, zero or negative
-- Solution 1 - Data issues will be fixed direct in source system
-- Solution 2 - Data issues has to be fixed in data warehouse
-- For solution 2 an approach might be
--    If Sales is negative, zero or null derive it using Quantity and Price
--    If Price is zero or null, calculate it using Sales and Quantity
--    If Price is negative, convert it to a positive value
select DISTINCT 
      sls_ord_num,
      sls_prd_key,
      sls_cust_id,
	  sls_sales AS sls_sales_old,
      sls_quantity,
      sls_price AS sls_price_old,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		   THEN sls_quantity * ABS(sls_price)
	   ELSE sls_sales
	END AS sls_sales,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
		   THEN sls_sales / NULLIF(sls_quantity, 0) -- Avoids divide by zero
	   ELSE sls_price
	END AS sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_ord_num;




-- Bronze table - bronze.erp_cust_az12
-- Check if strings in the table are in their related table
-- Expectation: No Results
select 
   cid,
   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
       ELSE cid
   END AS cid_corr,
   bdate,
   gen
from bronze.erp_cust_az12
where CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
       ELSE cid
      END NOT IN
(select DISTINCT cst_key from silver.crm_cust_info);

-- Check strings that are padded right or left
-- Expectation: No Results
SELECT cid,
   bdate,
   gen
  FROM bronze.erp_cust_az12
where cid != TRIM(cid);


-- Check bdate to see out of range
-- Expectation: No Results
-- The dates before 1924-01-01 will keep
-- The dates in the future will NULL out
SELECT bdate
  FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01'
OR bdate > GETDATE()
;

-- Check Data Standardization and Consistency
select distinct gen
from bronze.erp_cust_az12;
gen
NULL
F 
  
Male
Female
M 



-- Bronze table - bronze.erp_loc_a101
-- Check if strings in the table are in their related table
-- Expectation: No Results
select
cid cid_o,
REPLACE(TRIM(cid), '-', '') cid,
cntry
from bronze.erp_loc_a101
where REPLACE(TRIM(cid), '-', '') NOT IN
(select cst_key FROM silver.crm_cust_info)
;

-- Data Standardization and Consistency
select DISTINCT e.cntry AS cntry_variant,
COALESCE(cl.standard_cntry_name, 'Unmatched: ' + e.cntry) AS cntry
from bronze.erp_loc_a101 e
  LEFT JOIN silver.cntry_info cl
    ON UPPER(TRIM(ISNULL(e.cntry, ''))) = UPPER(cl.cntry_variant)
    AND cl.is_validated = 1
;

select cntry_id, cntry_variant, standard_cntry_name, cntry_code, is_validated, validation_date
from silver.cntry_info;



-- Bronze table - bronze.erp_loc_a101
-- Check id in the table are in their related table
-- Expectation: No Results
select id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2;

select prd_id,cat_id,prd_key,prd_nm,prd_start_dt,prd_end_dt
from silver.crm_prd_info;

-- Check for unwanted spaces
-- Expectation: No Results
select id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance);

-- Data Standardization and Consistency
select DISTINCT cat
from bronze.erp_px_cat_g1v2
;

select DISTINCT subcat
from bronze.erp_px_cat_g1v2
;

select DISTINCT maintenance
from bronze.erp_px_cat_g1v2
;

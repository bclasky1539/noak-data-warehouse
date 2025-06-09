/*
=============================================================
Quality Checks: Silver Layer
=============================================================
Overview
    This script performs various quality checks for data consistency,
	accuracy, and standardization across the Silver schemas.
	It includes checks for:
	- Null or duplicate primary keys
	- Unwanted spaces in string fields
	- Data standardization and consistency
	- Invalid date ranges and orders
	- Data consistency between related fields
	
Usage Notes:
    - Run these checks after data is loaded into the Silver Layer
	- Investigate and resolve any discrepancies found during the checks
*/

-- Silver table - silver.crm_cust_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
select cst_id, count(*) AS cst_count
from silver.crm_cust_info
group by cst_id
having count(*)>1 OR cst_id IS NULL;

-- Check strings that are padded right or left
-- Expectation: No Results
select cst_firstname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

select cst_lastname
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

select cst_marital_status
from silver.crm_cust_info
where cst_marital_status != TRIM(cst_marital_status);

select cst_gndr
from silver.crm_cust_info
where cst_gndr != TRIM(cst_gndr);

select * from silver.crm_cust_info;


-- Silver table - silver.crm_prd_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
select prd_id, count(*) AS prd_count
from silver.crm_prd_info
group by prd_id
having count(*)>1 OR prd_id IS NULL;

-- Check strings that are padded right or left
-- Expectation: No Results
select prd_nm
from silver.crm_prd_info
where prd_nm != TRIM(prd_nm);

-- Check strings that are padded right or left
-- Expectation: No Results
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;


-- Check Data Standardization and Consistency
select distinct prd_line
from silver.crm_prd_info;

-- Check for Invalid Date Orders
-- End Date must not be earlier than the start date
select prd_id,
      prd_key,
      prd_nm,
	  prd_start_dt,
	  prd_end_dt
from silver.crm_prd_info
where prd_end_dt < prd_start_dt
order by prd_key;

select * from silver.crm_prd_info;



-- Silver table - silver.crm_sales_details
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
  FROM silver.crm_sales_details
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
  FROM silver.crm_sales_details
--  WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
  WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)


-- Check for Invalid Date Orders
-- Order Date must always be earlier than the shipping date or due date
select sls_ord_num,
      sls_prd_key,
      sls_cust_id,
	  sls_order_dt,
	  sls_ship_dt,
	  sls_due_dt
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt
or sls_order_dt > sls_due_dt
order by sls_ord_num;


-- Check Date Consistency between sale, quantity and price
-- Sale = Quantity * Price
-- Values must not be NULL, zero or negative
select DISTINCT 
      sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_sales,
	  sls_quantity,
	  sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_ord_num;

select * from silver.crm_sales_details;




-- Silver table - silver.erp_cust_az12
-- Check bdate to see out of range
-- Expectation: No Results
-- The dates before 1924-01-01 will keep
-- The dates in the future will NULL out
SELECT bdate
  FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
OR bdate > GETDATE()
;

-- Check Data Standardization and Consistency
select distinct gen
from silver.erp_cust_az12;

select * from silver.erp_cust_az12;



-- Silver table - silver.erp_loc_a101
-- Data Standardization and Consistency
select DISTINCT cntry_variant, cntry
from silver.erp_loc_a101;

select * from silver.erp_loc_a101;



-- Silver table - silver.erp_px_cat_g1v2
select * from silver.erp_px_cat_g1v2;


EXEC silver.sp_load_silver_data;


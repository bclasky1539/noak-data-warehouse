-- Gold view - Customer
-- Check for Nulls or Duplicates that could be introduced by the join logic
-- Expectation: No Result
SELECT cst_id, COUNT(*)  FROM (
SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
  ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
  ON ci.cst_key = la.cid
) t
GROUP BY cst_id
HAVING COUNT(*) > 1
;

-- Data Integration Check
-- Check silver.crm_cust_info.cst_gndr against silver.erp_cust_az12.gen
-- NULLs in the result often come from the joining of the tables.
-- NULLs will appear if SQL finds no match
-- An assumption to be made is that the CRM data is the Master Source of Customer Data
SELECT DISTINCT
ci.cst_gndr,
ca.gen,
CASE WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr -- CRM is the Master for Gender Info
     ELSE COALESCE(ca.gen, 'Unknown')
END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
  ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
  ON ci.cst_key = la.cid
ORDER BY ci.cst_gndr,ca.gen;



-- Gold view - PRODUCT
-- If prd_end_dt is NULL then it is the current info of the product
-- Check for Duplicates that could be introduced by the join logic
-- Expectation: No Result
SELECT prd_key, COUNT(*) from (
SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
  ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter out all historical data
) t
GROUP BY prd_key
HAVING COUNT(*) > 1
;



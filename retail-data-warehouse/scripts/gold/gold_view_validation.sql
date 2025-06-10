SELECT *
FROM gold.dim_customers;

select *
from gold.dim_products;

select *
from gold.fact_sales;

-- Foreign Key Integrity (Dimensions)
-- Check for Nulls
-- Expectation: No Result
select *
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;

select *
from gold.fact_sales f
LEFT JOIN gold.dim_products p
  ON p.product_key = f.product_key
WHERE p.product_key IS NULL;


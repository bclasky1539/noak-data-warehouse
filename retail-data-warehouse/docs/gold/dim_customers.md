# gold.dim_customers

## Overview
**Description:** Stores customer details enriched with demographic and geographic data.<br>
**Update Frequency:** Daily<br>
**Object Type:** View<br>
**Last Updated:** 2025-06-10

## Object Schema
| Column Name        | Data Type      | Description                                                                                   |
|--------------------|----------------|-----------------------------------------------------------------------------------------------|
| customer_key       | INT            | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_id        | INT            | Unique numerical identifier assigned to each customer.                                        |
| customer_number    | NVARCHAR(100)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| first_name         | NVARCHAR(100)  | The customer's first name, as recorded in the system.                                         |
| last_name          | NVARCHAR(100)  | The customer's last name or family name.                                                      |
| marital_status     | NVARCHAR(10)   | The marital status of the customer (e.g., 'Married', 'Single').                               |
| gender             | NVARCHAR(10)   | The gender of the customer (e.g., 'Male', 'Female', 'Unknown').                               |
| birthdate          | DATE           | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| country            | NVARCHAR(100)  | The country of residence for the customer (e.g., 'United States').                            |
| create_date        | DATE           | The date and time when the customer record was created in the system                          |

---




## Data Sources
- **Bronze/Silver tables used:** silver.crm_cust_info, silver.erp_cust_az12, silver.erp_loc_a101
- **Key transformations:**
<br>customer_key - ROW_NUMBER() OVER (ORDER BY crm_cust_info.cst_id)
<br>gender - CASE WHEN crm_cust_info.cst_gndr != 'Unknown' THEN crm_cust_info.cst_gndr ELSE COALESCE(erp_cust_az12.gen, 'Unknown') END
- **Data quality rules:** None

## Usage Examples
```sql
-- Common query patterns
SELECT customer_key, customer_number 
FROM gold.dim_customers;

SELECT customer_key, birthdate 
FROM gold.dim_customers 
WHERE birthdate > '1980-01-01';

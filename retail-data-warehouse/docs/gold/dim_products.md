# gold.dim_products

## Overview
**Description:** Provides information about the products and their attributes.<br>
**Update Frequency:** Daily<br>
**Object Type:** View<br>
**Last Updated:** 2025-06-10

## Object Schema
| Column Name           | Data Type     | Description                                                                                   |
|-----------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key           | INT           | Surrogate key uniquely identifying each product record in the product dimension table.        |
| product_id            | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |
| product_number        | NVARCHAR(100) | A structured alphanumeric code representing the product, used for categorization/inventory.   |
| product_name          | NVARCHAR(100) | Descriptive name of the product, including key details such as type, color, and size.         |
| category_id           | NVARCHAR(100) | A unique identifier for the product's category, linking to its high-level classification.     |
| category              | NVARCHAR(100) | The broader classification of the product (e.g., Bikes, Components) to group related items.   |
| subcategory           | NVARCHAR(100) | A more detailed classification of the product within the category, such as product type.      |
| maintenance_required  | NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       |
| cost                  | DECIMAL(10,2) | The cost or base price of the product, measured in monetary units.                            |
| product_line          | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).      |
| start_date            | DATE          | The date when the product became available for sale or use, stored in                         |

---




## Data Sources
- **Bronze/Silver tables used:** silver.crm_prd_info, silver.erp_px_cat_g1v2
- **Key transformations:**
<br>product_key - ROW_NUMBER() OVER (ORDER BY crm_prd_info.prd_start_dt, crm_prd_info.prd_key)
- **Data quality rules:** None

## Usage Examples
```sql
-- Common query patterns
SELECT product_key, product_id 
FROM gold.dim_products;

SELECT product_key, product_number 
FROM gold.dim_products 
WHERE product_number LIKE 'BK-M%';

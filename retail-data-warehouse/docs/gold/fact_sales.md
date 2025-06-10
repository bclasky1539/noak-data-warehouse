# gold.fact_sales

## Overview
**Description:** Stores transactional sales data for analytical purposes.<br>
**Update Frequency:** Daily<br>
**Object Type:** View<br>
**Last Updated:** 2025-06-10

## Object Schema
| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|----------------------------------------------------------------------------|
| order_number    | NVARCHAR(100) | A unique alphanumeric identifier for each sales order (e.g., 'SO55837').   |
| product_key     | INT           | Foreign key reference linking the order to the product dimension table.    |
| customer_key    | INT           | Foreign key reference linking the order to the customer dimension table.   |
| order_date      | DATE          | The date when the order was placed.                                        |
| shipping_date   | DATE          | The date when the order was shipped to the customer.                       |
| due_date        | DATE          | The date when the order payment was due.                                   |
| sales_amount    | DECIMAL(10,2) | The total monetary value of the sale for the line item.                    |
| quantity        | INT           | The number of units of the product ordered for the line item.              |
| price           | DECIMAL(10,2) | The price per unit of the product for the line item.                       |

---




## Data Sources
- **Bronze/Silver tables used:** silver.crm_sales_details, gold.dim_products, gold.dim_customers
- **Key transformations:** None
- **Data quality rules:** None

## Usage Examples
```sql
-- Common query patterns
select c.first_name, c.last_name, c.country, s.order_number, s.customer_key,
s.order_date, s.shipping_date, s.due_date, s.price, s.quantity, s.sales_amount
from gold.fact_sales s
  left join gold.dim_customers c
    on s.customer_key = c.customer_key;
 
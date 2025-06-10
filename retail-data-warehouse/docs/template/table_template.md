# [Table Name]

## Overview
**Description:** Brief description of what this table contains<br>
**Update Frequency:** Daily/Weekly/Monthly<br>
**Object Type:** Table/View/Materialized View<br>
**Last Updated:** YYYY-MM-DD

## Object Schema
| Column Name        | Data Type     | Description                               |
|--------------------|---------------|-------------------------------------------|
| customer_id        | INT           | Unique customer identifier.               |
| order_count        | INT           | Total orders placed.                      |

---

## Data Sources
- **Bronze/Silver tables used:** List source tables
- **Key transformations:** Brief description of main logic
- **Data quality rules:** Any filters or cleansing applied

## Usage Examples
```sql
-- Common query patterns
SELECT customer_id, order_count 
FROM gold.customer_metrics 
WHERE order_count > 10;

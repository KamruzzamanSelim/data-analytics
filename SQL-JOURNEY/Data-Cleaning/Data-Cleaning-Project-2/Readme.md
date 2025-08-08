#  Dirty Cafe Sales – Data Cleaning Script

This project contains a **SQL-based data cleaning pipeline** for the `dirty_cafe_sales` dataset.  
It standardizes, cleans, and prepares the data for analysis, following well-defined and documented steps.

---

##  Overview

The script:
1. Creates a working copy of the raw data (`dirty_cafe_sales2`)
2. Handles missing or invalid values
3. Removes duplicates
4. Standardizes formats (dates, text fields, categories)
5. Calculates missing numeric fields
6. Backfills missing values using self-joins
7. Removes unusable rows
8. Produces final cleaned data and summary reports

---
```mermaid
flowchart TD
    A[Raw Data: dirty_cafe_sales] --> B[Create Working Table: dirty_cafe_sales2]
    B --> C[Replace Empty Strings with NULL]
    C --> D[Check & Remove Duplicates]
    D --> E[Explore and Standardize Values]
    E --> F[Fix Invalid Dates]
    F --> G[Clean Text Fields]
    G --> H[Remove Unusable Rows]
    H --> I[Fill Missing Price_Per_Unit]
    I --> J[Fill Missing Total_Spent]
    J --> K[Fill Missing Quantity]
    K --> L[Backfill Price via Self-Join]
    L --> M[Backfill Item via Self-Join]
    M --> N[Remove Remaining Missing Items]
    N --> O[Generate Summary Reports]
    O --> P[Final Clean Dataset]

```
##  How to Use

1. **Import the SQL script** into your MySQL environment.
2. **Run all steps in sequence** – the script is already ordered from raw data load to final output.
3. Review the **final cleaned table**:  
   ```sql
   SELECT * FROM dirty_cafe_sales2;

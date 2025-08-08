#From Messy Café Sales to Clean, Usable Data — A Complete SQL Data Cleaning Walkthrough

#Data cleaning is often the unglamorous but essential step before any meaningful analysis can happen. In this project, I worked with a messy café sales dataset (dirty_cafe_sales) and transformed it into a structured, analysis-ready table (dirty_cafe_sales2) using pure SQL.

#The process followed a structured eight-step pipeline to handle missing values, fix inconsistencies, standardize formats, and backfill data. By the end, the dataset was ready for reporting, trend analysis, and decision-making.


---

1. Loading & Structuring the Data

The first step was to create a clean working table with appropriate data types:

```sql
CREATE TABLE dirty_cafe_sales2 (
  Transaction_ID TEXT,
  Item TEXT,
  Quantity DOUBLE DEFAULT NULL,
  Price_Per_Unit INT DEFAULT NULL,
  Total_Spent TEXT,
  Payment_Method TEXT,
  Location TEXT,
  Transaction_Date TEXT
);
```
Then, I inserted the raw data from dirty_cafe_sales into dirty_cafe_sales2 for cleaning.


---

2. Handling Missing and Placeholder Values

Messy data often has missing fields represented as:

Empty strings ('')

Placeholder words like "UNKNOWN" or "ERROR"


These were replaced with proper NULL values across all columns for easier handling:
```sql
UPDATE dirty_cafe_sales2
SET Item = NULL
WHERE Item = '' OR Item = 'UNKNOWN' OR Item = 'ERROR';
```
This standardization ensures all missing values are treated consistently.


---

3. Removing Duplicate Records

To remove exact duplicate rows, I used a CTE with ROW_NUMBER():
```sql
WITH duplicate_check AS (
  SELECT *,
         ROW_NUMBER() OVER(
           PARTITION BY Transaction_ID, Item, Quantity, Price_Per_Unit, Total_Spent, Payment_Method, Location, Transaction_Date
         ) AS row_num
  FROM dirty_cafe_sales2
)
DELETE FROM duplicate_check
WHERE row_num > 1;
```
This kept the first occurrence of each duplicate and removed the rest.


---

4. Standardizing Data Formats

Inconsistent formats can cause analysis headaches. I standardized:

Dates: Converted Transaction_Date to a proper DATE format (%d-%m-%Y → YYYY-MM-DD)

Whitespace: Trimmed leading/trailing spaces in Item

Category Values: Ensured Payment_Method, Location, and Item used consistent naming


Example for fixing dates:
```sql
UPDATE dirty_cafe_sales2
SET Transaction_Date = STR_TO_DATE(Transaction_Date, '%d-%m-%Y');
```

---

5. Calculating Missing Values

Some rows had NULL for Price_Per_Unit, Total_Spent, or Quantity — but these could be calculated from the other two fields.

Price_Per_Unit = Total_Spent / Quantity

Total_Spent = Price_Per_Unit × Quantity

Quantity = Total_Spent / Price_Per_Unit


Example:
```sql
UPDATE dirty_cafe_sales2
SET Price_Per_Unit = Total_Spent / Quantity
WHERE Price_Per_Unit IS NULL
  AND Total_Spent IS NOT NULL
  AND Quantity IS NOT NULL;
```

---

6. Backfilling Using Self-Joins

To fill in missing values, I leveraged existing rows with the same Item or Price_Per_Unit:
```sql
UPDATE dirty_cafe_sales2 t1
JOIN dirty_cafe_sales2 t2
  ON t1.Item = t2.Item
SET t1.Price_Per_Unit = t2.Price_Per_Unit
WHERE t1.Price_Per_Unit IS NULL
  AND t2.Price_Per_Unit IS NOT NULL;
```
This reused known values from other transactions to complete missing fields.


---

7. Removing Unusable Rows

After all cleaning and backfilling, some rows still had:

No Item

No Price_Per_Unit

No Total_Spent


These records were removed:
```sql
DELETE FROM dirty_cafe_sales2
WHERE Item IS NULL
  AND Price_Per_Unit IS NULL
  AND Total_Spent IS NULL;
```

---

8. Final Checks & Insights

With the dataset clean, I could now run quick checks and summaries:

Top-selling items by revenue:

```sql
SELECT Item, SUM(Total_Spent) AS sum_spend
FROM dirty_cafe_sales2
GROUP BY Item
ORDER BY sum_spend DESC;
```
Monthly revenue trends:

```sql
SELECT MONTH(Transaction_Date) AS month, SUM(Total_Spent) AS sum_spend
FROM dirty_cafe_sales2
GROUP BY month
ORDER BY month ASC;
```

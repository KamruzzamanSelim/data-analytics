/* ===========================================================
 STEP 1 – View Original Data
=========================================================== */
SELECT * FROM dirty_cafe_sales;

/* ===========================================================
 STEP 2 – Create a Working Copy Table with Correct Data Types
=========================================================== */
CREATE TABLE `dirty_cafe_sales2` (
  `Transaction_ID` TEXT,
  `Item` TEXT,
  `Quantity` DOUBLE DEFAULT NULL,
  `Price_Per_Unit` INT DEFAULT NULL,
  `Total_Spent` TEXT,
  `Payment_Method` TEXT,
  `Location` TEXT,
  `Transaction_Date` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* Copy data from original table */
INSERT INTO dirty_cafe_sales2
SELECT * FROM dirty_cafe_sales;

SELECT * FROM dirty_cafe_sales2;

/* ===========================================================
 STEP 3 – Replace Empty Strings with NULL (Column by Column)
=========================================================== */
-- Transaction_ID
SELECT Transaction_ID FROM dirty_cafe_sales2 WHERE Transaction_ID LIKE '';
-- Item
SELECT Item FROM dirty_cafe_sales2 WHERE Item LIKE '';

UPDATE dirty_cafe_sales2 SET Item = NULL WHERE Item LIKE '';
UPDATE dirty_cafe_sales2 SET Quantity = NULL WHERE Quantity LIKE '';
UPDATE dirty_cafe_sales2 SET Price_Per_Unit = NULL WHERE Price_Per_Unit LIKE '';
UPDATE dirty_cafe_sales2 SET Total_Spent = NULL WHERE Total_Spent LIKE '';
UPDATE dirty_cafe_sales2 SET Payment_Method = NULL WHERE Payment_Method LIKE '';
UPDATE dirty_cafe_sales2 SET Location = NULL WHERE Location LIKE '';
UPDATE dirty_cafe_sales2 SET Transaction_Date = NULL WHERE Transaction_Date LIKE '';

SELECT * FROM dirty_cafe_sales2;

/* ===========================================================
 STEP 4 – Check for Duplicates
=========================================================== */
WITH duplicate_check AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Transaction_ID, Item, Quantity, Price_Per_Unit,
                            Total_Spent, Payment_Method, Location, Transaction_Date
           ) AS row_num
    FROM dirty_cafe_sales2
)
SELECT * FROM duplicate_check
WHERE row_num > 1;

/* ===========================================================
 STEP 5 – Standardization Checks
=========================================================== */
SELECT * FROM dirty_cafe_sales2;
SELECT * FROM dirty_cafe_sales2 WHERE Transaction_ID NOT LIKE 'TXN%%';
SELECT DISTINCT Item FROM dirty_cafe_sales2;
SELECT DISTINCT Payment_Method FROM dirty_cafe_sales2;
SELECT DISTINCT Location FROM dirty_cafe_sales2;

/* Check date conversion */
SELECT STR_TO_DATE(Transaction_Date, '%d-%m-%Y') AS Transaction_Date 
FROM dirty_cafe_sales2;

-- Identify invalid dates
SELECT Transaction_Date FROM dirty_cafe_sales2 WHERE Transaction_Date LIKE 'ERROR';
SELECT Transaction_Date FROM dirty_cafe_sales2 WHERE Transaction_Date LIKE 'UNKNOWN';

/* ===========================================================
 STEP 6 – Fix Invalid Dates
=========================================================== */
UPDATE dirty_cafe_sales2
SET Transaction_Date = NULL
WHERE Transaction_Date LIKE 'ERROR';

UPDATE dirty_cafe_sales2
SET Transaction_Date = NULL
WHERE Transaction_Date LIKE 'UNKNOWN';

UPDATE dirty_cafe_sales2
SET Transaction_Date = STR_TO_DATE(Transaction_Date, '%d-%m-%Y');

/* ===========================================================
 STEP 7 – Trim Extra Spaces and Remove Error Codes in Text Fields
=========================================================== */
-- Check for extra spaces in Item
SELECT LENGTH(Item), LENGTH(TRIM(Item)), LENGTH(Item) - LENGTH(TRIM(Item)) 
FROM dirty_cafe_sales2
WHERE LENGTH(Item) - LENGTH(TRIM(Item)) > 0;

-- Replace error/unknown values with NULL
UPDATE dirty_cafe_sales2
SET Item = NULL
WHERE Item = 'UNKNOWN' OR Item = 'ERROR';

UPDATE dirty_cafe_sales2
SET Payment_Method = NULL
WHERE Payment_Method = 'UNKNOWN' OR Payment_Method = 'ERROR';

UPDATE dirty_cafe_sales2
SET Location = NULL
WHERE Location = 'UNKNOWN' OR Location = 'ERROR';

SELECT * FROM dirty_cafe_sales2;

/* ===========================================================
 STEP 8 – Remove Rows with All Key Fields Missing
=========================================================== */
SELECT * FROM dirty_cafe_sales2
WHERE Item IS NULL
  AND Price_Per_Unit IS NULL
  AND Total_Spent IS NULL;

DELETE FROM dirty_cafe_sales2
WHERE Item IS NULL
  AND Price_Per_Unit IS NULL
  AND Total_Spent IS NULL;

/* ===========================================================
 STEP 9 – Check and Fill Missing Price_Per_Unit
=========================================================== */
SELECT Item, Price_Per_Unit FROM dirty_cafe_sales2
GROUP BY Item, Price_Per_Unit
ORDER BY Item;

SELECT * FROM dirty_cafe_sales2
WHERE Price_Per_Unit IS NULL
  AND Total_Spent IS NOT NULL
  AND Quantity IS NOT NULL;

UPDATE dirty_cafe_sales2
SET Price_Per_Unit = Total_Spent / Quantity
WHERE Price_Per_Unit IS NULL
  AND Total_Spent IS NOT NULL
  AND Quantity IS NOT NULL;

/* ===========================================================
 STEP 10 – Check and Fill Missing Total_Spent
=========================================================== */
SELECT * FROM dirty_cafe_sales2
WHERE Total_Spent IS NULL
  AND Price_Per_Unit IS NOT NULL
  AND Quantity IS NOT NULL;

UPDATE dirty_cafe_sales2
SET Total_Spent = Price_Per_Unit * Quantity
WHERE Total_Spent IS NULL
  AND Price_Per_Unit IS NOT NULL
  AND Quantity IS NOT NULL;

/* ===========================================================
 STEP 11 – Check and Fill Missing Quantity
=========================================================== */
SELECT * FROM dirty_cafe_sales2
WHERE Quantity IS NULL
  AND Price_Per_Unit IS NOT NULL
  AND Total_Spent IS NOT NULL;

UPDATE dirty_cafe_sales2
SET Quantity = Total_Spent / Price_Per_Unit
WHERE Quantity IS NULL
  AND Price_Per_Unit IS NOT NULL
  AND Total_Spent IS NOT NULL;

/* ===========================================================
 STEP 12 – Backfill Price_Per_Unit Using Self-Join
=========================================================== */
SELECT t1.Item, t2.Item, t1.Price_Per_Unit, t2.Price_Per_Unit 
FROM dirty_cafe_sales2 t1
JOIN dirty_cafe_sales2 t2
    ON t1.Item = t2.Item
WHERE t1.Price_Per_Unit IS NULL
  AND t2.Price_Per_Unit IS NOT NULL;

UPDATE dirty_cafe_sales2 t1
JOIN dirty_cafe_sales2 t2
    ON t1.Item = t2.Item
SET t1.Price_Per_Unit = t2.Price_Per_Unit
WHERE t1.Price_Per_Unit IS NULL
  AND t2.Price_Per_Unit IS NOT NULL;

/* ===========================================================
 STEP 13 – Backfill Item Using Self-Join
=========================================================== */
SELECT t1.Item, t2.Item, t1.Price_Per_Unit, t2.Price_Per_Unit 
FROM dirty_cafe_sales2 t1
JOIN dirty_cafe_sales2 t2
    ON t1.Price_Per_Unit = t2.Price_Per_Unit
WHERE t1.Item IS NULL
  AND t2.Item IS NOT NULL;

UPDATE dirty_cafe_sales2 t1
JOIN dirty_cafe_sales2 t2
    ON t1.Price_Per_Unit = t2.Price_Per_Unit
SET t1.Item = t2.Item
WHERE t1.Item IS NULL
  AND t2.Item IS NOT NULL;

/* ===========================================================
 STEP 14 – Remove Rows Still Missing Item
=========================================================== */
SELECT * FROM dirty_cafe_sales2 WHERE Item IS NULL;
DELETE FROM dirty_cafe_sales2 WHERE Item IS NULL;

/* ===========================================================
 STEP 15 – Final Aggregations
=========================================================== */
-- Spend per Item
SELECT Item, SUM(Total_Spent) AS sum_spend
FROM dirty_cafe_sales2
GROUP BY Item
ORDER BY sum_spend DESC;

-- Spend per Month
SELECT MONTH(Transaction_Date) AS `month`, SUM(Total_Spent) AS sum_spend
FROM dirty_cafe_sales2
GROUP BY MONTH(Transaction_Date)
ORDER BY `month` ASC;

SELECT * FROM dirty_cafe_sales2;

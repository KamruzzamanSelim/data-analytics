# SQL Data Cleaning Project

## Overview
This project demonstrates data cleaning techniques applied to [layoff.csv] using SQL. The goal was to improve data quality by removing duplicates, standardizing formats, and eliminating irrelevant information.

## Cleaning Process
1. **Removed duplicates**: Eliminated duplicate records.
2. **Data standardization**: 
   - Standardized date formats.
   - Normalized categorical variables (e.g."United States." → "United States", "Crypto Currency", "CryptoCurrency" → "Crypto")
3. **Removed columns**: Dropped columns "row_num" created temporarily for removing duplicate rows.
4. **Filtered rows**: Removed records with missing critical identifiers like missing "total_laid_off", "percentage_laid_off".

## Results
- Original dataset: 2,362 rows × 9 columns
- Cleaned dataset: 1,995 rows × 9 columns

## How to Replicate
1. Clone this repository
2. Import the raw data into your SQL database
3. Execute the SQL scripts in numerical order

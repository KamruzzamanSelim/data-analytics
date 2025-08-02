-- =============================
-- Load Original Data
-- =============================

SELECT * FROM layoffs;

-- =============================
-- Create Staging Table
-- =============================

CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

-- =============================
-- Identify Duplicate Rows
-- =============================

-- View with row numbers
SELECT *, 
       ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Create a CTE to detect full duplicates
WITH duplicate_cte AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, `date`, stage, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT * FROM duplicate_cte;

-- =============================
-- Create Cleaned Staging Table
-- =============================

CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert with deduplication logic
INSERT INTO layoffs_staging2
SELECT *, 
       ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, `date`, stage, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Remove duplicates (keep row_num = 1)
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- =============================
-- Data Cleaning & Standardization
-- =============================

-- Trim whitespace from company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Normalize Industry
SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Normalize Country
SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1;
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Remove trailing periods
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- =============================
-- Date Format Conversion
-- =============================

-- View current date format
SELECT `date` FROM layoffs_staging2;

-- Convert to DATE format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- =============================
-- Handle Missing Industry Data
-- =============================

-- Find NULL or empty industries
SELECT * FROM layoffs_staging2
WHERE industry IS NULL OR industry LIKE '';

-- Try filling missing industries by company name
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- =============================
-- Final Clean-Up
-- =============================

-- Remove rows with both layoff fields NULL
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Drop helper column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final result
SELECT * FROM layoffs_staging2;

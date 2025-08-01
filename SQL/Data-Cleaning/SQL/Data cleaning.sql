SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
select * from layoffs;

select * from layoffs_staging;

#---REMOVE DUPLICATE
select *, ROW_NUMBER() over(partition by company, location, industry, total_laid_off, funds_raised_millions) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *, ROW_NUMBER() over(partition by company, location, industry, total_laid_off, `date`, stage, funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte
;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2;

insert into layoffs_staging2
select *, ROW_NUMBER() over(partition by company, location, industry, total_laid_off, `date`, stage, funds_raised_millions) as row_num
from layoffs_staging;

delete 
from layoffs_staging2
WHERE row_num > 1;

#---STANDARDIZATION
SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%';


UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
where country LIKE 'United States%';

SELECT *
FROM layoffs_staging2;

SELECT `date`
FROM layoffs_staging2;

SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry LIKE '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Airbnb';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
OR t1.industry LIKE '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry LIKE '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
OR t1.industry LIKE '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE "Bally's Interactive";

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
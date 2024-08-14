-- Data Cleaning Project

SELECT 
    *
FROM
    layoffs;

-- 1. Remove duplicates (If any)
-- 2. Standardize data
-- 3. NULL values or Blank values
-- 4. Remove any columns or rows that aren't necessary

CREATE TABLE layoffs_staging LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT 
    *
FROM
    layoffs_staging;

-- Removing Duplicates

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- Creating CTE to make a table to show duplicates in the row_num column --

WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
 `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- 1 real row and 1 duplicate column --
SELECT 
    *
FROM
    layoffs_staging
WHERE
    company = 'Casper';

-- Creating another table to delete duplicates 

CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;


SELECT 
    *
FROM
    layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- filtering the table to find duplicates

SELECT 
    *
FROM
	layoffs_staging2
WHERE
    row_num > 1;

-- DELETING the duplicated values where the row_num is > 1 

DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;


-- Standardizing The Data

SELECT 
    company, TRIM(company)
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    company = TRIM(company);

-- Finding duplicates in the industry row

SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY 1;

-- Updating Crypto Currency and CryptoCurrency to Crypto to Group it all together 

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE 'Crypto%';



UPDATE layoffs_staging2 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'Crypto%';

SELECT DISTINCT
    industry
FROM
    layoffs_staging2;

SELECT 
    *
FROM
    layoffs_staging2;

-- Checking Locations for duplications

SELECT DISTINCT
    location
FROM
    layoffs_staging2
ORDER BY 1;

-- Fixing "United States." to remove the "." and Updating the table to reflect the change

SELECT DISTINCT
    country, TRIM(TRAILING '.' FROM country)
FROM
    layoffs_staging2
WHERE
    country LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2 
SET 
    country = TRIM(TRAILING '.' FROM country)
WHERE
    country LIKE 'United States%';

SELECT 
    *
FROM
    layoffs_staging2;

-- Changing Date data format from text to date 

SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT 
    `date`
FROM
    layoffs_staging2;
 
 ALTER TABLE layoffs_staging2
 MODIFY COLUMN `date` DATE;
 
SELECT 
    *
FROM
    layoffs_staging2;
 
 -- Working with NULL and Blank Values
 
 
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2 
SET 
    industry = NULL
WHERE
    industry = '';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL OR industry = '';
 
 -- Trying to populate data (industry column in this case)
 
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company = 'Airbnb';

-- Filling in blank spaces where there should be data (Airbnb industry being blank)

SELECT 
    *
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
        AND t1.location = t2.location
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;

-- Updating Bally's industry from NULL to "Media" 

SELECT 
    company, industry
FROM
    layoffs_staging2
WHERE
    industry IS NULL;

UPDATE layoffs_staging2 
SET 
    industry = 'Media'
WHERE
    industry IS NULL;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company LIKE 'Bally%';

SELECT 
    *
FROM
    layoffs_staging2;

-- Removing columns and rows we need to

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

-- Deleting or Dropping row_num column since we don't need it anymore

SELECT 
    *
FROM
    layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Changing Kitty Hawk's percentage laid off in 2020 to 0.7 or 70% instead of NULL because 70 people were laid off 
										SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company LIKE 'Kitty Hawk';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off IS NULL
        AND company = 'Kitty Hawk';

UPDATE layoffs_staging2 
SET 
    percentage_laid_off = 0.7
WHERE
    percentage_laid_off IS NULL
        AND company = 'Kitty Hawk';

SELECT 
    *
FROM
    layoffs_staging2;



-- Creating table to delete the duplicates in the company column
-- Noticed Kitty Hawk had duplicates so I'm deleting them in a new table

CREATE TABLE `layoffs_staging3` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging3
WHERE
    company = 'Kitty Hawk';

SELECT 
    *
FROM
    layoffs_staging3
WHERE
    company = 'Kitty Hawk' OR row_num > 1;

DELETE FROM layoffs_staging3 
WHERE
    row_num > 1;

ALTER TABLE layoffs_staging3
DROP COLUMN row_num;

SELECT 
    *
FROM
    layoffs_staging3;

-- Changing data type from a text to a date in table 3


SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT 
    `date`
FROM
    layoffs_staging3;
 
 ALTER TABLE layoffs_staging3
 MODIFY COLUMN `date` DATE;
 
 SELECT 
    `date`
FROM
    layoffs_staging3;
    
SELECT *
FROM layoffs_staging3;
    
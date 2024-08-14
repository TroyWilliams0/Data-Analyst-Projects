-- Data Exploration of World Layoffs

SELECT *
FROM layoffs_staging2;

-- Finding MAXIMUM people who were laid off

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Looking at Companies that completely went down

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Showing the total amount of people companies let go of

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Years the layoffs began in the dataset and how recent the layoffs are in the dataset

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Checking industry layoffs and how many total people were laid off in which industry 
													-- and the percentage laid off in each industry

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT industry, percentage_laid_off
FROM layoffs_staging2
GROUP BY industry, percentage_laid_off
ORDER BY 2 DESC;

-- Checking total layoffs by Country 

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs by date

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC; 

-- Total layoffs by year 
-- 2023 had 125,677 (in 3 months) 
-- 2022 had 160,591
-- 2021 had 15,823
-- 2020 had 80,998
-- (shown in table)

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- See which stage companies are in

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Company's average percentage laid off 

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Find progression of layoffs using a Rolling Sum by using month

SELECT SUBSTRING(`date`,6,2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY 1 ASC;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- USE CTE to apply the Rolling Sum to this query
-- CTE takes 1st month rolling_total + next month total_off and it = rolling_total
-- Shows month by month progression
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total
;

-- Company total layoffs by year 
-- ranking which years companies laid off most employees

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Using Multiple CTEs to rank companies layoffs per year 1-5

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
-- Showing top 5 companies who laid people off per year starting from 2020

-- Using Multiple CTEs to rank industries layoffs 1-5 from 2020 - 2023

WITH Industry_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
WHERE total_laid_off IS NOT NULL
AND years IS NOT NULL)
SELECT *
FROM Industry_Year_Rank
WHERE Ranking <= 5
;

-- Looking at Retail ranking per year

SELECT *
FROM layoffs_staging2
WHERE industry = 'Retail';

-- Using Multiple CTEs to see the rank of the Retail industry's total layoffs per year 1-5

WITH Retail_Per_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
ORDER BY 2 ASC
), Retail_Ranking AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Retail_Per_Year)
SELECT *
FROM Retail_Ranking
WHERE years IS NOT NULL
AND total_laid_off IS NOT NULL
AND industry LIKE 'Retail';

-- Retail was ranked 1st in layoffs in 2022 
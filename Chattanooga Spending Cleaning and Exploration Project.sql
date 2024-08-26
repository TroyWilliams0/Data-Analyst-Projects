-- Spending By The City of Chattanooga From 2014 - 2016 Cleaning & Exploration


-- Creating table to load the csv file into

CREATE TABLE spendingfr (
fiscal_year integer, fiscal_year_period integer,
fund text,
service text,
department text,
program text,
expense_category text,
invoice_id text,
invoice_date date,
amount double,
description text,
vendor_id text,
vendor_name text
);

-- Loading file into the newly created table

SET GLOBAL LOCAL_INFILE=ON;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Data/spending_in_chatt/spending2.csv" INTO TABLE spendingfr
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT *
FROM spendingfr;

SELECT *
FROM spendingfr;

-- removing duplicates in the data

SELECT *, ROW_NUMBER() OVER(PARTITION BY fiscal_year, fiscal_year_period, 
fund, service, department, program, expense_category, invoice_id, invoice_date,
amount, `description`, vendor_id, vendor_name) as row_num
FROM spendingfr;

WITH duplicates AS 
(SELECT *, ROW_NUMBER() OVER(PARTITION BY fiscal_year, fiscal_year_period, 
fund, service, department, program, expense_category, invoice_id, invoice_date,
amount, `description`, vendor_id, vendor_name) as row_num
FROM spendingfr
)
SELECT *
FROM duplicates 
WHERE row_num > 1;

-- creating new table to remove duplicates using row_num

CREATE TABLE `spending2` (
  `fiscal_year` int DEFAULT NULL,
  `fiscal_year_period` int DEFAULT NULL,
  `fund` varchar(255) DEFAULT NULL,
  `service` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `expense_category` varchar(255) DEFAULT NULL,
  `invoice_id` varchar(255) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `vendor_id` varchar(255) DEFAULT NULL,
  `vendor_name` varchar(512) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Using CTE to create a row_num column to detect duplicates

SELECT *, ROW_NUMBER() OVER(PARTITION BY fiscal_year, fiscal_year_period, 
fund, service, department, program, expense_category, invoice_id, invoice_date,
amount, `description`, vendor_id, vendor_name) as row_num
FROM spendingfr;


INSERT INTO spending2
SELECT *, ROW_NUMBER() OVER(PARTITION BY fiscal_year, fiscal_year_period, 
fund, service, department, program, expense_category, invoice_id, invoice_date,
amount, `description`, vendor_id, vendor_name) as row_num
FROM spendingfr;

SELECT *
FROM spending2;

SELECT *
FROM spending2
WHERE row_num > 1;

-- deleting duplicates from spending2 table

DELETE FROM spending2
WHERE row_num > 1;

SELECT *
FROM spending2;


-- dropping row_num column since it isn't needed anymore

ALTER TABLE spending2
DROP COLUMN `row_num`;

SELECT *
FROM spending2;

-- Populating blank rows in the table

SELECT  *
FROM spending2
WHERE fund = 'General Fund';

UPDATE spending2
SET fund = 'General Fund'
WHERE fund = 'N/A';

SELECT  *
FROM spending2
WHERE program LIKE '';

UPDATE spending2
SET program = 'N/A'
WHERE program = 'General Fund';

-- Now that every row is populated we can begin the exploration

-------------------------------------------------------------------------------------

-- First I want to see the TOTAL SPENT by Chattanooga overall from 2014 - 2016

SELECT ROUND(SUM(amount)) AS Total_Spent_Overall
FROM spending2;

-- Chattanooga spent $1,507,140,900 from 2014 - 2016 

-- Let's also find the average Chattanooga has spent from 2014 - 2016

SELECT ROUND(AVG(amount)) AS AVG_Spent_Overall
FROM spending2;

-- Chattanooga has spent $2,568 on average

-- Let's also do average per year

SELECT DISTINCT fiscal_year, ROUND(AVG(amount)) AS avg_spent
FROM spending2
GROUP BY fiscal_year;

-- The average amount spent in 2014 was $2,245
-- The average amount spent in 2015 was $2,651
-- The average amount spent in 2016 was $2,892

-- Lets add a rolling total to see the total average spent from 2014 - 2016

WITH Rolling_Total AS
(
SELECT DISTINCT fiscal_year, ROUND(AVG(amount)) AS avg_spent
FROM spending2
GROUP BY fiscal_year
)
SELECT fiscal_year, avg_spent, SUM(avg_spent) OVER(ORDER BY fiscal_year) AS rolling_total
FROM Rolling_Total;

-- The total average spent by Chattanooga from 2014 - 2016 was $7,788

-------------------------------------------------------------------------------------


-- Let's see what date had the most spent

SELECT DISTINCT invoice_date, ROUND(SUM(amount)) AS total_spent
FROM spending2
GROUP BY invoice_date
ORDER BY total_spent DESC;

-- December 2nd, 2014 was the highest amount spent between 2014 - 2016 with $29,365,090 in ONE DAY



-------------------------------------------------------------------------------------


-- I now want to see which month had the most amount spent

SELECT MONTH(`invoice_date`) AS `Month`, ROUND(SUM(amount)) AS total_spent
FROM spending2
GROUP BY `Month`
ORDER BY total_spent DESC; 

-- December is the month with the most spent with $175,829,129 


-- Also lets see the month with the most average spent

SELECT MONTH(invoice_date) AS `Month`, ROUND(AVG(amount)) AS avg_spent
FROM spending2
GROUP BY `Month`
ORDER BY avg_spent DESC;

-- December is also the month with the most average spent with $3,451
-- November and January are behind with $3,059 and $2,784 



-------------------------------------------------------------------------------------

-- I want to see how many funds, services, departments, and programs there are

SELECT COUNT(DISTINCT fund)
FROM spending2;		-- There are 214 UNIQUE funds that Chattanooga used

SELECT COUNT(DISTINCT service)
FROM spending2;		-- There are 6 UNIQUE services the funds were used for

SELECT DISTINCT service 
FROM spending2;

-- While i'm here I want to see which service had the most amount spent

SELECT DISTINCT service, ROUND(SUM(amount)) AS total_spent
FROM spending2
GROUP BY service
ORDER BY total_spent DESC;

-- General Government service had the most spent at $653,178,323
-- Public Works was 2nd with $430,170,619 spent
-- Public Safety was 3rd with $263,314,173 spent
-- Youth & Family Development was 4th with $68,415,333 spent
-- Economic & Community Development was 5th with $54,198,203 spent
-- Transportation was last with $37,864,249 spent

-- So far General Government services is the most important 

-- I also want to see the avg spent on all services

SELECT DISTINCT service, ROUND(AVG(amount)) AS avg_spent
FROM spending2
GROUP BY service
ORDER BY avg_spent DESC;

-- Transportation had the most average spent with $4,577 which means General Government is more often a spend than Transportation is
-- General Government's average spent is $3,834 at 2
-- Public Safety's average spent is $3,214 at 3
-- Economic & Community Development is at 4 with $3,048 average spent
-- Public Works is at 5 with $2,367 average spent
-- Youth & Family Development is in last with $539 average spent


SELECT COUNT(DISTINCT department) AS Departments
FROM spending2;

-- There are 14 UNIQUE departments

SELECT DISTINCT department 
FROM spending2;

-- Let's see which departments fall under a specific service

SELECT DISTINCT department, service
FROM spending2
WHERE service = "General Government"
GROUP BY department, service; -- There are 5 departments that fall under General Government

SELECT DISTINCT department, service
FROM spending2
WHERE service = "Youth & Family Development"
GROUP BY department, service; -- There are 4 departments that fall under Youth & Family Development

SELECT DISTINCT department, service
FROM spending2
GROUP BY department, service;

SELECT DISTINCT department, service
FROM spending2
WHERE service = "Public Safety"
GROUP BY department, service; -- There are 2 departments that fall under Public Safety

SELECT DISTINCT department, service
FROM spending2
WHERE service = "Public Works"
GROUP BY department, service; -- Only 1 department falls under Public Works

SELECT DISTINCT department, service
FROM spending2
WHERE service = "Transportation"
GROUP BY department, service; -- Only 1 department falls under Transportation


SELECT DISTINCT department, service
FROM spending2
WHERE service = "Economic & Community Development"
GROUP BY department, service; -- Only 1 department falls under Economic & Community Development

-- With General Government having 5 departments and Transportation only having 1 this shows-
-- if Transportation had more departments it could POSSIBLY be the service with the most money spent


SELECT COUNT(DISTINCT program)
FROM spending2; 

-- There are a total of 1,054 programs

-- Also checking how many vendors there are in the vendor_name column

SELECT COUNT(DISTINCT vendor_name)
FROM spending2;

-- There are 5,082 unique vendors in the vendor_name column

-------------------------------------------------------------------------------------


-- Now we are going to check to see which fiscal year had the most money spent 

SELECT *
FROM spending2;

SELECT DISTINCT fiscal_year, ROUND(SUM(amount)) as amount_per_year
FROM spending2
GROUP BY fiscal_year;

-- 2015 had the most spent with $564,692,366
-- 2014 was 2nd with $482,572,498
-- 2016 was 3rd with $459,876,037

-------------------------------------------------------------------------------------

-- Next I want to see which fiscal year periods were the top 5 in spending

SELECT *
FROM spending2;

SELECT DISTINCT fiscal_year_period, ROUND(SUM(amount)) as amount
FROM spending2
GROUP BY fiscal_year_period
ORDER BY amount DESC
LIMIT 5;

-- Looking at this the 6th period of the 3 years in total had the most money spent with $182,004,339
-- 2. is the 4th period with $171,025,178 total spent
-- 3. is the 5th period with $143,901,597 total spent
-- 4. is the 9th period with $137,043,480 total spent
-- 5th is the 3rd period with $134,450,085 total spent

-- The middle periods tend to have the most spent with 4, 5, and 6 all in the top 5

-- Lets see fiscal year period's average amount spent



SELECT fiscal_year_period, ROUND(AVG(amount)) as amount
FROM spending2
GROUP BY fiscal_year_period
ORDER BY amount DESC;

-- The top 5 total amount spent for each fiscal year period 
-- 6th fiscal period has the highest average amount spent at $3,264
-- 7th fiscal period has the 2nd highest average amount spent at $2,950
-- 5th fiscal period has the 3rd highest average amount spent at $2,915
-- 10th fiscal period has the 4th highest average amount spent at $2,830
-- 4th fiscal period has the least & 5th highest average amount spent at $2,800


-------------------------------------------------------------------------------------

-- Time to find out which 5 funds had the most amount spent

SELECT DISTINCT fund, ROUND(SUM(amount)) as total_spent
FROM spending2
GROUP BY fund
ORDER BY total_spent DESC
LIMIT 5; 

-- General Fund is number 1 with $602,853,910
-- Interceptor Sewer Operations is 2 with $183,019,224
-- Capital Improvement Bond Projects is 3 with $80,016,267
-- Debt Service is 4 with $68,746,329
-- Health Insurance Employees was 5 with $60,732,197

-------------------------------------------------------------------------------------

-- To piggy back off funds let's find out which fund had the most spent for a specific fiscal year    

SELECT *
FROM spending2;

-- Using a CTE to rank the funds total spent per year

SELECT fiscal_year, fund, ROUND(SUM(amount)) as total_spent
FROM spending2
GROUP BY fiscal_year, fund
ORDER BY 3 DESC;

WITH Fund_Year_Spent AS
(SELECT fiscal_year, fund, ROUND(SUM(amount)) as total_spent
FROM spending2
GROUP BY fiscal_year, fund
), Fund_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY fiscal_year ORDER BY total_spent DESC) AS Ranking
FROM Fund_Year_Spent
)
SELECT *
FROM Fund_Year_Rank
WHERE Ranking <=5;

-- 2014 
-- General Fund was 1st with $207,273,156 spent
-- Interceptor Sewer Operations was 2nd with $51,629,135 spent
-- Health Insurance Employees was 3rd with $29,398,064 spent
-- Debt Service was 4th with $21,778,700 spent
-- Capital Improvement Bond Projects was 5th with $16,830,659 spent

-- 2015 
-- General Fund	was 1st with $234,375,114 spent
-- Interceptor Sewer Operations was 2nd with $67,898,733 spent
-- Capital Improvement Bond Projects was 3rd with $28,857,010 spent
-- Debt Service	was 4th with $24,786,174 spent
-- Water Quality Mgmt Operations was 5th with $18,760,021

-- 2016
-- General Fund was 1st with $161,205,640 spent
-- Interceptor Sewer Operations was 2nd $63,491,356 spent
-- Capital Improvement Bond Projects was 3rd with $34,328,597 spent
-- Interceptor Sewer Consent Decree was 4th with $25,314,589 spent
-- Debt Service was 5th with $22,181,454 spent



-------------------------------------------------------------------------------------

-- Let's see the top 5 departments that have the most amount spent on average

SELECT *
FROM spending2;

SELECT DISTINCT department, ROUND(AVG(amount)) AS avg_spent
FROM spending2
GROUP BY department
ORDER BY avg_spent DESC
LIMIT 5;

-- Human Resources has the MOST average spent with $9,330 
-- General Gov't & Agencies has the 2nd most average spent with $6,770
-- Transportation has the 3rd most average spent with $4,577
-- Police have the 4th most average spent with $3,741
-- Economic & Community Development has the 5th and least average spent with $3,048

-- Let's see the top 5 TOTAL SPENT department

SELECT DISTINCT department, ROUND(SUM(amount)) AS total_spent
FROM spending2
GROUP BY department
ORDER BY total_spent DESC
LIMIT 5;

-- General Gov't & Agencies has the MOST total spent with $439,750,367
-- Public Works is 2nd most with $430,170,619 spent
-- Police is 3rd most with $158,133,119 spent
-- Human Resources is the 4th most with $108,591,427 spent
-- Fire is the 5th and least with $105,181,053 spent



-------------------------------------------------------------------------------------

-- Let's see which department has the most spent for each month


WITH dep_spent_month AS 
(
SELECT department, MONTH(invoice_date) AS `month` , ROUND(SUM(amount)) AS total_amount
FROM spending2
GROUP BY department, MONTH(invoice_date)
ORDER BY total_amount
), dep_spent_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY `month` ORDER BY total_amount) AS Ranking
FROM dep_spent_month
)
SELECT *
FROM dep_spent_rank
WHERE Ranking <=1
ORDER BY `month`;

-- Education, Arts & Culture is the most spent overall in November AND December with $121,871 and $2,986

SELECT 
    *
FROM
    walmartsalesdata;

-- Setting Time of Day in a new column

SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    walmartsalesdata;

ALTER TABLE walmartsalesdata ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmartsalesdata 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);

-- Adding a day of the week column 

SELECT 
    date, DAYNAME(date)
FROM
    walmartsalesdata;

ALTER TABLE walmartsalesdata ADD COLUMN day_of_week VARCHAR(10);

UPDATE walmartsalesdata 
SET 
    day_of_week = DAYNAME(date);

-- Adding a Month column

ALTER TABLE walmartsalesdata ADD COLUMN `Month` VARCHAR(10);

UPDATE walmartsalesdata 
SET 
    `Month` = MONTHNAME(date);

SELECT 
    *
FROM
    walmartsalesdata;



-- Finding how many unique cities walmart has and Which Branch they fall under

SELECT DISTINCT
    (City)
FROM
    walmartsalesdata;-- 3 Unique cities including Mandalay, Naypyitaw, and Yangon

SELECT DISTINCT
    (City), Branch
FROM
    walmartsalesdata;-- Branch A is in Yangon, Branch B is in Mandalay, and Branch C is in Naypyitaw
    
    


-- Finding How Many Product Lines there are

SELECT DISTINCT
    (`Product line`)
FROM
    walmartsalesdata;-- The data has 6 unique Product Lines

SELECT DISTINCT
    `Product line`, AVG(Rating) AS avg_rating
FROM
    walmartsalesdata
GROUP BY `Product line`
ORDER BY avg_rating DESC;-- The Average Rating Per Product Line from Females is 7.2 in Food & Beverages
						SELECT 
    *
FROM
    walmartsalesdata;



-- Finding the Average Unit Price per Product Line

SELECT DISTINCT
    `Product line`, AVG(`Unit Price`)
FROM
    walmartsalesdata
GROUP BY `Product line`;		
							-- Fashion accessories had the highest average price for their products at $57 





SELECT DISTINCT
    `Product line`, SUM(Total)
FROM
    walmartsalesdata
GROUP BY `Product line`
ORDER BY SUM(Total);		-- Most selling Product Line is Food and beverages





SELECT 
    *
FROM
    walmartsalesdata;



-- Total Amount spent by each customer type

SELECT DISTINCT
    (`Customer type`), SUM(Total)
FROM
    walmartsalesdata
GROUP BY `Customer type`;-- Members spent more money than Normal Customers




SELECT 
    COUNT(Payment)
FROM
    walmartsalesdata;

SELECT 
    Payment, COUNT(Payment)
FROM
    walmartsalesdata
GROUP BY Payment
ORDER BY Payment DESC;-- Ewallet is the most common payment method as it was used 345 times
					SELECT DISTINCT
    (`Month`), SUM(Total)
FROM
    walmartsalesdata
GROUP BY `Month`;

SELECT 
    `Month`, SUM(Total) AS Total_Revenue
FROM
    walmartsalesdata
GROUP BY `Month`
ORDER BY Total_Revenue DESC;
							-- January's total revenue was $116,291
							SELECT 
    *
FROM
    walmartsalesdata;






-- Finding the month with the largest COGS

SELECT DISTINCT
    (`Month`), SUM(cogs)
FROM
    walmartsalesdata
GROUP BY `Month`
ORDER BY SUM(cogs);-- January had the largest COGS with $110,754





SELECT 
    *
FROM
    walmartsalesdata;

SELECT DISTINCT
    (`Product line`), COUNT(Quantity)
FROM
    walmartsalesdata
GROUP BY `Product line`;	-- Fashion accessories was the most selling product line
							SELECT DISTINCT
    (`Product line`)
FROM
    walmartsalesdata;




                 
SELECT 
    Quantity, COUNT(*)
FROM
    walmartsalesdata
GROUP BY Quantity;

SELECT DISTINCT
    (`Product line`), gender
FROM
    walmartsalesdata
GROUP BY `Product line`;




-- Finding the city with the largest revenue

SELECT 
    branch, City, SUM(total)
FROM
    walmartsalesdata
GROUP BY City , branch
ORDER BY SUM(Total);	
					 -- Naypyitaw had the largest revenue with $110,568 in total
                     
                     
                     
SELECT 
    *
FROM
    walmartsalesdata;

SELECT 
    `Product line`, AVG(`Tax 5%`)
FROM
    walmartsalesdata
GROUP BY `Product line`
ORDER BY AVG(`Tax 5%`) DESC;-- Home and lifestyle has the largest VAT with 16%


                     
SELECT 
    AVG(Quantity)
FROM
    walmartsalesdata;-- average product sold was 5.51
    
    

SELECT DISTINCT
    (Branch), AVG(Quantity)
FROM
    walmartsalesdata
GROUP BY Branch;-- Branch C sold more products than the average product sold
				SELECT 
    gender, `Product line`, COUNT(gender)
FROM
    walmartsalesdata
GROUP BY gender , `Product line`
ORDER BY COUNT(gender) DESC;						-- Fashion Accessories is most popular 
								SELECT DISTINCT
    `Product line`, gender, ROUND(AVG(Rating), 2) AS avg_rating
FROM
    walmartsalesdata
GROUP BY `Product line`, gender
ORDER BY avg_rating DESC;-- The Average Rating Per Product Line from Females is Food and Beverages with an 
															-- Average Rating of 7.2
						SELECT 
    ROUND(AVG(Rating), 2) AS avg_rating, `Product line`
FROM
    walmartsalesdata
GROUP BY `Product line`
ORDER BY avg_rating DESC;


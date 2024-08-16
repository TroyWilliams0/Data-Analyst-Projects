SELECT *
FROM honda_sell_data;

-- Fixing errors in the data specifically any data that has "â€“"
-- In original data this was meant to be a dash because we don't have that data

SELECT Exterior_Color
FROM honda_sell_data
WHERE Exterior_Color LIKE '%â€“%';

UPDATE honda_sell_data
SET Exterior_Color = "N/A"
WHERE Exterior_Color LIKE '%â€“%'; -- Changed any value that was â€“ in Exterior Colors to "N/A"

-- Updating other columns with â€“

SELECT *
FROM honda_sell_data;

SELECT Interior_Color
FROM honda_sell_data
WHERE Interior_Color LIKE '%â€“%';

UPDATE honda_sell_data
SET Interior_Color = "N/A"
WHERE Interior_Color LIKE '%â€“%';

SELECT Interior_Color
FROM honda_sell_data
WHERE Interior_Color = "N/A"; -- Updated Interior Column to say N/A where we don't have an interior color


SELECT Transmission
FROM honda_sell_data
WHERE Transmission LIKE '%â€“%';

UPDATE honda_sell_data
SET Transmission = "N/A"
WHERE Transmission = 'â€“';

SELECT Transmission
FROM honda_sell_data
WHERE Transmission LIKE "N/A";

-- Fixing the MPG column to have a dash instead of the â€“ value
-- Also filling blank rows

SELECT *
FROM honda_sell_data;

SELECT `Year`, Model, `Condition`, MPG
FROM honda_sell_data
WHERE MPG = '';

SELECT * 
FROM honda_sell_data
WHERE model = "Ridgeline RTL" AND MPG = "18-24";

UPDATE honda_sell_data
SET MPG = "18-24"
WHERE model = "Ridgeline RTL" AND MPG = '';

SELECT * 
FROM honda_sell_data
WHERE model = "Ridgeline RTL" AND MPG = "18-24"; -- Changing the ridgeline mpg



SELECT `Year`, Model, `Condition`, MPG
FROM honda_sell_data
WHERE MPG = '';

-- Updating Drivetrain where "Front-wheel Drive" will be fixed to say "FWD"
-- "Four-wheel Drive" to say  "4WD" 
-- And "All-wheel Drive" will be "AWD"

SELECT Drivetrain 
FROM honda_sell_data;

SELECT *
FROM honda_sell_data
WHERE Drivetrain = "Front-wheel Drive";

UPDATE honda_sell_data
SET Drivetrain = "FWD"
WHERE Drivetrain = "Front-wheel Drive"; -- Drivetrain that was "Front-wheel Drive" is now "FWD"

SELECT *
FROM honda_sell_data
WHERE Drivetrain = "Four-wheel Drive";

UPDATE honda_sell_data
SET Drivetrain = "4WD"
WHERE Drivetrain = "Four-wheel Drive"; -- "Drivetrain that was "Four-wheel Drive" is now "4WD"

SELECT *
FROM honda_sell_data
WHERE Drivetrain = "Rear-wheel Drive";


UPDATE honda_sell_data
SET Drivetrain = "RWD"
WHERE Drivetrain = "Rear-wheel Drive";


SELECT *
FROM honda_sell_data
WHERE Drivetrain = "All-wheel Drive";

UPDATE honda_sell_data
SET Drivetrain = "AWD"
WHERE Drivetrain = "All-wheel Drive"; -- "All-wheel Drive" is now "AWD"

-- Updating rest of cars MPG

SELECT `Year`, Model, `Condition`, MPG, Drivetrain
FROM honda_sell_data
WHERE Model = "CR-V Hybrid Sport" AND MPG = '';

SELECT *
FROM honda_sell_data
WHERE Model = "CR-V Hybrid Sport" AND MPG = ''
AND Drivetrain = "FWD";

UPDATE honda_sell_data
SET MPG = "43-36"
WHERE Model = "CR-V Hybrid Sport" AND MPG = ''
AND Drivetrain = "FWD";

SELECT *
FROM honda_sell_data
WHERE Model = "CR-V Hybrid Sport" AND MPG = ''
AND Drivetrain = "AWD";

UPDATE honda_sell_data
SET MPG = "40-34"
WHERE Model = "CR-V Hybrid Sport" AND MPG = ''
AND Drivetrain = "AWD";

SELECT *
FROM honda_sell_data
WHERE Model = "CR-V Hybrid Sport Touring" AND MPG = '';

UPDATE honda_sell_data
SET MPG = "40-34"
WHERE Model = "CR-V Hybrid Sport Touring";



SELECT *
FROM honda_sell_data
WHERE Model = "CR-V EX-L" AND `Year` = "2023";

UPDATE honda_sell_data
SET MPG = "27-32"
WHERE Model = "CR-V EX-L" AND `Year` = "2023" 
AND Drivetrain = "AWD";

UPDATE honda_sell_data
SET MPG = "28-34"
WHERE Model = "CR-V EX-L" AND `Year` = "2023" 
AND Drivetrain = "FWD";

SELECT *
FROM honda_sell_data
WHERE Model = "CR-V EX-L" AND `Year` = "2023";

UPDATE honda_sell_data
SET Drivetrain = "AWD"
WHERE Drivetrain = "â€“";

UPDATE honda_sell_data
SET MPG = "27-32"
WHERE Model = "CR-V EX-L" AND `Year` = "2023" 
AND Drivetrain = "AWD" AND MPG = '';


SELECT *
FROM honda_sell_data
WHERE MPG LIKE '%â€“%';

UPDATE honda_sell_data
SET MPG = "50-45"
WHERE MPG = '50â€“45'; -- Changed every MPG value with â€ to a normal "-"

SELECT *
FROM honda_sell_data
WHERE Mileage = 'â€“';

UPDATE honda_sell_data
SET Mileage = "N/A"
WHERE Mileage = 'â€“'; -- Fixing Mileage to say N/A instead of â€“

-- Creating NEW Table for visualizations later on

CREATE TABLE `honda_sell_data2` (
  `Year` int DEFAULT NULL,
  `Make` text,
  `Model` text,
  `Condition` text,
  `Price` text,
  `Consumer_Rating` double DEFAULT NULL,
  `Consumer_Review_#` int DEFAULT NULL,
  `Exterior_Color` text,
  `Interior_Color` text,
  `Drivetrain` text,
  `MPG` text,
  `Fuel_Type` text,
  `Transmission` text,
  `Engine` text,
  `VIN` text,
  `Stock_#` text,
  `Mileage` text,
  `Comfort_Rating` double DEFAULT NULL,
  `Interior_Design_Rating` double DEFAULT NULL,
  `Performance_Rating` double DEFAULT NULL,
  `Value_For_Money_Rating` double DEFAULT NULL,
  `Exterior_Styling_Rating` double DEFAULT NULL,
  `Reliability_Rating` double DEFAULT NULL,
  `State` text,
  `Seller_Type` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO honda_sell_data2
SELECT *
FROM honda_sell_data;

SELECT *
FROM honda_sell_data2;

-- Replacing the "$" and "," in the Price for later exploration


SELECT REPLACE(Price,'$','') AS Price
FROM honda_sell_data;

UPDATE honda_sell_data
SET Price = REPLACE(Price,'$','');

SELECT REPLACE(Price,',','') AS Price
FROM honda_sell_data;

UPDATE honda_sell_data
SET Price = REPLACE(Price,',','');

-- Cleaning up Transmission column

SELECT `Transmission`
FROM honda_sell_data2
WHERE `Transmission` = "9-SPEED A/T";

UPDATE honda_sell_data2 
SET `Transmission` = "9-Speed Automatic"
WHERE `Transmission` = "9-SPEED A/T";

SELECT `Transmission`
FROM honda_sell_data2
WHERE `Transmission` = "electronic continuously variable";

UPDATE honda_sell_data2
SET `Transmission` = "ECVT"
WHERE `Transmission` = "electronic continuously variable"; 

UPDATE honda_sell_data2
SET `Transmission` = "CVA"
WHERE `Transmission` = "continuously variable automatic";

UPDATE honda_sell_data2 
SET `Transmission` = "10-Speed Automatic"
WHERE `Transmission` = "10-speed Automatic";

UPDATE honda_sell_data2
SET `Transmission` = '%%-speed Automatic'
WHERE `Transmission` = '%%-Speed Automatic';

UPDATE honda_sell_data2 
SET `Transmission` = "4-Speed Automatic"
WHERE `Transmission` = "4-SPEED A/T";

UPDATE honda_sell_data2 
SET `Transmission` = "5-Speed Automatic"
WHERE `Transmission` = "5 Speed Automatic";

UPDATE honda_sell_data2 
SET `Transmission` = "6-Speed Manual"
WHERE `Transmission` = "6-SPEED M/T";

UPDATE honda_sell_data2 
SET `Transmission` = "9-Speed Automatic"
WHERE `Transmission` = "9 Speed";

UPDATE honda_sell_data2 
SET `Transmission` = "1-Speed CVT with Overdrive"
WHERE `Transmission` = "1-Speed CVT w/OD";


SELECT *
FROM honda_sell_data2
WHERE `Transmission` = "9-Speed";

UPDATE honda_sell_data2
SET `Transmission` = "9-Speed Automatic"
WHERE `Transmission` = "9-Speed";

UPDATE honda_sell_data2
SET `Transmission` = "5-Speed Manual"
WHERE `Transmission` = "5-SPEED M/T";

UPDATE honda_sell_data2
SET `Transmission` = "N/A"
WHERE `Transmission` = "NOT SPECIFIED";

UPDATE honda_sell_data2
SET `Transmission` = "Automatic"
WHERE `Transmission` = "AUTOMATIC";

UPDATE honda_sell_data2
SET `Transmission` = "CVT"
WHERE `Transmission` = "continuously variable";

UPDATE honda_sell_data2
SET `Transmission` = "CVT with Sport Mode"
WHERE `Transmission` = "continuously variable w/sport mode";

UPDATE honda_sell_data2
SET `Transmission` = "CVT"
WHERE `Transmission` = "Continuously Variable Transmission";

UPDATE honda_sell_data2
SET `Transmission` = "Manual CVT"
WHERE `Transmission` = "continuously variable (m cvt)";

UPDATE honda_sell_data2
SET `Transmission` = "CVT"
WHERE `Transmission` = "continuously variable (ll cvt)";

UPDATE honda_sell_data2
SET `Transmission` = "CVT"
WHERE `Transmission` = "continuously variable (cvt)";

UPDATE honda_sell_data2
SET `Transmission` = "6-Speed Automatic"
WHERE `Transmission` = "Automatic, 6-Spd";

UPDATE honda_sell_data2
SET `Transmission` = "5-Speed Automatic"
WHERE `Transmission` = "Automatic, 5-Spd";

SELECT *
FROM honda_sell_data2;

-- "Fixing MO-22" in the state column to "MO"

SELECT *
FROM honda_sell_data2
WHERE `State` = "MO-22";

UPDATE honda_sell_data2
SET `State` = "MO"
WHERE `State` = "MO-22";


-- I want a NEW car for $30,000 or less, Specifically a Civic or an Accord

SELECT *
FROM honda_sell_data;

SELECT *
FROM honda_sell_data
WHERE `Condition` = 'New' AND Model LIKE 'Civic%'
AND Price < '30000'
OR Model LIKE 'Accord%' AND `Condition` = 'New'
AND Price < '30000'
ORDER BY Price ASC; -- Showing all Civics and Accord's that are brand new and under $30,000



-- Average Rating for Civic Sports since they are the best price for a new car

SELECT DISTINCT Model, `Year`, `Condition`, ROUND(AVG(Consumer_Rating),2) AS "AVG Rating"
FROM honda_sell_data
WHERE `Condition` = 'New' AND Model = "Civic Sport"
AND `Year` = "2022"
GROUP BY Model; -- Average Rating for NEW 2022 Civic Sports is 4.63 out of 5



-- Checking Civic Sport model for price and state

SELECT `year`, model, `Condition`, price, state
FROM honda_sell_data
WHERE model = "Civic Sport"
AND state = "TN"; -- 2022 Used Civic Sport costs $29,785
                  -- 2022 Honda Certified Civic Sport costs $29,987




-- Finding the cheapest Used car

SELECT *
FROM honda_sell_data;

SELECT `Year`, Model, `Condition`, Price
FROM honda_sell_data
WHERE `Condition` = "Used"
ORDER BY Price ASC; -- Cheapest used car is a 2005 Honda Civic Hybrid that costs $1,995

-- Finding the cheapest used car in TN

SELECT *
FROM honda_sell_data
WHERE State = 'TN';

SELECT `Year`, Model, `Condition`, Price, State
FROM honda_sell_data
WHERE State = 'TN'
AND `Condition` = 'Used'
ORDER BY `Year`; -- Cheapest Used car in TN is a 2001 Honda Accord EX that costs $4,999
				 -- 2nd cheapest Used car is a 2006 Civic EX that costs $7,995
                 -- 3rd cheapest Used car is a 2009 Accord LX that costs $9,995

-- Finding Cheapest NEW car

SELECT *
FROM honda_sell_data
WHERE `Condition` = "New"
ORDER BY Price ASC; -- Cheapest NEW car is the Honda HRV that costs $23,800 

-- Finding the ratings for Not Priced Cars

SELECT ROUND(AVG(Consumer_Rating),2) AS "AVG Rating", `Condition`
FROM honda_sell_data
WHERE Price = "Not Priced"
GROUP BY `Condition`; -- AVG Consumer Rating for Not Priced Cars is 4.19

-- Deleting values that aren't States in the State column

SELECT DISTINCT State
FROM honda_sell_data;


DELETE
FROM honda_sell_data
WHERE State = ''; 

DELETE
FROM honda_sell_data
WHERE State = 'Route'; 

DELETE
FROM honda_sell_data
WHERE State = 'Glens';

DELETE
FROM honda_sell_data
WHERE State = 'MO-22';  


-- Deleting Not Priced from table to be able to find averages and sums
DELETE
FROM honda_sell_data
WHERE Price = 'Not Priced';



-- Finding out which State has the best average price

SELECT REPLACE(Price,'$','') AS Price
FROM honda_sell_data;

UPDATE honda_sell_data
SET Price = REPLACE(Price,'$','');

SELECT REPLACE(Price,',','') AS Price
FROM honda_sell_data;

UPDATE honda_sell_data
SET Price = REPLACE(Price,',','');

SELECT State, COUNT(DISTINCT Model) AS cars_per_state
FROM honda_sell_data
GROUP BY State
;



SELECT State, cars_per_state
FROM honda_sell_data;

SELECT DISTINCT State, COUNT(DISTINCT Model) AS cars_per_state, CEILING(AVG(Price)) AS "AVG Price"
FROM honda_sell_data
GROUP BY State
HAVING COUNT(DISTINCT Model) > 3
ORDER BY 3 ASC; -- Utah has the best average price 


-- Top 5 States that have the best consumer rating

SELECT *
FROM honda_sell_data;

SELECT DISTINCT State, ROUND(AVG(Consumer_Rating),2) AS avg_rating
FROM honda_sell_data
GROUP BY State
ORDER BY avg_rating DESC
LIMIT 6; 
							-- 1. Delaware has a rating of 4.91
							-- 2. New Mexico has a rating of 4.88
                            -- 3. Hawaii & Nebraska tie for both having a rating of 4.87
                            -- 4. Rhode Island has a rating of 4.85 
                            -- 5. New Hampshire has a rating of 4.79
                            
                            

-- Finding AVG Price for Automatic CVT Transmissions

SELECT Transmission, CEILING(AVG(Price)) AS Avg_Price
FROM honda_sell_data
WHERE Transmission = "Automatic CVT" 
ORDER BY Price; 					-- Average Price for Automatic CVT's is $29,416

-- AVG Price for Variable Transmissions 

SELECT *
FROM honda_sell_data;

SELECT Transmission, CEILING(AVG(Price)) AS AVG_Price
FROM honda_sell_data
WHERE Transmission = "Variable"; 	-- Average Price for a Variable Transmission is $31,961


-- Average Price by Exterior Color 

SELECT DISTINCT Exterior_Color, AVG(Price)
FROM honda_sell_data
GROUP BY Exterior_Color
ORDER BY avg(Price) DESC; -- Average Price for EVERY Color 

SELECT DISTINCT Exterior_Color, CEILING(AVG(Price)) AS AVG_Price_Color
FROM honda_sell_data
WHERE Exterior_Color LIKE '%white%'
GROUP BY Exterior_Color
ORDER BY AVG_Price_Color DESC; -- Shows average price of each Car with White color variation



-- Find the average price of Aegan Blue since that's the color I want my car to be

SELECT DISTINCT Exterior_Color, CEILING(AVG(Price))
FROM honda_sell_data
WHERE Exterior_color LIKE '%Aegean blue%'
GROUP BY Exterior_Color
ORDER BY avg(Price) DESC; -- Cars with Aegean Blue on Average cost $26,995
						  -- Cars with Aegean Blue Metallic on Average cost $26,268
						

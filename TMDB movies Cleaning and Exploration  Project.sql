-- Creating table to load csv file into

CREATE TABLE `movies` (
  `id` int DEFAULT NULL,
  `title` varchar(512) DEFAULT NULL,
  `vote_average` float DEFAULT NULL,
  `vote_count` int DEFAULT NULL,
  `status` varchar(256) DEFAULT NULL,
  `release_date` varchar(256) DEFAULT NULL,
  `revenue` varchar(256) DEFAULT NULL,
  `runtime` varchar(512) DEFAULT NULL,
  `adult` varchar(256) DEFAULT NULL,
  `backdrop_path` varchar(256) DEFAULT NULL,
  `budget` INT DEFAULT NULL,
  `homepage` text,
  `imdb_id` varchar(256) DEFAULT NULL,
  `original_language` text,
  `original_title` varchar(256) DEFAULT NULL,
  `overview` text,
  `popularity` varchar(512) DEFAULT NULL,
  `poster_path` varchar(256) DEFAULT NULL,
  `tagline` varchar(256) DEFAULT NULL,
  `genres` varchar(256) DEFAULT NULL,
  `production_companies` text,
  `production_countries` text,
  `spoken_languages` varchar(256) DEFAULT NULL,
  `keywords` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Loading csv file into table

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Data/movies/TMDB_movie_dataset_v11.csv" INTO TABLE movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Creating a 2nd table to start data cleaning

CREATE TABLE `movies2` (
  `id` int DEFAULT NULL,
  `title` varchar(512) DEFAULT NULL,
  `vote_average` float DEFAULT NULL,
  `vote_count` int DEFAULT NULL,
  `status` varchar(256) DEFAULT NULL,
  `release_date` varchar(256) DEFAULT NULL,
  `revenue` bigint DEFAULT NULL,
  `runtime` int DEFAULT NULL,
  `adult` varchar(256) DEFAULT NULL,
  `backdrop_path` varchar(256) DEFAULT NULL,
  `budget` int DEFAULT NULL,
  `homepage` text,
  `imdb_id` varchar(256) DEFAULT NULL,
  `original_language` text,
  `original_title` varchar(256) DEFAULT NULL,
  `overview` text,
  `popularity` varchar(512) DEFAULT NULL,
  `poster_path` varchar(256) DEFAULT NULL,
  `tagline` varchar(256) DEFAULT NULL,
  `genres` varchar(256) DEFAULT NULL,
  `production_companies` text,
  `production_countries` text,
  `spoken_languages` varchar(256) DEFAULT NULL,
  `keywords` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting the data into the new table

INSERT INTO movies2
SELECT *
FROM movies;

------------------------------------------------

-- Data Cleaning

-- First let's get rid of duplicates

SELECT *
FROM movies2;

WITH duplicates AS
(SELECT *, ROW_NUMBER() OVER(PARTITION BY id, title, vote_average, vote_count, status, 
release_date, revenue, runtime, adult, backdrop_path, budget, homepage, imdb_id, 
original_language, original_title, overview, popularity, poster_path, tagline, genres, 
production_companies, production_countries, spoken_languages, keywords) AS row_num
FROM movies2
ORDER BY vote_count DESC
)
SELECT *
FROM duplicates
WHERE row_num > 1;

-- There are 365 duplicates in the table

-- creating table to get row_num column

CREATE TABLE `movies3` (
  `id` int DEFAULT NULL,
  `title` varchar(512) DEFAULT NULL,
  `vote_average` float DEFAULT NULL,
  `vote_count` int DEFAULT NULL,
  `status` varchar(256) DEFAULT NULL,
  `release_date` varchar(256) DEFAULT NULL,
  `revenue` bigint DEFAULT NULL,
  `runtime` int DEFAULT NULL,
  `adult` varchar(256) DEFAULT NULL,
  `backdrop_path` varchar(256) DEFAULT NULL,
  `budget` int DEFAULT NULL,
  `homepage` text,
  `imdb_id` varchar(256) DEFAULT NULL,
  `original_language` text,
  `original_title` varchar(256) DEFAULT NULL,
  `overview` text,
  `popularity` varchar(512) DEFAULT NULL,
  `poster_path` varchar(256) DEFAULT NULL,
  `tagline` varchar(256) DEFAULT NULL,
  `genres` varchar(256) DEFAULT NULL,
  `production_companies` text,
  `production_countries` text,
  `spoken_languages` varchar(256) DEFAULT NULL,
  `keywords` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting CTE data into new table to delete duplicates 

INSERT INTO movies3
SELECT *, ROW_NUMBER() OVER(PARTITION BY id, title, vote_average, vote_count, status, 
release_date, revenue, runtime, adult, backdrop_path, budget, homepage, imdb_id, 
original_language, original_title, overview, popularity, poster_path, tagline, genres, 
production_companies, production_countries, spoken_languages, keywords) AS row_num
FROM movies2
ORDER BY vote_count DESC;

-- Deleting the duplicates

SELECT *
FROM movies3
WHERE row_num > 1;

-- Deleting all 365 duplicate rows


DELETE FROM movies3
WHERE row_num > 1;

-- Dropping row_num column from table

ALTER TABLE movies3
DROP COLUMN row_num;

SELECT *
FROM movies3;

------------------------------------------------

-- Dropping unused columns

ALTER TABLE movies3
DROP COLUMN backdrop_path;

ALTER TABLE movies3
DROP COLUMN homepage;

ALTER TABLE movies3
DROP COLUMN poster_path;

ALTER TABLE movies3
DROP COLUMN imdb_id;

------------------------------------------------

-- Deleting rows where vote_average is 0 and vote_count is 0 for more accurate numbers

SELECT *
FROM movies3
WHERE vote_count = 0
AND vote_average = 0;

DELETE FROM movies3
WHERE vote_count = 0
AND vote_average = 0;

-- Also deleting empty release date values for each status for more precise exploration

DELETE 
FROM movies3
WHERE release_date = ''
AND status = 'Canceled';

DELETE 
FROM movies3
WHERE release_date = ''
AND status = 'Planned';

DELETE 
FROM movies3
WHERE release_date = ''
AND status = 'In Production';

DELETE 
FROM movies3
WHERE release_date = ''
AND status = 'Post Production';

DELETE 
FROM movies3
WHERE release_date = ''
AND status = 'Rumored';

DELETE 
FROM movies3
WHERE release_date = ''
AND status = 'Released';


------------------------------------------------

-- Deleting rows with 0 vote_count

SELECT *
FROM movies3
WHERE vote_count = 0;

DELETE 
FROM movies3
WHERE vote_count = 0;


------------------------------------------------

-- Fixing all lowercase original language column to Proper case using CONCAT and SUBSTRING

SELECT DISTINCT original_language
FROM movies3;

-- Using a transaction to ensure I have done it correctly 

START TRANSACTION;
UPDATE movies3
SET original_language = CONCAT(UCASE(LEFT(original_language, 1)),
							SUBSTRING(original_language, 2));
SELECT DISTINCT original_language 
FROM movies3;

COMMIT;

SELECT DISTINCT original_language 
FROM movies3;


------------------------------------------------

-- Getting rid of the adult column as I don't see it's need

-- First let's get rid of the True rows in the column as those are adult films that we have no use for in this analysis

SELECT *
FROM movies3
WHERE adult = "True";

DELETE 
FROM movies3
WHERE adult = "True";

-- Dropping the column since we now know there is no adult films in the data

ALTER TABLE movies3
DROP COLUMN adult;

SELECT *
FROM movies3;

------------------------------------------------

-- Updating blank rows in production_companies to N/A

SELECT *
FROM movies3
WHERE production_companies = ''
ORDER BY revenue DESC;

UPDATE movies3
SET production_companies = 'N/A'
WHERE production_companies = '';

------------------------------------------------

-- Lets add a Month and a Year Column for further exploration later on

-- Lets also add a season column to the data for more precise analysis later on

SELECT MONTH(release_date)
FROM movies3;

ALTER TABLE movies3
ADD COLUMN `Month` INT;

UPDATE movies3
SET `Month` = MONTH(release_date);

-- Now let's do Year

SELECT *
FROM movies3;

SELECT YEAR(release_date)
FROM movies3;

ALTER TABLE movies3
ADD COLUMN `Year` INT;

UPDATE movies3
SET `Year` = YEAR(release_date);

-- Lastly, let's add a season column using a CASE statement and a Transaction to ensure I can be precise with what I change 

ALTER TABLE movies3
DROP COLUMN Season;

START TRANSACTION; 
ALTER TABLE movies3
ADD COLUMN Season TEXT AS
(CASE WHEN MONTH(release_date)
IN (12, 1, 2) THEN 'Winter'
			  WHEN MONTH(release_date)
IN (3, 4, 5) THEN 'Spring'
			  WHEN MONTH(release_date)
IN (6, 7, 8) THEN 'Summer'
			 WHEN MONTH(release_date)
IN(9, 10, 11) THEN 'Fall' END);

SELECT *
FROM movies3;

DELETE 
FROM movies3
WHERE id IS NULL;

COMMIT;

-- Next I want to delete any music documentaries to focus on movies

SELECT *
FROM movies3
WHERE genres LIKE 'Music';

DELETE FROM
movies3
WHERE genres LIKE 'Music';

-- Lets delete vote average rows that have 0 average vote

SELECT *
FROM movies3
WHERE vote_average = 0;

DELETE FROM movies3
WHERE vote_average = 0;

-- Deleting any irregular data from the table

DELETE
FROM movies3
WHERE budget = 0
AND revenue = 0
AND vote_count = 1;

SELECT *
FROM movies3
WHERE revenue = -12;

DELETE 
FROM movies3
WHERE revenue = -12;

DELETE
FROM movies3
WHERE vote_count < 100;

------------------------------------------------

-- Data Exploration

-- First I want to see the budget, revenue, month, year, and season for my favorite movie The Batman
-- and my second favorite movie The Dark Knight

SELECT *
FROM movies3;

SELECT title, budget, revenue, `Month`, `Year`, season
FROM movies3
WHERE title = 'The Batman';

-- The Batman was released in March 2022 in the Spring and had a budget of $185,000,000 and made $770,945,583 in revenue

SELECT title, budget, revenue, `Month`, `Year`, season
FROM movies3
WHERE title = 'The Dark Knight';

-- The Dark Knight was released in July 2008 in the Summer and had a budget of $185,000,000 making $1,004,558,444 in revenue

-- The Dark Knight made 130% more revenue than The Batman

------------------------------------------------

-- Lets start with the basic functions of the vote average, budget, and revenue

SELECT ROUND(AVG(vote_average), 2) AS avg_rating, MIN(vote_average) AS min_vote, MAX(vote_average) AS max_vote
FROM movies3;

-- The average rating of every movie combined is 6.51
-- Minimum vote average is 1.91
-- Maximum vote is 9

-- Lets find the minimum, maximum, and average budget out of all of these movies

SELECT MIN(budget), MAX(budget), ROUND(AVG(budget)) AS avg_budget
FROM movies3;


-- Minimum budget is 0
-- Maximum budget is $460,000,000
-- Average budget is $13,204,127

-- Lets do the same with revenue

SELECT MIN(revenue) AS min_rev, MAX(revenue) AS max_rev, ROUND(AVG(revenue)) AS avg_rev
FROM movies3;

-- Minimum revenue is 0
-- Maximum revenue is $2,923,706,026
-- Average revenue is $37,118,546

------------------------------------------------

-- Now lets get more specific on the average vote and count numbers

SELECT ROUND(AVG(vote_count))
FROM movies3;		-- Average vote count is 1046

SELECT *
FROM movies3
WHERE vote_count >= 1046
ORDER BY vote_average DESC
LIMIT 5;		
		
			-- Using the average vote count the top 5 best vote averages are 
			-- The Godfather with 8.70 out of 18,677 votes
			-- The Shawshank Redemption with 8.70 out of 24,649 votes
			-- The Godfather Part II with 8.6 out of 11,293 votes
			-- Schlinder's List with 8.57 out of 14,594 votes
			-- Dilwale Dulhania Le Jayenge with 8.55 out of 4,256 votes
                
------------------------------------------------

-- Lets see popularity rating based on runtime

-- Fixing popularity from varchar to a float for more accurate data

ALTER TABLE movies3
MODIFY popularity float;

SELECT DISTINCT runtime, COUNT(popularity) AS `Total Popularity`
FROM movies3
GROUP BY runtime
ORDER BY `Total Popularity` DESC
LIMIT 5;							
				    
				-- There are 18,131 total popularity ratings
				-- Doing this gives us the top 5 runtimes with the most popularity ratings
				-- With a runtime of 90 there are 686 popularity ratings
				-- With a runtime of 100 there are 574 popularity ratings
				-- With a runtime of 95 there are 562 popularity ratings
				-- With a runtime of 97 there are 506 popularity ratings
				-- With a runtime of 93 there are 500 popularity ratings
                                    
 
SELECT title, runtime, popularity
FROM movies3
ORDER BY popularity DESC
LIMIT 5; 			
		    
            
		-- Blue Beetle is the most popular with a rating of 2,994 and a runtime of 128
		-- Gran Turismo is 2nd with a 2,681 rating and a runtime of 135
		-- The Nun II is 3rd with a popularity rating of 1,693 with a runtime of 110
		-- Meg 2: The Trench is 4th with a popularity rating of 1,567 with a runtime of 116
		-- Retribution is last with a rating of 1,547 and a runtime of 91

SELECT *
FROM movies3;

------------------------------------------------

-- Finding highest revenue movies based on genre

SELECT *
FROM movies3
WHERE genres LIKE 'Action%'
ORDER BY revenue DESC;
				
                
				-- Avatar is 1 making $2,923,706,026 of revenue in the action genre
				-- Spider-Man: No Way Home is 2 making $1,921,847,111 of revenue in action
				-- Jurassic World is 3 $1,671,537,444 of revenue in action
				-- Furious 7 is 4 making $1,515,341,399 of revenue in action 
				-- Top Gun: Maverick is 5 making $1,488,732,821 of revenue in action


SELECT *
FROM movies3
WHERE genres LIKE 'Adventure%'
ORDER BY revenue DESC;
				
                		-- Avengers: Endgame has made the most revenue in the Adventure genre with $2,800,000,000 made
				-- Star Wars: The Force Awakens made the 2nd most revenue in the genre with $2,068,223,624 made
				-- Avengers: Infinity War made the 3rd most revenue in the genre with $2,052,415,039 made
				-- The Lion King made the 4th most revenue in the genre with $1,663,075,401 made
				-- Star Wars: The Last Jedi made the 5th most revenue in the genre with $1,332,698,830 made

SELECT *
FROM movies3
WHERE genres LIKE 'Fantasy%'
ORDER BY revenue DESC; 		
				
               		 	-- Harry Potter and the Deathly Hallows: Part 2 made the most revenue in the Fantasy genre making $1,341,511,219
				-- The Hobbit: The Desolation of Smaug made the 2nd most revenue in the genre making $958,400,000
				-- Doctor Strange in the Multiverse of Madness made the 3rd most in the genre making $955,775,804
				-- Spider-Man 3 made the 4th most in the genre making $894,983,373
				-- Spider-Man made the 5th most in the genre making $821,708,551
                                
                                
SELECT *
FROM movies3
WHERE genres LIKE 'Drama%'
ORDER BY revenue DESC;
				
                		-- Titanic made the most revenue in the Drama genre making $2,264,162,353
				-- The Dark Knight made the 2nd most in the genre making $1,004,558,444
				-- Oppenheimer made the 3rd most in the genre making $933,700,000
				-- Hi, Mom made the 4th most in the genre making $822,049,668
				-- The Martian made the 5th most in the genre making $630,600,000

SELECT *
FROM movies3
WHERE genres LIKE 'Comedy%'
ORDER BY revenue DESC;			
				
                		-- Barbie made the most revenue in the comedy genre making $1,428,545,028
				-- Shrek Forever After made the 2nd most revenue making $752,600,867
				-- Forrest Gump made the 3rd most in the genre making $677,387,716
				-- Mamma Mia! made the 4th most in the genre making $609,841,637
				-- The Hangover Part II made the 5th most in the genre making $586,764,305
                                
                                
SELECT *
FROM movies3
WHERE genres LIKE 'Romance%'
ORDER BY revenue DESC;
				
                		-- Cinderella made the most revenue in the romance genre making $543,514,353
				-- Beauty and the Beast made the 2nd most in the genre making $424,967,620
				-- There's Something About Mary made the 3rd most in the genre making $369,884,651
				-- Notting Hill made the 4th most in the genre making $363,889,678
				-- Your Name. made the 5th most in the genre making $357,986,087


SELECT *
FROM movies3
WHERE genres LIKE 'Animation%'
ORDER BY revenue DESC;
				
                		-- The Super Mario Bros. Movie made the most in the animation genre making $1,355,725,263
				-- Frozen made the 2nd most in the genre making $1,274,219,009
				-- Toy Story 3 made the 3rd most in the genre making $1,066,969,703
				-- Zootopia made the 4th most in the genre making $1,023,784,195
				-- Despicable Me 2 made the 5th most in the genre making $970,761,885
                                

SELECT *
FROM movies3
WHERE genres LIKE 'Family%'
ORDER BY revenue DESC;
				
                		-- Frozen II made the most revenue in the family genre making $1,450,026,933
				-- Beauty and the Beast made the 2nd most in the genre making $1,266,115,964
				-- Minions made the 3rd most in the genre making $1,156,730,962
				-- Toy Story 4 made the 4th most in the genre making $1,073,394,593
				-- Alice in Wonderland made the 5th most in the genre making $1,025,467,110
                                

SELECT *
FROM movies3
WHERE genres LIKE 'Science Fiction%'
ORDER BY revenue DESC;

				-- Avatar: The Way of Water made the most revenue in the science fiction genre making $2,320,250,281
				-- The Avengers made the 2nd most revenue in the genre making $1,518,815,515
				-- Transformers: Age of Extinction made the 3rd most revenue in the genre making $1,104,054,072
				-- Guardians of the Galaxy Vol. 2 made the 4th most revenue in the genre making $863,756,051
				-- Venom made the 5th most revenue in the genre making $856,085,151


------------------------------------------------

-- Lets see how many movies are in each Month and Year

SELECT DISTINCT `Month`, COUNT(*) AS `Total Movies`
FROM movies3
GROUP BY `Month`
ORDER BY `Month` ASC;
			
            		-- January had 1,187 movies released
			-- February had 1,295 movies released
			-- March had 1,534 movies released
			-- April had 1,324 movies released
			-- May had 1,260 movies released
			-- June had 1,345 movies released
			-- July had 1,303 movies released
			-- August had 1,557 movies released
			-- September had 2,041 movies released
			-- October had 1,988 movies released
			-- November had 1,505 movies released
			-- December had 1,792 movies released

-- September through December is the usual sweet spot for when movies get released based on this data

-- Lets see which month made the most revenue

-- Let's do a rolling total to get the sum of the revenue

WITH ROLLING_TOTAL AS 
(SELECT DISTINCT `Month`, SUM(revenue) AS `Total Revenue`
FROM movies3
GROUP BY `Month`
ORDER BY `Total Revenue` DESC
)
SELECT `Month`, SUM(`Total Revenue`) OVER(ORDER BY `Month`)
FROM ROLLING_TOTAL;

-- Total Revenue is $672,996,360,131


SELECT DISTINCT `Month`, SUM(revenue) AS `Total Revenue`
FROM movies3
GROUP BY `Month`
ORDER BY `Total Revenue` DESC;	

						-- December had the most revenue making $92,029,756,912
						-- June was right behind with $88,287,537,900
						-- July was behind that with $73,885,068,450
						-- May had $72,286,509,724 of total revenue
						-- November was 5th with $64,408,224,822 of total revenue made
							
-- December accounts for 13.7% of the total revenue
-- June accounts for 13.1% of the total revenue
-- July accounts for 11% of the total revenue
-- May accounts for 10.7% of the total revenue
-- November accounts for 9.5% of the total revenue
-- Leaving the rest of the months accounting for the other 42%
							


------------------------------------------------

-- Since there are so many years lets get the top 5 years based on movies released

SELECT COUNT(`title`) AS `Total Movies`
FROM movies3;	-- 18,131 total movies

SELECT *
FROM movies3;



SELECT DISTINCT(`Year`), COUNT(`title`) AS `Total Movies`
FROM movies3
GROUP BY `Year`
ORDER BY `Total Movies` DESC
LIMIT 5;

	-- The top 5 Years for movies released in this data are
	-- 2018 with 835 movies released
	-- 2017 with 820 movies released
	-- 2019 with 771 movies released
	-- 2016 with 756 movies released
	-- 2014 with 714 movies released
    
-- While we are looking at top 5 years lets find the top 5 years that made the most revenue

SELECT DISTINCT(`Year`), SUM(`revenue`) AS `Total Revenue`
FROM movies3
GROUP BY `Year`
ORDER BY `Total Revenue` DESC		-- 672,996,360,131
LIMIT 5;			    

					-- 2017 had the most revenue made with $31,417,632,932  
				    	-- 2016 was 2nd with $31,276,758,929 in total revenue 
					-- 2018 was 3rd with $30,570,669,979 in total revenue
					-- 2019 was 4th with $30,323,376,769 in total revenue 
					-- 2015 was 5th with $29,571,459,995 in total revenue 


-- 2017 accounts for 4.7% of all total revenue
-- 2016 accounts for 4.6% of all total revenue
-- 2018 accounts for 4.5% of all total revenue
-- 2019 accounts for 4.5% of all total revenue
-- 2015 accounts for 4.4% of all total revenue



------------------------------------------------



-- Lets see which season gets the most movies

SELECT DISTINCT(`Season`), COUNT(*) AS `Total Movies`
FROM movies3
GROUP BY `Season`
ORDER BY `Total Movies` DESC;
				
                		-- Movies are more likely released in the Fall and Winter based on this data
				-- Fall had 5,534 movies released
				-- Winter had 4,274 movies released
				-- Spring had 4,205 movies released
				-- Summer had 4,118 movies released

-- To piggy back lets look at the total movie revenue for each season to validate which season is most ideal to release a movie

SELECT DISTINCT(Season), SUM(revenue) AS `Total Revenue`
FROM movies3
GROUP BY Season
ORDER BY `Total Revenue` DESC;	

							-- Based on revenue the movies released in the Summer are by far the money makers
							-- For Summer the total revenue was $200,879,165,248 made
							-- For Spring the total revenue was $167,014,503,027 made
							-- For Fall the total revenue was $153,530,155,185 made
							-- For Winter the total revenue was $151,572,536,671 made
							-- Total revenue overall is $672,996,360,131
                                
-- The Summer is usually the most profiting time to release a movie since the revenue is much higher than the other seasons
-- Summer revenue accounts for 29.8% of the total revenue between the 4 seasons
-- Spring revenue accounts for 24.8% of the total revenue
-- Fall revenue accounts for 22.8% of the total revenue
-- Winter revenue accounts for 22.6% of the total revenue
							    
-- Summer is 5% more than the next best revenue which is Spring 
-- And it's 7% more than Fall and Winter


------------------------------------------------

-- Lets find out which movie made the most revenue

SELECT title, release_date, budget, revenue, `Month`, `Year`, Season 
FROM movies3
ORDER BY revenue DESC;		-- Avatar has made the most revenue as it made $2,923,706,026



-- Lets find out the top 10 movies that made the most revenue between 1960 and 2000

SELECT title, revenue, `Year`
FROM movies3
WHERE `Year` BETWEEN '1960' AND '2000'
ORDER BY revenue DESC
LIMIT 10;							

						-- Titanic is number 1 making $2,264,162,353 in 1997
						-- Star Wars: Episode I - The Phantom Menace is 2 making $924,317,558 in 1999
						-- Jurassic Park is at 3 making $920,100,000 in 1993
						-- Independence Day is number 4 making $817,400,891 in 1996
						-- E.T. the Extra-Terrestrial is number 5 making $792,965,500 in 1982
						-- Star Wars is number 6 making $775,398,007 in 1977
						-- The Lion King is number 7 making $763,455,561 in 1994
						-- Forrest Gump is number 8 making $677,387,716 in 1994
						-- The Sixth Sense is number 9 making $672,806,292 in 1999
						-- The Lost World: Jurassic Park is last making $618,638,999 in 1997



-- Lets find out the top 5 movies that made the most revenue between 2000 and 2010

SELECT *
FROM movies3;

SELECT title, revenue, `Year`
FROM movies3
WHERE `Year` BETWEEN '2000' AND '2010'
ORDER BY revenue DESC			
LIMIT 5;		

								-- total top 5 revenue from 1960 and 2000 is $5,718,946,302		
								-- Avatar is number 1 in revenue making $2,923,706,026 in 2009
								-- The Lord of the Rings: The Return of the King is number 2 making $1,118,888,979 in 2003
								-- Toy Story 3 is number 3 (ironic) making $1,066,969,703 in 2010
								-- Pirates of the Caribbean: Dead Man's Chest is number 4 making $1,065,659,812 in 2006
								-- Alice in Wonderland is number 5 also making $1,025,467,110 in 2010
								-- Total revenue between top 5 movies between 2000 and 2010 is $7,200,691,630

-- Just from this we can tell that revenue is getting higher as the years go by 

-- The revenue of the top 5 total revenue made between 2000 and 2010 is 126% MORE than the top 5 total revenue made between 1960 and 2000

-- Lets find out the top 5 movies that made the most revenue between 2010 and 2024

SELECT *
FROM movies3;

SELECT title, revenue, `Year`
FROM movies3
WHERE `Year` BETWEEN '2010' AND '2024'
ORDER BY revenue DESC				
LIMIT 5;				

								-- Avengers: Endgame is number 1 making $2,800,000,000 in 2019
								-- Avatar: The Way of Water is number 2 making $2,320,250,281 in 2022
								-- Star Wars: The Force Awakens is 3 making $2,068,223,624 in 2015
								-- Avengers: Infinity War is number 4 making $2,052,415,039 in 2018
								-- Spider-Man: No Way Home is last making $1,921,847,111 in 2021
								-- Total revenue between the top 5 is $11,162,736,055

-- Total revenue made between 2010 and 2014 within the top 5 movies is 155% MORE than the revenue made within the top 5 movies between 2000 and 2014 


------------------------------------------------

-- Lastly, lets find out the highest rated movie from the most popular production companies


SELECT DISTINCT production_companies, vote_average
FROM movies3
ORDER BY vote_average DESC;

SELECT title, production_companies, vote_average
FROM movies3
WHERE production_companies LIKE 'Legendary Pictures%';
										
					-- The 2 highest rated Legendary Pictures films are Interstellar with a 8.42 rating 
					-- and Inception with an 8.36 rating 

SELECT title, production_companies, vote_average
FROM movies3
WHERE production_companies LIKE 'Paramount%';

	
					-- The 2 highest rated Paramount films are The Godfather with a rating of 8.71 
					-- and The Godfather Part II with a rating of 8.6
                    
                                        
SELECT DISTINCT production_companies, vote_average
FROM movies3
ORDER BY vote_average DESC;

SELECT title, production_companies, vote_average, genres
FROM movies3
WHERE production_companies LIKE 'Universal Pictures%'
ORDER BY vote_average DESC;
									
					-- The 2 highest rated Universal Pictures films are Back to the Future with an 8.314 rating
					-- and Gladiator with an 8.21 rating
                    
                                        
SELECT DISTINCT production_companies, vote_average
FROM movies3
ORDER BY vote_average DESC;

SELECT title, production_companies, vote_average
FROM movies3
WHERE production_companies LIKE 'Warner Bros. Pictures%'
ORDER BY vote_average DESC;

					-- The 2 highest rated Warner Bros. Pictures films are Clouds with a rating of 8.30
					-- and The Prestige with a rating of 8.203
                                        
SELECT title, production_companies, vote_average, genres
FROM movies3
WHERE production_companies LIKE 'Sony Pictures%' 
ORDER BY vote_average DESC;

					-- The 2 highest rated Sony Pictures films are Wish Dragon with a 8.00 rating
					-- and Inside Job with a 7.70 rating

SELECT title, production_companies, vote_average
FROM movies3
WHERE production_companies LIKE 'Lucasfilm%'
ORDER BY vote_average DESC;

					-- The 2 highest rated Lucasfilm films are The Empire Strikes Back with a rating of 8.4
					-- and Star Wars with a rating of 8.2

SELECT title, production_companies, vote_average
FROM movies3
WHERE production_companies LIKE 'New Line Cinema%'
ORDER BY vote_average DESC;


					-- The 2 highest rated New Line Cinema films are The Lord of the Rings: The Return of the King with a rating of 8.5
					-- and The Lord of the Rings: The Fellowship of the Ring with a rating of 8.4

SELECT title, production_companies, vote_average
FROM movies3
WHERE production_companies LIKE 'DC Comics%'
ORDER BY vote_average DESC;


					-- The 2 highest rated DC Comics films are The Dark Knight with a rating of 8.5
					-- and Batman: The Dark Knight Returns, Part 2 with a rating of 7.9
                                        
---------------------------------------------------

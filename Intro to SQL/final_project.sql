-- Final project for Intro to SQL IBM course
-- Tasked with querying real-world data from chicago socioeconomic statistics
-- Using MySQL

-- Problem 1
-- Find the total number of crimes recorded in the CRIME table.
SELECT COUNT(ID) FROM chicago_crime; 

--Problem 2
-- Retrieve first 10 rows from the CRIME table.
SELECT * FROM chicago_crime LIMIT 10; 

-- Problem 3
-- How many crimes involve an arrest?
SELECT COUNT(*) FROM chicago_crime WHERE ARREST = 'TRUE';

--Problem 4
-- Which unique types of crimes have been recorded at GAS STATION locations?
SELECT DISTINCT(PRIMARY_TYPE) FROM chicago_crime WHERE LOCATION_DESCRIPTION = 'GAS STATION';

--Problem 5
-- In the CENUS_DATA table list all Community Areas whose names start with the letter 'B'.
SELECT COMMUNITY_AREA_NAME FROM chicago_socioeconomic_data WHERE COMMUNITY_AREA_NAME LIKE 'B%'; 

--Problem 6
-- Which schools in Community Areas 10 to 15 are healthy school certified?
SELECT NAME_OF_SCHOOL, COMMUNITY_AREA_NUMBER, HEALTHY_SCHOOL_CERTIFIED FROM chicago_public_schools WHERE HEALTHY_SCHOOL_CERTIFIED = 'YES' AND COMMUNITY_AREA_NUMBER BETWEEN 10 AND 15; 

-- Problem 7
-- What is the average school Safety Score?
SELECT AVG(SAFETY_SCORE) FROM chicago_public_schools; 

-- Problem 8
-- List the top 5 Community Areas by average College Enrollment [number of students]
SELECT COMMUNITY_AREA_NAME, AVG(COLLEGE_ENROLLMENT) AS AVG_ENROLLMENT FROM chicago_public_schools GROUP BY COMMUNITY_AREA_NAME ORDER BY AVG_ENROLLMENT DESC LIMIT 5;

--Problem 9
-- Use a sub-query to determine which Community Area has the least value for school Safety Score?
SELECT COMMUNITY_AREA_NAME, SAFETY_SCORE FROM chicago_public_schools WHERE SAFETY_SCORE = (SELECT MIN(SAFETY_SCORE) FROM chicago_public_schools);

--Problem 10
-- [Without using an explicit JOIN operator] Find the Per Capita Income of the Community Area which has a school Safety Score of 1.
SELECT CSD.COMMUNITY_AREA_NAME, CSD.PER_CAPITA_INCOME, CPS.SAFETY_SCORE FROM chicago_socioeconomic_data CSD, chicago_public_schools CPS WHERE CPS.COMMUNITY_AREA_NAME = CSD.COMMUNITY_AREA_NAME AND CPS.SAFETY_SCORE = 1;

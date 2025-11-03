-- Practicing Aggregate, string, scalar, date, and time functions in MySQL

-- create the tables
drop table if exists PETRESCUE;

create table PETRESCUE (
	ID INTEGER NOT NULL,
	ANIMAL VARCHAR(20),
	QUANTITY INTEGER,
	COST DECIMAL(6,2),
	RESCUEDATE DATE,
	PRIMARY KEY (ID)
	);

insert into PETRESCUE values 
	(1,'Cat',9,450.09,'2018-05-29'),
	(2,'Dog',3,666.66,'2018-06-01'),
	(3,'Dog',1,100.00,'2018-06-04'),
	(4,'Parrot',2,50.00,'2018-06-04'),
	(5,'Dog',1,75.75,'2018-06-10'),
	(6,'Hamster',6,60.60,'2018-06-11'),
	(7,'Cat',1,44.44,'2018-06-11'),
	(8,'Goldfish',24,48.48,'2018-06-14'),
	(9,'Dog',2,222.22,'2018-06-15')
	
;

-- AGGREGATE FUNCTIONS
--  Enter a function that calculates the total cost of all animal rescues in the PETRESCUE table.
select SUM(COST) from PETRESCUE;

-- Enter a function that displays the total cost of all animal rescues in the PETRESCUE table in a column called SUM_OF_COST.
select SUM(COST) AS SUM_OF_COST from PETRESCUE;

-- Enter a function that displays the maximum quantity of animals rescued.
select MAX(QUANTITY) from PETRESCUE;

-- Enter a function that displays the average cost of animals rescued.
select AVG(COST) from PETRESCUE;

--  Enter a function that displays the average cost of rescuing a dog.
-- Bear in mind the cost of rescuing one dog one day, is different from another day. 
-- So you will have to use an average of averages.
select AVG(COST/QUANTITY) from PETRESCUE where ANIMAL = 'Dog';

-- SCALAR AND STRING FUNCTIONS
-- Enter a function that displays the rounded cost of each rescue.
select ROUND(COST) from PETRESCUE;

-- Enter a function that displays the length of each animal name.
select LENGTH(ANIMAL) from PETRESCUE;

-- Enter a function that displays the animal name in each rescue in uppercase.
select UCASE(ANIMAL) from PETRESCUE;

-- Enter a function that displays the animal name in each rescue in uppercase without duplications.
select DISTINCT(UCASE(ANIMAL)) from PETRESCUE;

-- Enter a query that displays all the columns from the PETRESCUE table, 
-- where the animal(s) rescued are cats. Use cat in lower case in the query.
select * from PETRESCUE where LCASE(ANIMAL) = 'cat';

-- DATE AND TIME FUNCTIONS
-- Enter a function that displays the day of the month when cats have been rescued.
select DAY(RESCUEDATE) from PETRESCUE where ANIMAL = 'Cat';

-- Enter a function that displays the number of rescues on the 5th month.
select SUM(QUANTITY) from PETRESCUE where MONTH(RESCUEDATE)='05';

-- Enter a function that displays the number of rescues on the 14th day of the month.
select SUM(QUANTITY) from PETRESCUE where DAY(RESCUEDATE)='14';

-- Animals rescued should see the vet within three days of arrivals. 
-- Enter a function that displays the third day from each rescue.
select DATE_add(RESCUEDATE, INTERVAL 3 DAY) from PETRESCUE;

-- Enter a function that displays the length of time the animals have been rescued; 
-- the difference between today's date and the rescue date.
select DATEDIFF(CURRENT_TIMESTAMP,RESCUEDATE) from PETRESCUE;

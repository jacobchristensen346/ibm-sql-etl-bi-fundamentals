-- This sql script contains exercise problems from the
-- Hands-On Lab: Querying the Data Warehouse using 
-- PostgreSQL (Cubes, Rollups, Grouping Sets and Materialized Views)

-- Problem 1: Create a grouping set for the columns year, quartername, sum(billedamount).
SELECT year, quartername, sum(billedamount) as totalbilled
FROM "FactBilling"
JOIN "DimMonth" ON "FactBilling".monthid = "DimMonth".monthid
GROUP BY GROUPING SETS(year, quartername);

-- Problem 2: Create a rollup for the columns country, category, sum(billedamount).
SELECT country, category, sum(billedamount) as totalbilled
FROM "FactBilling"
JOIN "DimCustomer" ON "FactBilling".customerid = "DimCustomer".customerid
GROUP BY ROLLUP(country, category)
ORDER BY country, category;

-- Problem 3: Create a cube for the columns year,country, category, sum(billedamount).
SELECT year, country, category, sum(billedamount) as totalbilled
FROM "FactBilling"
JOIN "DimCustomer" ON "FactBilling".customerid = "DimCustomer".customerid
JOIN "DimMonth" ON "FactBilling".monthid = "DimMonth".monthid
GROUP BY CUBE(year, country, category);

-- Problem 4: Create an Materialized views named average_billamount with columns year, quarter, category, country, average_bill_amount.
CREATE MATERIALIZED VIEW average_billamount (year, quarter, category, country, average_bill_amount) AS
	(SELECT year, quarter, category, country, AVG(billedamount) AS average_bill_amount
	FROM "FactBilling"
	JOIN "DimCustomer" ON "FactBilling".customerid = "DimCustomer".customerid
	JOIN "DimMonth" ON "FactBilling".monthid = "DimMonth".monthid
	GROUP BY year, quarter, category, country
	);

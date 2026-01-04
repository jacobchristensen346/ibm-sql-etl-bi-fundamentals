-- Practice exercises from the Hands-on lab:
-- Populating a Data Warehouse using PostgreSQL

-- Problem 1: Using the PostgreSQL tool, find the count of rows in the table FactBilling
select count(*) from public."FactBilling";

-- Problem 2: Using the PostgreSQL tool, create a simple Materialized 
-- views named avg_customer_bill with fields customerid and averagebillamount.
CREATE MATERIALIZED VIEW  avg_customer_bill (customerid, averagebillamount) AS
(select customerid, avg(billedamount)
from public."FactBilling"
group by customerid
);

-- Problem 3: Refresh the newly created Materialized views
REFRESH MATERIALIZED VIEW avg_customer_bill;

-- Problem 4: Using the newly created Materialized views find 
-- the customers whose average billing is more than 11000.
select * from avg_customer_bill where averagebillamount > 11000;

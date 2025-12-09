-- Exercise.
-- This sql script creates the schema for a fashion retailer
-- as described in the Hands-on Lab: Working with Facts and Dimension Tables.

-- This dimension table will contain information
-- pertaining to each store.

BEGIN;

CREATE TABLE public."DimStore"
(
    storeid integer PRIMARY KEY,
    country "char" NOT NULL,
    city "char" NOT NULL
);

-- This dimension table will contain info
-- pertaining to the date with regard to total sales.
CREATE TABLE public."DimDate"
(
    dateid integer PRIMARY KEY,
    date "char" NOT NULL,
    day integer NOT NULL,
    weekday integer NOT NULL,
    weekdayname "char" NOT NULL,
    month integer NOT NULL,
    monthname "char" NOT NULL,
    year integer NOT NULL
);

-- This fact table will contain information
-- about sales, with references to the dimension tables.
-- Do not create foreign keys yet, first
-- we must allow the tables to resolve.
CREATE TABLE public."FactSales"
(
    saleid integer PRIMARY KEY,
    storeid integer NOT NULL,
    dateid integer NOT NULL,
    totalsales decimal NOT NULL
);

-- Now alter the fact table
-- to include references to the dimension tables.
ALTER TABLE public."FactSales"
    ADD FOREIGN KEY (storeid)
    REFERENCES public."DimStore" (storeid)
    NOT VALID;


ALTER TABLE public."FactSales"
    ADD FOREIGN KEY (dateid)
    REFERENCES public."DimDate" (dateid)
    NOT VALID;

END;

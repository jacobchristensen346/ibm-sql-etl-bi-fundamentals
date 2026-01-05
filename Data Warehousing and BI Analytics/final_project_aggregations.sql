-- These are my aggregation queries
-- for the tables I created for the
-- final project.

-- Create a grouping sets query using the columns stationid, trucktype, total waste collected. 
SELECT
    f.stationid,
    t.trucktype,
    SUM(f.wastecollected) AS totalwastecollected
FROM
    facttrips f
INNER JOIN
    dimtruck t ON f.truckid = t.truckid
GROUP BY GROUPING SETS (
    (f.stationid, t.trucktype),
    f.stationid,
    t.trucktype,
    ()
)
ORDER BY
    f.stationid,
    t.trucktype;

-- Create a rollup query using the columns year, city, stationid, and total waste collected. 
SELECT
    d.year,
    s.city,
    f.stationid,
    SUM(f.wastecollected) AS totalwastecollected 
FROM
    facttrips f
INNER JOIN
    dimdate d ON f.dateid = d.dateid
INNER JOIN
    dimstation s ON f.stationid = s.stationid
GROUP BY ROLLUP (d.year, s.city, f.stationid)
ORDER BY
    d.year DESC,
    s.city,
    f.stationid;

-- Create a cube query using the columns year, city, stationid, and average waste collected. 
SELECT
    d.year,
    s.city,
    f.stationid,
    AVG(f.wastecollected) AS avgwastecollected
FROM
    facttrips f
INNER JOIN
    dimdate d ON f.dateid = d.dateid
INNER JOIN
    dimstation s ON f.stationid = s.stationid
GROUP BY CUBE (d.year, s.city, f.stationid);

-- Create a materialized view named max_waste_stats using the columns city, stationid, trucktype, and max waste collected. 
CREATE MATERIALIZED VIEW max_waste_stats AS
SELECT
    s.city,
    f.stationid,
    t.trucktype,
    MAX(f.wastecollected) AS maxwastecollected
FROM
    facttrips f
JOIN
    dimstation s ON f.stationid = s.stationid
JOIN
    dimtruck t ON f.truckid = t.truckid
GROUP BY
    s.city,
    f.stationid,
    t.trucktype
WITH DATA;

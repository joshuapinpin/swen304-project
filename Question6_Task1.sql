/**
 * Question 6.1
 * Journalists from the Chicago Herald suggest that Chicago is the hotspot of bank
 * robberies in the Chicago district. Therefore, they ask the police whether they think that
 * Chicago is more profitable for bank robbers than other cities in the district.
 * 
 * To support the police, you are asked to write a query that finds the average share of all
 * robberies in Chicago, and also the average share of all robberies in the other city (i.e.,
 * not Chicago) with the largest average share. Note that the average share of a bank
 * robbery can be determined based on the number of participating robbers.
 */

 -- Cleanup before using
 DROP VIEW IF EXISTS AvgSharePerCity CASCADE;
 DROP VIEW IF EXISTS ChicagoAvg CASCADE;
 DROP VIEW IF EXISTS BestOtherCity CASCADE;

-- 1: Stepwise Approach
-- Get average share per city
CREATE VIEW AvgSharePerCity AS
SELECT City, AVG(Share) AS AvgShare
FROM Accomplices
GROUP BY City;

-- Get Chicago's average share
CREATE VIEW ChicagoAvg AS
SELECT City, AvgShare
FROM AvgSharePerCity
WHERE City = 'Chicago';

-- Get the city that's not Chicago with the largest average share
CREATE VIEW BestOtherCity AS
SELECT City, AvgShare
FROM AvgSharePerCity
WHERE City <> 'Chicago'
ORDER BY AvgShare DESC
LIMIT 1;

-- Produce result with City and AvgShare columns
SELECT City, ROUND(AvgShare, 2) AS AvgShare FROM ChicagoAvg
UNION ALL
SELECT City, ROUND(AvgShare, 2) AS AvgShare FROM BestOtherCity;


-- 2: Nested Query
SELECT City, ROUND(AVG(Share), 2) AS AvgShare
FROM Accomplices
WHERE City = 'Chicago'
GROUP BY City

UNION ALL

SELECT City, ROUND(AvgShare, 2) AS AvgShare
FROM (
    SELECT City, AVG(Share) AS AvgShare
    FROM Accomplices
    WHERE City <> 'Chicago'
    GROUP BY City
    ORDER BY AvgShare DESC
    LIMIT 1
) AS BestOther;
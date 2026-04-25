/**
 * Question 5.3
 * Retrieve BankName and City of all banks that were not robbed in the year, in which there
 * 	were robbery plans for that bank. 
 */

 -- Cleanup before using
 DROP VIEW IF EXISTS PlannedYears CASCADE;
 DROP VIEW IF EXISTS RobbedYears CASCADE;

-- 1: Stepwise Approach
-- Find all (BankName, City, Year) combinations where a plan existed
CREATE VIEW PlannedYears AS
SELECT BankName, City, EXTRACT(YEAR FROM PlannedDate) AS PlanYear
FROM Plans;

-- Find all (BankName, Ciry, Year) combinations where a robbery actually happened
CREATE VIEW RobbedYears AS
SELECT BankName, City, EXTRACT(YEAR FROM RobDate) AS RobYear
FROM Robberies;

-- Find banks where the plan year has no matching robbery year
SELECT DISTINCT p.BankName, p.City
FROM PlannedYears p
WHERE NOT EXISTS (
    SELECT 1 FROM RobbedYears r
    WHERE r.BankName = p.BankName
      AND r.City = p.City
      AND r.RobYear = p.PlanYear
);


-- 2: Nested Query
SELECT DISTINCT p.BankName, p.City
FROM Plans p
WHERE NOT EXISTS (
    SELECT 1
    FROM Robberies r
    WHERE r.BankName = p.BankName
      AND r.City = p.City
      AND EXTRACT(YEAR FROM r.RobDate) = EXTRACT(YEAR FROM p.PlannedDate)
);
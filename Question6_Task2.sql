/**
 * Question 6.2
 * The police department wants to know whether bank branches with lower security levels
 * are more attractive to robbers than those with higher security levels.
 * 
 * To support the police, you are asked to write a query to retrieve the Security level, the
 * total Number of robberies that occurred in bank branches of that security level, and the
 * average Amount of money that was stolen during these robberies. 
 */

-- Cleanup before using
DROP VIEW IF EXISTS RobberiesWithSecurity CASCADE;
DROP VIEW IF EXISTS SecurityStats CASCADE;

-- 1: Stepwise Approach
-- Goal: for each security level, find total num of robberies and average amount stolen

-- join robberes with banks to get the security level for each robbery
CREATE VIEW RobberiesWithSecurity AS
SELECT b.Security, r.BankName, r.City, r.RobDate, r.Amount
FROM Robberies r
JOIN Banks b ON r.BankName = b.BankName AND r.City = b.City;

-- Aggregate by security level
CREATE VIEW SecurityStats AS
SELECT 
    Security,
    COUNT(*) AS NoRobberies,
    ROUND(AVG(Amount),2 ) AS AvgAmount
FROM RobberiesWithSecurity
GROUP BY Security;

-- Final output, ordered by security level
SELECT Security, NoRobberies, AvgAmount
FROM SecurityStats
ORDER BY Security;


-- 2: Nested Query
SELECT 
    b.Security,
    COUNT(*) AS NoRobberies,
    ROUND(AVG(Amount),2 ) AS AvgAmount
FROM Robberies r
JOIN Banks b ON r.BankName = b.BankName AND r.City = b.City
GROUP BY b.Security
ORDER BY b.Security;
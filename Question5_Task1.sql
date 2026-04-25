/**
 * Question 5.1
 * Retrieve RobberId, Nickname and individual total “earnings” of those robbers who
 *  participated in the robbery with the highest amount. The answer should be sorted in
 *  increasing order of the total earnings. 
 */

 -- Cleanup before using
 DROP VIEW IF EXISTS MaxRobbery CASCADE;
 DROP VIEW IF EXISTS TopRobbery CASCADE;
 DROP VIEW IF EXISTS TopEarners CASCADE;

-- 1: Stepwise Approach
-- Find the highest robbery amount
CREATE VIEW MaxRobbery AS
SELECT MAX(Amount) AS MaxAmount
FROM Robberies;

-- Get bank name, city, and rob date of that robbery (or robberies if tied)
CREATE VIEW TopRobbery AS
SELECT r.BankName, r.City, r.RobDate
FROM Robberies r, MaxRobbery m
WHERE r.Amount = m.MaxAmount;

-- Find all accomplices who particupated in that robbery, and sume their shares
CREATE VIEW TopEarners AS
SELECT a.RobberId, SUM(a.Share) AS TotalEarnings
FROM Accomplices a, TopRobbery t
WHERE a.BankName = t.BankName
  AND a.City = t.City
  AND a.RobDate = t.RobDate
GROUP BY a.RobberId;

-- Join with Robbers to get the nicknames.
SELECT r.RobberId, r.Nickname, te.TotalEarnings
FROM Robbers r, TopEarners te
WHERE r.RobberId = te.RobberId
ORDER BY te.TotalEarnings ASC;


-- 2: Nested QUery
SELECT r.RobberId, r.Nickname, SUM(a.Share) AS TotalEarnings
FROM Robbers r
JOIN Accomplices a ON r.RobberId = a.RobberId
WHERE (a.BankName, a.City, a.RobDate) IN (
    SELECT BankName, City, RobDate
    FROM Robberies
    WHERE Amount = (SELECT MAX(Amount) FROM Robberies)
)
GROUP BY r.RobberId, r.Nickname
ORDER BY TotalEarnings ASC;
/**
 * Question 5.1
 * Retrieve RobberId, Nickname and individual total “earnings” of those robbers who
 *  participated in the robbery with the highest amount. The answer should be sorted in
 *  increasing order of the total earnings. 
 */

 -- Cleanup before using
 DROP VIEW IF EXISTS MaxRobbery CASCADE;
 DROP VIEW IF EXISTS QualifiedRobbers CASCADE;
 DROP VIEW IF EXISTS TotalEarnings CASCADE;

-- 1: Stepwise Approach
-- Find the highest robbery amount
CREATE VIEW MaxRobbery AS
  SELECT MAX(Amount) AS MaxAmount
  FROM Robberies;

-- Find robbers who participated in that robbery
CREATE VIEW QualifiedRobbers AS
  SELECT DISTINCT ac.RobberId
  FROM Accomplices ac
  JOIN Robberies rb ON ac.BankName = rb.BankName
    AND ac.City = rb.City
    AND ac.RobDate = rb.RobDate
  JOIN MaxRobbery mr ON rb.Amount = mr.MaxAmount;

-- Sum total earnings across ALL robberies for those robbers
CREATE VIEW TotalEarnings AS
  SELECT r.RobberId, r.Nickname, SUM(a.Share) AS TotalEarnings
  FROM Robbers r
  JOIN Accomplices a ON r.RobberId = a.RobberId
  WHERE r.RobberId IN (SELECT RobberId FROM QualifiedRobbers)
  GROUP BY r.RobberId, r.Nickname;

-- Final query
SELECT * FROM TotalEarnings
ORDER BY TotalEarnings ASC;


-- 2: Nested Query
SELECT r.RobberId, r.Nickname, SUM(a.Share) AS TotalEarnings
FROM Robbers r
JOIN Accomplices a ON r.RobberId = a.RobberId
WHERE r.RobberId IN (
  SELECT DISTINCT ac.RobberId
  FROM Accomplices ac
  JOIN Robberies rb ON ac.BankName = rb.BankName
    AND ac.City = rb.City
    AND ac.RobDate = rb.RobDate
  WHERE rb.Amount = (
      SELECT MAX(Amount)
      FROM Robberies
  )
)
GROUP BY r.RobberId, r.Nickname
ORDER BY TotalEarnings ASC;
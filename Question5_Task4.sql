/**
 * Question 5.4
 * Retrieve RobberId and Nickname of all robbers who never robbed the banks at which
 * 	they have an account.
 */

 -- Cleanup before using
 DROP VIEW IF EXISTS RobberAccounts CASCADE;
 DROP VIEW IF EXISTS RobberRobberies CASCADE;
 DROP VIEW IF EXISTS RobbedOwnBank CASCADE;

-- 1: Stepwise Approach
-- Find all (RobberId, BankName, City) combinations where robber has an account
CREATE VIEW RobberAccounts AS
SELECT RobberId, BankName, City
FROM HasAccounts;

-- Find all (RobberId, BankName, City) combinations where robber ACTUALLY robbed
CREATE VIEW RobberRobberies AS
SELECT RobberId, BankName, City
FROM Accomplices;

-- Find robbers who have an account at a bank they have ALSO robbed
CREATE VIEW RobbedOwnBank AS
SELECT DISTINCT ra.RobberId
FROM RobberAccounts ra, RobberRobberies rr
WHERE ra.RobberId = rr.RobberId
  AND ra.BankName = rr.BankName
  AND ra.City = rr.City;

-- Find all robbers with accoutns who are NOT in that above list
SELECT DISTINCT r.RobberId, r.Nickname
FROM Robbers r
WHERE r.RobberId IN (SELECT RobberId FROM RobberAccounts)
  AND r.RobberId NOT IN (SELECT RobberId FROM RobbedOwnBank);


-- 2: Nested Query
SELECT DISTINCT r.RobberId, r.Nickname
FROM Robbers r
WHERE r.RobberId IN (SELECT RobberId FROM HasAccounts)
  AND r.RobberId NOT IN (
      SELECT a.RobberId
      FROM Accomplices a
      JOIN HasAccounts ha ON a.RobberId = ha.RobberId
                         AND a.BankName = ha.BankName
                         AND a.City = ha.City
  );
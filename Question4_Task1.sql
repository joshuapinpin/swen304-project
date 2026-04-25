/**
 * Question 4.1
 * Retrieve BankName and City of all banks that have never been robbed. 
 */

SELECT b.BankName, b.City
FROM Banks b
WHERE NOT EXISTS (
    SELECT *
    FROM Robberies r
    WHERE r.BankName = b.BankName
      AND r.City = b.City
);
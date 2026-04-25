/**
 * Question 4.4
 * Retrieve BankName and city of all banks where Al Capone has an account. The answer
 * 	should list every bank at most once
 */

SELECT DISTINCT ha.BankName, ha.City
FROM HasAccounts ha
JOIN Robbers r ON r.RobberId = ha.RobberId
WHERE r.Nickname = 'Al Capone'
ORDER BY ha.BankName, ha.City;
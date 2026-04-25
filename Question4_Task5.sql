/**
 * Question 4.5
 * Retrieve RobberId, Nickname and individual total “earnings” of those robbers who have
 * 	earned at least $55,000 by robbing banks. The answer should be sorted in decreasing
 * 	order of the total earnings. 
 */


SELECT r.RobberId,
	r.Nickname,
    SUM(a.Share) AS TotalEarnings
FROM Robbers r
JOIN Accomplices a ON a.RobberId = r.RobberId
GROUP BY r.RobberId, r.Nickname
HAVING SUM(a.Share) >= 55000
ORDER BY TotalEarnings DESC;
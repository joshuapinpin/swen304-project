/**
 * Question 4.3
 * Retrieve RobberId, Nickname, Age, and all skill descriptions of all robbers who are not
 * 	younger than 40 years
 */

SELECT r.RobberId, r.Nickname, r.Age, s.Description
FROM Robbers r
JOIN HasSkills hs ON hs.RobberId = r.RobberId
JOIN Skills s ON s.SkillId = hs.SkillId
WHERE r.Age >= 40
ORDER BY r.RobberId, s.Description;
/**
 * Question 4.6
 * Retrieve the Description of all skills together with RobberId and NickName of all robbers
 * 	who possess this skill. The answer should be ordered by skill description. 
 */

SELECT s.Description,
       r.RobberId,
       r.Nickname
FROM Skills s
LEFT JOIN HasSkills hs ON hs.SkillId = s.SkillId
LEFT JOIN Robbers r ON r.RobberId = hs.RobberId
ORDER BY s.Description, r.RobberId;
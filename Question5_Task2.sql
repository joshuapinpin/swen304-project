/**
 * Question 5.2
 * Retrieve RobberId, Nickname, and Description of the first preferred skill of all robbers
 * 	who have two or more skills.
 */

 -- Cleanup before using
 DROP VIEW IF EXISTS MultiSkillRobbers CASCADE;
 DROP VIEW IF EXISTS FirstPreference CASCADE;

-- 1: Stepwise Approach
-- Find robbers with 2 or more skills
CREATE VIEW MultiSkillRobbers AS
SELECT RobberId
FROM HasSkills
GROUP BY RobberId
HAVING COUNT(SkillId) >= 2;

-- For each robber, find their top preference skill
CREATE VIEW FirstPreference AS
SELECT hs.RobberId, hs.SkillId
FROM HasSkills hs, MultiSkillRobbers msr
WHERE hs.RobberId = msr.RobberId
  AND hs.Preference = (
      SELECT MIN(hs2.Preference)
      FROM HasSkills hs2
      WHERE hs2.RobberId = hs.RobberId
  );

-- Join with Robbers and Skills to get Nickname and Description.
SELECT r.RobberId, r.Nickname, s.Description
FROM Robbers r, FirstPreference fp, Skills s
WHERE r.RobberId = fp.RobberId
  AND s.SkillId = fp.SkillId;


-- 2: Nested QUery
SELECT r.RobberId, r.Nickname, s.Description
FROM Robbers r
JOIN HasSkills hs ON r.RobberId = hs.RobberId
JOIN Skills s ON hs.SkillId = s.SkillId
WHERE r.RobberId IN (
    SELECT RobberId FROM HasSkills
    GROUP BY RobberId HAVING COUNT(SkillId) >= 2
)
AND hs.Preference = (
    SELECT MIN(hs2.Preference)
    FROM HasSkills hs2
    WHERE hs2.RobberId = r.RobberId
);
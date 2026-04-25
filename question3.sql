/**
 * Question 3
 * Checking the Database
*/

-- 1: Should have unique description
INSERT INTO Skills(SkillId, Description) VALUES (21, 'Driving');


-- 2a
INSERT INTO Banks(BankName, City, NoAccounts, Security) 
VALUES ('Loanshark Bank', 'Evanston', 100, 'very good');

-- 2b: NoAccounts = -5, violates CHECK (NoAccounts >= 0)
INSERT INTO Banks(BankName, City, NoAccounts, Security) 
VALUES ('EasyLoan Bank', 'Evanston', -5, 'excellent');

-- 2c: Security = 'poor', not in allowed set
INSERT INTO Banks(BankName, City, NoAccounts, Security) 
VALUES ('EasyLoan Bank', 'Evanston', 100, 'poor');


-- 3a: 'NXP Bank' in 'Chicago' does not exist in Banks
INSERT INTO Robberies(BankName, City, RobDate, Amount)
VALUES ('NXP Bank', 'Chicago', '2019-01-08', 1000);


-- 4a: Attempt to delete a skill that robbers depend on via HasSkills
DELETE FROM Skills WHERE SkillId = 9 AND Description = 'Driving';


-- 5a: Attempt to delete a bank that has robberies/plans/accounts referencing it
DELETE FROM Banks
WHERE BankName = 'PickPocket Bank' AND City = 'Evanston';


-- 6a: RobDate is empty string — invalid date, and likely no matching row
DELETE FROM Robberies
WHERE BankName = 'Loanshark Bank' AND City = 'Chicago' AND RobDate = '';


-- 7a: RobberId = 1 already exists (Al Capone) → duplicate primary key
INSERT INTO Robbers(RobberId, Nickname, Age, NoYears) VALUES (1, 'Shotgun', 70, 0);

-- 7b: NoYears (35) > Age (25) → violates CHECK constraint
INSERT INTO Robbers(RobberId, Nickname, Age, NoYears) VALUES (333, 'Jail Mouse', 25, 35);


-- 8a: (SkillId=7, RobberId=1) — check if this primary key already exists
INSERT INTO HasSkills(SkillId, RobberId, Preference, Grade) VALUES (7, 1, 1, 'A+');
-- Likely violates PRIMARY KEY if (7,1) already exists in HasSkills

-- 8b: Preference = 0 — check if this is allowed (depends on your constraint)
INSERT INTO HasSkills(SkillId, RobberId, Preference, Grade) VALUES (2, 1, 0, 'A');

-- 8c: RobberId = 333 does not exist in Robbers
INSERT INTO HasSkills(SkillId, RobberId, Preference, Grade) VALUES (1, 333, 1, 'B-');

-- 8d: SkillId = 20 does not exist in Skills
INSERT INTO HasSkills(SkillId, RobberId, Preference, Grade) VALUES (20, 3, 3, 'B+');


-- 9a: Al Capone (RobberId = 1) is referenced in Accomplices and/or HasSkills
DELETE FROM Robbers WHERE RobberId = 1 AND Nickname = 'Al Capone';
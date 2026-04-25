/*
Question 2
Populating the DB with Data
*/

-- 1. Banks
\copy Banks(BankName, City, NoAccounts, Security) FROM ~/Pro1/banks_26.data

-- 2. Robberies and Plans(depends on Banks)
\copy Robberies(BankName, City, RobDate, Amount) FROM ~/Pro1/robberies_26.data
\copy Plans(BankName, City, PlannedDate, NoRobbers) FROM ~/Pro1/plans_26.data

-- 3. Robbers
\copy Robbers(Nickname, Age, NoYears) FROM ~/Pro1/robbers_26.data

-- 4. Skills (needs special construction)
CREATE TEMP TABLE TempHasSkills (
	Nickname VARCHAR(100),
    Description TEXT,
    Preference INT,
    Grade VARCHAR(2)
);

\copy TempHasSkills FROM ~/Pro1/hasskills_26.data

-- extract unique skill descriptions into the Skills Table
INSERT INTO Skills(Description)
SELECT DISTINCT Description FROM TempHasSkills; 

-- 5. HasAccounts (depends on Robbers + Banks)
CREATE TEMP TABLE TempHasAccounts (
    Nickname VARCHAR(100),
    BankName VARCHAR(100),
    City VARCHAR(100)
);

\copy TempHasAccounts FROM ~/Pro1/hasaccounts_26.data

INSERT INTO HasAccounts(RobberId, BankName, City)
SELECT r.RobberId, t.BankName, t.City
FROM TempHasAccounts t
JOIN Robbers r ON r.Nickname = t.Nickname;

-- 6.  HasSkills (Depends on Robbers + Skills)
INSERT INTO HasSkills(SkillId, RobberId, Preference, Grade)
SELECT s.SkillId, r.RobberId, t.Preference, t.Grade
FROM TempHasSkills t
JOIN Robbers r ON r.Nickname = t.Nickname
JOIN Skills s ON s.Description = t.Description;

-- 7. Accomplices (depends on Robbers + Robberies)
CREATE TEMP TABLE TempAccomplices (
    Nickname VARCHAR(100),
    BankName TEXT,
    City TEXT,
    RobDate DATE,
    Share DECIMAL(15,2)
);

\copy TempAccomplices FROM ~/Pro1/accomplices_26.data

INSERT INTO Accomplices(RobberId, BankName, City, RobDate, Share)
SELECT r.RobberId, t.BankName, t.City, t.RobDate, t.Share
FROM TempAccomplices t
JOIN Robbers r ON r.Nickname = t.Nickname;

-- Clean up Temp Tables
DROP TABLE IF EXISTS TempHasSkills;
DROP TABLE IF EXISTS TempHasAccounts;
DROP TABLE IF EXISTS TempAccomplices;
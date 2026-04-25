
-- 1: ENTITIES

CREATE TABLE Banks (
	BankName VARCHAR(100) NOT NULL,
	City VARCHAR(100) NOT NULL,
	NoAccounts INT NOT NULL CHECK (NoAccounts >= 0),
	Security VARCHAR(20) NOT NULL CHECK(Security IN ('weak', 'good', 'very good', 'excellent')),
	CONSTRAINT pk_banks PRIMARY KEY(BankName, City)
);

CREATE TABLE Robbers(
	RobberId SERIAL PRIMARY KEY,
	Nickname VARCHAR(100) NOT NULL,
	Age INT NOT NULL CHECK (Age >= 0),
	NoYears INT NOT NULL CHECK (NoYears >= 0),
	CONSTRAINT chk_robbers_years CHECK (NoYears <= Age)
);

CREATE TABLE Skills(
	SkillId SERIAL PRIMARY KEY,
	Description TEXT UNIQUE NOT NULL
);

-- 2: RELATIONS

CREATE TABLE Robberies(
	BankName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    RobDate DATE NOT NULL,
    Amount DECIMAL(15,2) CHECK (Amount > 0),
    -- assumes no robbery with same date, bank name, and city.
    CONSTRAINT pk_robberies PRIMARY KEY (BankName, City, RobDate),
    CONSTRAINT fk_robberies 
    	FOREIGN KEY (BankName, City) REFERENCES Banks(BankName, City)
    	ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Plans(
	BankName VARCHAR(100) NOT NULL,
	City VARCHAR(100) NOT NULL,
	PlannedDate DATE NOT NULL,
	NoRobbers INT CHECK (NoRobbers >= 0),
	CONSTRAINT pk_plans PRIMARY KEY (BankName, City, PlannedDate),
	CONSTRAINT fk_plans 
		FOREIGN KEY (BankName, City) REFERENCES Banks(BankName, City)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Accomplices(
	RobberId INT NOT NULL,
	BankName TEXT NOT NULL,
	City TEXT NOT NULL,
	RobDate DATE NOT NULL,
	Share DECIMAL(15,2) NOT NULL,
	CONSTRAINT pk_accomplices PRIMARY KEY (RobberId, BankName, City, RobDate),
	CONSTRAINT fk_accomplices_robber
		FOREIGN KEY (RobberId) REFERENCES Robbers(RobberId)
		ON DELETE RESTRICT,
	CONSTRAINT fk_accomplices_robberies
		FOREIGN KEY (BankName, City, RobDate) REFERENCES Robberies(BankName, City, RobDate)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE HasAccounts(
	RobberId INT NOT NULL,
	BankName VARCHAR(100) NOT NULL,
	City VARCHAR(100) NOT NULL,
	CONSTRAINT pk_hasAccounts PRIMARY KEY (RobberId, BankName, City),
	CONSTRAINT fk_hasAccounts_robber
		FOREIGN KEY (RobberId) REFERENCES Robbers(RobberId)
		ON DELETE RESTRICT,
	CONSTRAINT fk_hasAccounts_bank
		FOREIGN KEY (BankName, City) REFERENCES Banks(BankName, City)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE HasSkills(
	SkillId INT NOT NULL,
	RobberId INT NOT NULL,
	Preference INT NOT NULL CHECK (Preference > 0),
	Grade VARCHAR(2) NOT NULL,
	CONSTRAINT pk_hasSkills PRIMARY KEY (SkillId, RobberId),
	CONSTRAINT fk_hasSkills_robber
		FOREIGN KEY (RobberId) REFERENCES Robbers(RobberId)
		ON DELETE RESTRICT,
	CONSTRAINT fk_hasSkills_skill
		FOREIGN KEY (SkillId) REFERENCES Skills(SkillId)
		ON DELETE RESTRICT
);

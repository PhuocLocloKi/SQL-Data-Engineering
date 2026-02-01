--One-To-Many-cascade.sql

--------------------------------------------------
--Create database for One-to-Many relationship practice
CREATE DATABASE YEC2_One-To-Many-cascade
USE YEC2_One-To-Many-cascade

--------------------------------------------------
--Create table to store city information
--This table represents the ONE side of a One-to-Many relationship

CREATE TABLE CITY(
      ID INT NOT NULL,
            Name NVARCHAR(40)
)

--------------------------------------------------
--Add primary key constraint
ALTER TABLE CITY
ADD CONSTRAINT PK_CITY_ID PRIMARY KEY (ID)

--------------------------------------------------
--Add unique constraint to prevent duplicate city names
ALTER TABLE CITY
ADD CONSTRAINT UQ_CITY_Name UNIQUE (Name)

--------------------------------------------------
--Insert city data
INSERT INTO City VALUES (1, N'TP.HCM')
INSERT INTO City VALUES (2, N'TP.Hà Nội')
INSERT INTO City VALUES (3, N'TP.Bình Dương')
INSERT INTO City VALUES (4, N'TP.Tây Ninh')
INSERT INTO City VALUES (5, N'TP.BẮC kẠN')
INSERT INTO City VALUES (6, N'TP.DAk lak')

--------------------------------------------------
--Create table to store exam candidates (students)
--This table represents the MANY side
--Each candidate belongs to one city

CREATE TABLE Candidate(
      ID CHAR(5) NOT NULL,
            LastName NVARCHAR(30) NOT NULL,
	      FirstName NVARCHAR(30) NOT NULL,
	      CityID INT
)

--------------------------------------------------
--Add primary key for Candidate
ALTER TABLE Candidate
ADD CONSTRAINT PK_Candidate_ID PRIMARY KEY (ID)

--------------------------------------------------
--Add foreign key constraint
--Candidate.CityID references CITY.ID
ALTER TABLE Candidate
ADD CONSTRAINT FK_Candidate_CityID_City_ID
FOREIGN KEY (CityID) REFERENCES CITY(ID)

--------------------------------------------------
--Insert candidate data
INSERT INTO Candidate VALUES ('C1', N'Nguyễn', N'An', 1)
INSERT INTO Candidate VALUES ('C2', N'Lê',     N'Bình', 1)
INSERT INTO Candidate VALUES ('C3', N'Võ',     N'Cường', 2)
INSERT INTO Candidate VALUES ('C4', N'Phạm',   N'Dũng', 3)
INSERT INTO Candidate VALUES ('C5', N'Trần',   N'Em', 4)

--------------------------------------------------
--1. List all candidates
SELECT * FROM Candidate

--------------------------------------------------
--2. List candidates with their city information
--LEFT JOIN keeps all candidates even if CityID is NULL
SELECT * 
FROM Candidate ca 
LEFT JOIN CITY ci ON ca.CityID = ci.ID

--------------------------------------------------
--2.1 List all cities with candidate information
--RIGHT JOIN keeps all cities, including those with no candidates

SELECT ci.*, ca.LastName, ca.FirstName
FROM Candidate ca 
RIGHT JOIN CITY ci ON ca.CityID = ci.ID

--------------------------------------------------
--3. List candidates from Ho Chi Minh City

SELECT *
FROM Candidate ca 
LEFT JOIN CITY ci ON ca.CityID = ci.ID
WHERE ci.Name = N'TP.HCM'

--------------------------------------------------
--4. Count total number of candidates
SELECT COUNT(ca.ID) AS totalCandidates 
FROM Candidate ca

--------------------------------------------------
--4.1 Count number of candidates per city

SELECT ci.ID, COUNT(ca.ID) AS totalCandidates
FROM Candidate ca 
RIGHT JOIN CITY ci ON ca.CityID = ci.ID
GROUP BY ci.ID

--------------------------------------------------
--4.2 Count how many candidates are from Ho Chi Minh City

SELECT ci.ID, COUNT(ca.ID) AS totalCandidates
FROM Candidate ca 
RIGHT JOIN CITY ci ON ca.CityID = ci.ID
GROUP BY ci.ID
HAVING ci.ID = (
      SELECT ID 
      FROM City 
      WHERE Name = N'TP.HCM'
)

--------------------------------------------------
--4.3 Find the city that has the maximum number of candidates

SELECT MAX(s1) AS maxCandidates
FROM (
      SELECT ci.ID, COUNT(ca.ID) AS s1
      FROM Candidate ca 
      RIGHT JOIN CITY ci ON ca.CityID = ci.ID
      GROUP BY ci.ID
) AS ld

--------------------------------------------------
--4.4 Find cities that have no candidates

SELECT ci.ID, COUNT(ca.ID) AS totalCandidates
FROM Candidate ca 
RIGHT JOIN CITY ci ON ca.CityID = ci.ID
GROUP BY ci.ID
HAVING COUNT(ca.ID) = 0

--------------------------------------------------
--Domino effect demonstration

SELECT * FROM City
SELECT * FROM Candidate

--Explanation:
--The CITY table is the parent (ONE side)
--The Candidate table is the child (MANY side)

--Question:
--What happens if we delete a parent record?
--What happens if we delete a child record?

--------------------------------------------------
--Try deleting Ho Chi Minh City
DELETE City WHERE ID = '1'

--This delete fails because:
--There are candidates referencing this city
--This is the default FOREIGN KEY behavior (RESTRICT)

--To delete Ho Chi Minh City, all related candidates must be deleted first

--------------------------------------------------
--Delete a city that has no candidates
DELETE City WHERE ID = '5'
--This delete succeeds because no child records exist

--------------------------------------------------
--Try updating a primary key value
UPDATE City SET ID = '61' WHERE ID = '3'

--This update fails due to foreign key constraint violation
--This demonstrates the domino effect during UPDATE

--------------------------------------------------
--Solution: handle UPDATE and DELETE explicitly
--Version 2: add cascading rules

--------------------------------------------------
--Create CITYV2 table
CREATE TABLE CITYV2(
      ID INT NOT NULL,
            Name NVARCHAR(40)
)

ALTER TABLE CITYV2
ADD CONSTRAINT PK_CITY_ID PRIMARY KEY (ID)

ALTER TABLE CITYV2
ADD CONSTRAINT UQ_CITY_Name UNIQUE (Name)

INSERT INTO CITYV2 VALUES (1, N'TP.HCM')
INSERT INTO CITYV2 VALUES (2, N'TP.Hà Nội')
INSERT INTO CITYV2 VALUES (3, N'TP.Bình Dương')
INSERT INTO CITYV2 VALUES (4, N'TP.Tây Ninh')
INSERT INTO CITYV2 VALUES (5, N'TP.BẮC kẠN')
INSERT INTO CITYV2 VALUES (6, N'TP.DAk lak')

--------------------------------------------------
--Create CandidateV2 table with cascading rules

CREATE TABLE CandidateV2(
      ID CHAR(5) NOT NULL,
	      LastName NVARCHAR(30) NOT NULL,
	      FirstName NVARCHAR(30) NOT NULL,
	      CityID INT
)

ALTER TABLE CandidateV2
ADD CONSTRAINT PK_Candidate_ID PRIMARY KEY (ID)

ALTER TABLE CandidateV2
ADD CONSTRAINT FK_Candidate_CityID_City_ID
FOREIGN KEY (CityID) REFERENCES CITY(ID)
ON DELETE SET NULL
ON UPDATE CASCADE

--------------------------------------------------
--Insert data
INSERT INTO CandidateV2 VALUES ('C1', N'Nguyễn', N'An', 1)
INSERT INTO CandidateV2 VALUES ('C2', N'Lê',     N'Bình', 1)
INSERT INTO CandidateV2 VALUES ('C3', N'Võ',     N'Cường', 2)
INSERT INTO CandidateV2 VALUES ('C4', N'Phạm',   N'Dũng', 3)
INSERT INTO CandidateV2 VALUES ('C5', N'Trần',   N'Em', 4)

SELECT * FROM CandidateV2
SELECT * FROM CITYV2

--------------------------------------------------
--Test cascading update
UPDATE CITYV2 SET ID = '61' WHERE ID = 3

--Result:
--CandidateV2.CityID is automatically updated
--This eliminates the domino effect

--------------------------------------------------
--Advanced notes:
--RESTRICT (default): safest, prevents data loss
--ON DELETE SET NULL: keeps child data but removes relationship
--ON DELETE CASCADE: deletes child data automatically (use with caution)
--Surrogate keys are preferred to avoid updating primary keys

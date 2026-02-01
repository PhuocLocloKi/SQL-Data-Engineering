--One-To-One-Relationship.sql
--ONE-TO-ONE RELATIONSHIP

--A one-to-one relationship means:
--Each row in table A can be associated with at most ONE row in table B
--and vice versa.

CREATE DATABASE YEC2_One-To-One-Relationship
USE YEC2_One-To-One-Relationship

--------------------------------------------------
--Citizen table
--Stores basic information about citizens
--Each citizen is uniquely identified by CID

CREATE TABLE Citizen(
       CID char(9) not null,
	       LastName nvarchar(15) not null,
	       FirstName nvarchar(15) not null
)

ALTER TABLE Citizen
       ADD CONSTRAINT PK_Citizen_CID PRIMARY KEY (CID)

INSERT INTO Citizen VALUES ('C1', N'VŨ', N'DUY')
INSERT INTO Citizen VALUES ('C2', N'Phước', N'Lộc')
INSERT INTO Citizen VALUES ('C3', N'Tây', N'DUY')
INSERT INTO Citizen VALUES ('C4', N'Nguyễn', N'Đạt')

--------------------------------------------------
--PASSPORT STORY (Business Rules)

--Business rules:
--1. One citizen can own ONLY ONE passport
--2. A passport must belong to EXACTLY ONE citizen
--3. A passport cannot exist without a citizen

--This is a classic ONE-TO-ONE relationship

--------------------------------------------------
--Passport table
--Stores passport information

CREATE TABLE Passport(
       PNO char(9) not null,          --Passport number
	       IssueDate DATE,               --Date of issue
	       ExpiredDate DATE,             --Expiration date
	       CMND char(9) not null          --Citizen ID (FK)
)

ALTER TABLE Passport
       ADD CONSTRAINT PK_Passport_PNO PRIMARY KEY (PNO)

ALTER TABLE Passport
       ADD CONSTRAINT FK_Passport_CMND_Citizen_CID
	       FOREIGN KEY (CMND) REFERENCES Citizen(CID)

--IMPORTANT:
--The UNIQUE constraint on CMND is the KEY POINT
--It enforces the ONE-TO-ONE relationship
--Without this UNIQUE constraint, the relationship would become ONE-TO-MANY

ALTER TABLE Passport
       ADD CONSTRAINT UQ_Passport_CMND UNIQUE (CMND)

--------------------------------------------------
--Sample data

INSERT INTO Passport VALUES ('P1', '2023-01-01', '2033-01-01', 'C1')
INSERT INTO Passport VALUES ('P2', '2023-01-01', '2033-01-01', 'C2')

--The following insert will FAIL for TWO reasons:
--1. Duplicate primary key PNO ('P1')
--2. Citizen 'C5' does NOT exist (foreign key violation)

INSERT INTO Passport VALUES ('P1', '2023-01-01', '2033-01-01', 'C5')

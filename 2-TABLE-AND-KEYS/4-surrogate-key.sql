--04-surrogate-key.sql

--How can we update data without causing data corruption or cascading failures?

--Surrogate key concepts:
--Artificial key
--Auto-increment key
--Substitute key
--Fake key (non-business key)

--A surrogate key is generated automatically by the system
--It guarantees uniqueness without relying on business meaning

--Two common generation mechanisms:
--1. Auto-increment numeric values (IDENTITY)
--   → generates numbers that never duplicate existing values in the table
--2. GUID / UUID (hexadecimal identifiers)
--   → generates globally unique values across the entire database (or system)

--------------------------------------------------

--Create a phone book table to store phone numbers

CREATE TABLE PhoneBook ( --SEQ: Sequence (incremental number)
        SEQ INT IDENTITY(2,5), --start = 2, increment = 5  
        Owner NVARCHAR(40),
		phoneNumber CHAR(11),
		CONSTRAINT PK_PhoneBook_SEQ PRIMARY KEY (SEQ)
)

-- Clarification:
-- IDENTITY(start, increment) is SQL Server–specific
-- The database automatically generates SEQ values

--------------------------------------------------

INSERT INTO PhoneBook VALUES (N'Girlfriends', '0905123')
INSERT INTO PhoneBook VALUES (N'Wife',       '0905645')
INSERT INTO PhoneBook VALUES (N'Sugar baby', '0905346')

SELECT * FROM PhoneBook

-- Advanced note:
-- When using IDENTITY, column values should NOT be manually inserted
-- unless IDENTITY_INSERT is explicitly enabled

--------------------------------------------------

--Mechanism 2: GUID-based surrogate key

CREATE TABLE PhoneBookV2 ( 
        --SEQ: Sequence
        --NEWID() generates a random hexadecimal identifier (GUID)
        SEQ UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
        Owner NVARCHAR(40),
		phoneNumber CHAR(11),
		CONSTRAINT PK_PhoneBookV2_SEQ PRIMARY KEY (SEQ)
)

-- Clarification (important correction):
-- UNIQUEIDENTIFIER does NOT "block duplicates"
-- It allows uniqueness via PRIMARY KEY / UNIQUE constraint
-- NEWID() statistically guarantees uniqueness

--------------------------------------------------

--With GUID keys, columns must be explicitly listed
INSERT INTO PhoneBookV2 (Owner, phoneNumber) 
VALUES (N'Girlfriends', '0905123')

INSERT INTO PhoneBookV2 (Owner, phoneNumber)
VALUES (N'Wife', '0905645')

INSERT INTO PhoneBookV2 (Owner, phoneNumber)
VALUES (N'Sugar baby', '0905346')

SELECT * FROM PhoneBookV2

--------------------------------------------------

--Natural key vs Surrogate key

--Natural key: a key derived from real-world business data
--Examples: CitizenID, StudentCode, Email

--Meaning of using surrogate keys:
--1. Used as a replacement when no stable natural key exists
--2. Used to replace complex composite keys
--3. Prevents the "domino effect" when business data changes

-- Clarification (important):
-- Surrogate keys do NOT replace business rules
-- Natural keys should still be enforced using UNIQUE constraints

--------------------------------------------------

--Create table Major to store academic majors

CREATE TABLE Major (
        SEQ INT IDENTITY(1,1) PRIMARY KEY,
	    ID CHAR(2) NOT NULL UNIQUE,
	    Name NVARCHAR(30)
)

INSERT INTO Major VALUES ('SB', N'Business Administration')
INSERT INTO Major VALUES ('SE', N'Software Engineering')
INSERT INTO Major VALUES ('GD', N'Graphic Design')

--------------------------------------------------

--Create Student management table

CREATE TABLE STUDENT (
        ID CHAR(8) NOT NULL PRIMARY KEY,
	    Name NVARCHAR(40) NOT NULL,
	    MID INT,
	    CONSTRAINT FK_Student_MID_Major_SEQ
	    FOREIGN KEY (MID) REFERENCES Major (SEQ)
)

INSERT INTO Student VALUES ('S1', N'An',    '1')
INSERT INTO Student VALUES ('S2', N'Binh',  '1')
INSERT INTO Student VALUES ('S3', N'Cường', '2')
INSERT INTO Student VALUES ('S4', N'Dũng',  '2')

SELECT * FROM Major
SELECT * FROM STUDENT

--------------------------------------------------

--Update a natural key value
UPDATE Major SET ID = 'SS' WHERE ID = 'SE'

-- Advanced note (critical concept):
-- Because STUDENT references Major.SEQ (surrogate key),
-- changing Major.ID does NOT affect foreign keys
-- This completely avoids cascading updates and data corruption

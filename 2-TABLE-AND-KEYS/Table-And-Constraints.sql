--Table-And-Constraints.sql
--Learning how to design a simple single table
--This lesson focuses on:
--  - Table structure
--  - Primary key
--  - Candidate keys
--  - Constraints
--  - Basic data validation

CREATE DATABASE YEC2_Table-And-Constraints
USE YEC2_Table-And-Constraints

-------------------------------------------------
--Create a table to store student information
--This version has NO constraints
--Used to demonstrate data quality problems

CREATE TABLE Student(
      ID char(8),
      Name nvarchar(30),
      DOB date,
      Sex char(1),
      Email nvarchar(50)
)

INSERT INTO Student VALUES
       ('SE123456', N'Nguyen A', '1989-01-01', 'F', 'nguyen@@')

-------------------------------------------------
--THEORY: Keys in a table
--
--A table should have at least one column that uniquely identifies a row
--Example student table:
--student(id, name, phone, email, household_id, citizen_id, driver_license)
--
--Possible unique columns:
--id, citizen_id, driver_license
--
--These columns are called CANDIDATE KEYS
--A candidate key is a column (or set of columns) that CAN uniquely identify a row
--
--Among candidate keys, we choose ONE as the PRIMARY KEY
--
--Rules for choosing a primary key:
--1. It must uniquely identify a row
--2. It must NOT be NULL
--3. It should be stable (rarely changes)
--4. It should be short and efficient
--
--Primary key is a CONSTRAINT
--It enforces:
--  - NOT NULL
--  - UNIQUE

-------------------------------------------------
--Create student table with PRIMARY KEY

CREATE TABLE Student1(
      ID char(8) PRIMARY KEY,
      Name nvarchar(30),
      DOB date,
      Sex char(1),
      Email nvarchar(50)
)

--This INSERT will FAIL because PRIMARY KEY cannot be NULL
INSERT INTO Student1 VALUES
       ('SE123456', NULL, NULL, NULL, NULL)

-------------------------------------------------
--Incorrect table definition (syntax issue in original)
--Corrected version is shown below for learning purpose

CREATE TABLE Student2(
      ID char(8) PRIMARY KEY,
      Name nvarchar(30) NOT NULL,
      DOB date,
      Sex char(1),
      Email nvarchar(50) NOT NULL
)

--This INSERT will FAIL because Name and Email are NOT NULL
INSERT INTO Student2 VALUES
       ('SE123456', NULL, NULL, NULL, NULL)

-------------------------------------------------
--Partial column insert technique
--Allows inserting only required columns

INSERT INTO Student2(ID, Name, Email)
VALUES ('SE123456', 'Nguyen A', 'nguyen@@')

-------------------------------------------------
--Normalize name into FirstName and LastName

CREATE TABLE Student3(
      ID char(8) PRIMARY KEY,
      FirstName nvarchar(30) NOT NULL,
      LastName nvarchar(30) NOT NULL,
      DOB date,
      Sex char(1),
      Email nvarchar(50)
)

-------------------------------------------------
--THEORY: Constraints
--
--A CONSTRAINT is a rule that forces valid data
--
--Common constraints:
--PRIMARY KEY   : unique + not null
--UNIQUE        : unique (NULL allowed unless NOT NULL)
--NOT NULL      : value must exist
--FOREIGN KEY   : reference integrity
--DEFAULT       : default value
--CHECK         : custom condition
--
--Naming constraints is a BEST PRACTICE
--It helps with:
--  - Debugging
--  - Dropping constraints
--  - Maintenance

-------------------------------------------------
--Advanced concepts (theory level)
--
--Composite key:
--Primary key made of multiple columns
--Example: (Block, Room)
--
--Super key:
--A key that uniquely identifies rows but contains unnecessary columns
--
--Weak entity:
--An entity that depends on another entity to exist
--Example:
--  Patient (strong entity)
--  MedicalRecord (weak entity)

-------------------------------------------------
--Final refined student table with named constraints

CREATE TABLE Student4(
      ID char(8),
      FirstName nvarchar(30) NOT NULL,
      LastName nvarchar(30) NOT NULL,
      DOB date,
      Sex char(1),
      Email nvarchar(50)
)

ALTER TABLE Student4
ADD CONSTRAINT PK_Student4_ID PRIMARY KEY(ID)

ALTER TABLE Student4
ADD CONSTRAINT UQ_Student4_Email UNIQUE (Email)

-------------------------------------------------
--Valid inserts

INSERT INTO Student4 (ID, FirstName, LastName, Email)
VALUES ('SE123456', 'Nguyen', 'B', 'nguyen@@')

INSERT INTO Student4 (ID, FirstName, LastName, Email)
VALUES ('SE123457', 'Nguyen', 'B', 'nguyen##')

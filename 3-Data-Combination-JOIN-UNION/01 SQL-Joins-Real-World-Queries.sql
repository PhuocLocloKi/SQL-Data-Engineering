--1-JOIN
--SQL JOIN OPERATIONS – PRACTICAL DATABASE DEMONSTRATION
--This script demonstrates:
--1. INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
--2. How NULL values appear in JOIN results
--3. JOIN combined with aggregation functions
--4. Real-world reporting queries using JOIN + GROUP BY

------------------------------------------------------------
--CREATE DEMO DATABASE
CREATE DATABASE YENOTO_C2_CH04_JOIN
USE YENOTO_C2_CH04_JOIN

------------------------------------------------------------
--MASTER TABLE
--This table represents the "parent" or reference dataset
CREATE TABLE Master(
	MMO INT,
	ViDesc nvarchar (10)
)

--Insert sample master records
INSERT INTO Master VALUES (1,N'MỘT')
INSERT INTO Master VALUES (2,N'HAI')
INSERT INTO Master VALUES (3,N'BA')
INSERT INTO Master VALUES (4,N'BỐN')
INSERT INTO Master VALUES (5,N'NĂM')
INSERT INTO Master VALUES (6,N'SÁU')

------------------------------------------------------------
--DETAIL TABLE
--This table represents the "child" or dependent dataset
CREATE TABLE Detailed(
	DMO INT,
	EnDesc nvarchar(10)
)

INSERT INTO Detailed values(1,'ONE')
INSERT INTO Detailed values(3,'THREE')
INSERT INTO Detailed values(5,'FIVE')
INSERT INTO Detailed values(7,'SEVEN')

------------------------------------------------------------
--OLD-STYLE JOIN (IMPLICIT JOIN)
--This syntax is deprecated and not recommended
--It can easily produce a Cartesian product if the WHERE clause is missing
SELECT * FROM Detailed D, Master M WHERE D.DMO = M.MMO

------------------------------------------------------------
--INNER JOIN
--Returns only rows that have matching values in BOTH tables
--This represents the intersection of two datasets
SELECT * FROM Detailed INNER JOIN Master ON DMO = MMO
--Only common records are returned

------------------------------------------------------------
--OUTER JOIN
--LEFT JOIN
--The LEFT table (Master) is the driving table
--All rows from Master are preserved
--Non-matching rows from Detailed will be returned as NULL
SELECT * FROM Master LEFT JOIN Detailed ON DMO = MMO

--Important clarification:
--LEFT JOIN does NOT remove rows from the left table
--Rows existing only in the right table will be excluded

------------------------------------------------------------
--RIGHT JOIN
--The RIGHT table (Detailed) becomes the driving table
--All rows from Detailed are preserved
--Rows in Master without a match will be excluded
SELECT * FROM Master RIGHT JOIN Detailed ON DMO = MMO

------------------------------------------------------------
--FULL JOIN
--Returns all rows from BOTH tables
--If there is no matching row on either side, NULL will be returned
--This is useful for reconciliation and data comparison
SELECT * FROM Master FULL JOIN Detailed ON DMO = MMO

------------------------------------------------------------
--MAJOR TABLE
--Represents academic majors
CREATE TABLE Major(
	ID char(2) primary key,
	Name nvarchar(30),
	Room char(4),
	Hotline char(11)
)

Insert into Major Values('IS','Information System','R101','091x...')
Insert into Major Values('JS','Japanese Software Eng','R101','091x...')
Insert into Major Values('ES','Embedded System','R102','091x...')
Insert into Major Values('JP','Japanese Language','R103','091x...')
Insert into Major Values('EN','English','R104',null)
Insert into Major Values('HT','Hotel management','R105',null)

------------------------------------------------------------
--STUDENT TABLE
--One-to-Many relationship:
--One Major can have many Students
--A Student may temporarily have no Major (MID is NULL)
CREATE TABLE Student(
	ID char(8) primary key,
	Name nvarchar(30),
	MID char(2) null,
	Foreign key (MID) references Major(ID)
)

------------------------------------------------------------
--Insert sample students
insert into Student values ('SE123458', N'Cường Võ', 'IS')
insert into Student values ('SE123459', N'Dũng Phạm', 'IS')

insert into Student values ('SE123460', N'Em Trần', 'JS')
insert into Student values ('SE123461', N'Giang Lê', 'JS')
insert into Student values ('SE123462', N'Hương Võ', 'JS') 
insert into Student values ('SE123463', N'Khanh Lê', 'JS') 

insert into Student values ('SE123464', N'Lan Trần', 'ES')
insert into Student values ('SE123465', N'Minh Lê', 'ES')
insert into Student values ('SE123466', N'Ninh Phạm', 'ES') 

insert into Student values ('SE123467', N'Oanh Phạm', 'JP')
insert into Student values ('SE123468', N'Phương Nguyễn', 'JP')

insert into Student values ('SE123469', N'Quang Trần', null)
insert into Student values ('SE123470', N'Rừng Lê', null)
insert into Student values ('SE123471', N'Sơn Phạm', null)

------------------------------------------------------------
--1. List all majors together with their students
--LEFT JOIN ensures majors without students are still shown
--Output: MajorID, MajorName, StudentID, StudentName
SELECT Major.ID AS MajorID, Major.Name AS MajorName, Student.ID AS StudentID, Student.Name AS StudentName
FROM Major LEFT JOIN Student ON Major.ID = Student.MID
ORDER BY  Major.ID, Student.ID;

------------------------------------------------------------
--SWITCH TO ANOTHER DATABASE FOR BUSINESS QUERIES
use convenienceStoreDB

------------------------------------------------------------
--2. Count how many orders each customer has made
--Output: CustomerID, CustomerName, OrderCount
SELECT Customer.CusID AS CUSid, Customer.FirstName AS CUSname, COUNT(Orders.OrdID) AS COUNTorder
FROM Customer JOIN Orders ON Customer.CusID = Orders.CustomerID
GROUP BY Customer.CusID, Customer.FirstName

------------------------------------------------------------
--3. Count how many customers are handled by each employee
--(Demonstration purpose – query logic incomplete for real systems)
SELECT Orders.EmpID AS [Employee ID], count(Customer.CusID)
FROM Orders JOIN Customer ON Orders.EmpID = Customer

------------------------------------------------------------
--Return to JOIN demo database
USE YENOTO_C2_CH04_JOIN

------------------------------------------------------------
--Insert new major and student
insert into Major values ('IA','Information Asurance', 'R103',null)
insert into Student values('SE123472',N'Anh Lê','IA')

------------------------------------------------------------
--AGGREGATION QUERIES
--These queries demonstrate COUNT, ALL, MIN, SUM with JOIN

--1. Count total number of majors
SELECT COUNT(ID) FROM Major

--2. Count total number of students
SELECT COUNT(ID) FROM Student

--3. Count students in major IS
SELECT COUNT(ID) FROM Student where MID = 'IS'

------------------------------------------------------------
--4. Count students per major
--LEFT JOIN keeps majors with zero students
SELECT m.ID, m.Name, COUNT(s.ID)
FROM Major m left join Student s on s.MID = m.ID
GROUP BY m.ID, m.Name

------------------------------------------------------------
--5. Find major(s) with the highest number of students
--Using ALL to compare against all aggregated values
SELECT ld.*, m.Name
FROM(
	SELECT m.ID, COUNT(s.ID) as ld
	FROM Major m left join Student s on s.MID = m.ID
	GROUP BY m.ID
	HAVING COUNT(s.ID) >= ALL(
		SELECT COUNT(s.ID)
		FROM Major m left join Student s on s.MID = m.ID
		GROUP BY m.ID
	)
) ld left join Major m on ld.ID = m.ID

------------------------------------------------------------
--6. Find major(s) with the lowest number of students
--ALL ensures correct handling when multiple majors share the same minimum
SELECT m.ID, COUNT(s.ID) as ld
FROM Major m left join Student s on s.MID = m.ID
GROUP BY m.ID
HAVING COUNT(s.ID) <= ALL(
	SELECT COUNT(s.ID)
	FROM Major m left join Student s on s.MID = m.ID
	GROUP BY m.ID
)

------------------------------------------------------------
--ADVANCED NOTE:
--LEFT JOIN + GROUP BY + HAVING
--is the STANDARD reporting pattern in real enterprise systems
--This avoids missing master data and incorrect statistics

--5-SuperMarket.sql
--Supermarket database design
--Design a Customer table for customer management
--Customer attributes:
--(id, name, dob, sex, numberOfInhabitants, phone, email, typeOfCustomer)

--------------------------------------------------
--Create database
CREATE DATABASE YEC2Manager;
USE YEC2Manager;

--------------------------------------------------
--City table
--Stores master data for cities
--This table represents a lookup/reference table

CREATE TABLE City (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100)
);

--Note:
--City.ID is a natural key in this design
--In real systems, it is often replaced by a surrogate key

--------------------------------------------------
--Insert city data
INSERT INTO City VALUES (1, N'Hồ Chí Minh');
INSERT INTO City VALUES (2, N'Hà Nội');
INSERT INTO City VALUES (3, N'Đà Nẵng');
INSERT INTO City VALUES (4, N'Cần Thơ');

--------------------------------------------------
--Customer table
--Stores customer information for the supermarket system
--Each customer belongs to exactly one city

CREATE TABLE Customer (
    ID CHAR(5) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    DOB DATE,
    Sex NVARCHAR(10),
    NumberOfInhabitants INT,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    TypeOfCustomer NVARCHAR(50),
    CityID INT NOT NULL,
    CONSTRAINT FK_Customer_City 
        FOREIGN KEY (CityID) REFERENCES City(ID)
);

--Important clarification:
--This is a one-to-many (1-N) relationship:
--One City → Many Customers
--Customer.CityID is a foreign key referencing City.ID

--------------------------------------------------
--Insert customer data
INSERT INTO Customer VALUES 
('CU01', N'Nguyễn hehe', '2011-01-01', N'Nam', 4, '0909123456', 'hehe@gmail.com', N'VIP', 1);

INSERT INTO Customer VALUES 
('CU02', N'Lê haha', '2013-02-15', N'Nữ', 3, '0912345678', 'haha@gmail.com', N'Thường', 1);

INSERT INTO Customer VALUES 
('CU03', N'Võ Khặc Khặc', '2012-06-20', N'Nam', 5, '0987654321', 'khackhac@gmail.com', N'VIP', 2);

INSERT INTO Customer VALUES 
('CU04', N'Phạm Há Há', '2011-11-11', N'Nam', 2, '0933445566', 'haha11@gmail.com', N'Vãng lai', 3);

SELECT * FROM Customer;

--------------------------------------------------
--Advanced notes (design-level):
--Phone and Email SHOULD usually have UNIQUE constraints
--Sex should ideally be CHAR(1) with a CHECK constraint
--TypeOfCustomer should be normalized into a lookup table
--DOB can be used to calculate age instead of storing age

--------------------------------------------------
--------------------------------------------------

--06-PromotionGirl
--(Self-referencing foreign key technique)

--Create a table to store promotion girl information
--Within the promotion girls:
--Some members are selected as leaders
--Leaders manage other members
--This forms multiple teams

--Business requirements:
--1. Identify all leaders
--2. Retrieve all members under a specific leader
--3. Retrieve leader + members together
--4. Identify whom a specific employee leads

--------------------------------------------------
--PromotionGirl table
--LeaderID references the same table (recursive relationship)

CREATE TABLE PromotionGirl (
    ID CHAR(5) PRIMARY KEY,                      
    Name NVARCHAR(100) NOT NULL,                
    DOB DATE,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    LeaderID CHAR(5),                            
    CONSTRAINT FK_PromotionGirl_Leaded 
        FOREIGN KEY (LeaderID) REFERENCES PromotionGirl(ID)
);

--Important correction:
--This is NOT recursion at the SQL execution level
--This is a SELF-REFERENCING FOREIGN KEY (hierarchical relationship)

--------------------------------------------------
--Insert promotion girl data
INSERT INTO PromotionGirl VALUES 
('PG01', N'Nguyễn Cu', '2009-01-01', '0909000001', 'cu@gmail.com', NULL);

INSERT INTO PromotionGirl VALUES 
('PG02', N'Lê Tay', '2010-02-02', '0909000002', 'tay@gmail.com', 'PG01');

INSERT INTO PromotionGirl VALUES 
('PG03', N'Phạm Chân', '2012-03-03', '0909000003', 'chan@gmail.com', 'PG01');

INSERT INTO PromotionGirl VALUES 
('PG04', N'Hoàng Mặt', '2013-04-04', '0909000004', 'mat@gmail.com', 'PG02');

INSERT INTO PromotionGirl VALUES 
('PG05', N'Trần Ngón Chân', '2011-05-05', '0909000005', 'ngonchan@gmail.com', 'PG02');

SELECT * FROM PromotionGirl;

--------------------------------------------------
--Advanced notes (hierarchical design):
--LeaderID = NULL → top-level leader
--Multiple hierarchy levels are supported
--This structure enables self-join queries
--Recursive CTEs can be used to traverse the hierarchy

--------------------------------------------------
--------------------------------------------------

--REVISED EXERCISE

--05. Supermarket (revised design attempt)

CREATE TABLE Customer (
        CusID CHAR(8) NOT NULL,
	    Name NVARCHAR(20) NOT NULL,
	    DOB DATE NULL,
	    Sex CHAR(1) NULL,
	    NumberOFInhabitants INT NULL,
	    Phone VARCHAR(15) NOT NULL,
	    Email VARCHAR(100) NOT NULL,
	    TypeOfCustomer CHAR(20)
);

ALTER TABLE Customer
ADD CONSTRAINT PK_Customer_CusID 
PRIMARY KEY (CusID);

--------------------------------------------------
--Important correction:
--NumberOfInhabitants should be numeric, not CHAR
--Phone numbers should usually be VARCHAR, not CHAR
--Email length should allow realistic email sizes
--Customer type should be normalized into a reference table

--Design takeaway:
--This version improves column constraints
--But normalization and data typing can still be improved

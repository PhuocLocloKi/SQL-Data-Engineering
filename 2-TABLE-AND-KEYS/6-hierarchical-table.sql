--Create database for Promotion management
CREATE DATABASE Promotion
USE Promotion

--------------------------------------------------
--PromotionGirl table
--This table stores information about promotion girls
--It also models a leader–member relationship using a self-referencing foreign key

--Important:
--Each promotion girl may act as a leader
--Each promotion girl may also be managed by another promotion girl

CREATE DATABASE PromotionGirl(
        ID CHAR(8) PRIMARY KEY NOT NULL,
	    LastName NVARCHAR(20) NOT NULL,
	    FirstName NVARCHAR(20) NOT NULL,
	    LID CHAR(8) NOT NULL,

	    CONSTRAINT FK_PromotionGirl_ID
	    FOREIGN KEY (LID) REFERENCES PromotionGirl(ID)
)

--Correction (theoretical):
--This is NOT a recursive algorithm
--This is a SELF-REFERENCING FOREIGN KEY
--The table references itself to represent hierarchical data

--------------------------------------------------
--Insert data

--Leader record:
--Leader references itself (ID = LID)
INSERT INTO PromotionGirl 
VALUES ('P113', N'Cảnh', N'Sát', 'P113')

--Member records:
--Members reference the leader's ID
INSERT INTO PromotionGirl 
VALUES ('P114', N'Cứu', N'Thương', 'P113')

INSERT INTO PromotionGirl 
VALUES ('P113', N'Cứu', N'Hoả', 'P113')

--Important theoretical note:
--Using self-reference (ID = LID) is one way to mark a leader
--Another common approach is allowing LID to be NULL for leaders

--------------------------------------------------
--Query leaders
--Leaders are identified when ID equals LeaderID (LID)
SELECT * 
FROM PromotionGirl 
WHERE ID = LID

--------------------------------------------------
--Query members of a specific leader
--This returns all promotion girls managed by leader P113
SELECT * 
FROM PromotionGirl 
WHERE LID = 'P113'

--------------------------------------------------
--Advanced design notes:

--1. This table represents a hierarchical structure (tree)
--2. Depth can be unlimited (leader → sub-leader → member)
--3. Queries can be extended using SELF JOIN or Recursive CTE
--4. This pattern is commonly used for:
--   - Employee–Manager
--   - Organization chart
--   - Category hierarchy
--   - Team / leader structures

--Best practice note:
--Allowing LID to be NULL for leaders is usually cleaner
--It avoids self-referencing inserts and simplifies constraints

--Performance note:
--An index on LID is recommended for fast hierarchy queries

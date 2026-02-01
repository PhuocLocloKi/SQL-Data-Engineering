--2-rdbms-and-select.sql
--In reality, there are many types of databases in the world
--RDBMS: relational database management system
--(Oracle, MySQL, MS Server, PostgreSQL)
--Key-Value databases: key, value (HashMap, Redis, Memcached)
--Document Store - MongoDB, CouchBase

-- Advanced note:
-- RDBMS stores data in tables with relationships between them.
-- Key-Value databases focus on speed and simplicity.
-- Document databases store semi-structured data (JSON/BSON).

--Learning RDBMS because it satisfies ACID
--Atomicity: indivisibility: in one transaction
                             --there are many operations, if one operation fails
							 --> the whole transaction fails

-- Clarification:
-- Atomicity guarantees: ALL operations succeed or NONE of them do.
-- Partial commits are not allowed.

--Consistency: data consistency (e.g. bank statements)
--                               an operation creates a new valid data state
--                               if an error occurs during execution
--                               the system rolls back to the last valid state

-- Advanced note:
-- Consistency is enforced by constraints:
-- PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK
-- Example: account balance cannot become negative.

--Isolation: independence: a transaction being executed
--                          must be isolated from other transactions

-- Advanced note:
-- Isolation prevents concurrency problems:
-- Dirty Read, Non-repeatable Read, Phantom Read
-- Controlled by isolation levels.
-- SQL Server default: READ COMMITTED

--Durability: persistence: committed data is stored permanently
--                            even in case of system failure;
--							  data is guaranteed not to be lost

-- Advanced note:
-- Durability is achieved via transaction logs, checkpoints, and backups.
-- Once COMMIT succeeds, data survives crashes.

--You want to transfer money to account B: one transaction
--One transaction contains multiple operations

-- Advanced note:
-- This process is called a TRANSACTION:
-- BEGIN TRANSACTION
-- COMMIT / ROLLBACK

--------------------task list
--check your account balance: true
--check account availability: true
--check beneficiary account: true
--transfer money: false
--check beneficiary eligibility: true
--transfer completed: true

-- Clarification:
-- If ANY step fails → the whole transaction must ROLLBACK.

--You owe A (10 million) and owe B (5 million)
--Your account has 10 million: transfer to B (5 million)
--System is slow, money not deducted yet, still shows 10 million
--Transfer again to A (10 million)

-- Advanced note:
-- This is a classic Isolation problem (Lost Update).
-- Without proper isolation, financial systems break.

--Advantages:
--Powerful SQL querying
--Easy to develop and scale
--Supports authorization (admin, guest, user, ...)

-- Advanced note:
-- RDBMS also provides:
-- Indexes, Views, Stored Procedures, Triggers
-- Role-based Access Control (RBAC)

--Disadvantages:
--Poor handling of unstructured data
--Slower compared to NoSQL in big-scale systems

-- Clarification:
-- "Slow" mainly in Big Data / IoT / Log systems.
-- For OLTP workloads, RDBMS is highly efficient.

--When should it be used:
--When data integrity must be preserved
--When data must not be easily modified
--Examples: financial systems (MISA), defense systems
--healthcare information systems
--automation systems
--internal enterprise data

-- Best practice:
-- RDBMS is ideal for OLTP (Online Transaction Processing).
-- Requires tuning for large-scale analytics (OLAP).

--In a database, there are many tables

--What is a table? A list representing an object
--A table consists of columns and rows
--One row contains full information of an object
--> A table usually has many columns
--column | field | property | attribute

-- Advanced note:
-- Row = record / tuple
-- Table = relation (relational algebra concept)

--In a table, there is usually a special column
--where data is never duplicated (Primary Key - PK)
--Purpose: identify an object
--> ensures no two rows are 100% identical

-- Advanced note:
-- Primary Key = UNIQUE + NOT NULL
-- Can be single-column or composite (multi-column).

--table student
--ID     |  Name   |  Score   |  YOB
--001    |  Dat    |  10      | 2004
--002    |  Tung   |  4       | 2003
--003    |  Nam    |  8       | 2003
--004    |  Tung   |  9       | 2003
--005    |  Diep   |  10      | 1999

-- Clarification:
-- Names can be duplicated
-- IDs must always be unique

--2. What is a database?
--A collection of tables with the same topic
--solving a specific storage problem

-- Advanced note:
-- A database also contains:
-- Views, Indexes, Functions, Procedures, Triggers

--3. To view, insert, update, delete data
--we use SQL DML commands
--Data Manipulation Language
--SQL DML: SELECT, INSERT, UPDATE, DELETE

-- Clarification:
-- SELECT: read data
-- INSERT: add data
-- UPDATE: modify data
-- DELETE: remove data

-----------PRACTICE
--Select database
USE convenienceStoreDB

-- Best practice:
-- Always explicitly select the database before querying.

--1. List all employees with full information
--SELECT COLUMN, COLUMN,... FROM TABLE
--SELECT * : retrieve all columns

SELECT * FROM Employee -- retrieve all columns from Employee table

-- Best practice:
-- Avoid SELECT * in production systems.
-- Select only required columns to improve performance.

--2. List employees with partial information
--output: employee ID, first name, last name, birthday
SELECT EmpID, FirstName, LastName, Birthday FROM Employee

--3. List employees with full name and year of birth
SELECT EmpID,
       FirstName + '' + LastName AS [full name],
	   YEAR(Birthday) AS [YOB]
FROM Employee

-- Advanced note:
-- String concatenation uses + in SQL Server.
-- NULL values may cause issues → CONCAT() is safer.

SELECT EmpID,
       [full name] = FirstName + ' ' + LastName,
	   [YOB] = YEAR(Birthday)
FROM Employee

--4. List employees with age
SELECT EmpID,
       FirstName + ' ' + LastName AS [full name],
	   YEAR(GETDATE()) - YEAR(Birthday) AS [age]
FROM Employee

-- Advanced note:
-- This age calculation is approximate.
-- More accurate method uses DATEDIFF with date comparison.

--5. Display supplier information
SELECT * FROM Supplier

--6. Display product categories
SELECT * FROM Category

--7. Display products
SELECT * FROM Product

--8. Display shipping companies
SELECT * FROM Shipper

--9. Check warehouse inventory
SELECT * FROM Barn

--10. Display orders
SELECT * FROM Orders

--11. Display order summary
--output: order ID, customer ID
SELECT ordID, CustomerID
FROM Orders

--12. Display order details
SELECT * FROM OrdersDetail

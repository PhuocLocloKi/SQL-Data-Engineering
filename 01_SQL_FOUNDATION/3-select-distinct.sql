--3-select-Distinct.sql
USE convenienceStoreDB

--In a table, there is usually a special column called the Primary Key (PK)
--A SELECT statement always returns a result set in table format

--When we use SELECT * ,
--the result will never contain two rows that are 100% identical
--because the Primary Key column is included

--However, if we SELECT only specific columns
--and those columns do NOT include the Primary Key
--then the result may contain duplicate rows

-- Clarification (important correction):
-- Duplicate rows here mean rows where ALL selected columns have identical values,
-- not necessarily duplicate records in the table itself.

--In relational theory, a row is called a "tuple"
--Duplicate tuples can appear in a SELECT result

--To remove duplicate rows from the result set,
--we use DISTINCT immediately after SELECT
--Syntax:
--SELECT DISTINCT column1, column2, ...

-- Advanced note:
-- DISTINCT works on the COMBINATION of all selected columns.
-- If any column value is different, the row is considered unique.

-- Advanced note:
-- DISTINCT is applied AFTER FROM and WHERE,
-- but BEFORE ORDER BY.

--------------------------------------------------

--1. Display all customer information
SELECT * FROM Customer

-- Best practice:
-- SELECT * is acceptable for learning and quick inspection
-- In production, always select only required columns.

--2. From which cities do your customers come?
--   List all distinct cities where customers are located
SELECT DISTINCT City FROM Customer

-- Advanced note:
-- If City contains NULL values,
-- DISTINCT will return only ONE NULL value (if any).

-- Advanced note:
-- DISTINCT ignores duplicate values but does NOT modify the data in the table.
-- It only affects the query result.

--------------------------------------------------

--3. Display all products that have been imported into the warehouse
SELECT * FROM Barn

-- Clarification:
-- This query shows all warehouse records,
-- including possible multiple entries for the same product.

--------------------------------------------------

--4. Display all import bills (warehouse input packages)
SELECT * FROM InputBill

-- Advanced note:
-- If you want to see unique import dates, suppliers, or products,
-- DISTINCT can be applied to specific columns instead of SELECT *.

-- Example (theoretical):
-- SELECT DISTINCT SupplierID FROM InputBill

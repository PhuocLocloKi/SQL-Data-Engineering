--4-order-By-sorting.sql
USE convenienceStoreDB

--SELECT always returns the result in table format
--We can sort the result set by one or more columns
--Sorting only affects the RESULT SET, not the original data in the table

--Comparison rules:
--        Numbers: normal numeric comparison
--        Date/Time: compared chronologically
--             1975-04-30 < 2025-01-10
--        Strings (character arrays):
--             longer strings are NOT necessarily greater
--             strings are compared based on character codes (ASCII / Unicode)
--             case-insensitive by default (depends on database collation)

-- Clarification (important correction):
-- String comparison is NOT pure ASCII in SQL Server.
-- It depends on COLLATION (e.g., case-insensitive, accent-sensitive).

--Sorting by multiple columns:
--        The order of columns DOES matter
--        Sorting is performed from LEFT to RIGHT
--        First column is sorted first
--        Rows with equal values are then sorted by the next column

--Examples:
--Sort Score in ascending order
--Sort Name in descending order

--To sort data, use ORDER BY Column ASC | DESC
--ASC: ascending (default) | DESC: descending

--------------------------------------------------

--ORDER BY always appears at the END of a SELECT statement
--When ordering by multiple columns, sorting is evaluated from left to right

-- Advanced note:
-- Logical order of SQL execution:
-- FROM → WHERE → SELECT → ORDER BY
-- ORDER BY is executed LAST

--------------------------------------------------

--1. Display all customer information
SELECT * FROM Customer

-- Best practice:
-- SELECT * is useful for learning and debugging
-- Avoid SELECT * in production for performance reasons

--------------------------------------------------

--2. List orders sorted by freight (weight)
SELECT * FROM Orders ORDER BY Freight

-- Advanced note:
-- ASC is the default sort order
-- This query is equivalent to:
-- SELECT * FROM Orders ORDER BY Freight ASC

-- Advanced note:
-- NULL values are sorted LAST by default in SQL Server

--------------------------------------------------

--3. Sort employees by first name
SELECT * FROM Employee ORDER BY FirstName

-- Clarification:
-- Sorting is based on database collation
-- Case-insensitive collations treat 'a' and 'A' as equal

--------------------------------------------------

--4. Sort orders:
--   Ascending by employee ID
--   Descending by freight
SELECT * FROM Orders ORDER BY EmpID, Freight DESC

-- Advanced note:
-- First, rows are grouped by EmpID in ascending order
-- Within the same EmpID, rows are sorted by Freight DESC

-- Advanced note (performance):
-- ORDER BY may require extra memory or disk (SORT operator)
-- Indexes on ORDER BY columns can significantly improve performance

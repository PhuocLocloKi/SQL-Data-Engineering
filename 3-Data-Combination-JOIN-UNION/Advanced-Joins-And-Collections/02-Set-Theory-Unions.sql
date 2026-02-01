------------------------------------------------------------
--[SQL LEARNING DOCUMENT]
--Part 02-set-theory-unions.sql
--Topic: Combining result sets vertically
------------------------------------------------------------

/*
OVERVIEW
--------
UNION combines ROWS, not columns.
JOIN combines COLUMNS, not rows.
*/

------------------------------------------------------------
--1. UNION vs UNION ALL
------------------------------------------------------------

/*
UNION
- Removes duplicate rows
- Slower due to DISTINCT operation
*/

SELECT ID, Name FROM Table_A
UNION
SELECT ID, Name FROM Table_B;

------------------------------------------------------------

/*
UNION ALL
- Keeps duplicate rows
- Faster
- Recommended unless duplicates MUST be removed
*/

SELECT ID, Name FROM Table_A
UNION ALL
SELECT ID, Name FROM Table_B;

------------------------------------------------------------
--RULES FOR UNION
------------------------------------------------------------

/*
1. Same number of columns
2. Compatible data types
3. Column names are taken from the FIRST SELECT
*/

------------------------------------------------------------
--2. INTERSECT
--Returns rows that appear in BOTH result sets
------------------------------------------------------------

SELECT ProductID
FROM SalesOrderDetail
INTERSECT
SELECT ProductID
FROM SalesOrderHeader;

------------------------------------------------------------
--3. EXCEPT
--Returns rows in FIRST query but NOT in second
------------------------------------------------------------

SELECT ProductID
FROM Product
EXCEPT
SELECT ProductID
FROM vProductAndDescription;

------------------------------------------------------------
--4. SET THEORY SUMMARY
------------------------------------------------------------

/*
UNION        = A ∪ B
INTERSECT    = A ∩ B
EXCEPT       = A - B
JOIN         = Horizontal combination
*/

------------------------------------------------------------
--5. ADVANCED NOTE (IMPORTANT)
------------------------------------------------------------

/*
JOIN vs UNION – WHEN TO USE?
--------------------------------
JOIN:
- When tables are RELATED
- When you need columns from multiple tables

UNION:
- When tables have SIMILAR structure
- When you want to MERGE datasets
*/

------------------------------------------------------------
--6. SHORT PRACTICE EXERCISES
------------------------------------------------------------

--EX1: Combine active and archived customers
SELECT CustomerID, CustomerName FROM Customer
UNION ALL
SELECT CustomerID, CustomerName FROM CustomerArchive;

--EX2: Find common ProductIDs sold and purchased
SELECT ProductID FROM SalesOrderDetail
INTERSECT
SELECT ProductID FROM PurchaseOrderDetail;

--EX3: Find products never described
SELECT ProductID FROM Product
EXCEPT
SELECT ProductID FROM vProductAndDescription;

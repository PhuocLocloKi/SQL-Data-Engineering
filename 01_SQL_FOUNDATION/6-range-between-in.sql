--06-range-between-in.sql

--I/ THEORY

--1. When we need to filter rows (similar to Excel filters)
--using the WHERE clause in a table,
--sometimes we want to filter a RANGE (from ... to ...)

--Example:
--[1970 - 1999]
--year <= 1999 AND year >= 1970

--Or when we want to filter a SET of values:
--1, 2, 3, 4, 5, 6, 7, 8, 9

--The DBMS provides two operators for this purpose:
--BETWEEN → used for ranges
--IN      → used for sets

--------------------------------------------------

--Example 1: Range [1970 - 1999]
                --year BETWEEN 1970 AND 1999
				--year <= 1999 AND year >= 1970

-- Clarification (important correction):
-- BETWEEN is INCLUSIVE on both ends
-- BETWEEN 1970 AND 1999 includes 1970 and 1999

--Example 2: Select people born in 2000, 2004, 2006
                --year IN (2000, 2004, 2006)
				--year = 2000 OR year = 2004 OR year = 2006

-- Advanced note:
-- IN is more readable and easier to maintain than multiple OR conditions

--------------------------------------------------
--II/ PRACTICE

--1. List orders shipped to the UK, USA, and Japan
SELECT * FROM Orders 
WHERE ShipCountry IN ('UK', 'USA', 'Japan')

-- Advanced note:
-- IN is optimized internally and preferred over multiple OR clauses

--------------------------------------------------

--2. List employees who are NOT in London and NY
--Write using multiple approaches: NOT, IN, BETWEEN (logic comparison)

SELECT * FROM Employee 
WHERE NOT City IN ('London', 'NY') 

SELECT * FROM Employee 
WHERE City NOT IN ('London', 'NY')

-- Clarification:
-- NOT IN and NOT (...) are logically equivalent

-- Advanced warning:
-- If City contains NULL values,
-- NOT IN may return unexpected results
-- Best practice is to handle NULL explicitly

--------------------------------------------------

--3. List orders with freight weight from 50 to 100 pounds
--Filtering a range using AND or BETWEEN

SELECT * FROM Orders 
WHERE Freight >= 50 AND Freight <= 100
ORDER BY Freight

-- Without BETWEEN, using NOT
SELECT * FROM Orders 
WHERE NOT (Freight < 50 OR Freight > 100)

-- Using BETWEEN
SELECT * FROM Orders 
WHERE Freight BETWEEN 50 AND 100
ORDER BY Freight

-- Clarification:
-- All three queries return the SAME result
-- BETWEEN includes both boundary values (50 and 100)

-- Advanced note:
-- BETWEEN improves readability but not performance by itself
-- Indexes determine performance, not syntax choice

--------------------------------------------------

--4. List orders shipped in the year 2021
--excluding months 6, 7, 8, 9
--Solve using two different approaches

SELECT * FROM Orders 
WHERE YEAR(ShippedDate) = 2021 
AND MONTH(ShippedDate) NOT IN (6,7,8,9)

SELECT * FROM Orders 
WHERE YEAR(ShippedDate) = 2021 
AND NOT (MONTH(ShippedDate) BETWEEN 6 AND 9)

-- Advanced note (important performance insight):
-- Using YEAR() or MONTH() in WHERE prevents index usage
-- A better production approach would use date ranges:
-- ShippedDate >= '2021-01-01' AND ShippedDate < '2022-01-01'

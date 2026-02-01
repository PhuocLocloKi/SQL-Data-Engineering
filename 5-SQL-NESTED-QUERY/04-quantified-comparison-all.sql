-- =====================================================
-- 04_ALL.sql
-- =====================================================

-- PURPOSE:
-- Create a demo environment to practice the ALL operator
-- used with comparison operators in SQL

CREATE DATABASE YE_C2_Subquery_ALL;
GO

USE YE_C2_Subquery_ALL;
GO

-- =====================================================
-- CREATE DEMO TABLES
-- =====================================================

-- Table storing odd numbers
CREATE TABLE Odds (
    Number INT -- integer column
);

INSERT INTO Odds VALUES (1);
INSERT INTO Odds VALUES (3);
INSERT INTO Odds VALUES (5);
INSERT INTO Odds VALUES (7);
INSERT INTO Odds VALUES (9);

SELECT * FROM Odds;

-- -----------------------------------------------------

-- Table storing even numbers
CREATE TABLE Evens (
    Number INT -- integer column
);

-- NOTE:
-- INSERT INTO Evens VALUES()
-- would insert NULL and is NOT recommended
-- for ALL operator demonstrations

INSERT INTO Evens VALUES (0);
INSERT INTO Evens VALUES (2);
INSERT INTO Evens VALUES (4);
INSERT INTO Evens VALUES (6);
INSERT INTO Evens VALUES (8);

SELECT * FROM Evens;

-- -----------------------------------------------------

-- Table storing a mixed set of integers
CREATE TABLE Integers (
    Number INT
);

INSERT INTO Integers VALUES (1);
INSERT INTO Integers VALUES (2);
INSERT INTO Integers VALUES (3);
INSERT INTO Integers VALUES (4);
INSERT INTO Integers VALUES (5);
INSERT INTO Integers VALUES (6);

SELECT * FROM Integers;

-- =====================================================
-- ALL OPERATOR THEORY
-- =====================================================

-- 1. SQL provides the ALL operator to be used together
-- with comparison operators.
--
-- SYNTAX:
-- WHERE column <comparison_operator> ALL (subquery)
--
-- The subquery must return:
--   - one column
--   - multiple rows (a set of values)

-- EXAMPLES:
-- Is Duy taller than ALL students from HCM?
-- Who in group A is shorter than ALL people in group B?

-- -----------------------------------------------------

-- 2. MEANING OF ALL
-- The condition is TRUE only if the comparison
-- is TRUE for EVERY value returned by the subquery.

-- =====================================================
-- DEMONSTRATIONS
-- =====================================================

-- 1. Find numbers in Evens that are greater than
-- ALL numbers in Odds
SELECT *
FROM Evens
WHERE Number > ALL (
    SELECT Number
    FROM Odds
);

-- -----------------------------------------------------

-- 2. Find numbers in Odds that are greater than
-- ALL numbers in Evens
SELECT *
FROM Odds
WHERE Number > ALL (
    SELECT Number
    FROM Evens
);

-- -----------------------------------------------------

-- 3. Find numbers in Odds that are greater than or equal to
-- ALL numbers in Odds
-- (This returns the maximum value)
SELECT *
FROM Odds
WHERE Number >= ALL (
    SELECT Number
    FROM Odds
);

-- -----------------------------------------------------

-- 4. Find the largest number in Integers
SELECT *
FROM Integers
WHERE Number >= ALL (
    SELECT Number
    FROM Integers
);

-- =====================================================
-- REAL DATABASE PRACTICE
-- =====================================================

USE convenienceStoreDB;
GO

-- 1. Display employee information along with their age
--
-- NOTE (IMPORTANT):
-- This age calculation is APPROXIMATE.
-- A precise calculation requires checking month/day.
SELECT *,
       YEAR(GETDATE()) - YEAR(Birthday) AS [AGE]
FROM Employee;

-- -----------------------------------------------------

-- 2. Find the employee(s) with the maximum age
SELECT *,
       YEAR(GETDATE()) - YEAR(Birthday) AS [AGE]
FROM Employee
WHERE YEAR(GETDATE()) - YEAR(Birthday) >= ALL (
    SELECT YEAR(GETDATE()) - YEAR(Birthday)
    FROM Employee
);

-- -----------------------------------------------------

-- 3. Among employees from the USA,
-- find the employee(s) with the maximum age
SELECT *,
       YEAR(GETDATE()) - YEAR(Birthday) AS [AGE]
FROM Employee
WHERE Country = 'USA'
AND YEAR(GETDATE()) - YEAR(Birthday) >= ALL (
    SELECT YEAR(GETDATE()) - YEAR(Birthday)
    FROM Employee
    WHERE Country = 'USA'
);

-- -----------------------------------------------------

-- 4. List all products that belong to the categories:
-- Moto, bag, clothes
SELECT *
FROM Product
WHERE CategoryID IN (
    SELECT CategoryID
    FROM Category
    WHERE CategoryName IN ('Moto', 'bag', 'clothes')
);

-- -----------------------------------------------------

-- 5. Find the order(s) with the maximum freight
SELECT *
FROM Orders
WHERE Freight >= ALL (
    SELECT Freight
    FROM Orders
);

-- -----------------------------------------------------

-- 5.1 Find the maximum freight value among all orders
SELECT Freight
FROM Orders
WHERE Freight >= ALL (
    SELECT Freight
    FROM Orders
);

-- -----------------------------------------------------

-- 6. Among orders shipped to Hàng Mã or Tokyo,
-- find the order(s) with the maximum freight
SELECT *
FROM (
    SELECT *
    FROM Orders
    WHERE ShipCity IN (N'Votive paper', 'Tokyo')
) AS [Orders to Hang Ma and Tokyo]
WHERE Freight >= ALL (
    SELECT Freight
    FROM (
        SELECT *
        FROM Orders
        WHERE ShipCity IN (N'Votive paper', 'Tokyo')
    ) AS [Filtered Orders]
);

-- -----------------------------------------------------

-- 7. Among orders shipped to Hàng Mã or Tokyo,
-- find the order(s) with the MINIMUM freight
SELECT *
FROM (
    SELECT *
    FROM Orders
    WHERE ShipCity IN (N'Votive paper', 'Tokyo')
) AS [Orders to Hang Ma and Tokyo]
WHERE Freight <= ALL (
    SELECT Freight
    FROM (
        SELECT *
        FROM Orders
        WHERE ShipCity IN (N'Votive paper', 'Tokyo')
    ) AS [Filtered Orders]
);

-- -----------------------------------------------------

-- 8. Find the product(s) with the highest selling price
SELECT *
FROM Product
WHERE Price >= ALL (
    SELECT Price
    FROM Product
);

-- -----------------------------------------------------

-- 9. Find the category of the product(s)
-- with the highest selling price
SELECT CategoryName
FROM Category
WHERE CategoryID = (
    SELECT CategoryID
    FROM Product
    WHERE Price >= ALL (
        SELECT Price
        FROM Product
    )
);

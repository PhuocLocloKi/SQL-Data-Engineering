-- =====================================================
-- 01-single-row-subqueries.
-- =====================================================

-- BASIC SQL SYNTAX
-- SELECT ... FROM ... ORDER BY ...
-- SELECT * or SELECT column1, column2, ...
-- WHERE is used to filter rows
-- IMPORTANT:
-- Every SELECT statement ALWAYS returns a TABLE
-- (even if it contains only 1 row and 1 column)

-- -----------------------------------------------------
-- SINGLE-VALUE SUBQUERY (Scalar Subquery)
-- -----------------------------------------------------
-- Definition:
-- A single-value subquery returns:
--   - exactly 1 row
--   - exactly 1 column
--   - exactly 1 cell (scalar value)
--
-- A scalar subquery can be treated like a normal value
-- and can be used with comparison operators:
--   =, >, <, >=, <=, <>
--
-- WARNING:
-- If the subquery returns more than 1 row,
-- the query will cause a runtime error.

USE convenienceStoreDB;

-- -----------------------------------------------------
-- Requirement:
-- Get all employees who live in the SAME city
-- as the employee with EmpID = 'Emp004'
-- (including Emp004 itself)
--
-- Step 1: Find the city of employee Emp004
-- Step 2: Compare all employees' City with that city
-- -----------------------------------------------------

SELECT *
FROM Employee
WHERE City = (
    SELECT City
    FROM Employee
    WHERE EmpID = 'Emp004'
);
-- This is called a NESTED QUERY (Subquery inside WHERE)

-- =====================================================
-- PRACTICE EXERCISES
-- =====================================================

-- 1. List all employees who live in London
SELECT *
FROM Employee
WHERE City = 'London';

-- -----------------------------------------------------

-- 2. List all employees who come from the same country
-- as Angelina (excluding Angelina herself)
--
-- THEORY NOTE:
-- The subquery must return exactly ONE value.
-- If multiple Angelinas exist, this query will fail.
-- In that case, IN() should be used instead.
SELECT *
FROM Employee
WHERE Country = (
    SELECT Country
    FROM Employee
    WHERE FirstName = 'Angelina'
)
AND FirstName <> 'Angelina';

-- -----------------------------------------------------

-- 3. List all orders that have a required delivery date
SELECT *
FROM Orders
WHERE RequiredDate IS NOT NULL;

-- -----------------------------------------------------

-- 4. List all orders whose freight is greater than
-- the freight of order ORD021
SELECT *
FROM Orders
WHERE Freight > (
    SELECT Freight
    FROM Orders
    WHERE OrdID = 'ORD021'
);

-- -----------------------------------------------------

-- 5. List all orders that:
--   - have freight greater than order ORD021
--   - are shipped to the same city as order ORD012
--   - INCLUDING order ORD012 itself
--
-- THEORY FIX:
-- Freight must be compared with Freight
-- City must be compared with City
SELECT *
FROM Orders
WHERE Freight > (
    SELECT Freight
    FROM Orders
    WHERE OrdID = 'ORD021'
)
AND ShipCity = (
    SELECT ShipCity
    FROM Orders
    WHERE OrdID = 'ORD012'
);

-- -----------------------------------------------------

-- 6. List all orders that:
--   - are shipped to the same city as order ORD014
--   - have freight greater than 50 pounds
SELECT *
FROM Orders
WHERE Freight > 50
AND ShipCity = (
    SELECT ShipCity
    FROM Orders
    WHERE OrdID = 'ORD014'
);

-- -----------------------------------------------------

-- 7. List all orders that:
--   - are shipped by carrier SHIP003
--   - are shipped to the same city as order ORD012
--
-- THEORY FIX:
-- Comparison operator '=' was missing
SELECT *
FROM Orders
WHERE ShipID = 'SHIP003'
AND ShipCity = (
    SELECT ShipCity
    FROM Orders
    WHERE OrdID = 'ORD012'
);

-- -----------------------------------------------------

-- 8. List all orders delivered by the shipper
-- named 'Giaohangtietkiem'
--
-- Step 1: Get ShipID of Giaohangtietkiem
-- Step 2: Find all orders using that ShipID
SELECT *
FROM Orders
WHERE ShipID = (
    SELECT ShipID
    FROM Shipper
    WHERE CompanyName = 'Giaohangtietkiem'
);

-- -----------------------------------------------------

-- 9. List all products with:
--   - product ID
--   - product name
--   - category ID
SELECT ProID, ProName, CategoryID
FROM Product;

-- -----------------------------------------------------

-- 10. Find the category of the product 'pork shank'
-- Output:
--   - CategoryID
--   - CategoryName
SELECT CategoryID, CategoryName
FROM Category
WHERE CategoryID = (
    SELECT CategoryID
    FROM Product
    WHERE ProName = 'pork shank'
);

-- -----------------------------------------------------

-- 11. List all products that belong to the same category
-- as 'pork shank' (including pork shank itself)
SELECT *
FROM Product
WHERE CategoryID = (
    SELECT CategoryID
    FROM Product
    WHERE ProName = 'pork shank'
);

-- -----------------------------------------------------

-- 12. List all products that belong to the category 'meat'
SELECT *
FROM Product
WHERE CategoryID = (
    SELECT CategoryID
    FROM Category
    WHERE CategoryName = 'meat'
);

-- -----------------------------------------------------

-- 13. List all suppliers that provide the product 'pork shank'
--
-- THEORY (ADVANCED):
-- This is a MULTI-LEVEL SUBQUERY:
-- Product -> InputBill -> Supplier
SELECT *
FROM Supplier
WHERE SupID IN (
    SELECT SupID
    FROM InputBill
    WHERE ProID = (
        SELECT ProID
        FROM Product
        WHERE ProName = 'pork shank'
    )
);

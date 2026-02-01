-- =====================================================
-- 02-multi-row-subqueries.sql
-- =====================================================

-- MULTI-VALUE SUBQUERY
-- -----------------------------------------------------
-- Definition:
-- A multi-value subquery returns:
--   - multiple rows
--   - one single column
--
-- This type of subquery CANNOT be used with '='
-- It must be used with set operators such as:
--   IN, NOT IN, ANY, ALL
--
-- IMPORTANT:
-- The result of any SELECT statement is always a TABLE.

-- =====================================================
-- PRACTICE EXERCISES
-- =====================================================

-- 1. List all products that belong to categories:
--    CATE006, CATE005, CATE003
SELECT *
FROM Product
WHERE CategoryID IN ('CATE006', 'CATE005', 'CATE003');

-- -----------------------------------------------------

-- 2. List all products that belong to the categories:
--    meat, car, bag
--
-- THEORY:
-- The subquery returns multiple CategoryID values,
-- so IN must be used instead of '='
SELECT *
FROM Product
WHERE CategoryID IN (
    SELECT CategoryID
    FROM Category
    WHERE CategoryName IN ('bag', 'meat', 'car')
);

-- -----------------------------------------------------

-- 3. List all suppliers who provide products
-- whose categories are: car, meat, bag
--
-- DATA FLOW (Nested multi-level subquery):
-- Category -> Product -> InputBill -> Supplier
SELECT *
FROM Supplier
WHERE SupID IN (
    SELECT SupID
    FROM InputBill
    WHERE ProID IN (
        SELECT ProID
        FROM Product
        WHERE CategoryID IN (
            SELECT CategoryID
            FROM Category
            WHERE CategoryName IN ('car', 'meat', 'bag')
        )
    )
);

-- -----------------------------------------------------

-- 4. List all orders placed by customers
-- from Vietnam, USA, or Japan
SELECT *
FROM Orders
WHERE CustomerID IN (
    SELECT CusID
    FROM Customer
    WHERE Country IN ('USA', 'Japan', 'VietNam')
);

-- -----------------------------------------------------

-- 5. List all orders that:
--   - are placed by customers from Vietnam, USA, or Japan
--   - are shipped to the same city as order ORD015
--   - INCLUDING order ORD015 itself
SELECT *
FROM Orders
WHERE CustomerID IN (
    SELECT CusID
    FROM Customer
    WHERE Country IN ('USA', 'Japan', 'VietNam')
)
AND ShipCity IN (
    SELECT ShipCity
    FROM Orders
    WHERE OrdID = 'ORD015'
);

-- -----------------------------------------------------

-- 6. List all orders placed by customers
-- who are NOT from USA or Japan
--
-- THEORY NOTE (IMPORTANT):
-- NOT IN returns no rows if the subquery contains NULL.
-- In real systems, NOT EXISTS is safer.
SELECT *
FROM Orders
WHERE CustomerID NOT IN (
    SELECT CusID
    FROM Customer
    WHERE Country IN ('USA', 'Japan')
);

-- -----------------------------------------------------

-- 7. List all orders handled by employee EMP004
SELECT *
FROM Orders
WHERE EmpID = 'EMP004';

-- -----------------------------------------------------

-- 8. List all orders handled by employees
-- who work in New York (NY)
SELECT *
FROM Orders
WHERE EmpID IN (
    SELECT EmpID
    FROM Employee
    WHERE City = 'NY'
);

-- -----------------------------------------------------

-- 9. List all shippers who delivered orders
-- to the city of London
SELECT *
FROM Shipper
WHERE ShipID IN (
    SELECT ShipID
    FROM Orders
    WHERE ShipCity = 'London'
);

-- -----------------------------------------------------

-- 10. List all employees who handled orders
-- shipped to New York (NY)
SELECT *
FROM Employee
WHERE EmpID IN (
    SELECT EmpID
    FROM Orders
    WHERE ShipCity = 'NY'
);

-- -----------------------------------------------------

-- 11. List all products supplied by suppliers
-- SUP003 and SUP005
SELECT *
FROM Product
WHERE ProID IN (
    SELECT ProID
    FROM InputBill
    WHERE SupID IN ('SUP003', 'SUP005')
);

-- -----------------------------------------------------

-- 12. List all product categories that are supplied by
-- suppliers NOT located in Vietnam
--
-- ADVANCED THEORY:
-- This query uses FOUR LEVELS of subqueries
-- Supplier -> InputBill -> Product -> Category
SELECT *
FROM Category
WHERE CategoryID IN (
    SELECT CategoryID
    FROM Product
    WHERE ProID IN (
        SELECT ProID
        FROM InputBill
        WHERE SupID IN (
            SELECT SupID
            FROM Supplier
            WHERE Country <> 'VietNam'
        )
    )
);

-- -----------------------------------------------------

-- 13. List all orders handled by the employee
-- whose first name is "Enno's"
--
-- THEORY FIX:
-- Apostrophe inside string must be escaped by doubling it
SELECT *
FROM Orders
WHERE EmpID IN (
    SELECT EmpID
    FROM Employee
    WHERE FirstName = 'Enno''s'
);

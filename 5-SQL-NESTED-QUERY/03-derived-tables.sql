-- =====================================================
-- 03-derived-tables.sql
-- =====================================================

-- IMPORTANT CONCEPT:
-- The result of any SELECT statement is ALWAYS a TABLE
-- (regardless of how many rows or columns it returns)

-- SELECT ... FROM <TABLE | SUBQUERY>
-- A subquery used in the FROM clause is called:
--   DERIVED TABLE (or INLINE VIEW)

-- -----------------------------------------------------
-- THEORY (CRITICAL):
-- To be used as a table, a subquery MUST:
--   1. Have a table alias
--   2. Every selected column MUST have a name
--      (avoid "No column name" error)
-- -----------------------------------------------------

-- =====================================================
-- PRACTICE EXERCISES
-- =====================================================

-- 1. List all customers from the USA
SELECT *
FROM Customer
WHERE Country = 'USA';

-- -----------------------------------------------------

-- 2. List all customers from the USA
-- who have a phone number
SELECT *
FROM Customer
WHERE Country = 'USA'
AND PhoneNumber IS NOT NULL;

-- -----------------------------------------------------
-- Same requirement using a DERIVED TABLE
--
-- NOTE:
-- SELECT 8 is meaningless data-wise
-- It is used only to demonstrate that
-- the subquery behaves like a real table
SELECT 8
FROM (
    SELECT *
    FROM Customer
    WHERE Country = 'USA'
) AS [Customers from USA]
WHERE PhoneNumber IS NOT NULL;

-- -----------------------------------------------------

SELECT 8
FROM (
    SELECT *
    FROM Customer
    WHERE PhoneNumber IS NOT NULL
) AS [Customers with phone]
WHERE Country = 'USA';

-- =====================================================
-- 3. List all orders that:
--   - are shipped to London, California, or Hàng Mã
--   - are handled by employee EMP001
--
-- Requirement: solve in 3 different ways
-- =====================================================

-- Way 1: Direct filtering
SELECT *
FROM Orders
WHERE ShipCity IN ('London', 'California', N'HàngMã')
AND EmpID = 'EMP001';

-- -----------------------------------------------------

-- Way 2: Filter by employee first, then by city
SELECT *
FROM (
    SELECT *
    FROM Orders
    WHERE EmpID = 'EMP001'
) AS [Orders handled by EMP001]
WHERE ShipCity IN ('London', 'California', N'HàngMã');

-- -----------------------------------------------------

-- Way 3: Filter by city first, then by employee
SELECT *
FROM (
    SELECT *
    FROM Orders
    WHERE ShipCity IN ('London', 'California', N'HàngMã')
) AS [Orders shipped to target cities]
WHERE EmpID = 'EMP001';

-- =====================================================
-- 4. List all orders that:
--   - are shipped to London, California, or Hàng Mã
--   - are placed by customers named Roney or Hồng
--   - solve in 3 different ways
-- =====================================================

-- Way 1: Subquery in WHERE
SELECT *
FROM Orders
WHERE ShipCity IN ('London', 'California', N'HàngMã')
AND CustomerID IN (
    SELECT CusID
    FROM Customer
    WHERE FirstName IN ('Roney', N'Hồng')
);

-- -----------------------------------------------------

-- Way 2: Derived table first (filter by customer)
SELECT *
FROM (
    SELECT *
    FROM Orders
    WHERE CustomerID IN (
        SELECT CusID
        FROM Customer
        WHERE FirstName IN ('Roney', N'Hồng')
    )
) AS [Orders of Roney and Hồng]
WHERE ShipCity IN ('London', 'California', N'HàngMã');

-- -----------------------------------------------------

-- Way 3: Direct combination
SELECT *
FROM Orders
WHERE ShipCity IN ('London', 'California', N'HàngMã')
AND CustomerID IN (
    SELECT CusID
    FROM Customer
    WHERE FirstName IN ('Roney', N'Hồng')
);

-- =====================================================
-- 5. List all input bills that:
--   - are supplied by SUP006
--   - have amount less than 1000
--   - solve in 3 different ways
-- =====================================================

-- Way 1: Direct filtering
SELECT *
FROM InputBill
WHERE SupID = 'SUP006'
AND Amount < 1000;

-- -----------------------------------------------------

-- Way 2: Filter by supplier first
SELECT *
FROM (
    SELECT *
    FROM InputBill
    WHERE SupID = 'SUP006'
) AS [Input bills of SUP006]
WHERE Amount < 1000;

-- -----------------------------------------------------

-- Way 3: Filter by amount first
SELECT *
FROM (
    SELECT *
    FROM InputBill
    WHERE Amount < 1000
) AS [Input bills under 1000]
WHERE SupID = 'SUP006';

-- =====================================================
-- 6. List all input bills that:
--   - are supplied by Vingroup
--   - have amount less than 1000
--   - solve in 3 different ways
-- =====================================================

-- Way 1: Direct subquery
SELECT *
FROM InputBill
WHERE Amount < 1000
AND SupID = (
    SELECT SupID
    FROM Supplier
    WHERE SupName = 'Vingroup'
);

-- -----------------------------------------------------

-- Way 2: Derived table by amount
SELECT *
FROM (
    SELECT *
    FROM InputBill
    WHERE Amount < 1000
) AS [Input bills under 1000]
WHERE SupID = (
    SELECT SupID
    FROM Supplier
    WHERE SupName = 'Vingroup'
);

-- -----------------------------------------------------

-- Way 3: Derived table by supplier
SELECT *
FROM (
    SELECT *
    FROM InputBill
    WHERE SupID = (
        SELECT SupID
        FROM Supplier
        WHERE SupName = 'Vingroup'
    )
) AS [Input bills from Vingroup]
WHERE Amount < 1000;

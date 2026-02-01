--5-where-filtering.sql

--A SELECT statement always returns a result set in table format

--A complete SELECT statement structure:
--SELECT Column, Column, ...
--FROM Table
--WHERE condition clause
--ORDER BY Column ASC | DESC

-- Advanced note:
-- ORDER BY is optional and always executed LAST.

USE convenienceStoreDB

SELECT EmpID, FirstName, LastName, City
FROM Employee
WHERE City = 'California'

--------------------------------------------------

--The SELECT clause is used to filter columns (vertical filtering)
--SELECT * : retrieves all columns from the table

--FROM TableX: selects which table to read data from

--WHERE condition clause: filters data horizontally (by rows)
--      If a row (record / object) satisfies the condition,
--      it will be included in the result set

--Comparison operators:
-- =   (equal)
-- !=  or <> (not equal)
-- >   (greater than)
-- <   (less than)
-- >=  (greater than or equal)
-- <=  (less than or equal)

--Logical operators:
-- AND, OR, NOT

-- Clarification (important correction):
-- WHERE is evaluated BEFORE SELECT.
-- That is why column aliases cannot be used in WHERE.

--() GROUP BY: used to group rows based on values of one or more columns
-- Advanced note:
-- GROUP BY is applied AFTER WHERE and BEFORE SELECT aggregation.

--------------------------------------------------

--1. List all employees
SELECT * FROM Employee

--------------------------------------------------

--2. List employees who live in California
SELECT * FROM Employee
WHERE City = 'California'

--------------------------------------------------

--3. List employees who live in London
--Output: id, full name, title, address
SELECT 
         EmpID,
         FirstName + ' ' + LastName AS FullName,
		 Title,
		 Address
FROM Employee
WHERE City = 'London'

--------------------------------------------------

--4. List employees who live in London and California
-- Clarification (logic note):
-- This uses OR, meaning employees in EITHER city
FROM Employee
WHERE City = 'London' OR City = 'California'

-- Advanced note:
-- This condition can be rewritten using IN:
-- WHERE City IN ('London', 'California')

--------------------------------------------------

--5. List employees who live in London or NY
SELECT * FROM Employee WHERE City = 'NY' OR City = 'NY'

-- Clarification (theory fix):
-- OR checks multiple possible values
-- Using IN is clearer and safer for multiple values

--------------------------------------------------

--6. List all orders
SELECT * FROM Orders

--------------------------------------------------

--7. List orders NOT delivered to "Hàng mã"
--Using three different comparison styles
SELECT * FROM Orders WHERE ShipCity != N'Hàng mã'
SELECT * FROM Orders WHERE ShipCity <> N'Hàng mã'
SELECT * FROM Orders WHERE ShipCity = N'Hàng mã'  -- this one is logically opposite

-- Clarification (important correction):
-- != and <> both mean "NOT EQUAL" and behave the same
-- The last query returns orders delivered TO "Hàng mã"

--------------------------------------------------

--8. List orders NOT delivered to "Hàng mã" AND NOT to London
SELECT * FROM Orders 
WHERE ShipCity != N'Hàng mã' AND ShipCity != 'London'

SELECT * FROM Orders 
WHERE NOT (ShipCity = N'Hàng mã' OR ShipCity = 'London')

-- Advanced note:
-- These two queries are logically equivalent (De Morgan’s Law)

--------------------------------------------------

--9. List orders NOT delivered to "Hàng mã" OR London
SELECT * FROM Orders 
WHERE NOT ShipCity = N'Hàng mã' AND NOT ShipCity = 'London'

-- Clarification:
-- Multiple NOT conditions can reduce readability
-- Parentheses improve clarity and prevent logic errors

--------------------------------------------------

--10. List employees with the title "Promotion"
SELECT * FROM Employee WHERE Title = 'Promotion'

-- Advanced note:
-- String comparison depends on database collation
-- Case-insensitive by default in SQL Server

--4-Aggregate
--        COUNT-and-NULL-Handling.sql
--Aggregate: aggregation means collapsing multiple rows into a single result value
--COUNT(*)    : counts rows, as long as a row exists it is counted
--COUNT(column): counts only non-NULL values in the specified column (NULL values are ignored)

USE convenienceStoreDB;

-------------------------------------------------------
-- Count how many phone numbers exist in the customer list
-- Method 1: filter NULL explicitly
SELECT COUNT(*) 
FROM Customer 
WHERE PhoneNumber IS NOT NULL;

-- Method 2: COUNT(column) automatically ignores NULL values
SELECT COUNT(PhoneNumber) 
FROM Customer;

SELECT * FROM Customer;

-------------------------------------------------------
-- II. Exercises

-- 1. List all employees
SELECT * FROM Employee;

-- 2. How many employees are there?
SELECT COUNT(EmpID) 
FROM Employee;
-- Best practice: always count on a NOT NULL column (usually Primary Key)

-------------------------------------------------------
-- 4. Count how many orders have a RequiredDate (3 approaches)

-- Approach 1: COUNT rows after filtering NULL
SELECT COUNT(*) 
FROM Orders 
WHERE RequiredDate IS NOT NULL;

-- Approach 2: COUNT(column) ignores NULL automatically
SELECT COUNT(RequiredDate) 
FROM Orders;

-- Approach 3: explicit NOT NULL condition
-- (Corrected typo: COUNT, not COUTN)
SELECT COUNT(*) 
FROM Orders 
WHERE RequiredDate IS NOT NULL;

-------------------------------------------------------
-- 5. Count how many customers have a phone number
SELECT COUNT(*) 
FROM Customer 
WHERE PhoneNumber IS NOT NULL;

-------------------------------------------------------
-- 6. Count how many cities appear in the Customer table
-- This counts customers who have a city value (NULL cities are ignored)
SELECT COUNT(City) 
FROM Customer;

-------------------------------------------------------
-- 6.1 Count how many DISTINCT cities (each city counted once)
-- Question meaning: From how many different cities do customers come?

-- Incorrect demo (logic explanation):
-- COUNT(Country) only counts non-NULL values, NOT distinct values

-- Correct approach 1: Subquery with DISTINCT
SELECT COUNT(*) 
FROM (
    SELECT DISTINCT Country 
    FROM Customer
) AS UniqueCountries;

-------------------------------------------------------
-- 7. Count how many DISTINCT cities exist in the Employee table
-- Meaning: From how many different cities do employees come?

-- Approach 1: Subquery
SELECT COUNT(*) 
FROM (
    SELECT DISTINCT City 
    FROM Employee
) AS UniqueCities;

-- Approach 2: COUNT DISTINCT (preferred)
SELECT COUNT(DISTINCT City) 
FROM Employee;

-------------------------------------------------------
-- 8. How many customers do NOT have a phone number?

-- Approach 1: filter NULL explicitly
SELECT COUNT(*) 
FROM Customer 
WHERE PhoneNumber IS NULL;

-- Approach 2: total rows minus rows having phone number
SELECT COUNT(*) - COUNT(PhoneNumber) 
FROM Customer;

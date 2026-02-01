--07-null-handling.sql

--NULL: a state where the data type is known
--      but the actual value is unknown, missing, or not yet provided

--VOID: represents "nothing at all"
--      (concept from programming languages, not SQL)

--UNDEFINED: a variable exists but its type and value are unknown
--           (common in JavaScript, not SQL)

--------------------------------------------------
--              / variable exists / data type known / value known
--VOID          /        NO       /       NO        /     NO
--UNDEFINED     /        YES      /       NO        /     NO
--NULL          /        YES      /       YES       /     NO

-- Clarification (important correction):
-- SQL ONLY has NULL.
-- VOID and UNDEFINED do NOT exist in SQL databases.
-- They are programming-language concepts used here for comparison.

--------------------------------------------------

--In real-world data, values may be missing for many reasons:
--business rules not satisfied yet
--data not collected
--data will be updated later

--NULL means:
--We know WHAT type of data it should be,
--but we do NOT know the actual value at this moment.

--Analogy:
--NULL is like a mystery box:
--you know the category, but not the exact item inside.

--Therefore:
--NULL is NOT a value
--NULL is NOT equal to anything, even another NULL

--You CANNOT use comparison operators with NULL
--score = NULL        --> INVALID
--Correct usage:
--score IS NULL
--score IS NOT NULL
--NOT score IS NULL

--------------------------------------------------
--II/ PRACTICE

--1. Use database
USE convenienceStoreDB

--------------------------------------------------

--2. List all customers
SELECT * FROM Customer

--------------------------------------------------

--3. List customers who do NOT have a phone number
SELECT * FROM Customer WHERE PhoneNumber IS NULL

-- Clarification:
-- IS NULL checks for missing / unknown values

--------------------------------------------------

--4. List customers who HAVE updated phone numbers (3 ways)

SELECT * FROM Customer WHERE PhoneNumber IS NOT NULL

SELECT * FROM Customer WHERE NOT PhoneNumber IS NULL  

SELECT * FROM Customer WHERE NOT NOT PhoneNumber IS NOT NULL

-- Clarification:
-- All three queries are logically equivalent
-- The first one is the clearest and best practice
-- Double NOT reduces readability and should be avoided

--------------------------------------------------

--5. List orders with NO required date
--and shipped to London or California (2 ways)

SELECT * FROM Orders 
WHERE RequiredDate IS NULL 
AND ShipCity IN ('London', 'California')

SELECT * FROM Orders 
WHERE NOT RequiredDate IS NOT NULL 
AND ShipCity IN ('London', 'California')

-- Advanced note:
-- IS NULL checks should always be explicit
-- Do NOT rely on comparison operators

--------------------------------------------------

--6. List orders that HAVE a required date
SELECT * FROM Orders WHERE RequiredDate IS NOT NULL

--------------------------------------------------

--7. List orders that HAVE a required date
--and are shipped by company SHIP001 or SHIP004

SELECT * FROM Orders 
WHERE ShipID IN ('SHIP001', 'SHIP004')
AND RequiredDate IS NOT NULL

-- Best practice:
-- Put IS NULL / IS NOT NULL conditions clearly
-- Improves readability and maintainability

--------------------------------------------------

--8. List orders in London that HAVE a required date

SELECT * FROM Orders 
WHERE RequiredDate IS NOT NULL 
AND ShipCity = 'London'

SELECT * FROM Orders 
WHERE RequiredDate IS NOT NULL 
AND ShipCity IN ('London')

-- Clarification:
-- Using IN with a single value is valid but unnecessary
-- '=' is clearer for single-value comparison

--------------------------------------------------

-- Advanced knowledge (VERY IMPORTANT):

--NULL in logical expressions follows 3-valued logic:
--TRUE, FALSE, UNKNOWN

--Example:
--NULL = NULL        --> UNKNOWN
--NULL <> NULL       --> UNKNOWN
--NULL AND TRUE      --> UNKNOWN
--NULL OR TRUE       --> TRUE

--This is why NULL must be handled explicitly using IS NULL / IS NOT NULL

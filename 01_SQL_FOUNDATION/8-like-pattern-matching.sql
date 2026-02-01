--08-like-pattern-matching.sql

--Using "=" is an absolute comparison
--The value must match 100% exactly
--Example:
--name = N'Hà'
--Matches only 'Hà'
--Does NOT match: 'Hà Nội', 'Hà Giang', 'Hà...'

--When we want to find names that CONTAIN a substring (e.g. 'Hà')
--we CANNOT use "="
--We MUST use LIKE
--Examples that should match:
--'Hà Nội', 'Hà Giang', 'Hà', ...

--The database engine provides the LIKE operator
--LIKE allows pattern matching
--LIKE is SIMILAR to regex, but much simpler
--(LIKE is NOT full regex)

--------------------------------------------------

--LIKE uses two special wildcard characters:
--%  : represents ANY sequence of characters (length >= 0)
--_  : represents EXACTLY ONE character (including space)

-- Clarification:
-- % can match empty string
-- _ always matches exactly one character

--------------------------------------------------

--Example 1: Find students whose name is exactly 'Đạt'
--WHERE name = N'Đạt'

--Example 2: Find students whose name CONTAINS 'Đạt'
--WHERE name LIKE N'%Đạt%'
--Matches: 'Đạt Nguyễn', 'Tiến Đạt', 'Đạt'

--Example 3: Find students whose name STARTS with 'Đạt'
--WHERE name LIKE N'Đạt%'

--Example 4: Find students whose name has EXACTLY 3 characters
--WHERE name LIKE N'___'

--------------------------------------------------
--PRACTICE

--1. Select database
USE convenienceStoreDB

--------------------------------------------------

--2. Display all employees
SELECT * FROM Employee

--------------------------------------------------

--3. Display employee whose first name is exactly 'Scarlett'
--Expected: 1 row
SELECT * FROM Employee WHERE FirstName = 'Scarlett' 

--------------------------------------------------

--4. Display employees whose first name starts with 'H'
SELECT * FROM Employee WHERE Firstname = 'H%'

-- Clarification (important correction):
-- This query is logically WRONG
-- '=' does NOT support wildcards
-- LIKE must be used with %

--------------------------------------------------

--5. Display employees whose first name starts with 'A'
--Expected: Andrew, Anne
SELECT * FROM Employee WHERE FirstName LIKE 'A%'

--------------------------------------------------

--6. Display employees whose first name ends with 'A'
SELECT * FROM Employee WHERE FirstName LIKE '%A'

--------------------------------------------------

--7. Display employees whose first name CONTAINS 'A'
--Position of 'A' does not matter
SELECT * FROM Employee WHERE FirstName LIKE '%A%'

--------------------------------------------------

--8. Employees whose first name has EXACTLY 3 characters
SELECT * FROM Employee WHERE FirstName LIKE '___'

--Employees whose first name has EXACTLY 2 characters
SELECT * FROM Employee WHERE FirstName LIKE '__'

--------------------------------------------------

--9. Employees whose first name ends with 'e'
SELECT * FROM Employee WHERE FirstName LIKE '%e'

--Employees whose first name has exactly 4 characters
--and ends with 'e'
SELECT * FROM Employee 
WHERE FirstName LIKE '%e' 
AND FirstName LIKE '____'

--Alternative approach
SELECT * FROM Employee WHERE FirstName LIKE '____e'

--------------------------------------------------

--10. Employees whose first name:
--has exactly 6 characters
--AND contains the letter 'A' (any position)
--Expected: 3 rows
SELECT * FROM Employee 
WHERE FirstName LIKE '%A%' 
AND FirstName LIKE '______'

--------------------------------------------------

--11. Find customers whose name has 'I'
--as the 2nd character from the left
SELECT * FROM Customer WHERE FirstName LIKE '_I%'

--------------------------------------------------

--12. Find products whose name has EXACTLY 5 characters
--Expected: 2 rows
SELECT * FROM Product WHERE FirstName LIKE '_____'

--------------------------------------------------

--13. Find products where the LAST word
--in the product name has exactly 5 characters

SELECT * FROM Product 
WHERE ProName LIKE '%_____'
OR ProName LIKE '_____'

-- Clarification:
-- This is an approximation
-- LIKE cannot truly detect "last word"
-- Advanced string functions are required for exact logic

--------------------------------------------------
--ADVANCED

--1. Display products whose name contains a dot '.'
SELECT * FROM Product WHERE ProName LIKE '%,%'

-- Clarification (theory fix):
-- '.' is NOT special in LIKE
-- It does NOT need escaping
-- %,% means: any text + ',' + any text

--------------------------------------------------

--2. Display employees whose address contains '_'

SELECT * FROM Employee WHERE Address LIKE '%[_]%'

SELECT * FROM Employee WHERE Address LIKE '%#_%' ESCAPE '#'

-- Clarification:
-- '_' is a wildcard, so it MUST be escaped
-- ESCAPE defines a custom escape character

--ESCAPE characters can be:
--#, ^, $, ~ (any character you choose)

--------------------------------------------------

--3. Find employees whose name contains a single quote (')

SELECT * FROM Employee WHERE FirstName LIKE '%' ' %'

-- Clarification (important correction):
-- This query is syntactically INVALID
-- To search for single quote, it must be escaped:
-- Example: LIKE '%''%'

--------------------------------------------------

--Demo: SQL Injection attack (DANGEROUS example)

SELECT * FROM table
WHERE username = '' 
AND username LIKE 'and password = '123'

-- Advanced note (VERY IMPORTANT):
-- This demonstrates SQL Injection
-- NEVER build SQL queries using string concatenation
-- Always use parameterized queries or prepared statements

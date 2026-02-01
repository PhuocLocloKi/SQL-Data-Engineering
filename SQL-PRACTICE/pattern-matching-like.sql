
USE convenienceStoreDB;

-- 2. List all Employees
SELECT * FROM Employee;

-- 3. Exact Match: Find employee named 'Scarlett'
-- Result: Returns rows where FirstName is EXACTLY 'Scarlett'
SELECT * FROM Employee WHERE FirstName = 'Scarlett';

-- 4. Find employees whose name starts with 'H'
-- Logic: 'H' followed by anything.
SELECT * FROM Employee WHERE FirstName LIKE 'H%';

-- 5. Find employees whose name starts with 'A'
SELECT * FROM Employee WHERE FirstName LIKE 'A%';

-- 6. Find employees whose name ENDS with 'A'
-- Logic: Anything followed by 'A' at the end.
SELECT * FROM Employee WHERE FirstName LIKE '%A';

-- 7. Find employees whose name CONTAINS 'A'
-- Logic: 'A' can be at the start, middle, or end.
SELECT * FROM Employee WHERE FirstName LIKE '%A%';

-- 8. Find employees with a name of EXACTLY 3 characters
SELECT * FROM Employee WHERE FirstName LIKE '___'; -- 3 underscores

-- 8.1 Find employees with a name of EXACTLY 2 characters
SELECT * FROM Employee WHERE FirstName LIKE '__';  -- 2 underscores

-- 9. Find employees with names ending in 'e'
SELECT * FROM Employee WHERE FirstName LIKE '%e';

-- 9.1 Find employees with exactly 4 characters, ending in 'e'
-- Logic: 3 unknown chars + 'e' = 4 chars total.
-- [Correction]: Your original code '____e' meant 5 chars.
SELECT * FROM Employee WHERE FirstName LIKE '___e'; 

-- 10. Find employees with exactly 6 characters, containing 'A'
-- Logic: Length is 6 AND contains 'A'.
SELECT * FROM Employee 
WHERE FirstName LIKE '______'      -- Length check
  AND FirstName LIKE '%A%';        -- Content check

-- 11. Find Customers where the 2nd letter of the address is 'I'
-- Logic: 1 random char + 'I' + anything else.
SELECT * FROM Customer WHERE Address LIKE '_I%';

-- 12. Find Products with a name of EXACTLY 5 characters
-- [Correction]: Use 'ProName' instead of 'FirstName' for Product table.
SELECT * FROM Product WHERE ProName LIKE '_____';

-- 13. Find Products where the LAST WORD has 5 characters
-- Logic: 
-- Case 1: The name IS the word (Total 5 chars) -> '_____'
-- Case 2: The name ends with space + 5 chars -> '% _____'
SELECT * FROM Product 
WHERE ProName LIKE '% _____' 
   OR ProName LIKE '_____';

-- 1. Find Products containing a dot (.)
-- Note: Dot is not a wildcard, so we can use it directly.
SELECT * FROM Product WHERE ProName LIKE '%.%';

-- 2. Find Employees where Address contains an underscore (_)
-- Since '_' is a wildcard, we must "Escape" it to treat it as text.

-- Method A: Using Brackets [] (SQL Server specific)
SELECT * FROM Employee WHERE Address LIKE '%[_]%';

-- Method B: Using ESCAPE keyword (Standard SQL)
-- Logic: Tell SQL that '#' is the escape character.
SELECT * FROM Employee WHERE Address LIKE '%#_%' ESCAPE '#';

-- 3. Find Employees with a single quote (') in their name (e.g., O'Neil)
-- Rule: To write a single quote in SQL string, you type it twice ('').
SELECT * FROM Employee WHERE FirstName LIKE '%''%';

-- The query below simulates a hacking attempt where the user inputs
-- malicious code into a search box.
-- Input:  ' OR '1'='1
-- Result: The database returns ALL data because '1'='1' is always True.



/* DANGEROUS QUERY DEMO (DO NOT RUN IN PRODUCTION):
   SELECT * FROM Users
   WHERE Username = '' OR '1'='1'; -- This bypasses authentication!
*/
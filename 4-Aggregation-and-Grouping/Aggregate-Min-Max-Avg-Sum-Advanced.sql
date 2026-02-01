--Aggregate-Min-Max-Avg-Sum-Advanced
-- Setup Environment
CREATE DATABASE YEC2_Aggrerate
USE YEC2_Aggrerate

CREATE	TABLE GPA(
      name nVarChar(10),
	  points float,
	  major char(2)
)


insert into GPA values(N'An', 9, 'IS')
insert into GPA values(N'Bình', 7, 'IS')
insert into GPA values(N'Cường', 5, 'IS')

insert into GPA values(N'Dũng', 8, 'JS')
insert into GPA values(N'Em', 7, 'JS')
insert into GPA values(N'Giang', 4, 'JS')
insert into GPA values(N'Hương', 8, 'JS')

insert into GPA values(N'Khanh', 7, 'ES')
insert into GPA values(N'Minh', 6, 'ES')
insert into GPA values(N'Nam', 5, 'ES')
insert into GPA values(N'Oanh', 5, 'ES')

-- MIN, MAX, AVG, SUM
-- All four are classified as Aggregate Functions.
-- [!] IMPORTANT: Aggregate functions CANNOT be nested directly.
-- Example: MAX(COUNT(column)) is INVALID (Syntax Error).
-- However, you can combine multiple columns or multiple aggregates in one SELECT statement.

---------------------------------------------------------
-- AGGREGATE FUNCTIONS & SUBQUERIES PRACTICE
---------------------------------------------------------
-- Find the student(s) with the highest score
SELECT * FROM GPA WHERE points >= all(SELECT points FROM GPA)

-- Using MAX to find the highest value
SELECT MAX(points) FROM GPA;

-- Find the student(s) with the highest score using a Subquery
SELECT * FROM GPA WHERE points = (SELECT MAX(points) FROM GPA);

-- 1. How many students are there in total?
SELECT COUNT(*) FROM GPA;

-- 2. How many students are in the Information Systems (IS) major?
SELECT COUNT(*) FROM GPA WHERE major = 'IS';

-- 2.1. How many students are in Embedded Systems ('JS') and IS combined?
-- (Note: 'IN' operator allows selecting multiple values)
SELECT COUNT(*) FROM GPA WHERE major IN ('JS', 'IS');

-- 2.2. What is the highest score in the student list?
SELECT MAX(points) FROM GPA;

-- 2.3. Who is the student with the highest score?
SELECT * FROM GPA WHERE points = (SELECT MAX(points) FROM GPA);

-- Using ALL operator to compare against the entire set
SELECT * FROM GPA WHERE points >= ALL (SELECT points FROM GPA);

-- 2.4. Calculate the total points of all students
SELECT SUM(points) FROM GPA;

-- 2.5. Calculate the average score of all students (rounded to 2 decimal places)
SELECT ROUND(AVG(points), 2) FROM GPA;

---------------------------------------------------------
-- 3. GROUP BY FUNDAMENTALS
---------------------------------------------------------

-- Requirement: "How many students does EACH major have?"
-- [!] KEYWORD TRIGGER: When you see "EACH" or "PER", you must use GROUP BY.

-- DEFINITION: GROUP BY clusters rows based on a specific standard/column.
-- Example Scenarios:
-- 1. Count students based on Year of Birth (e.g., 2000: 10, 2002: 5).
-- 2. Count candidates per City (e.g., HCM: 100, DN: 200).

-- SYNTAX ORDER: 
-- SELECT ... FROM ... WHERE ... GROUP BY ... ORDER BY ...

-- [!] THE GOLDEN RULE (THE MANTRA):
-- When using GROUP BY, the SELECT clause can ONLY contain:
-- 1. The columns specified in the GROUP BY clause.
-- 2. Aggregate functions (COUNT, SUM, AVG, MAX, MIN).
-- (You cannot select a raw column that hasn't been grouped or aggregated).

-- 3. Count the number of students per major
SELECT major, COUNT(name) AS StudentCount
FROM GPA
GROUP BY major;

-- 4. Find the highest score for each major
SELECT major, MAX(points) AS MaxScore
FROM GPA
GROUP BY major;

-- 5. Find the average score for each major
SELECT major, AVG(points) AS AvgScore
FROM GPA
GROUP BY major;

---------------------------------------------------------
-- DATA MANIPULATION (INSERTING EDGE CASES)
---------------------------------------------------------
-- Insert more data to increase difficulty (Testing edge cases)

-- Add a student named 'Phuong' with 8 points in Japanese major ('JP')
INSERT INTO GPA VALUES(N'Phượng', 8, 'JP');

-- Add a new major 'Hotel Management' (HT) with NULL student info
-- (Used to test how COUNT/AVG handles NULLs)
INSERT INTO GPA VALUES(NULL, NULL, 'HT');

-- Expected Data Snapshot:
-- ES: 4 students
-- HT: 0 students (or 1 row with NULLs)
-- IS: 3 students
-- JP: 1 student
-- JS: 4 students

----------------------------------------------------------------------------------------------------Here is the professional English translation for the remaining section of your SQL exercises. I have refined the comments to use standard database terminology (e.g., "Filtering Groups," "Derived Table," "Scalar Subquery").

SQL
---------------------------------------------------------
-- 5. FILTERING GROUPS (HAVING CLAUSE)
---------------------------------------------------------

-- Requirement: Which majors have 4 or more students?
-- Note: We are selecting from a derived table (subquery result), but standard syntax usually does this directly.
SELECT major, ld.sl
FROM (
    SELECT major, COUNT(name) as [sl] FROM GPA GROUP BY major
) as [ld]
GROUP BY major
HAVING COUNT(name) >= 4;

-- SYNTAX RULE: SELECT... FROM... WHERE... GROUP BY... HAVING... ORDER BY...
-- KEY DIFFERENCE:
-- WHERE: Filters rows BEFORE grouping.
-- HAVING: Filters groups AFTER aggregation (the "WHERE" for groups).

---------------------------------------------------------
-- 6. FINDING THE MINIMUM AGGREGATE (FEWEST STUDENTS)
---------------------------------------------------------

-- Requirement: Which major has the FEWEST students?

-- Approach 1: Using ALL()
-- (Find groups where count <= counts of all other groups)

-- Approach 2: Using MIN() with a Subquery
-- First: Count students per major.
SELECT major, COUNT(name) as sl FROM GPA GROUP BY major;

-- Second: Find the minimum value from that list.
SELECT MIN(sl) FROM (SELECT major, COUNT(name) as sl FROM GPA GROUP BY major) as sl;

-- Third: Combine to find the major matching that minimum value.
SELECT major, COUNT(name) as sl FROM GPA 
GROUP BY major
HAVING COUNT(name) = (
    SELECT MIN(sl) FROM (
        SELECT major, COUNT(name) as sl FROM GPA GROUP BY major
    ) as ld
);

---------------------------------------------------------
-- 7. CONDITIONAL AGGREGATION & DETAILS
---------------------------------------------------------

-- 7. What is the highest score in the IS major?
SELECT MAX(points) FROM GPA WHERE major = 'IS';

-- 7.1. Retrieve FULL details of the student(s) with the max score in IS
-- Note: Grouping by Name/Major/Points here acts like a DISTINCT filter.
SELECT name, major, MAX(points) 
FROM GPA
GROUP BY major, points, name 
HAVING major = 'IS';

-- 8. Find the highest score for EACH major
SELECT major, MAX(points) FROM GPA GROUP BY major;

-- Handling NULLs: Using IIF (Ternary Operator) to replace NULL with 0
SELECT major, IIF(MAX(points) IS NULL, 0, MAX(points)) 
FROM GPA GROUP BY major;

-- 9. Which majors have a "Valedictorian" (Top Scorer) with points > 8?
SELECT major, IIF(MAX(points) IS NULL, 0, MAX(points)) 
FROM GPA 
GROUP BY major  
HAVING MAX(points) > 8; 

--=======================================================
--              ORDERS DATASET EXERCISES
--=======================================================

-- 14. What is the maximum freight weight across all shipped orders?
-- Method A: Using ALL
SELECT OrdID, CustomerID, Freight FROM Orders 
WHERE Freight >= ALL(SELECT Freight FROM Orders);

-- Method B: Using MAX
SELECT Freight FROM Orders 
WHERE Freight >= ALL(SELECT MAX(Freight) FROM Orders); 
-- Note: The query above is slightly redundant; usually SELECT MAX(Freight) FROM Orders is sufficient.

-- 14.1. Which specific order has the heaviest freight?
-- Output: OrderID, CustomerID, Weight
-- Logic: Retrieve the value that is >= all other values in the set.
-- Using ALL:
SELECT OrdID, CustomerID, Freight FROM Orders 
WHERE Freight >= ALL(SELECT Freight FROM Orders);

-- Using MAX (scalar):
SELECT MAX(Freight) FROM Orders;

---------------------------------------------------------
-- GROUPING BY COUNTRY
---------------------------------------------------------

-- 15. Count the number of orders per Country
-- Keyword "EACH" -> implies GROUP BY standard.
SELECT ShipCountry, COUNT(ShipCountry) as SL FROM Orders GROUP BY ShipCountry;
SELECT * FROM Orders; -- (View raw data)

-- 15.1. Which countries have 8 or more orders?
-- Step 1: Count orders per country.
-- Step 2: Filter the results (Post-Aggregation Filter).
-- Solution: Use HAVING.
SELECT ShipCountry, COUNT(ShipCountry) as SL FROM Orders 
GROUP BY ShipCountry
HAVING COUNT(ShipCountry) >= 8;

---------------------------------------------------------
-- 16. FINDING THE MAXIMUM OF A COUNT (MOST ORDERS)
---------------------------------------------------------

-- Requirement: Which country has the MOST orders?
-- Logic: Count per country -> Find Max of those counts -> Filter country matching Max.

-- Method 1: Using ALL
SELECT ShipCountry, COUNT(ShipCountry) as  SL  FROM Orders
GROUP BY ShipCountry
HAVING COUNT(ShipCountry) >= ALL (SELECT COUNT(ShipCountry) as SL FROM Orders GROUP BY ShipCountry);

-- Method 2: Using MAX on a Derived Table
-- Since SQL does not allow MAX(COUNT(*)), we must nest queries.
-- We treat the result of the count as a temporary table, then find MAX.
SELECT ShipCountry, COUNT(ShipCountry) as SL FROM Orders
GROUP BY ShipCountry
HAVING COUNT(ShipCountry) = (
    SELECT MAX(SL) FROM (
        SELECT ShipCountry, COUNT(ShipCountry) as SL FROM Orders
        GROUP BY ShipCountry
    ) as CountTable
);

---------------------------------------------------------
-- 17 - 18. GROUPING BY CARRIER (SHIPPER)
---------------------------------------------------------

-- 17. How many orders did EACH shipping company handle?
-- Hint: Group by ShipID (or ShipVia)
SELECT ShipID, COUNT(ShipID) FROM Orders GROUP BY ShipID;

-- 18. Which shipping company handled the FEWEST orders?
-- Method A: Using ALL
SELECT ShipID, COUNT(ShipID) FROM Orders GROUP BY ShipID
HAVING COUNT(ShipID) <= ALL (SELECT COUNT(ShipID) FROM Orders GROUP BY ShipID);

-- Method B: Using MIN on a Derived Table
SELECT ShipID, COUNT(ShipID) FROM Orders GROUP BY ShipID
HAVING COUNT(ShipID) = (
    SELECT MIN(SL) FROM (
        SELECT ShipID, COUNT(ShipID) as SL FROM Orders 
        GROUP BY ShipID
    ) as CountTable
);

---------------------------------------------------------
-- 19 - 20. SUMMARIZING DATA (SUM)
---------------------------------------------------------

-- 19. List Customers with the TOTAL freight weight of all their orders
SELECT CustomerID, SUM(Freight) as [SUM OF FREIGHT] 
FROM Orders 
GROUP BY CustomerID;

-- 20. Which Customer has the HIGHEST total freight weight?
-- Method A: Using ALL
SELECT CustomerID, SUM(Freight) as [SUM OF FREIGHT] FROM Orders
GROUP BY CustomerID
HAVING SUM(Freight) >= ALL (
    SELECT SUM(Freight) as [SUM OF FREIGHT] FROM Orders
    GROUP BY CustomerID
);

-- Method B: Using MAX (Multiple Columns / Derived Table logic)
SELECT CustomerID, SUM(Freight) as [SUM OF FREIGHT] FROM Orders
GROUP BY CustomerID
HAVING SUM(Freight) = (
    SELECT MAX([SUM OF FREIGHT]) FROM (
        SELECT CustomerID, SUM(Freight) as [SUM OF FREIGHT] FROM Orders
        GROUP BY CustomerID
    ) as SumTable
);

-------------------------------------------------------------------------------------------------
---------------------------------------------------------
-- 20. FINDING MAX AGGREGATE USING DERIVED TABLES
---------------------------------------------------------
-- Method: Multi-column aggregation. 
-- Logic: Filter groups where the sum equals the maximum sum found in a derived table.
SELECT CustomerID, SUM(Freight) as [SUM OF FREIGHT] 
FROM Orders
GROUP BY CustomerID
HAVING SUM(Freight) = (
    SELECT MAX([SUM OF FREIGHT]) 
    FROM (
        SELECT CustomerID, SUM(Freight) as [SUM OF FREIGHT] 
        FROM Orders 
        GROUP BY CustomerID
    ) as SumTable
);

-- 21. Total orders for 'NY' and 'London'
-- Approach 1: Using COUNT with WHERE IN
SELECT ShipCity, COUNT(OrdID) 
FROM Orders 
WHERE ShipCity IN ('NY', 'London')
GROUP By ShipCity;

-- Approach 2: Summing the results of a grouped subquery
SELECT SUM(s1) FROM (
    SELECT ShipCity, COUNT(OrdID) as s1 
    FROM Orders 
    WHERE ShipCity IN ('NY', 'London')
    GROUP BY ShipCity
) as CityCounts;

-- 22. Which shipping company handled the MOST orders?
-- Method A: Using ALL
SELECT ShipID, COUNT(ShipID) FROM Orders GROUP BY ShipID
HAVING COUNT(ShipID) >= ALL(SELECT COUNT(ShipID) FROM Orders GROUP BY ShipID);

-- Method B: Using MAX on a Derived Table
SELECT ShipID, COUNT(ShipID) FROM Orders GROUP BY ShipID
HAVING COUNT(ShipID) = (
    SELECT MAX(SL) 
    FROM (SELECT ShipID, COUNT(ShipID) as SL FROM Orders GROUP BY ShipID) as CountTable
);

---------------------------------------------------------
-- CUSTOMER & LOCATION ANALYSIS
---------------------------------------------------------

-- 1. List all customers
SELECT * FROM Customer;

-- 2. Count customers per City
-- Problem: Standard COUNT(Column) ignores NULL values.
-- Solution: Use IIF to handle NULLs explicitly (labeling them as 'NULL' or 'Undefined').
SELECT City, IIF(COUNT(CusID) IS NULL, N'NULL', COUNT(CusID)) as SL 
FROM Customer 
GROUP BY City;

-- 3. Count total transaction occurrences by country
-- (Note: This counts every row, regardless of duplicates)
SELECT COUNT(ShipCountry) FROM Orders;

-- Alternative: Grouping to see the list first
SELECT ShipCountry FROM Orders GROUP BY ShipCountry;

-- 4. Count the number of UNIQUE countries involved in orders
-- Keyword: DISTINCT (removes duplicates before counting)
SELECT COUNT(DISTINCT ShipCity) FROM Orders;

-- Alternative logic using a subquery:
-- Step 1: Group by Country (Unique list). Step 2: Count the rows.
SELECT COUNT(ShipCountry)
FROM (SELECT ShipCountry FROM Orders GROUP BY ShipCountry) as UniqueCountries;

-- 5. Count orders PER Country
SELECT ShipCountry, COUNT(OrdID) FROM Orders GROUP BY ShipCountry;

-- 6. Count orders PER Customer
SELECT CustomerID, COUNT(OrdID) FROM Orders GROUP BY CustomerID;

---------------------------------------------------------
-- SPECIFIC FILTERING SCENARIOS
---------------------------------------------------------

-- 7. How many orders did customer 'CUS004' place? (Two approaches)
-- Approach 1: Using GROUP BY + HAVING
SELECT CustomerID, COUNT(OrdID) FROM Orders 
GROUP BY CustomerID HAVING CustomerID = 'CUS004';

-- Approach 2: Aggregate + WHERE (More efficient)
SELECT COUNT(OrdID) FROM Orders
WHERE CustomerID = 'CUS004';

-- 8. Calculate total orders for a specific list of customers (CUS004, 001, 005)
-- Approach 1: Simple Aggregate + WHERE
SELECT COUNT(OrdID) FROM Orders
WHERE CustomerID IN ('CUS004', 'CUS001', 'CUS005');

-- Approach 2: Grouping, Counting, then Summing (Complex way)
SELECT CustomerID, COUNT(OrdID) as SL FROM Orders
WHERE CustomerID IN ('CUS004', 'CUS001', 'CUS005')
GROUP BY CustomerID;

-- Summing the result of the group above:
SELECT SUM(SL) FROM (
    SELECT CustomerID, COUNT(OrdID) as SL FROM Orders
    WHERE CustomerID IN ('CUS004', 'CUS001', 'CUS005')
    GROUP BY CustomerID
) as CustCounts;

-- 9. Count orders per country (Result: 21 rows)
SELECT ShipCountry, COUNT(OrdID) FROM Orders GROUP BY ShipCountry;

-- 10. Count orders specifically for 'USA'
-- Method A: WHERE clause (Filter rows before counting)
SELECT COUNT(OrdID) FROM Orders WHERE ShipCountry = 'USA';

-- Method B: WHERE + GROUP BY (Filter rows, then group)
SELECT COUNT(OrdID) FROM Orders WHERE ShipCountry = 'USA' GROUP BY ShipCountry;

-- Method C: GROUP BY + HAVING (Group all, then filter the group)
SELECT COUNT(OrdID) FROM Orders GROUP BY ShipCountry
HAVING ShipCountry = 'USA';

-- 11. List IDs of customers who have purchased MORE THAN 2 orders
SELECT CustomerID FROM Orders GROUP BY CustomerID
HAVING COUNT(OrdID) > 2;

---------------------------------------------------------
-- ADVANCED MAX/MIN LOGIC REVISITED
---------------------------------------------------------

-- 12. Which country has the HIGHEST number of orders?
-- Logic:
-- 1. Count orders per country (GROUP BY).
-- 2. From those counts, find the MAX value.
-- 3. Filter the original groups to match that MAX value.

-- Step 1 & 2 combined (Finding the max count):
SELECT MAX(CountVal) FROM (
    SELECT COUNT(OrdID) as CountVal, ShipCountry
    FROM Orders GROUP BY ShipCountry
) as LD;

-- Final Solution using ALL:
SELECT COUNT(OrdID) as OrderCount FROM Orders GROUP BY ShipCountry
HAVING COUNT(OrdID) >= ALL(SELECT COUNT(OrdID) FROM Orders GROUP BY ShipCountry);

-- Final Solution using Subquery Max:
SELECT COUNT(OrdID) as OrderCount FROM Orders GROUP BY ShipCountry
HAVING COUNT(OrdID) = (
    SELECT MAX(CountVal) FROM (
        SELECT COUNT(OrdID) as CountVal, ShipCountry 
        FROM Orders GROUP BY ShipCountry
    ) as LD
);

-- 13. How many orders did EACH shipping company handle?
SELECT ShipID, COUNT(OrdID) FROM Orders GROUP BY ShipID;

-- 14. How many orders was EACH employee responsible for?
SELECT EmpID, COUNT(OrdID) FROM Orders GROUP BY EmpID;

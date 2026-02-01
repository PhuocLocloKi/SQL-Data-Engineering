-- 1. List orders shipped to UK, USA, or Japan
-- Syntax: WHERE column IN (value1, value2, ...)
SELECT * FROM Orders 
WHERE ShipCountry IN ('UK', 'USA', 'Japan');

-- 2. List employees NOT living in London or NY
-- Requirement: Demonstrate 3 different methods.

-- Method A: Using NOT IN (Cleanest)
SELECT * FROM Employee 
WHERE City NOT IN ('London', 'NY');

-- Method B: Using NOT with IN
SELECT * FROM Employee 
WHERE NOT City IN ('London', 'NY');

-- Method C: Using Standard Operators (AND + <>)
SELECT * FROM Employee 
WHERE City <> 'London' AND City <> 'NY';

-- 3. List orders with Freight between 50 and 100 pounds
-- Note: BETWEEN is INCLUSIVE (includes both 50 and 100).

-- Method A: Standard Logical Operators (AND)
SELECT * FROM Orders 
WHERE Freight >= 50 AND Freight <= 100
ORDER BY Freight;

-- Method B: Using NOT logic (Excluding the outside range)
-- Logic: Not (Less than 50 OR Greater than 100)
SELECT * FROM Orders 
WHERE NOT (Freight < 50 OR Freight > 100);

-- Method C: Using BETWEEN (Professional Standard)
SELECT * FROM Orders 
WHERE Freight BETWEEN 50 AND 100
ORDER BY Freight;

-- 4. List orders shipped in 2021, EXCLUDING June, July, August, Sept
-- Requirement: Solve using 2 methods.

-- Method A: Using NOT IN
SELECT * FROM Orders 
WHERE YEAR(ShippedDate) = 2021 
  AND MONTH(ShippedDate) NOT IN (6, 7, 8, 9);

-- Method B: Using NOT BETWEEN (Completing your unfinished query)
SELECT * FROM Orders 
WHERE YEAR(ShippedDate) = 2021 
  AND NOT (MONTH(ShippedDate) BETWEEN 6 AND 9);
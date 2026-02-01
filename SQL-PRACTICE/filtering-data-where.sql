-- 1. List all employees
SELECT * FROM Employee;

-- 2. List employees currently living in California
SELECT * FROM Employee
WHERE City = 'California';

-- 3. List employees in London with specific columns
-- Output: ID, Full Name, Job Title, Address
SELECT 
      EmpID,
      FirstName + ' ' + LastName AS FullName,
      Title,
      Address
FROM Employee
WHERE City = 'London';

-- 4. List employees in London OR California
-- [Error Fix]: Added missing 'SELECT *' at the beginning
SELECT * FROM Employee
WHERE City = 'London' OR City = 'California';

-- 5. List employees in London OR New York (NY)
-- [Logic Fix]: Changed second 'NY' to 'London' to match the requirement
SELECT * FROM Employee 
WHERE City = 'NY' OR City = 'London';

-- 6. List all Orders
SELECT * FROM Orders;

-- 7. List orders NOT shipped to 'Hàng Mã'
-- Method 1: Using != (Non-standard but common)
SELECT * FROM Orders WHERE ShipCity != N'Hàng mã';

-- Method 2: Using <> (ISO Standard SQL - Professional Choice)
SELECT * FROM Orders WHERE ShipCity <> N'Hàng mã';

-- Method 3: Using NOT with = 
SELECT * FROM Orders WHERE NOT (ShipCity = N'Hàng mã'); 

-- 8. List orders NOT sent to 'Hàng Mã' AND NOT sent to 'London'
-- Logic: Exclude both cities.
SELECT * FROM Orders 
WHERE ShipCity != N'Hàng mã' AND ShipCity != 'London';

-- Alternative using De Morgan's Law: NOT (A OR B)
SELECT * FROM Orders 
WHERE NOT (ShipCity = N'Hàng mã' OR ShipCity = 'London');

-- 9. (Redundant) Same logic as #8
SELECT * FROM Orders 
WHERE NOT ShipCity = N'Hàng mã' AND NOT ShipCity = 'London';

-- 10. List employees with the title 'Promotion'
SELECT * FROM Employee WHERE Title = 'Promotion';

-- 11. List employees whose title is NOT 'Promotion'
SELECT * FROM Employee WHERE Title != 'Promotion';
SELECT * FROM Employee WHERE Title <> 'Promotion'; -- (Best Practice)
SELECT * FROM Employee WHERE NOT Title = 'Promotion';

-- 12. List employees with title 'Promotion' OR 'Telesale'
-- [Typo Fix]: Corrected 'promition' to 'Promotion'
SELECT * FROM Employee 
WHERE Title = 'Promotion' OR Title = 'Telesale';

-- 13. List employees with title 'Promotion' OR 'Mentor'
SELECT * FROM Employee 
WHERE Title = 'Promotion' OR Title = 'Mentor';

-- 14. List employees whose title is NEITHER 'Promotion' NOR 'Telesale'
-- Method 1: Using NOT (A OR B)
SELECT * FROM Employee 
WHERE NOT (Title = 'Promotion' OR Title = 'Telesale');

-- Method 2: Using != AND !=
SELECT * FROM Employee 
WHERE Title != 'Promotion' AND Title != 'Telesale';

-- 16. List employees born before 1972
SELECT * FROM Employee WHERE YEAR(Birthday) < 1972;

-- 17. List employees older than 40, sorted by age
SELECT *, 
       YEAR(GETDATE()) - YEAR(Birthday) AS [Age]
FROM Employee
WHERE (YEAR(GETDATE()) - YEAR(Birthday) > 40)
ORDER BY Age;

-- 18. List orders heavier than 100 lbs and shipped to London
SELECT * FROM Orders 
WHERE Freight > 100 AND ShipCity = 'London';

-- 19. List customers aged 22 to 28 living in London
-- [Logic Fix]: Adjusted > 21 and < 29 (which means 22-28)
SELECT * FROM Customer 
WHERE (YEAR(GETDATE()) - YEAR(Birthday)) > 21
  AND (YEAR(GETDATE()) - YEAR(Birthday)) < 29
  AND City = 'London';

-- 20. List customers from UK or Vietnam
SELECT * FROM Customer
WHERE Country = 'UK' OR Country = 'VietNam';

-- 21. List orders shipped to Vietnam OR Japan
-- [Critical Fix]: Changed 'AND' to 'OR'. 
-- A shipment cannot be to UK AND Japan at the same time.
SELECT * FROM Orders
WHERE ShipCountry = N'VietNam' OR ShipCountry = N'Japan';

-- 22. List orders with weight between 100 and 500
SELECT * FROM Orders 
WHERE Freight >= 100 AND Freight <= 500;
-- Pro Tip: Use 'WHERE Freight BETWEEN 100 AND 500'

-- 23. Sort the above list by weight descending
SELECT * FROM Orders
WHERE Freight >= 100 AND Freight <= 500
ORDER BY Freight DESC;

-- 24. List orders sent to UK, USA, Vietnam sorted by weight
SELECT * FROM Orders
WHERE ShipCountry = 'UK' OR ShipCountry = 'USA' OR ShipCountry = 'VietNam'
ORDER BY Freight ASC;
-- Pro Tip: Use 'WHERE ShipCountry IN ('UK', 'USA', 'VietNam')'

-- 25. List orders NOT sent to UK, France, USA with weight 50-100
-- Sorted by weight
SELECT * FROM Orders
WHERE ShipCountry != 'UK' 
  AND ShipCountry != 'USA' 
  AND ShipCountry != 'France'
  AND Freight > 50
  AND Freight < 100
ORDER BY Freight;

-- 26. List employees born between 1970 and 1999 (exclusive)
SELECT * FROM Employee
WHERE YEAR(Birthday) < 1999 AND YEAR(Birthday) > 1970;
-- 1. List all Customer information
SELECT * FROM Customer;

-- 2. List orders sorted by Weight (Freight)
-- Default sort order is Ascending (ASC) - from smallest to largest.
SELECT * FROM Orders ORDER BY Freight;

-- 3. Sort employees by First Name
SELECT * FROM Employee ORDER BY FirstName;

-- 4. Multi-level Sorting
-- Requirement: Sort orders by Employee ID (Ascending) 
-- AND by Freight (Descending) for each employee.
-- Logic: It groups same EmpIDs together, then inside that group, it sorts Freight high to low.

SELECT * FROM Orders ORDER BY EmpID ASC, Freight DESC;

-- 1. List all employees with full details
-- SELECT *: Retrieves ALL columns from the table.
SELECT * FROM Employee; -- Retrieve all columns from the Employee table

-- 2. List employees with specific information only (Projection)
-- Output: Employee ID, First Name, Last Name, Birthday
SELECT EmpID, FirstName, LastName, Birthday FROM Employee;

-- 3. List employees with custom column names (Aliasing)
-- Output: EmpID, Full Name, Year of Birth (YOB)

-- Method 1: Using 'AS' (Standard SQL)
SELECT EmpID,
       FirstName + ' ' + LastName AS [Full Name],
       YEAR(Birthday) AS [YOB]
FROM Employee;

-- Method 2: Using '=' (T-SQL Specific)
SELECT EmpID,
       [Full Name] = FirstName + ' ' + LastName,
       [YOB] = YEAR(Birthday)
FROM Employee;

-- 4. List employees with calculated columns
-- Output: EmpID, Full Name, Age
-- Logic: Current Year - Birth Year = Age
SELECT EmpID,
       FirstName + ' ' + LastName AS [Full Name],
       YEAR(GETDATE()) - YEAR(Birthday) AS [Age]
FROM Employee;

-- 5. Display information of all Suppliers
SELECT * FROM Supplier;

-- 6. Display information of all Product Categories
SELECT * FROM Category;

-- 7. Display information of all Products
SELECT * FROM Product;

-- 8. Display information of all Shipping Companies
SELECT * FROM Shipper;

-- 9. Check inventory items in the Barn
SELECT * FROM Barn;

-- 10. List all sold Orders
SELECT * FROM Orders;

-- 11. List sold orders with specific details
-- Output: Order ID, Customer ID, Employee ID, Freight
SELECT OrdID, CustomerID, EmpID, Freight 
FROM Orders;

-- 12. Display Order Details (Line items)
SELECT * FROM OrdersDetail;
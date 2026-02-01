
------------------------------------------------------------
--[SQL LEARNING DOCUMENT]
--Part 01-relational-join-techniques.sql
--Topic: Combining tables horizontally using JOIN
------------------------------------------------------------

/*
OVERVIEW
--------
JOIN is used to combine columns from two or more tables
based on a related column (usually Primary Key – Foreign Key).

JOIN is the CORE concept of Relational Databases.
*/

------------------------------------------------------------
--1. PRIMARY KEY AND FOREIGN KEY
------------------------------------------------------------

/*
PRIMARY KEY (PK)
- Uniquely identifies each row in a table
- Must be UNIQUE
- Must NOT be NULL
- Each table has only ONE primary key
- Can be a single column or composite key
*/

/*
FOREIGN KEY (FK)
- References a primary key in another table
- Used to create relationships between tables
- Can contain NULL values
- A table can have multiple foreign keys
*/

------------------------------------------------------------
--2. TYPES OF JOIN
------------------------------------------------------------

------------------------------------------------------------
--2.1 INNER JOIN
--Returns only matching rows between two tables
------------------------------------------------------------

SELECT *
FROM Table_A A
INNER JOIN Table_B B
    ON A.ID = B.ID;

/*
INNER JOIN = INTERSECTION
Rows that exist in BOTH tables
*/

------------------------------------------------------------
--2.2 LEFT JOIN
--Returns all rows from LEFT table
--Unmatched rows from RIGHT table become NULL
------------------------------------------------------------

SELECT *
FROM Table_A A
LEFT JOIN Table_B B
    ON A.ID = B.ID;

/*
LEFT table is the "base table"
LEFT table NEVER loses rows
*/

------------------------------------------------------------
--2.3 RIGHT JOIN
--Returns all rows from RIGHT table
--Unmatched rows from LEFT table become NULL
------------------------------------------------------------

SELECT *
FROM Table_A A
RIGHT JOIN Table_B B
    ON A.ID = B.ID;

------------------------------------------------------------
--2.4 FULL OUTER JOIN
--Returns ALL rows from both tables
--Unmatched rows become NULL on the missing side
------------------------------------------------------------

SELECT *
FROM Table_A A
FULL JOIN Table_B B
    ON A.ID = B.ID;

------------------------------------------------------------
--2.5 CROSS JOIN
--Cartesian product: rows_A × rows_B
--EXTREMELY DANGEROUS if data is large
------------------------------------------------------------

SELECT *
FROM Table_A
CROSS JOIN Table_B;

------------------------------------------------------------
--3. JOIN MORE THAN TWO TABLES
------------------------------------------------------------

SELECT
    O.OrderID,
    C.CustomerName,
    P.ProductName
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN Products P  ON O.ProductID  = P.ProductID;

------------------------------------------------------------
--4. SELF JOIN
--Joining a table with itself
------------------------------------------------------------

/*
Common use cases:
- Employee ↔ Manager
- Category ↔ ParentCategory
- Leader ↔ Member
*/

SELECT
    E.EmployeeID,
    E.EmployeeName,
    M.EmployeeName AS ManagerName
FROM Employee E
LEFT JOIN Employee M
    ON E.ManagerID = M.EmployeeID;

------------------------------------------------------------
--5. IMPORTANT JOIN NOTES
------------------------------------------------------------

/*
NOTE 1: Always use table ALIAS
- Improves readability
- Avoids ambiguity
*/

--BAD
SELECT CustomerID FROM Customer JOIN Orders ON CustomerID = CustomerID;

--GOOD
SELECT C.CustomerID
FROM Customer C
JOIN Orders O ON C.CustomerID = O.CustomerID;

/*
NOTE 2: Ambiguous column name error
Occurs when a column exists in multiple tables
Solution: Always prefix with alias
*/

------------------------------------------------------------
--6. SHORT PRACTICE EXERCISES
------------------------------------------------------------

--EX1: List all customers and their orders (including customers without orders)
SELECT C.CustomerID, C.CustomerName, O.OrderID
FROM Customer C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID;

--EX2: Find customers who have NOT placed any orders
SELECT C.CustomerID, C.CustomerName
FROM Customer C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

--EX3: Count number of orders per customer
SELECT C.CustomerID, COUNT(O.OrderID) AS OrderCount
FROM Customer C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID;

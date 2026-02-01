-- 1. SET ACTIVE DATABASE
-- =====================================================
USE convenienceStoreDB;

-- =====================================================
-- 2. BASIC NULL CHECKS
-- =====================================================

-- 2. List all Customers
SELECT * FROM Customer;

-- 3. List Customers who do NOT have a phone number (Missing Data)
-- [!] CRITICAL RULE: You cannot use "PhoneNumber = NULL".
-- NULL is not a value, it is a state of "Unknown". You must use "IS NULL".



SELECT * FROM Customer WHERE PhoneNumber IS NULL;

-- 4. List Customers who HAVE updated their phone number (3 Methods)
-- Requirement: Field must have data.

-- Method A: Standard (Best Practice)
SELECT * FROM Customer WHERE PhoneNumber IS NOT NULL;

-- Method B: Negating IS NULL
SELECT * FROM Customer WHERE NOT (PhoneNumber IS NULL);

-- Method C: Double Negation (Theoretical / "Mental Gymnastics")
-- Logic: NOT (NOT (IS NOT NULL)) -> IS NOT NULL
SELECT * FROM Customer WHERE NOT NOT PhoneNumber IS NOT NULL;

-- =====================================================
-- 3. COMBINING NULL CHECKS WITH LOGIC
-- =====================================================

-- 5. List orders with NO Required Date AND shipped to London or California
-- Requirement: Solve using 2 methods.

-- Method A: Standard IS NULL
SELECT * FROM Orders 
WHERE RequiredDate IS NULL 
  AND ShipCity IN ('London', 'California');

-- Method B: Using NOT IS NOT NULL
SELECT * FROM Orders 
WHERE NOT (RequiredDate IS NOT NULL) 
  AND ShipCity IN ('London', 'California');

-- 6. List orders that definitely have a Required Date
SELECT * FROM Orders WHERE RequiredDate IS NOT NULL;

-- 7. List orders with a Required Date shipped by carriers SHIP001 or SHIP004
SELECT * FROM Orders 
WHERE ShipID IN ('SHIP001', 'SHIP004')
  AND RequiredDate IS NOT NULL;

-- 8. List orders in London that have a Required Date (Non-null)
-- Method A: Using Equals (=)
SELECT * FROM Orders 
WHERE RequiredDate IS NOT NULL AND ShipCity = 'London';

-- Method B: Using IN (Valid for single item lists too)
SELECT * FROM Orders 
WHERE RequiredDate IS NOT NULL AND ShipCity IN ('London');
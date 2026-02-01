/*
 * TOPIC: ELIMINATING DUPLICATES (DISTINCT)
 */

-- 1. List all Customer information
SELECT * FROM Customer;

-- 2. List the cities where customers are located
-- Requirement: List unique cities only (remove duplicates)
-- Keyword: DISTINCT is used to return only different (unique) values.



SELECT DISTINCT City FROM Customer;

-- 3. List inventory items currently in the Barn (Warehouse)
SELECT * FROM Barn;

-- 4. List all Import Bills (Input Bills)
SELECT * FROM InputBill;
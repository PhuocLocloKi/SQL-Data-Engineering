-- 1. Print a "fact" (String Literal)
-- N'' is used for Unicode characters (e.g., Vietnamese accents)
SELECT N'Studying at FPT is a mistake';

-- 2. Print the sum of 5 + 10
-- Keyword: AS (Alias) renames the result column
SELECT 5 + 10 AS Total;

-- 3. Print the current System Date & Time
SELECT GETDATE() AS CurrentDateTime;

-- 4. Print the current Year
SELECT YEAR(GETDATE()) AS CurrentYear;

-- 5. Print the current Month
SELECT MONTH(GETDATE()) AS CurrentMonth;

-- 6. Print relationship status
SELECT N'NO LOVER FOUND';
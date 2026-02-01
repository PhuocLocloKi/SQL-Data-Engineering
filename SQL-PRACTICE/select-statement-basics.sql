-- 1. Print a "fact" (String literal)
SELECT N'Studying at FPT is a mistake'

-- 2. Print the sum of 5 + 10
SELECT 5 + 10 AS Total -- Total is the column alias

-- 3. Print the current date and time
SELECT GETDATE()

-- 4. Print the current year
SELECT YEAR(GETDATE()) AS CurrentYear

-- 5. Print the current month
SELECT MONTH(GETDATE()) AS CurrentMonth

-- 6. Print your name combined with your lover's name
SELECT N'HAVE NO LOVER'
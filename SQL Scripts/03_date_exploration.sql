/*
===============================================================================
 Script Name : 03_date_exploration.sql
 Description : Explore the date range and time-related characteristics of the
               sales and customer data available in the Gold Layer.

               The analysis identifies the sales period, order distribution
               across years and months, and customer age characteristics.
===============================================================================
*/


-- ==========================================================
-- SALES DATE EXPLORATION
-- ==========================================================

-- Find the first and last order dates
-- Also determine the approximate number of years covered by sales data
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;


------------------------------------------------------------

-- Explore the number of orders by year
SELECT
    YEAR(order_date) AS order_year,
    COUNT(*) AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


------------------------------------------------------------

-- Explore the number of orders by month
SELECT
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_month;


------------------------------------------------------------

-- Explore order volume by year and month
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;


------------------------------------------------------------

-- Identify the year with the highest number of orders
SELECT TOP 1
    YEAR(order_date) AS order_year,
    COUNT(*) AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY total_orders DESC;


-- ==========================================================
-- CUSTOMER DATE / AGE EXPLORATION
-- ==========================================================

-- Find the oldest and youngest customer birth dates
SELECT
    MIN(birthdate) AS oldest_birth_date,
    MAX(birthdate) AS youngest_birth_date
FROM gold.dim_customers;


------------------------------------------------------------

-- Estimate the age range of customers
SELECT
    MIN(birthdate) AS oldest_birth_date,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birth_date,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers
WHERE birthdate IS NOT NULL;


------------------------------------------------------------

-- Explore customer distribution by birth year
SELECT
    YEAR(birthdate) AS birth_year,
    COUNT(*) AS customer_count
FROM gold.dim_customers
WHERE birthdate IS NOT NULL
GROUP BY YEAR(birthdate)
ORDER BY birth_year;


------------------------------------------------------------

-- Explore customer creation by year
SELECT
    YEAR(create_date) AS customer_created_year,
    COUNT(*) AS customers_created
FROM gold.dim_customers
WHERE create_date IS NOT NULL
GROUP BY YEAR(create_date)
ORDER BY customer_created_year;

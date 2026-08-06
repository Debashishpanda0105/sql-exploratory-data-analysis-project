/*
===============================================================================
 Script Name : 02_dimension_exploration.sql
 Description : Explore all business dimensions available in the Gold Layer.
               This script helps understand customers, products, categories,
               and other descriptive attributes before performing analysis.
===============================================================================
*/

-- ==========================================================
-- CUSTOMER DIMENSION EXPLORATION
-- ==========================================================

-- Explore all countries where customers are located
SELECT DISTINCT
    country
FROM gold.dim_customers
ORDER BY country;

------------------------------------------------------------

-- Explore customer gender distribution
SELECT DISTINCT
    gender
FROM gold.dim_customers
ORDER BY gender;

------------------------------------------------------------

-- Explore marital status values
SELECT DISTINCT
    marital_status
FROM gold.dim_customers
ORDER BY marital_status;

------------------------------------------------------------

-- Explore customer creation years
SELECT DISTINCT
    YEAR(create_date) AS customer_created_year
FROM gold.dim_customers
ORDER BY customer_created_year;

------------------------------------------------------------

-- Count total customers
SELECT
    COUNT(*) AS total_customers
FROM gold.dim_customers;

------------------------------------------------------------

-- Preview customer dimension
SELECT TOP (20) *
FROM gold.dim_customers;


-- ==========================================================
-- PRODUCT DIMENSION EXPLORATION
-- ==========================================================

-- Explore product categories and subcategories
SELECT DISTINCT
    category,
    sub_category
FROM gold.dim_products
ORDER BY category, sub_category;

------------------------------------------------------------

-- Explore product lines
SELECT DISTINCT
    product_line
FROM gold.dim_products
ORDER BY product_line;

------------------------------------------------------------

-- Explore maintenance types
SELECT DISTINCT
    maintenance
FROM gold.dim_products
ORDER BY maintenance;

------------------------------------------------------------

-- Count products by category
SELECT
    category,
    COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

------------------------------------------------------------

-- Count products by product line
SELECT
    product_line,
    COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY product_line
ORDER BY total_products DESC;

------------------------------------------------------------

-- Preview product dimension
SELECT TOP (20) *
FROM gold.dim_products;

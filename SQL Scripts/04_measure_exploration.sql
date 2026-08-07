/*
===============================================================================
 Script Name : 04_measure_exploration.sql

 Description :
     Explore the key quantitative measures and business KPIs available in the
     Gold Layer.

     This analysis examines sales performance, order activity, product and
     customer metrics, pricing, revenue contribution, and customer purchasing
     behavior.

     The objective is to establish a quantitative understanding of the business
     before moving into magnitude and ranking analysis.
===============================================================================
*/


-- ==========================================================
-- 1. SALES & REVENUE MEASURES
-- ==========================================================

-- Calculate total sales revenue
SELECT
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the minimum sales value of a transaction
SELECT
    MIN(sales_amount) AS minimum_sales
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the maximum sales value of a transaction
SELECT
    MAX(sales_amount) AS maximum_sales
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average sales value per transaction
SELECT
    AVG(sales_amount) AS average_sales
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the median sales value per transaction
SELECT
    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY sales_amount)
    OVER () AS median_sales
FROM gold.fact_sales;


-- ==========================================================
-- 2. ORDER MEASURES
-- ==========================================================

-- Calculate the total number of unique orders
SELECT
    COUNT(DISTINCT order_name) AS total_orders
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the minimum number of items in an order line
SELECT
    MIN(quantity) AS minimum_quantity
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the maximum number of items in an order line
SELECT
    MAX(quantity) AS maximum_quantity
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average quantity sold per order line
SELECT
    AVG(quantity) AS average_quantity
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average sales value per order
SELECT
    SUM(sales_amount) / NULLIF(COUNT(DISTINCT order_name), 0)
        AS average_order_value
FROM gold.fact_sales;


-- ==========================================================
-- 3. PRODUCT MEASURES
-- ==========================================================

-- Calculate the total number of products
SELECT
    COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products;


------------------------------------------------------------

-- Calculate the minimum product cost
SELECT
    MIN(cost) AS minimum_product_cost
FROM gold.dim_products;


------------------------------------------------------------

-- Calculate the maximum product cost
SELECT
    MAX(cost) AS maximum_product_cost
FROM gold.dim_products;


------------------------------------------------------------

-- Calculate the average product cost
SELECT
    AVG(cost) AS average_product_cost
FROM gold.dim_products;


------------------------------------------------------------

-- Calculate the number of products currently available
SELECT
    COUNT(*) AS active_products
FROM gold.dim_products;


-- ==========================================================
-- 4. CUSTOMER MEASURES
-- ==========================================================

-- Calculate the total number of customers
SELECT
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;


------------------------------------------------------------

-- Calculate the number of customers who have placed at least one order
SELECT
    COUNT(DISTINCT customer_key) AS active_customers
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the number of customers who have never placed an order
SELECT
    COUNT(*) - COUNT(DISTINCT customer_key) AS inactive_customers
FROM gold.dim_customers;


------------------------------------------------------------

-- Calculate the average number of customers per country
SELECT
    COUNT(DISTINCT customer_key) * 1.0
    / NULLIF(COUNT(DISTINCT country), 0) AS avg_customers_per_country
FROM gold.dim_customers;


-- ==========================================================
-- 5. QUANTITY MEASURES
-- ==========================================================

-- Calculate the total quantity of products sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average quantity sold per transaction
SELECT
    AVG(quantity) AS average_quantity_per_line
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the highest quantity sold in a single transaction line
SELECT
    MAX(quantity) AS maximum_quantity_per_line
FROM gold.fact_sales;


-- ==========================================================
-- 6. PRICING MEASURES
-- ==========================================================

-- Calculate the minimum selling price
SELECT
    MIN(price) AS minimum_selling_price
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the maximum selling price
SELECT
    MAX(price) AS maximum_selling_price
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average selling price
SELECT
    AVG(price) AS average_selling_price
FROM gold.fact_sales;


------------------------------------------------------------

-- Compare average product cost with average selling price
SELECT
    AVG(dp.cost) AS average_product_cost,
    AVG(fs.price) AS average_selling_price
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key;


-- ==========================================================
-- 7. CUSTOMER BEHAVIOR MEASURES
-- ==========================================================

-- Calculate the average number of orders per active customer
SELECT
    COUNT(DISTINCT order_name) * 1.0
    / NULLIF(COUNT(DISTINCT customer_key), 0)
        AS average_orders_per_customer
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average sales generated per active customer
SELECT
    SUM(sales_amount) * 1.0
    / NULLIF(COUNT(DISTINCT customer_key), 0)
        AS average_sales_per_customer
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the average quantity purchased per active customer
SELECT
    SUM(quantity) * 1.0
    / NULLIF(COUNT(DISTINCT customer_key), 0)
        AS average_quantity_per_customer
FROM gold.fact_sales;


-- ==========================================================
-- 8. SALES EFFICIENCY MEASURES
-- ==========================================================

-- Calculate revenue generated per item sold
SELECT
    SUM(sales_amount) * 1.0
    / NULLIF(SUM(quantity), 0) AS revenue_per_item
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate sales per order
SELECT
    SUM(sales_amount) * 1.0
    / NULLIF(COUNT(DISTINCT order_name), 0) AS sales_per_order
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate the percentage of customers who have placed an order
SELECT
    COUNT(DISTINCT fs.customer_key) * 100.0
    / NULLIF(COUNT(DISTINCT dc.customer_key), 0)
        AS customer_activation_rate
FROM gold.dim_customers AS dc
LEFT JOIN gold.fact_sales AS fs
    ON dc.customer_key = fs.customer_key;


-- ==========================================================
-- 9. PRODUCT SALES MEASURES
-- ==========================================================

-- Calculate sales generated per product
SELECT
    SUM(sales_amount) * 1.0
    / NULLIF(COUNT(DISTINCT product_key), 0)
        AS average_sales_per_product
FROM gold.fact_sales;


------------------------------------------------------------

-- Calculate quantity sold per product
SELECT
    SUM(quantity) * 1.0
    / NULLIF(COUNT(DISTINCT product_key), 0)
        AS average_quantity_per_product
FROM gold.fact_sales;


-- ==========================================================
-- 10. CONSOLIDATED KPI REPORT
-- ==========================================================

-- Generate a single report containing the major business KPIs

SELECT
    'Total Sales' AS measure_name,
    SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Quantity',
    SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Orders',
    COUNT(DISTINCT order_name)
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Products',
    COUNT(DISTINCT product_key)
FROM gold.dim_products

UNION ALL

SELECT
    'Total Customers',
    COUNT(DISTINCT customer_key)
FROM gold.dim_customers

UNION ALL

SELECT
    'Active Customers',
    COUNT(DISTINCT customer_key)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Selling Price',
    AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Order Value',
    SUM(sales_amount) * 1.0
    / NULLIF(COUNT(DISTINCT order_name), 0)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Quantity Per Order Line',
    AVG(quantity)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Sales Per Customer',
    SUM(sales_amount) * 1.0
    / NULLIF(COUNT(DISTINCT customer_key), 0)
FROM gold.fact_sales;

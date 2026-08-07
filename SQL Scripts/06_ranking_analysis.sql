/*
===============================================================================
 Script Name : 06_ranking_analysis.sql

 Description :
     Perform ranking analysis on products, customers, categories, and countries
     using aggregate functions and SQL window functions.

     The analysis identifies the highest and lowest performing business
     entities based on revenue, sales, quantity, and order activity.

     The objective is to identify top performers, underperformers, and
     high-value customers that can support business decision-making.
===============================================================================
*/


-- ==========================================================
-- 1. TOP 5 PRODUCTS BY REVENUE
-- ==========================================================

-- Identify the top 5 products generating the highest revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-- ==========================================================
-- 2. TOP 5 PRODUCTS USING ROW_NUMBER()
-- ==========================================================

-- Demonstrate ranking with a SQL window function
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY SUM(f.sales_amount) DESC
        ) AS product_rank
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE product_rank <= 5
ORDER BY product_rank;


-- ==========================================================
-- 3. WORST 5 PRODUCTS BY REVENUE
-- ==========================================================

-- Identify the five products generating the lowest revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;


-- ==========================================================
-- 4. TOP 10 CUSTOMERS BY REVENUE
-- ==========================================================

-- Identify the top 10 customers generating the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


-- ==========================================================
-- 5. TOP 10 CUSTOMERS USING RANK()
-- ==========================================================

-- Rank customers while allowing tied revenue values to share the same rank
SELECT *
FROM (
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (
            ORDER BY SUM(f.sales_amount) DESC
        ) AS customer_rank
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
) AS ranked_customers
WHERE customer_rank <= 10
ORDER BY customer_rank;


-- ==========================================================
-- 6. BOTTOM 5 CUSTOMERS BY REVENUE
-- ==========================================================

-- Identify customers generating the lowest revenue
SELECT TOP 5
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue ASC;


-- ==========================================================
-- 7. TOP 10 CUSTOMERS BY NUMBER OF ORDERS
-- ==========================================================

-- Identify customers placing the highest number of orders
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_name) AS total_orders
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC;


-- ==========================================================
-- 8. 3 CUSTOMERS WITH THE FEWEST ORDERS
-- ==========================================================

-- Identify customers with the lowest order activity
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_name) AS total_orders
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;


-- ==========================================================
-- 9. TOP 5 CATEGORIES BY REVENUE
-- ==========================================================

-- Identify the categories contributing the most revenue
SELECT TOP 5
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ==========================================================
-- 10. BOTTOM 5 CATEGORIES BY REVENUE
-- ==========================================================

-- Identify categories generating the lowest revenue
SELECT TOP 5
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue ASC;


-- ==========================================================
-- 11. TOP 5 COUNTRIES BY REVENUE
-- ==========================================================

-- Identify the countries generating the highest revenue
SELECT TOP 5
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_revenue DESC;


-- ==========================================================
-- 12. TOP 5 COUNTRIES BY QUANTITY SOLD
-- ==========================================================

-- Identify countries with the highest product volume
SELECT TOP 5
    c.country,
    SUM(f.quantity) AS total_quantity_sold
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_quantity_sold DESC;


-- ==========================================================
-- 13. TOP 5 PRODUCTS BY QUANTITY SOLD
-- ==========================================================

-- Identify the products with the highest sales volume
SELECT TOP 5
    p.product_name,
    SUM(f.quantity) AS total_quantity_sold
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;


-- ==========================================================
-- 14. TOP 10 CUSTOMERS BY QUANTITY PURCHASED
-- ==========================================================

-- Identify customers purchasing the highest number of items
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.quantity) AS total_quantity
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_quantity DESC;


-- ==========================================================
-- 15. PRODUCT RANKING WITH DENSE_RANK()
-- ==========================================================

-- Rank all products by revenue while keeping consecutive ranks for ties
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(f.sales_amount) DESC
    ) AS product_rank
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY product_rank;


-- ==========================================================
-- 16. CUSTOMER RANKING BY REVENUE
-- ==========================================================

-- Rank every customer based on total revenue generated
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (
        ORDER BY SUM(f.sales_amount) DESC
    ) AS customer_rank
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY customer_rank;


-- ==========================================================
-- 17. CATEGORY RANKING BY REVENUE
-- ==========================================================

-- Rank product categories based on their revenue contribution
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(f.sales_amount) DESC
    ) AS category_rank
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY category_rank;


-- ==========================================================
-- 18. TOP 3 PRODUCTS WITHIN EACH CATEGORY
-- ==========================================================

-- Identify the top products within each category rather than globally
SELECT *
FROM (
    SELECT
        p.category,
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(f.sales_amount) DESC
        ) AS product_rank
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY
        p.category,
        p.product_name
) AS ranked_products
WHERE product_rank <= 3
ORDER BY
    category,
    product_rank;


-- ==========================================================
-- 19. TOP 3 CUSTOMERS WITHIN EACH COUNTRY
-- ==========================================================

-- Identify the highest-value customers within each country
SELECT *
FROM (
    SELECT
        c.country,
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY c.country
            ORDER BY SUM(f.sales_amount) DESC
        ) AS customer_rank
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.country,
        c.customer_key,
        c.first_name,
        c.last_name
) AS ranked_customers
WHERE customer_rank <= 3
ORDER BY
    country,
    customer_rank;


-- ==========================================================
-- 20. FINAL RANKING SUMMARY
-- ==========================================================

-- Create a consolidated view of major business rankings

SELECT TOP 5
    'Product' AS entity_type,
    p.product_name AS entity_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

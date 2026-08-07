--part-to-whole-analysis
/*
===============================================================================
PART-TO-WHOLE ANALYSIS
===============================================================================
Purpose:
    Analyze how individual business entities contribute to the overall
    business performance.

Key Analysis:
    1. Category contribution to total sales
    2. Product contribution to total sales
    3. Customer contribution to total sales
    4. Country contribution to total sales
    5. Quantity contribution by category
    6. Customer contribution by country

Business Use:
    Helps identify the major revenue contributors and understand the
    concentration of business across products, customers, and markets.
===============================================================================
*/


-- ============================================================================
-- 1. CATEGORY CONTRIBUTION TO TOTAL SALES
-- ============================================================================
-- Determine how much each product category contributes to total revenue.

WITH category_sales AS
(
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY
        p.category
)

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND(
        CAST(total_sales AS DECIMAL(18,2))
        / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2),'%') 
    AS percentage_of_total_sales
FROM category_sales
ORDER BY
    total_sales DESC;


-- ============================================================================
-- 2. PRODUCT CONTRIBUTION TO TOTAL SALES
-- ============================================================================
-- Identify products that contribute the most to overall revenue.

WITH product_sales AS
(
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY
        p.product_name
)

SELECT
    product_name,
    total_sales,
    ROUND(
        CAST(total_sales AS DECIMAL(18,2))
        / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2
    ) AS percentage_of_total_sales
FROM product_sales
ORDER BY
    total_sales DESC;


-- ============================================================================
-- 3. CUSTOMER CONTRIBUTION TO TOTAL SALES
-- ============================================================================
-- Determine how much revenue each customer contributes to the business.

WITH customer_sales AS
(
    SELECT
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
)

SELECT
    customer_key,
    customer_name,
    total_sales,
    ROUND(
        CAST(total_sales AS DECIMAL(18,2))
        / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2
    ) AS percentage_of_total_sales
FROM customer_sales
ORDER BY
    total_sales DESC;


-- ============================================================================
-- 4. COUNTRY CONTRIBUTION TO TOTAL SALES
-- ============================================================================
-- Analyze the contribution of each country to total revenue.

WITH country_sales AS
(
    SELECT
        c.country,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.country
)

SELECT
    country,
    total_sales,
    ROUND(
        CAST(total_sales AS DECIMAL(18,2))
        / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2
    ) AS percentage_of_total_sales
FROM country_sales
ORDER BY
    total_sales DESC;


-- ============================================================================
-- 5. CATEGORY CONTRIBUTION BY QUANTITY
-- ============================================================================
-- Determine how much of the total quantity sold comes from each category.

WITH category_quantity AS
(
    SELECT
        p.category,
        SUM(f.quantity) AS total_quantity
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY
        p.category
)

SELECT
    category,
    total_quantity,
    SUM(total_quantity) OVER () AS overall_quantity,
    ROUND(
        CAST(total_quantity AS DECIMAL(18,2))
        / NULLIF(SUM(total_quantity) OVER (), 0) * 100,
        2
    ) AS percentage_of_total_quantity
FROM category_quantity
ORDER BY
    total_quantity DESC;


-- ============================================================================
-- 6. CUSTOMER CONTRIBUTION BY COUNTRY
-- ============================================================================
-- Understand how customers are distributed across countries.

WITH country_customers AS
(
    SELECT
        country,
        COUNT(DISTINCT customer_key) AS total_customers
    FROM gold.dim_customers
    GROUP BY
        country
)

SELECT
    country,
    total_customers,
    SUM(total_customers) OVER () AS overall_customers,
    ROUND(
        CAST(total_customers AS DECIMAL(18,2))
        / NULLIF(SUM(total_customers) OVER (), 0) * 100,
        2
    ) AS percentage_of_total_customers
FROM country_customers
ORDER BY
    total_customers DESC;


-- ============================================================================
-- 7. CATEGORY SALES CONTRIBUTION USING CTE
-- ============================================================================
-- Business-friendly view showing category sales and its share of revenue.

WITH category_sales AS
(
    SELECT
        p.category,
        SUM(f.sales_amount) AS category_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY
        p.category
)

SELECT
    category,
    category_sales,
    ROUND(
        CAST(category_sales AS DECIMAL(18,2))
        / NULLIF(SUM(category_sales) OVER (), 0) * 100,
        2
    ) AS sales_contribution_percentage
FROM category_sales
ORDER BY
    sales_contribution_percentage DESC;

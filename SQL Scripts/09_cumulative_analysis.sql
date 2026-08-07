/*
===============================================================================
Script Name : 09_cumulative_analysis.sql

Purpose:
    Perform cumulative analysis to understand how key business metrics
    accumulate over time.

Business Objectives:
    - Calculate running sales totals over time
    - Track cumulative quantity sold
    - Track cumulative orders and customers
    - Measure cumulative business contribution
    - Identify long-term growth patterns

Key Concepts:
    - Window Functions
    - Running Totals
    - Cumulative Metrics
    - CTEs
    - Aggregation
    - Time-Series Analysis

Data Sources:
    - gold.fact_sales
===============================================================================
*/


/*=============================================================================
1. MONTHLY SALES AND RUNNING TOTAL
===============================================================================
Calculate monthly sales and the cumulative sales generated from the beginning
of the available sales period.
=============================================================================*/

WITH monthly_sales AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    order_month,
    total_sales,

    SUM(total_sales) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales

FROM monthly_sales
ORDER BY order_month;


/*=============================================================================
2. CUMULATIVE QUANTITY SOLD
===============================================================================
Track how the total number of units sold accumulates over time.
=============================================================================*/

WITH monthly_quantity AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(quantity) AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    order_month,
    total_quantity,

    SUM(total_quantity) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_quantity

FROM monthly_quantity
ORDER BY order_month;


/*=============================================================================
3. CUMULATIVE ORDERS
===============================================================================
Track the growth of total orders over time.
=============================================================================*/

WITH monthly_orders AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        COUNT(DISTINCT order_name) AS total_orders
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    order_month,
    total_orders,

    SUM(total_orders) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_orders

FROM monthly_orders
ORDER BY order_month;


/*=============================================================================
4. CUMULATIVE ACTIVE CUSTOMERS
===============================================================================
Measure the cumulative number of unique customers who have placed orders.

Note:
    A customer is counted only once across the entire analysis period.
=============================================================================*/

WITH first_customer_order AS
(
    SELECT
        customer_key,
        MIN(order_date) AS first_order_date
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
      AND customer_key IS NOT NULL
    GROUP BY customer_key
),

monthly_new_customers AS
(
    SELECT
        DATETRUNC(MONTH, first_order_date) AS order_month,
        COUNT(*) AS new_customers
    FROM first_customer_order
    GROUP BY DATETRUNC(MONTH, first_order_date)
)

SELECT
    order_month,
    new_customers,

    SUM(new_customers) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_customers

FROM monthly_new_customers
ORDER BY order_month;


/*=============================================================================
5. CUMULATIVE SALES BY YEAR
===============================================================================
Calculate yearly sales and the cumulative sales generated across years.
=============================================================================*/

WITH yearly_sales AS
(
    SELECT
        YEAR(order_date) AS order_year,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
)

SELECT
    order_year,
    total_sales,

    SUM(total_sales) OVER (
        ORDER BY order_year
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales

FROM yearly_sales
ORDER BY order_year;


/*=============================================================================
6. CUMULATIVE SALES CONTRIBUTION
===============================================================================
Calculate each month's percentage contribution to total sales and the
cumulative percentage contribution over time.
=============================================================================*/

WITH monthly_sales AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    order_month,
    total_sales,

    ROUND(
        total_sales * 100.0 /
        NULLIF(SUM(total_sales) OVER (), 0),
        2
    ) AS sales_percentage,

    ROUND(
        SUM(total_sales) OVER (
            ORDER BY order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 /
        NULLIF(SUM(total_sales) OVER (), 0),
        2
    ) AS cumulative_sales_percentage

FROM monthly_sales
ORDER BY order_month;


/*=============================================================================
7. CUMULATIVE SALES BY PRODUCT
===============================================================================
Identify products that contribute most to total revenue when products are
ordered from highest to lowest sales.
=============================================================================*/

WITH product_sales AS
(
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY p.product_name
)

SELECT
    product_name,
    total_sales,

    SUM(total_sales) OVER (
        ORDER BY total_sales DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales,

    ROUND(
        SUM(total_sales) OVER (
            ORDER BY total_sales DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 /
        NULLIF(SUM(total_sales) OVER (), 0),
        2
    ) AS cumulative_sales_percentage

FROM product_sales
ORDER BY total_sales DESC;


/*=============================================================================
8. CUMULATIVE BUSINESS KPI SUMMARY
===============================================================================
Provide a consolidated view of monthly business performance with cumulative
sales, orders, and quantity.
=============================================================================*/

WITH monthly_kpis AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT order_name) AS total_orders,
        SUM(quantity) AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT
    order_month,
    total_sales,
    total_orders,
    total_quantity,

    SUM(total_sales) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales,

    SUM(total_orders) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_orders,

    SUM(total_quantity) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_quantity

FROM monthly_kpis
ORDER BY order_month;

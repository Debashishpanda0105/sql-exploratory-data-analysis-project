/*
===============================================================================
Script Name : 08_change_over_time_analysis.sql

Purpose:
    Analyze how business performance changes over time by evaluating sales,
    customers, orders, and quantity sold across monthly and yearly periods.

Business Objectives:
    - Identify monthly and yearly sales trends
    - Monitor customer and order growth
    - Measure year-over-year (YoY) sales growth
    - Identify periods of business growth or decline
    - Analyze customer acquisition trends
    - Support management with time-based performance insights

Key Metrics:
    - Total Sales
    - Total Orders
    - Active Customers
    - Total Quantity Sold
    - Average Order Value
    - YoY Sales Growth
    - Customer Growth

Data Sources:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/


/*=============================================================================
1. MONTHLY SALES PERFORMANCE
===============================================================================
Analyze monthly sales, orders, active customers, quantity sold, and
average order value.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT order_name) AS total_orders,
    COUNT(DISTINCT customer_key) AS active_customers,
    SUM(quantity) AS total_quantity,
    AVG(sales_amount) AS avg_sales_per_transaction
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;


/*=============================================================================
2. YEARLY SALES PERFORMANCE
===============================================================================
Analyze annual business performance and compare sales, orders, customers,
and quantity sold across years.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT order_name) AS total_orders,
    COUNT(DISTINCT customer_key) AS active_customers,
    SUM(quantity) AS total_quantity,
    AVG(sales_amount) AS avg_sales_per_transaction
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date)
ORDER BY
    order_year;


/*=============================================================================
3. YEAR-OVER-YEAR SALES GROWTH
===============================================================================
Compare annual sales with the previous year to identify business growth
or decline.
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
    LAG(total_sales) OVER (
        ORDER BY order_year
    ) AS previous_year_sales,

    total_sales -
    LAG(total_sales) OVER (
        ORDER BY order_year
    ) AS sales_change,

    ROUND(
        (total_sales -
        LAG(total_sales) OVER (
            ORDER BY order_year
        ))
        * 100.0
        / NULLIF(
            LAG(total_sales) OVER (
                ORDER BY order_year
            ), 0
        ),
        2
    ) AS yoy_growth_percentage

FROM yearly_sales
ORDER BY order_year;


/*=============================================================================
4. MONTH-OVER-MONTH SALES TREND
===============================================================================
Compare monthly sales with the previous month to identify short-term
business trends.
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

    LAG(total_sales) OVER (
        ORDER BY order_month
    ) AS previous_month_sales,

    total_sales -
    LAG(total_sales) OVER (
        ORDER BY order_month
    ) AS sales_change,

    ROUND(
        (total_sales -
        LAG(total_sales) OVER (
            ORDER BY order_month
        ))
        * 100.0
        / NULLIF(
            LAG(total_sales) OVER (
                ORDER BY order_month
            ), 0
        ),
        2
    ) AS mom_growth_percentage

FROM monthly_sales
ORDER BY order_month;


/*=============================================================================
5. CUSTOMER ACQUISITION OVER TIME
===============================================================================
Measure the number of new customers acquired in each year.
=============================================================================*/

SELECT
    YEAR(create_date) AS create_year,
    COUNT(DISTINCT customer_key) AS new_customers
FROM gold.dim_customers
WHERE create_date IS NOT NULL
GROUP BY YEAR(create_date)
ORDER BY create_year;


/*=============================================================================
6. CUSTOMER ACQUISITION BY MONTH
===============================================================================
Analyze customer acquisition at a monthly level to identify periods with
strong or weak customer growth.
=============================================================================*/

SELECT
    DATETRUNC(MONTH, create_date) AS create_month,
    COUNT(DISTINCT customer_key) AS new_customers
FROM gold.dim_customers
WHERE create_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, create_date)
ORDER BY create_month;


/*=============================================================================
7. YEARLY QUANTITY TREND
===============================================================================
Analyze how the number of products sold changes over time.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    SUM(quantity) AS total_quantity,
    AVG(quantity) AS avg_quantity_per_transaction
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


/*=============================================================================
8. YEARLY ACTIVE CUSTOMER TREND
===============================================================================
Measure the number of unique customers who placed at least one order
during each year.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    COUNT(DISTINCT customer_key) AS active_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


/*=============================================================================
9. YEARLY ORDER TREND
===============================================================================
Track the number of unique orders generated each year.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    COUNT(DISTINCT order_name) AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


/*=============================================================================
10. ROLLING 3-MONTH SALES
===============================================================================
Calculate a rolling three-month sales total to smooth short-term
fluctuations and identify the underlying business trend.
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
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_sales

FROM monthly_sales
ORDER BY order_month;


/*=============================================================================
11. YEARLY AVERAGE ORDER VALUE
===============================================================================
Track the average revenue generated per order by year.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT order_name) AS total_orders,

    ROUND(
        SUM(sales_amount) * 1.0
        / NULLIF(COUNT(DISTINCT order_name), 0),
        2
    ) AS average_order_value

FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


/*=============================================================================
12. BUSINESS PERFORMANCE SUMMARY
===============================================================================
Create a consolidated yearly report containing major business KPIs.
=============================================================================*/

SELECT
    YEAR(order_date) AS order_year,

    SUM(sales_amount) AS total_sales,

    COUNT(DISTINCT order_name) AS total_orders,

    COUNT(DISTINCT customer_key) AS active_customers,

    SUM(quantity) AS total_quantity,

    ROUND(
        SUM(sales_amount) * 1.0
        / NULLIF(COUNT(DISTINCT order_name), 0),
        2
    ) AS average_order_value

FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

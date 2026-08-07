/*
===============================================================================
Customer & Product Reporting
===============================================================================

Purpose:
    This script creates business-oriented analytical reports from the Gold Layer.

Reports Included:
    1. Executive KPI Summary
    2. Customer Report
    3. Product Report
    4. Category Performance Report
    5. Yearly Sales Summary
    6. Top Customers
    7. Top Products
    8. Customer Segmentation Summary

Data Sources:
    - gold.fact_sales
    - gold.dim_customers
    - gold.dim_products

Author:
    Debashish Panda

Tool:
    SQL Server / SSMS
===============================================================================
*/


/*
===============================================================================
1. EXECUTIVE KPI SUMMARY
===============================================================================
Purpose:
    Provide a high-level snapshot of the overall business.
===============================================================================
*/

SELECT
    'Total Sales' AS measure_name,
    SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Orders',
    COUNT(DISTINCT order_name)
FROM gold.fact_sales

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
    'Total Products',
    COUNT(DISTINCT product_key)
FROM gold.dim_products

UNION ALL

SELECT
    'Total Quantity Sold',
    SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Selling Price',
    AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Order Value',
    SUM(sales_amount) /
        NULLIF(COUNT(DISTINCT order_name), 0)
FROM gold.fact_sales;


/*
===============================================================================
2. CUSTOMER REPORT
===============================================================================
Purpose:
    Consolidate customer-level metrics into a single analytical report.

Metrics:
    - Customer information
    - Total orders
    - Total sales
    - Total quantity
    - Total products purchased
    - First order date
    - Last order date
    - Customer lifespan
    - Recency
    - Average order value
===============================================================================
*/

WITH customer_metrics AS
(
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        c.gender,
        c.country,
        c.birthdate,

        COUNT(DISTINCT f.order_name) AS total_orders,

        SUM(f.sales_amount) AS total_sales,

        SUM(f.quantity) AS total_quantity,

        COUNT(DISTINCT f.product_key) AS total_products,

        MIN(f.order_date) AS first_order_date,

        MAX(f.order_date) AS last_order_date

    FROM gold.dim_customers c

    LEFT JOIN gold.fact_sales f
        ON c.customer_key = f.customer_key

    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name,
        c.gender,
        c.country,
        c.birthdate
)

SELECT
    customer_key,
    first_name,
    last_name,
    gender,
    country,
    birthdate,

    total_orders,
    total_sales,
    total_quantity,
    total_products,

    first_order_date,
    last_order_date,

    DATEDIFF(
        MONTH,
        first_order_date,
        last_order_date
    ) AS customer_lifespan_months,

    DATEDIFF(
        MONTH,
        last_order_date,
        (SELECT MAX(order_date) FROM gold.fact_sales)
    ) AS recency_months,

    total_sales /
        NULLIF(total_orders, 0) AS average_order_value

FROM customer_metrics
ORDER BY total_sales DESC;


/*
===============================================================================
3. PRODUCT REPORT
===============================================================================
Purpose:
    Analyze product-level performance.

Metrics:
    - Product information
    - Category
    - Sub-category
    - Total orders
    - Total quantity sold
    - Total revenue
    - Average selling price
    - First sale date
    - Last sale date
===============================================================================
*/

SELECT
    p.product_key,
    p.product_name,
    p.category,
    p.sub_category,
    p.cost,

    COUNT(DISTINCT f.order_name) AS total_orders,

    SUM(f.quantity) AS total_quantity_sold,

    SUM(f.sales_amount) AS total_revenue,

    AVG(f.price) AS average_selling_price,

    MIN(f.order_date) AS first_sale_date,

    MAX(f.order_date) AS last_sale_date

FROM gold.dim_products p

LEFT JOIN gold.fact_sales f
    ON p.product_key = f.product_key

GROUP BY
    p.product_key,
    p.product_name,
    p.category,
    p.sub_category,
    p.cost

ORDER BY total_revenue DESC;


/*
===============================================================================
4. CATEGORY PERFORMANCE REPORT
===============================================================================
Purpose:
    Compare revenue and sales volume across product categories.
===============================================================================
*/

SELECT
    p.category,

    COUNT(DISTINCT p.product_key) AS total_products,

    COUNT(DISTINCT f.order_name) AS total_orders,

    SUM(f.quantity) AS total_quantity_sold,

    SUM(f.sales_amount) AS total_revenue,

    AVG(f.price) AS average_selling_price,

    AVG(p.cost) AS average_product_cost

FROM gold.dim_products p

LEFT JOIN gold.fact_sales f
    ON p.product_key = f.product_key

GROUP BY
    p.category

ORDER BY total_revenue DESC;


/*
===============================================================================
5. YEARLY SALES SUMMARY
===============================================================================
Purpose:
    Provide a year-level business performance report.
===============================================================================
*/

SELECT
    YEAR(order_date) AS order_year,

    COUNT(DISTINCT order_name) AS total_orders,

    COUNT(DISTINCT customer_key) AS total_customers,

    SUM(quantity) AS total_quantity,

    SUM(sales_amount) AS total_sales,

    AVG(sales_amount) AS average_sales_per_transaction,

    SUM(sales_amount) /
        NULLIF(COUNT(DISTINCT order_name), 0)
        AS average_order_value

FROM gold.fact_sales

WHERE order_date IS NOT NULL

GROUP BY
    YEAR(order_date)

ORDER BY
    order_year;


/*
===============================================================================
6. TOP 10 CUSTOMERS REPORT
===============================================================================
Purpose:
    Identify the highest-value customers based on revenue.
===============================================================================
*/

SELECT TOP 10

    c.customer_key,

    CONCAT(
        c.first_name,
        ' ',
        c.last_name
    ) AS customer_name,

    c.country,

    COUNT(DISTINCT f.order_name) AS total_orders,

    SUM(f.quantity) AS total_quantity,

    SUM(f.sales_amount) AS total_revenue

FROM gold.dim_customers c

INNER JOIN gold.fact_sales f
    ON c.customer_key = f.customer_key

GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country

ORDER BY
    total_revenue DESC;


/*
===============================================================================
7. TOP 10 PRODUCTS REPORT
===============================================================================
Purpose:
    Identify products generating the highest revenue.
===============================================================================
*/

SELECT TOP 10

    p.product_key,

    p.product_name,

    p.category,

    p.sub_category,

    SUM(f.quantity) AS total_quantity_sold,

    COUNT(DISTINCT f.order_name) AS total_orders,

    SUM(f.sales_amount) AS total_revenue

FROM gold.dim_products p

INNER JOIN gold.fact_sales f
    ON p.product_key = f.product_key

GROUP BY
    p.product_key,
    p.product_name,
    p.category,
    p.sub_category

ORDER BY
    total_revenue DESC;


/*
===============================================================================
8. CUSTOMER SEGMENTATION REPORT
===============================================================================
Purpose:
    Segment customers based on their total revenue contribution.

Segments:
    - High Value
    - Medium Value
    - Low Value
===============================================================================
*/

WITH customer_sales AS
(
    SELECT

        c.customer_key,

        CONCAT(
            c.first_name,
            ' ',
            c.last_name
        ) AS customer_name,

        SUM(f.sales_amount) AS total_revenue,

        COUNT(DISTINCT f.order_name) AS total_orders,

        SUM(f.quantity) AS total_quantity

    FROM gold.dim_customers c

    INNER JOIN gold.fact_sales f
        ON c.customer_key = f.customer_key

    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
)

SELECT

    customer_key,

    customer_name,

    total_revenue,

    total_orders,

    total_quantity,

    CASE

        WHEN total_revenue >= 5000
            THEN 'High Value Customer'

        WHEN total_revenue >= 2000
            THEN 'Medium Value Customer'

        ELSE 'Low Value Customer'

    END AS customer_segment

FROM customer_sales

ORDER BY
    total_revenue DESC;


/*
===============================================================================
9. CUSTOMER SEGMENT SUMMARY
===============================================================================
Purpose:
    Understand how customers are distributed across value segments.
===============================================================================
*/

WITH customer_sales AS
(
    SELECT

        c.customer_key,

        SUM(f.sales_amount) AS total_revenue

    FROM gold.dim_customers c

    INNER JOIN gold.fact_sales f
        ON c.customer_key = f.customer_key

    GROUP BY
        c.customer_key
),

customer_segments AS
(
    SELECT

        customer_key,

        total_revenue,

        CASE

            WHEN total_revenue >= 5000
                THEN 'High Value'

            WHEN total_revenue >= 2000
                THEN 'Medium Value'

            ELSE 'Low Value'

        END AS customer_segment

    FROM customer_sales
)

SELECT

    customer_segment,

    COUNT(customer_key) AS total_customers,

    SUM(total_revenue) AS total_revenue,

    AVG(total_revenue) AS average_customer_revenue

FROM customer_segments

GROUP BY
    customer_segment

ORDER BY
    total_revenue DESC;


/*
===============================================================================
10. CUSTOMER ACTIVITY REPORT
===============================================================================
Purpose:
    Identify active and inactive customers based on their latest purchase.
===============================================================================
*/

WITH customer_activity AS
(
    SELECT

        c.customer_key,

        CONCAT(
            c.first_name,
            ' ',
            c.last_name
        ) AS customer_name,

        MAX(f.order_date) AS last_order_date,

        SUM(f.sales_amount) AS total_revenue,

        COUNT(DISTINCT f.order_name) AS total_orders

    FROM gold.dim_customers c

    LEFT JOIN gold.fact_sales f
        ON c.customer_key = f.customer_key

    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
)

SELECT

    customer_key,

    customer_name,

    last_order_date,

    total_revenue,

    total_orders,

    DATEDIFF(
        MONTH,
        last_order_date,
        (SELECT MAX(order_date)
         FROM gold.fact_sales)
    ) AS inactive_months,

    CASE

        WHEN last_order_date IS NULL
            THEN 'Never Purchased'

        WHEN DATEDIFF(
                MONTH,
                last_order_date,
                (SELECT MAX(order_date)
                FROM gold.fact_sales)
             ) <= 6
            THEN 'Active'

        WHEN DATEDIFF(
                MONTH,
                last_order_date,
                (SELECT MAX(order_date)
                FROM gold.fact_sales)
             ) <= 12
            THEN 'At Risk'

        ELSE 'Inactive'

    END AS customer_status

FROM customer_activity

ORDER BY
    total_revenue DESC;


/*
===============================================================================
END OF REPORTING SCRIPT
===============================================================================

Business Value:

This reporting layer transforms raw analytical queries into structured
business reports that can support:

    - Executive decision-making
    - Customer analysis
    - Product performance analysis
    - Revenue analysis
    - Customer segmentation
    - Retention analysis
    - Business performance monitoring

===============================================================================
*/

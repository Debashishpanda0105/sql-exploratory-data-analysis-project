/*
===============================================================================
13_reporting.sql
SQL Exploratory Data Analysis Project
Reporting Layer
===============================================================================

Purpose:
    Create reusable, business-ready SQL views for reporting and BI.

The reporting layer transforms the Gold Layer into analytical views
that can be consumed by:

    - SQL Analysts
    - Business Analysts
    - Power BI
    - Tableau
    - Management Reports

Data Sources:
    gold.fact_sales
    gold.dim_customers
    gold.dim_products

Reporting Views:
    1. gold.report_customers
    2. gold.report_products
    3. gold.report_sales

===============================================================================
*/


/*
===============================================================================
1. CUSTOMER REPORT
===============================================================================

Purpose:
    Consolidate customer demographics, purchasing behavior,
    KPIs, segmentation and activity status.

===============================================================================
*/

CREATE OR ALTER VIEW gold.report_customers
AS

WITH customer_base AS
(
    SELECT

        /* Customer Information */
        c.customer_key,
        c.first_name,
        c.last_name,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        c.gender,
        c.marital_status,
        c.birthdate,
        c.create_date,

        /* Purchase Timeline */
        MIN(f.order_date) AS first_order_date,
        MAX(f.order_date) AS last_order_date,

        /* Customer Metrics */
        COUNT(DISTINCT f.order_name) AS total_orders,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        COUNT(DISTINCT f.product_key) AS total_products

    FROM gold.dim_customers AS c

    LEFT JOIN gold.fact_sales AS f
        ON c.customer_key = f.customer_key

    GROUP BY

        c.customer_key,
        c.first_name,
        c.last_name,
        c.country,
        c.gender,
        c.marital_status,
        c.birthdate,
        c.create_date
),

customer_metrics AS
(
    SELECT

        *,

        /* Customer Age */
        CASE
            WHEN birthdate IS NULL THEN NULL

            ELSE
                DATEDIFF(YEAR, birthdate, GETDATE())
                -
                CASE
                    WHEN DATEADD(
                            YEAR,
                            DATEDIFF(YEAR, birthdate, GETDATE()),
                            birthdate
                         ) > GETDATE()
                    THEN 1
                    ELSE 0
                END
        END AS age,

        /* Customer Lifespan */
        CASE
            WHEN first_order_date IS NULL
                THEN 0
            ELSE
                DATEDIFF(
                    MONTH,
                    first_order_date,
                    last_order_date
                )
        END AS lifespan_months,

        /* Recency */
        CASE
            WHEN last_order_date IS NULL
                THEN NULL
            ELSE
                DATEDIFF(
                    MONTH,
                    last_order_date,
                    GETDATE()
                )
        END AS recency_months,

        /* Average Order Value */
        CASE
            WHEN total_orders = 0
                THEN 0
            ELSE
                CAST(total_sales AS DECIMAL(18,2))
                / total_orders
        END AS average_order_value,

        /* Average Monthly Spend */
        CASE
            WHEN first_order_date IS NULL
                THEN 0

            WHEN DATEDIFF(
                    MONTH,
                    first_order_date,
                    last_order_date
                 ) = 0
                THEN CAST(total_sales AS DECIMAL(18,2))

            ELSE
                CAST(total_sales AS DECIMAL(18,2))
                /
                DATEDIFF(
                    MONTH,
                    first_order_date,
                    last_order_date
                )
        END AS average_monthly_spend

    FROM customer_base
)

SELECT

    /*==========================================================
      Customer Attributes
    ==========================================================*/

    customer_key,
    first_name,
    last_name,
    customer_name,
    country,
    gender,
    marital_status,

    /*==========================================================
      Customer Demographics
    ==========================================================*/

    birthdate,
    age,
    create_date,

    /*==========================================================
      Purchase Timeline
    ==========================================================*/

    first_order_date,
    last_order_date,
    lifespan_months,
    recency_months,

    /*==========================================================
      Customer KPIs
    ==========================================================*/

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    average_order_value,
    average_monthly_spend,

    /*==========================================================
      Customer Segmentation
    ==========================================================*/

    CASE

        WHEN total_sales >= 10000
            THEN 'High Value'

        WHEN total_sales >= 5000
            THEN 'Medium Value'

        WHEN total_sales > 0
            THEN 'Low Value'

        ELSE 'No Purchase'

    END AS customer_segment,

    /*==========================================================
      Customer Activity
    ==========================================================*/

    CASE

        WHEN last_order_date IS NULL
            THEN 'Never Purchased'

        WHEN DATEDIFF(
                MONTH,
                last_order_date,
                GETDATE()
             ) <= 6
            THEN 'Active'

        WHEN DATEDIFF(
                MONTH,
                last_order_date,
                GETDATE()
             ) <= 12
            THEN 'At Risk'

        ELSE 'Inactive'

    END AS customer_status

FROM customer_metrics;
GO



/*
===============================================================================
2. PRODUCT REPORT
===============================================================================

Purpose:
    Consolidate product information and sales performance.

Use Cases:
    - Product performance analysis
    - Category analysis
    - Revenue analysis
    - Product ranking
    - Power BI Product Dashboard

===============================================================================
*/

CREATE OR ALTER VIEW gold.report_products
AS

WITH product_base AS
(
    SELECT

        /* Product Information */

        p.product_key,
        p.product_name,
        p.category,
        p.sub_category,
        p.product_line,
        p.cost,

        /* Product Sales Metrics */

        COUNT(DISTINCT f.order_name) AS total_orders,

        SUM(f.sales_amount) AS total_sales,

        SUM(f.quantity) AS total_quantity,

        COUNT(DISTINCT f.customer_key) AS total_customers,

        MIN(f.order_date) AS first_sale_date,

        MAX(f.order_date) AS last_sale_date

    FROM gold.dim_products AS p

    LEFT JOIN gold.fact_sales AS f
        ON p.product_key = f.product_key

    GROUP BY

        p.product_key,
        p.product_name,
        p.category,
        p.sub_category,
        p.product_line,
        p.cost
)

SELECT

    /* Product Information */

    product_key,
    product_name,
    category,
    sub_category,
    product_line,
    cost,

    /* Sales Metrics */

    total_orders,
    total_sales,
    total_quantity,
    total_customers,

    /* Sales Timeline */

    first_sale_date,
    last_sale_date,

    /* Average Selling Price */

    CASE
        WHEN total_quantity = 0
            THEN 0

        ELSE
            CAST(total_sales AS DECIMAL(18,2))
            / total_quantity
    END AS average_selling_price,

    /* Revenue After Product Cost */

    CASE
        WHEN total_quantity = 0
            THEN 0

        ELSE
            total_sales - (cost * total_quantity)
    END AS estimated_profit,

    /* Product Performance */

    CASE

        WHEN total_sales >= 100000
            THEN 'High Performer'

        WHEN total_sales >= 50000
            THEN 'Medium Performer'

        WHEN total_sales > 0
            THEN 'Low Performer'

        ELSE 'No Sales'

    END AS product_segment,

    /* Product Activity */

    CASE

        WHEN last_sale_date IS NULL
            THEN 'No Sales'

        WHEN DATEDIFF(
                MONTH,
                last_sale_date,
                GETDATE()
             ) <= 6
            THEN 'Active'

        ELSE 'Inactive'

    END AS product_status

FROM product_base;
GO



/*
===============================================================================
3. SALES REPORT
===============================================================================

Purpose:
    Create a time-based reporting view for executive reporting,
    trend analysis and Power BI dashboards.

Grain:
    One row per month.

Use Cases:
    - Monthly sales trend
    - Customer trend
    - Quantity trend
    - Year-over-Year analysis
    - Running total
    - Power BI Executive Dashboard

===============================================================================
*/

CREATE OR ALTER VIEW gold.report_sales
AS

WITH monthly_sales AS
(
    SELECT

        DATETRUNC(MONTH, f.order_date) AS sales_month,

        YEAR(f.order_date) AS sales_year,

        MONTH(f.order_date) AS sales_month_number,

        SUM(f.sales_amount) AS total_sales,

        COUNT(DISTINCT f.order_name) AS total_orders,

        COUNT(DISTINCT f.customer_key) AS total_customers,

        SUM(f.quantity) AS total_quantity

    FROM gold.fact_sales AS f

    WHERE f.order_date IS NOT NULL

    GROUP BY

        DATETRUNC(MONTH, f.order_date),
        YEAR(f.order_date),
        MONTH(f.order_date)
)

SELECT

    /* Date Information */

    sales_month,
    sales_year,
    sales_month_number,

    /* Business Metrics */

    total_sales,
    total_orders,
    total_customers,
    total_quantity,

    /* Average Order Value */

    CASE
        WHEN total_orders = 0
            THEN 0

        ELSE
            CAST(total_sales AS DECIMAL(18,2))
            / total_orders
    END AS average_order_value,

    /* Average Quantity per Order */

    CASE
        WHEN total_orders = 0
            THEN 0

        ELSE
            CAST(total_quantity AS DECIMAL(18,2))
            / total_orders
    END AS average_quantity_per_order,

    /* Running Total */

    SUM(total_sales) OVER
    (
        ORDER BY sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_sales,

    /* Previous Month Sales */

    LAG(total_sales) OVER
    (
        ORDER BY sales_month
    ) AS previous_month_sales,

    /* Month-over-Month Difference */

    total_sales
    -
    LAG(total_sales) OVER
    (
        ORDER BY sales_month
    ) AS month_over_month_difference,

    /* Month-over-Month Growth % */

    CASE

        WHEN LAG(total_sales) OVER
        (
            ORDER BY sales_month
        ) IS NULL

        THEN NULL

        WHEN LAG(total_sales) OVER
        (
            ORDER BY sales_month
        ) = 0

        THEN NULL

        ELSE

            CAST
            (
                (
                    total_sales
                    -
                    LAG(total_sales) OVER
                    (
                        ORDER BY sales_month
                    )
                )
                * 100.0
                /
                LAG(total_sales) OVER
                (
                    ORDER BY sales_month
                )
                AS DECIMAL(18,2)
            )

    END AS month_over_month_growth

FROM monthly_sales;
GO



/*
===============================================================================
4. REPORT VALIDATION
===============================================================================

Use these queries to validate the reporting layer.

===============================================================================
*/


/*---------------------------------------------------------
Customer Report
---------------------------------------------------------*/

SELECT TOP 20 *
FROM gold.report_customers
ORDER BY total_sales DESC;


/*---------------------------------------------------------
Product Report
---------------------------------------------------------*/

SELECT TOP 20 *
FROM gold.report_products
ORDER BY total_sales DESC;


/*---------------------------------------------------------
Sales Report
---------------------------------------------------------*/

SELECT *
FROM gold.report_sales
ORDER BY sales_month;



/*
===============================================================================
5. BUSINESS REPORTING QUERIES
===============================================================================
*/


/*---------------------------------------------------------
Top 10 Customers
---------------------------------------------------------*/

SELECT TOP 10

    customer_key,
    customer_name,
    country,
    total_orders,
    total_sales,
    average_order_value,
    customer_segment

FROM gold.report_customers

ORDER BY total_sales DESC;



/*---------------------------------------------------------
Top 10 Products
---------------------------------------------------------*/

SELECT TOP 10

    product_key,
    product_name,
    category,
    total_orders,
    total_sales,
    total_quantity,
    estimated_profit,
    product_segment

FROM gold.report_products

ORDER BY total_sales DESC;



/*---------------------------------------------------------
Customer Segment Distribution
---------------------------------------------------------*/

SELECT

    customer_segment,

    COUNT(*) AS total_customers,

    SUM(total_sales) AS total_sales,

    AVG(total_sales) AS average_customer_sales

FROM gold.report_customers

GROUP BY customer_segment

ORDER BY total_sales DESC;



/*---------------------------------------------------------
Product Category Performance
---------------------------------------------------------*/

SELECT

    category,

    COUNT(*) AS total_products,

    SUM(total_sales) AS total_sales,

    SUM(total_quantity) AS total_quantity,

    SUM(estimated_profit) AS estimated_profit

FROM gold.report_products

GROUP BY category

ORDER BY total_sales DESC;



/*---------------------------------------------------------
Monthly Business Performance
---------------------------------------------------------*/

SELECT

    sales_month,
    total_sales,
    total_orders,
    total_customers,
    total_quantity,
    average_order_value,
    cumulative_sales,
    month_over_month_growth

FROM gold.report_sales

ORDER BY sales_month;

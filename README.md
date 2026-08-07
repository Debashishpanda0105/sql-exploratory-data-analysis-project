# 📊 SQL Exploratory Data Analysis Project & Business Insights Project

Welcome to the **SQL Exploratory Data Analysis (EDA) & Business Insights Project**! 🚀

This project demonstrates how SQL can be used to explore, analyze, and generate business insights from a modern Data Warehouse. Using the curated **Gold Layer** of a SQL Server Data Warehouse, this project answers real-world business questions through exploratory data analysis and analytical SQL queries.

---

# 🚀 Project Overview

The objective of this project is to perform **Exploratory Data Analysis (EDA)** using SQL Server. The analysis is built on top of a dimensional data model created in the **SQL Data Warehouse Project**, enabling business users and analysts to better understand customer behavior, product performance, and sales trends.

Unlike traditional dashboards, this project focuses on extracting insights directly using SQL.

---

# 🔗 Related Project

This project uses the **Gold Layer** created in my SQL Data Warehouse Project.

➡️ **SQL Data Warehouse Project**
> https://github.com/Debashishpanda0105/sql-data-warehouse-project
---

# 🎯 Project Objectives

- Explore the data warehouse structure
- Understand business dimensions
- Analyze historical sales data
- Generate key business metrics (KPIs)
- Measure business performance
- Rank customers and products
- Answer real-world business questions using SQL

---

# 📂 Data Source

This project uses the **Gold Layer** from the SQL Data Warehouse Project.

### Fact Table

- `gold.fact_sales`

### Dimension Tables

- `gold.dim_customers`
- `gold.dim_products`

---

# 📁 Project Structure

```text
sql-exploratory-data-analysis-project
│
├── SQL Scripts/
│
│   ├── 01_database_exploration.sql
│   ├── 02_dimension_exploration.sql
│   ├── 03_date_exploration.sql
│   ├── 04_measure_exploration.sql
│   ├── 05_magnitude_analysis.sql
│   ├── 06_ranking_analysis.sql
│   ├── 07_business_questions.sql
│
│   ├── 08_change_over_time_analysis.sql
│   ├── 09_cumulative_analysis.sql
│   ├── 10_performance_analysis.sql
│   ├── 11_part_to_whole_analysis.sql
│   ├── 12_data_segmentation.sql
│   └── 13_reporting.sql
│
├── Documentation/
│   ├── Business_Requirements.md
│   ├── Analysis_Methodology.md
│   ├── SQL_Query_Explanation.md
│   └── Business_Insights.md
│
├── Images/
│   ├── star_schema.png
│   ├── project_architecture.png
│   ├── workflow.png
│   └── sql_analysis.png
│
├── README.md
└── LICENSE
```

---

# 📊 Analysis Modules

## 1️⃣ Database Exploration

Explore the overall structure and metadata of the Gold Layer.

### Topics Covered

- Database Information
- Schemas
- Tables
- Columns
- Row Counts
- Metadata
- Table Relationships

---

## 2️⃣ Dimension Exploration

Analyze the descriptive business entities available in the data warehouse.

### 👥 Customer Analysis

- Countries
- Gender
- Marital Status
- Customer Distribution

### 📦 Product Analysis

- Product Categories
- Sub Categories
- Product Lines
- Product Distribution

---

## 3️⃣ Date Exploration

Analyze the available sales timeline and customer age information.

### Topics Covered

- First Order Date
- Last Order Date
- Sales Duration
- Available Sales Years
- Oldest Customer
- Youngest Customer
- Customer Age Analysis

---

## 4️⃣ Measure Exploration

Generate key business metrics and KPIs.

### Key Measures

- Total Sales
- Total Orders
- Total Customers
- Total Products
- Total Quantity Sold
- Average Selling Price
- Average Order Value
- Average Quantity per Order
- Minimum Sales
- Maximum Sales
- Minimum Order Value
- Maximum Order Value

### Business KPI Report

A consolidated KPI report is created to provide a quick overview of overall business performance.

---

## 5️⃣ Magnitude Analysis

Measure business performance across different dimensions.

### Analysis Examples

- Customers by Country
- Customers by Gender
- Products by Category
- Average Product Cost by Category
- Revenue by Country
- Revenue by Category
- Revenue by Product
- Revenue by Customer
- Quantity Sold by Country
- Sales by Gender
- Sales by Marital Status

### Objective

Understand the magnitude and distribution of business performance across customers, products, and geographical dimensions.

---

## 6️⃣ Ranking Analysis

Identify the highest and lowest performing business entities.

### Analysis Examples

- Top 5 Products by Revenue
- Bottom 5 Products by Revenue
- Top 10 Customers by Revenue
- Customers with the Fewest Orders
- Top Categories by Revenue
- Top Countries by Sales
- Best Performing Products
- Worst Performing Products

### SQL Techniques

- `TOP`
- `ORDER BY`
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- Window Functions

---

## 7️⃣ Business Questions

Answer real-world business questions using analytical SQL.

### Examples

- Which customers generate the highest revenue?
- Which products sell the most?
- Which country has the highest sales?
- Which product category performs best?
- What is the average order value?
- Which year generated the highest revenue?
- Which customers purchased only once?
- Which products are underperforming?
- Which customers should be targeted for retention?
- Which products require business attention?

---

# 📈 Phase 2 — Advanced Analytics

The second phase extends the basic EDA into advanced analytical techniques used in real-world business analytics.

---

## 8️⃣ Change-Over-Time Analysis

Analyze how business metrics change across different time periods.

### Analysis Examples

- Yearly Sales Trends
- Monthly Sales Trends
- Quarterly Sales Trends
- Revenue Growth
- Year-over-Year (YoY) Analysis
- Customer Growth Over Time
- Quantity Trends
- Order Trends
- Average Sales Trends

### Business Questions

- How are sales changing year over year?
- Which year generated the highest revenue?
- Which months show the highest sales?
- Is the business growing or declining?
- How does customer activity change over time?
- Are order volumes increasing or decreasing?

### SQL Techniques

- `YEAR()`
- `MONTH()`
- `DATENAME()`
- `DATEPART()`
- `LAG()`
- `LEAD()`
- Window Functions

---

## 9️⃣ Cumulative Analysis

Analyze cumulative business performance over time.

### Analysis Examples

- Running Total of Sales
- Cumulative Revenue
- Cumulative Quantity
- Cumulative Orders
- Year-to-Date Performance
- Running Customer Count

### Business Questions

- How does revenue accumulate over time?
- How much revenue has been generated up to a specific period?
- Which period contributed most to cumulative revenue?
- How quickly is the business reaching its annual revenue targets?

### SQL Techniques

- Window Functions
- `SUM() OVER()`
- `PARTITION BY`
- `ORDER BY`

---

## 🔟 Performance Analysis

Evaluate business performance by comparing current results with previous periods or benchmarks.

### Analysis Examples

- Current Year vs Previous Year
- Current Month vs Previous Month
- Product Performance
- Customer Performance
- Category Performance
- Revenue Growth
- Performance Comparison
- Year-over-Year Performance
- Month-over-Month Performance

### Business Questions

- Which products improved their performance?
- Which products declined?
- Which customers are increasing their purchases?
- Which categories are performing above or below expectations?
- Which products require management attention?
- Which business areas are showing positive growth?

### SQL Techniques

- `LAG()`
- `LEAD()`
- `CASE WHEN`
- Window Functions
- Percentage Change Calculations

---

## 1️⃣1️⃣ Part-to-Whole Analysis

Understand how individual business entities contribute to the overall business.

### Analysis Examples

- Category Contribution to Total Revenue
- Product Contribution to Total Revenue
- Country Contribution to Total Sales
- Customer Contribution to Total Revenue
- Percentage of Sales by Category
- Percentage of Revenue by Product

### Business Questions

- Which category contributes the most to total revenue?
- What percentage of revenue comes from the top products?
- Which country contributes the largest share of sales?
- How much revenue is generated by the top customers?
- Which products have the largest contribution to overall sales?

### SQL Techniques

- Aggregate Functions
- Window Functions
- `SUM() OVER()`
- Percentage Calculations
- Common Table Expressions (CTEs)

---

## 1️⃣2️⃣ Data Segmentation

Segment customers and products into meaningful business groups.

### 👥 Customer Segmentation

Customers can be classified based on:

- Revenue
- Purchase Frequency
- Number of Orders
- Quantity Purchased
- Customer Activity
- Spending Behavior

### Example Customer Segments

| Segment | Description |
|---|---|
| High Value Customers | Customers generating high revenue |
| Medium Value Customers | Customers generating moderate revenue |
| Low Value Customers | Customers generating relatively low revenue |

### 📦 Product Segmentation

Products can be classified based on:

- Revenue
- Sales Volume
- Quantity Sold
- Product Cost
- Product Category
- Product Performance

### Example Product Segments

| Segment | Description |
|---|---|
| High Performers | Products generating high revenue |
| Mid Performers | Products generating moderate revenue |
| Low Performers | Products generating low revenue |

### Business Questions

- Who are our high-value customers?
- Which customers generate the majority of revenue?
- Which products are high performers?
- Which products are underperforming?
- Which customer segments should receive targeted marketing?
- Which products require promotional strategies?

### SQL Techniques

- `CASE WHEN`
- Aggregations
- CTEs
- Window Functions
- Revenue-Based Segmentation

---

## 1️⃣3️⃣ Reporting

The final stage converts analytical findings into business-oriented reporting.

### 📊 Reporting Includes

- Executive KPIs
- Sales Summary
- Customer Summary
- Product Summary
- Revenue Trends
- Top Performers
- Bottom Performers
- Customer Segments
- Product Segments
- Business Trends
- Key Business Findings

### Example Executive Metrics

- Total Revenue
- Total Orders
- Total Customers
- Total Products
- Total Quantity Sold
- Average Order Value
- Top Revenue Product
- Top Revenue Customer
- Best Performing Category
- Best Performing Country

### Reporting Objective

The goal is to transform SQL analysis into **clear, concise, and actionable business insights** that can support data-driven decision-making.

---

# 🛠️ Technologies Used

--Fundamentals
SELECT
WHERE
DISTINCT
ORDER BY
GROUP BY
HAVING
--Joins
INNER JOIN
LEFT JOIN
--Aggregation
SUM
COUNT
AVG
MIN
MAX
--Conditional Logic
CASE WHEN
COALESCE
--Date Analysis
MIN / MAX Date
DATEDIFF
DATEPART
YEAR
MONTH
Date grouping


---

# 📈 SQL Concepts Covered

- SELECT Statements
- Filtering Data
- Sorting
- GROUP BY
- HAVING
- INNER JOIN
- LEFT JOIN
- Aggregate Functions
- CASE WHEN
- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Date Functions
--Advanced SQL
-Common Table Expressions (CTEs)
-Subqueries
-Window Functions
-ROW_NUMBER
-RANK
-DENSE_RANK
-Running Totals
-Partitioning
-Percentage Calculations

---

# 💼 Business Insights Generated

This project helps answer questions such as:

- Which customers contribute the highest revenue?
- Which products drive sales growth?
- Which product categories perform best?
- What are the monthly and yearly sales trends?
- Which countries generate the most revenue?
- What is the average order value?
- Which customers should be targeted for retention?
- Which products require business attention?

---

# 📊 Skills Demonstrated

- Exploratory Data Analysis (EDA)
- Business Analytics
- SQL Query Optimization
- Data Exploration
- Data Aggregation
- Window Functions
- Ranking Analysis
- KPI Development
- Business Reporting
- Analytical Thinking

---

# 🔄 Project Workflow

```text
Gold Layer
      │
      ▼
Database Exploration
      │
      ▼
Dimension Exploration
      │
      ▼
Date Exploration
      │
      ▼
Measure Exploration
      │
      ▼
Magnitude Analysis
      │
      ▼
Ranking Analysis
      │
      ▼
Business Questions
      │
      ▼
Business Insights
```

---

# 🎯 Learning Outcomes

Through this project, I gained hands-on experience in:

- SQL Exploratory Data Analysis
- Business Analytics
- SQL Window Functions
- Ranking Analysis
- KPI Development
- Business Reporting
- Analytical SQL
- Data Exploration
- Data Interpretation

---

# 🚀 Future Enhancements

- Power BI Dashboard Integration

---

# 📄 License

This project is licensed under the **MIT License**.

---

# 👨‍💻 About Me

Hi, I'm **Debashish Panda**.

🎓 MCA Graduate | 📊 Data Analyst | 💾 SQL Developer | 📈 Business Intelligence Enthusiast

I enjoy transforming raw data into meaningful business insights using SQL, Data Analytics, and Business Intelligence. I am passionate about solving real-world business problems through data-driven decision-making.

---

## ⭐ If you found this project useful, consider giving it a Star!

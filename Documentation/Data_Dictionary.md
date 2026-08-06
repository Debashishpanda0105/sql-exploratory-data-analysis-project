# Data Dictionary

## Overview

This document describes the business meaning of each table and column used in the SQL Exploratory Data Analysis project.

---

# Tables

## 1. gold.dim_customers

Dimension table containing customer information.

| Column | Data Type | Description |
|---------|-----------|-------------|
| customer_key | INT | Surrogate key generated for the customer dimension |
| customer_id | INT | Original customer identifier from CRM |
| customer_number | NVARCHAR | Business customer number |
| first_name | NVARCHAR | Customer first name |
| last_name | NVARCHAR | Customer last name |
| country | NVARCHAR | Customer country |
| marital_status | NVARCHAR | Customer marital status |
| gender | NVARCHAR | Customer gender |
| birthdate | DATE | Customer birth date |
| create_date | DATE | Customer record creation date |

---

## 2. gold.dim_products

Dimension table containing product information.

| Column | Data Type | Description |
|---------|-----------|-------------|
| product_key | INT | Surrogate key generated for the product dimension |
| product_id | INT | Original product identifier |
| product_number | NVARCHAR | Business product code |
| product_name | NVARCHAR | Product name |
| category_id | NVARCHAR | Product category identifier |
| category | NVARCHAR | Product category |
| sub_category | NVARCHAR | Product subcategory |
| maintenance | NVARCHAR | Maintenance classification |
| cost | INT | Product cost |
| product_line | NVARCHAR | Product line |
| start_date | DATE | Product effective start date |

---

## 3. gold.fact_sales

Fact table containing sales transactions.

| Column | Data Type | Description |
|---------|-----------|-------------|
| order_name | NVARCHAR | Sales order number |
| product_key | INT | Foreign key to dim_products |
| customer_key | INT | Foreign key to dim_customers |
| order_date | DATE | Order date |
| shipping_date | DATE | Shipping date |
| due_date | DATE | Due date |
| sales_amount | INT | Total sales amount |
| quantity | INT | Quantity sold |
| price | INT | Unit selling price |

---

# Relationships

```

dim_customers (1)
|
| customer_key
|
fact_sales
|
| product_key
|
dim_products (1)

```

---

# Data Model

The project follows a **Star Schema**, where:

- Dimension tables provide descriptive attributes.
- Fact table stores transactional sales data.
- Surrogate keys are used for efficient joins.

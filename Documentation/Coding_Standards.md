# SQL Coding Standards

## Purpose

This document defines the SQL coding standards followed throughout the project to improve readability, maintainability, and consistency.

---

# Naming Conventions

## Schemas

| Schema | Purpose |
|---------|---------|
| bronze | Raw source data |
| silver | Cleaned and transformed data |
| gold | Business-ready analytical data |

---

## Tables

Use lowercase with underscores.

Example

```
dim_customers
fact_sales
crm_cust_info
erp_cust_az12
```

---

## Views

Prefix analytical views appropriately.

Example

```
gold.dim_customers
gold.dim_products
gold.fact_sales
```

---

## Aliases

Use meaningful aliases.

Example

```
cu = Customer
pr = Product
sd = Sales Details
```

Avoid aliases like:

```
a
b
x
y
```

---

# Formatting

Keywords should be uppercase.

Example

```sql
SELECT
FROM
WHERE
GROUP BY
ORDER BY
```

---

Each column should appear on a new line.

Preferred:

```sql
SELECT
    customer_id,
    first_name,
    last_name
FROM gold.dim_customers;
```

---

# Comments

Use comments only where business logic or complex transformations require clarification.

Good example:

```sql
-- Select the latest customer record based on the creation date
```

Avoid obvious comments such as:

```sql
-- Select data
```

---

# Joins

Always use explicit JOIN syntax.

Preferred:

```sql
INNER JOIN
LEFT JOIN
```

Avoid implicit joins.

---

# NULL Handling

Always handle NULL values appropriately.

Preferred functions:

- ISNULL()
- COALESCE()
- NULLIF()

---

# Window Functions

Use window functions when ranking or deduplicating data.

Examples:

- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LEAD()
- LAG()

---

# Business Rules

Business logic should be implemented using:

- CASE expressions
- CTEs
- Window Functions

rather than hard-coded values whenever possible.

---

# Best Practices

✔ Write readable SQL.

✔ Use meaningful names.

✔ Keep queries modular.

✔ Avoid duplicate logic.

✔ Comment only complex transformations.

✔ Maintain consistent formatting.

✔ Validate data quality before analysis.

✔ Optimize queries for performance.

---

# Version Control

- Store SQL scripts in Git.
- Commit logical changes.
- Use descriptive commit messages.
- Maintain documentation alongside code.

---

Following these standards ensures consistency, maintainability, and scalability across all SQL scripts in this project.

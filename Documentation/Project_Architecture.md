# Project Architecture

## Overview

This project is built on top of a modern SQL Server Data Warehouse following the **Medallion Architecture**.

The Gold Layer serves as the analytical data source for SQL-based Exploratory Data Analysis.

---

# Architecture Diagram

```text
                ERP CSV Files
                      │
                      │
                CRM CSV Files
                      │
                      ▼
              Bronze Layer
         (Raw Source Data)
                      │
                      ▼
              Silver Layer
      (Cleaned & Standardized Data)
                      │
                      ▼
               Gold Layer
      (Star Schema Data Model)
                      │
                      ▼
     SQL Exploratory Data Analysis
                      │
                      ▼
          Business Insights
```

---

# Layer Description

## Bronze Layer

Purpose

- Store raw source data
- Preserve original records
- No transformations

---

## Silver Layer

Purpose

- Data cleaning
- Standardization
- Validation
- Deduplication
- Data quality improvements

---

## Gold Layer

Purpose

- Dimensional modeling
- Star schema
- Business-ready datasets
- Optimized analytical queries

---

# Data Flow

```text
Source Systems
        │
        ▼
Bronze
        │
        ▼
Silver
        │
        ▼
Gold
        │
        ▼
SQL Analysis
        │
        ▼
Business Insights
```

---

# Technologies

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL
- ETL
- Data Warehousing
- Star Schema
- Git
- GitHub

---

# Benefits

- Clean data
- High performance
- Easy reporting
- Consistent business metrics
- Scalable architecture

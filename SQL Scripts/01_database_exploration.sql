/*
===============================================================================
Script: 01_database_exploration.sql
Purpose:
    Explore the SQL Server database structure before performing analysis.

    This script provides:
    - Database information
    - Schema exploration
    - Table exploration
    - Column exploration
    - Row counts
    - Table sizes
===============================================================================
*/

-------------------------------------------------------------------------------
-- 1. Current Database Information
-------------------------------------------------------------------------------

SELECT
    DB_NAME() AS database_name;

-------------------------------------------------------------------------------
-- 2. List All Schemas
-------------------------------------------------------------------------------

SELECT
    schema_name
FROM INFORMATION_SCHEMA.SCHEMATA
ORDER BY schema_name;

-------------------------------------------------------------------------------
-- 3. List All Tables
-------------------------------------------------------------------------------

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;

-------------------------------------------------------------------------------
-- 4. List All Columns
-------------------------------------------------------------------------------

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME,
    ORDINAL_POSITION;

-------------------------------------------------------------------------------
-- 5. Explore Gold Layer Tables
-------------------------------------------------------------------------------

SELECT *
FROM gold.dim_customers;

SELECT *
FROM gold.dim_products;

SELECT *
FROM gold.fact_sales;

-------------------------------------------------------------------------------
-- 6. Count Records in Each Gold Table
-------------------------------------------------------------------------------

SELECT COUNT(*) AS total_customers
FROM gold.dim_customers;

SELECT COUNT(*) AS total_products
FROM gold.dim_products;

SELECT COUNT(*) AS total_sales
FROM gold.fact_sales;

-------------------------------------------------------------------------------
-- 7. View Table Row Counts (Metadata)
-------------------------------------------------------------------------------

SELECT
    t.name AS table_name,
    SUM(p.rows) AS row_count
FROM sys.tables t
JOIN sys.partitions p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
GROUP BY t.name
ORDER BY row_count DESC;

-------------------------------------------------------------------------------
-- 8. View All Views
-------------------------------------------------------------------------------

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;

-------------------------------------------------------------------------------
-- 9. List Primary Keys
-------------------------------------------------------------------------------

SELECT
    KU.TABLE_SCHEMA,
    KU.TABLE_NAME,
    KU.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
    ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY
    KU.TABLE_NAME;

-------------------------------------------------------------------------------
-- 10. List Foreign Keys
-------------------------------------------------------------------------------

SELECT
    fk.name AS foreign_key_name,
    OBJECT_NAME(parent_object_id) AS parent_table,
    OBJECT_NAME(referenced_object_id) AS referenced_table
FROM sys.foreign_keys fk
ORDER BY
    parent_table;

-------------------------------------------------------------------------------
-- 11. Check Table Storage Size
-------------------------------------------------------------------------------

EXEC sp_spaceused 'gold.dim_customers';

EXEC sp_spaceused 'gold.dim_products';

EXEC sp_spaceused 'gold.fact_sales';

-------------------------------------------------------------------------------
-- 12. Database Summary
-------------------------------------------------------------------------------

SELECT
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES) AS total_tables,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.VIEWS) AS total_views,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS) AS total_columns;


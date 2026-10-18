/*
===============================================================================
Database Exploration
===============================================================================
*/

--Purpose: Identify the tables available in the Gold layer.
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Purpose: Understand the schema and data types of each column.
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;

--Purpose: Measure the size of each Gold-layer table.
SELECT 'dim_customers' AS table_name,
       COUNT_BIG(*) AS total_records
FROM gold.dim_customers
UNION ALL
SELECT 'dim_products',
       COUNT_BIG(*)
FROM gold.dim_products
UNION ALL
SELECT 'report_customers',
       COUNT_BIG(*)
FROM gold.report_customers
UNION ALL
SELECT 'report_products',
       COUNT_BIG(*)
FROM gold.report_products
UNION ALL
SELECT 'fact_sales',
       COUNT_BIG(*)
FROM gold.fact_sales;
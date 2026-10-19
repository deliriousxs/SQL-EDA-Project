/*
===============================================================================
Measures  Exploration
===============================================================================
*/

-- Summarize sales measures
SELECT
    COUNT_BIG(*) AS sales_lines,
    COUNT(DISTINCT order_number) AS distinct_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    AVG(CAST(sales_amount AS DECIMAL(18,2))) AS avg_line_sales,
    AVG(CAST(price AS DECIMAL(18,2))) AS avg_unit_price
FROM gold.fact_sales;



-- Understand transaction quantities and identify unusual values.
SELECT
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity,
    AVG(CAST(quantity AS DECIMAL(18,2))) AS avg_quantity_per_line,
    SUM(quantity) AS total_quantity,
    SUM(CASE
        WHEN quantity < 0 THEN 1
        ELSE 0
    END) AS negative_quantity_lines,
    SUM(CASE
        WHEN quantity = 0 THEN 1
        ELSE 0
    END) AS zero_quantity_lines
FROM gold.fact_sales;

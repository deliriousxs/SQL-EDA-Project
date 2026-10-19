/*
===============================================================================
Date Exploration
===============================================================================
*/

-- Determine the sales date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(
        DAY,
        MIN(order_date),
        MAX(order_date)
    ) AS date_range_days,
    COUNT_BIG(*) AS total_sales_records
FROM gold.fact_sales;

-- Analyze sales by year
SELECT
    YEAR(order_date) AS sales_year,
    COUNT_BIG(*) AS sales_lines,
    COUNT(DISTINCT order_number) AS distinct_orders,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY sales_year;

-- Identify monthly sales patterns
SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    sales_year,
    sales_month;


/*
===============================================================================
Cumulative Analysis
===============================================================================
*/

-- Purpose: Measure the accumulation of sales revenue over the dataset's historical timeline.
WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS sales_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)
SELECT
    sales_month,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_sales
FROM monthly_sales
ORDER BY sales_month;

-- Purpose: Understand how annual sales contribute to the overall historical total.
WITH yearly_sales AS (
    SELECT
        YEAR(order_date) AS sales_year,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
)
SELECT
    sales_year,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY sales_year
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_sales
FROM yearly_sales
ORDER BY sales_year;
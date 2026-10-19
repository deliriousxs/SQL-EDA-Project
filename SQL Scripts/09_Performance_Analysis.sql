/*
===============================================================================
Performance Analysis
===============================================================================
*/

-- Purpose: Evaluate changes in revenue and order volume between recorded months.
WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS sales_month,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT order_number) AS total_orders
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),
comparison AS (
    SELECT
        sales_month,
        total_sales,
        total_orders,
        LAG(total_sales) OVER (
            ORDER BY sales_month
        ) AS previous_sales,
        LAG(total_orders) OVER (
            ORDER BY sales_month
        ) AS previous_orders
    FROM monthly_sales
)
SELECT
    sales_month,
    total_sales,
    total_orders,
    total_sales - previous_sales AS sales_difference,
    total_orders - previous_orders AS order_difference,
    CAST(
        100.0 * (total_sales - previous_sales)
        / NULLIF(previous_sales, 0)
        AS DECIMAL(10,2)
    ) AS sales_growth_pct
FROM comparison
ORDER BY sales_month DESC;


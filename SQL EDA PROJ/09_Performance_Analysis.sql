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

-- Purpose: Compare category sales with the overall average category sales
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.dim_products AS p
    JOIN gold.fact_sales AS f
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    AVG(CAST(total_sales AS DECIMAL(18,2)))
        OVER () AS avg_category_sales,
    total_sales
        - AVG(CAST(total_sales AS DECIMAL(18,2)))
          OVER () AS difference_from_average,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS category_rank
FROM category_sales
ORDER BY total_sales DESC;
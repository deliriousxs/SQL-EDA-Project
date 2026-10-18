/*
===============================================================================
Change over time
===============================================================================
*/

-- Purpose: Monthly sales growth
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
),
sales_comparison AS (
    SELECT
        sales_month,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    total_sales,
    previous_month_sales,
    total_sales - previous_month_sales AS sales_change,
    CAST(
        100.0 * (total_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0)
        AS DECIMAL(10,2)
    ) AS growth_percentage
FROM sales_comparison
ORDER BY sales_month;

-- Purpose: Compare business performance across calendar years.
WITH yearly_sales AS (
    SELECT
        YEAR(order_date) AS sales_year,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT order_number) AS total_orders
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
)
SELECT
    sales_year,
    total_sales,
    total_orders,
    LAG(total_sales) OVER (
        ORDER BY sales_year
    ) AS previous_year_sales,
    total_sales - LAG(total_sales) OVER (
        ORDER BY sales_year
    ) AS annual_sales_change
FROM yearly_sales
ORDER BY sales_year;

-- Purpose: Determine which product categories are gaining or losing sales over time.
WITH category_monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(f.order_date),
            MONTH(f.order_date),
            1
        ) AS sales_month,
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        MONTH(f.order_date),
        p.category
)
SELECT
    sales_month,
    category,
    total_sales,
    LAG(total_sales) OVER (
        PARTITION BY category
        ORDER BY sales_month
    ) AS previous_period_sales,
    total_sales - LAG(total_sales) OVER (
        PARTITION BY category
        ORDER BY sales_month
    ) AS sales_change
FROM category_monthly_sales
ORDER BY
    category,
    sales_month;
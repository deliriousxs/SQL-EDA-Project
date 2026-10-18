/*
===============================================================================
Part to Whole
===============================================================================
*/

-- Purpose: Calculate each product category's percentage of total sales
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    CAST(
        100.0 * total_sales
        / NULLIF(SUM(total_sales) OVER (), 0)
        AS DECIMAL(10,2)
    ) AS sales_contribution_pct
FROM category_sales
ORDER BY sales_contribution_pct DESC;
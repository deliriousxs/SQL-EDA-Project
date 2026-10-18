/*
===============================================================================
Dimensions Exploration
===============================================================================
*/

-- Purpose: Determine the geographic distribution of customers.
SELECT
    country,
    COUNT(*) AS customer_count
FROM gold.dim_customers
GROUP BY country
ORDER BY customer_count DESC;

-- Analyze customer marital status and gender
SELECT
    marital_status,
    gender,
    COUNT(*) AS customer_count
FROM gold.dim_customers
GROUP BY
    marital_status,
    gender
ORDER BY
    marital_status,
    gender;

-- Identify distinct product categories and subcategories
SELECT
    category,
    subcategory,
    COUNT(*) AS product_count
FROM gold.dim_products
GROUP BY
    category,
    subcategory
ORDER BY
    category,
    product_count DESC;

-- Compare the product catalog with actual sales activity.
SELECT
    p.category,
    COUNT(DISTINCT p.product_key) AS products_in_catalog,
    COUNT(DISTINCT f.product_key) AS products_sold,
    COUNT_BIG(f.order_number) AS sales_lines,
    SUM(f.quantity) AS units_sold
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales AS f
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY units_sold DESC;
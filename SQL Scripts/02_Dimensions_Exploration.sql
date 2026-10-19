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

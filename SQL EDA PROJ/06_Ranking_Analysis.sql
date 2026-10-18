/*
===============================================================================
Ranking Analysis
===============================================================================
*/

-- Purpose: Rank the top 10 customers by total sales
WITH customer_sales AS (
    SELECT
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(f.sales_amount) AS total_sales
    FROM gold.dim_customers AS c
    JOIN gold.fact_sales AS f
        ON c.customer_key = f.customer_key
    GROUP BY
        c.customer_key,
        c.customer_number,
        c.first_name,
        c.last_name
)
SELECT TOP (10)
    customer_key,
    customer_number,
    customer_name,
    total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales
ORDER BY total_sales DESC;

-- Purpose: Rank the top 10 products by total sales
WITH product_sales AS (
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity
    FROM gold.dim_products AS p
    JOIN gold.fact_sales AS f
        ON p.product_key = f.product_key
    GROUP BY
        p.product_key,
        p.product_name,
        p.category
)
SELECT TOP (10)
    product_key,
    product_name,
    category,
    total_sales,
    total_quantity,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM product_sales
ORDER BY total_sales DESC;

-- Purpose: Rank product categories by sales quantity
WITH category_quantity AS (
    SELECT
        p.category,
        SUM(f.quantity) AS total_quantity
    FROM gold.dim_products AS p
    JOIN gold.fact_sales AS f
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_quantity,
    DENSE_RANK() OVER (
        ORDER BY total_quantity DESC
    ) AS quantity_rank
FROM category_quantity
ORDER BY total_quantity DESC;
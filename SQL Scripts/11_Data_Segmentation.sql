/*
===============================================================================
Data Segmentation
===============================================================================
*/

-- Purpose: Analyze customers by age group and segment
SELECT
    age_group,
    customer_segment,
    COUNT(*) AS customer_count,
    AVG(CAST(age AS DECIMAL(10,2))) AS avg_age,
    AVG(CAST(total_sales AS DECIMAL(18,2)))
        AS avg_customer_sales,
    AVG(CAST(total_orders AS DECIMAL(18,2)))
        AS avg_customer_orders
FROM gold.report_customers
GROUP BY
    age_group,
    customer_segment
ORDER BY
    age_group,
    customer_count DESC;

-- Purpose: Segment products by performance classification
SELECT
    product_segment,
    COUNT(*) AS product_count,
    SUM(total_sales) AS segment_sales,
    SUM(total_quantity) AS units_sold,
    AVG(CAST(total_sales AS DECIMAL(18,2)))
        AS avg_sales_per_product,
    AVG(CAST(total_customers AS DECIMAL(18,2)))
        AS avg_customers_per_product
FROM gold.report_products
GROUP BY product_segment
ORDER BY segment_sales DESC;
/*
===============================================================================
Magnitude Analysis
===============================================================================
*/

-- Quantify the magnitude of sales across geographic markets.
SELECT
    c.country,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.order_number) AS total_orders,
    COUNT(DISTINCT c.customer_key) AS purchasing_customers
FROM gold.fact_sales AS f
JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;

-- Determine the scale of each product category's contribution to sales.
SELECT
    p.category,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_units,
    COUNT(DISTINCT f.order_number) AS total_orders,
    COUNT(DISTINCT f.customer_key) AS unique_customers
FROM gold.fact_sales AS f
JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

-- Measure the size of individual orders.
WITH order_totals AS (
    SELECT
        order_number,
        SUM(sales_amount) AS order_sales
    FROM gold.fact_sales
    WHERE order_number IS NOT NULL
    GROUP BY order_number
)
SELECT
    COUNT_BIG(*) AS total_orders,
    SUM(order_sales) AS total_sales,
    AVG(CAST(order_sales AS DECIMAL(18,2))) AS avg_order_value,
    MIN(order_sales) AS minimum_order_value,
    MAX(order_sales) AS maximum_order_value
FROM order_totals;

-- Measure sales by transaction year and month
SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    SUM(sales_amount) AS monthly_sales,
    SUM(quantity) AS monthly_quantity,
    COUNT(DISTINCT order_number) AS monthly_orders,
    AVG(CAST(sales_amount AS DECIMAL(18,2))) AS avg_sales_per_line
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    sales_year,
    sales_month;
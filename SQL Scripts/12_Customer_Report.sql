/*
===============================================================================
Customer Report
===============================================================================
*/

-- Customer Value and Behavior Analysis

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    age_group,
    customer_segment,

    -- Purchase Recency
    last_order_date,
    recency AS recency_days,

    -- Purchase Behavior
    total_orders,
    total_quantity,
    total_products,

    -- Customer Value
    total_sales,
    avg_order_value,
    avg_monthly_spend,

    -- Customer Relationship Duration
    lifespan AS customer_lifespan,

    -- Additional Performance Indicators
    CASE
        WHEN recency <= 30 THEN 'Recent Customer'
        WHEN recency <= 90 THEN 'Needs Monitoring'
        WHEN recency <= 180 THEN 'At Risk'
        ELSE 'Inactive / High Risk'
    END AS recency_status,

    CASE
        WHEN total_sales >= 5000 THEN 'High Value'
        WHEN total_sales >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_value_category

FROM gold.report_customers
ORDER BY
    total_sales DESC,
    total_orders DESC;
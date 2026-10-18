/*
===============================================================================
Product Report
===============================================================================
*/

-- Product Performance and Sales Contribution Analysis
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    product_segment,

    -- Sales Performance
    total_sales,
    total_orders,
    total_quantity,

    -- Customer Reach
    total_customers,

    -- Pricing and Revenue Metrics
    cost,
    avg_selling_price,
    avg_order_revenue,
    avg_monthly_revenue,

    -- Sales Recency
    last_sale_date,
    recency_in_months AS sales_recency_months,

    -- Product Lifespan
    lifespan AS product_lifespan,

    -- Average Sales per Customer
    CAST(
        total_sales * 1.0
        / NULLIF(total_customers, 0)
        AS DECIMAL(18,2)
    ) AS sales_per_customer,

    -- Product Activity Classification
    CASE
        WHEN last_sale_date IS NULL
            THEN 'No Recorded Sales Date'
        WHEN recency_in_months >= 12
            THEN 'Sales Inactive / Needs Review'
        WHEN recency_in_months >= 6
            THEN 'Low Recent Activity'
        ELSE 'Recently Sold'
    END AS sales_activity_status

FROM gold.report_products
ORDER BY
    total_sales DESC,
    total_quantity DESC;
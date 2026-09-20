CREATE OR REPLACE TABLE monthly_kpis AS
SELECT
    DATE_TRUNC('month', event_time) AS month,
    COUNT(*) AS purchase_events,
    ROUND(SUM(price), 2) AS revenue,
    COUNT(DISTINCT user_id) AS purchasing_users,
    COUNT(DISTINCT user_session) AS purchasing_sessions,
    ROUND(
        SUM(price) / NULLIF(COUNT(DISTINCT user_session), 0),
        2
    ) AS avg_purchase_basket_value
FROM read_csv_auto(
    'E:/ecommerce-analytics-project/data/*.csv',
    union_by_name = true
)
WHERE event_type = 'purchase'
GROUP BY 1
ORDER BY 1;


CREATE OR REPLACE TABLE product_performance AS
SELECT
    product_id,
    SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS views,
    SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS carts,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases,
    ROUND(
        SUM(CASE WHEN event_type = 'purchase' THEN price ELSE 0 END),
        2
    ) AS revenue,
    ROUND(
        100.0 * SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END), 0),
        2
    ) AS view_to_purchase_pct,
    ROUND(
        100.0 * SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END), 0),
        2
    ) AS view_to_cart_pct
FROM read_csv_auto(
    'E:/ecommerce-analytics-project/data/*.csv',
    union_by_name = true
)
GROUP BY product_id;


CREATE OR REPLACE TABLE customer_segments AS
WITH user_stats AS (
    SELECT
        user_id,
        COUNT(DISTINCT user_session) AS purchase_sessions,
        COUNT(*) AS purchase_events,
        ROUND(SUM(price), 2) AS revenue,
        COUNT(DISTINCT product_id) AS unique_products
    FROM read_csv_auto(
        'E:/ecommerce-analytics-project/data/*.csv',
        union_by_name = true
    )
    WHERE event_type = 'purchase'
    GROUP BY user_id
)
SELECT
    user_id,
    CASE
        WHEN purchase_sessions = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    purchase_sessions,
    purchase_events,
    revenue,
    unique_products
FROM user_stats;


CREATE OR REPLACE TABLE data_quality AS
SELECT
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(DISTINCT user_session) AS unique_sessions,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN product_id END) AS viewed_products,
    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN product_id END) AS cart_products,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN product_id END) AS purchased_products,
    SUM(CASE WHEN category_code IS NULL OR category_code = '' THEN 1 ELSE 0 END) AS missing_category_events,
    SUM(CASE WHEN brand IS NULL OR brand = '' THEN 1 ELSE 0 END) AS missing_brand_events,
    MIN(event_time) AS first_event,
    MAX(event_time) AS last_event
FROM read_csv_auto(
    'E:/ecommerce-analytics-project/data/*.csv',
    union_by_name = true
);
SELECT
    COUNT(DISTINCT user_session || '-' || CAST(product_id AS VARCHAR)) AS purchased_product_sessions
FROM read_csv_auto(
    'E:/ecommerce-analytics-project/data/*.csv',
    union_by_name = true
)
WHERE event_type = 'purchase';
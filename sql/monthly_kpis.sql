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
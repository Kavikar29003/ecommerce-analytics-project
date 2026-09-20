WITH ps AS (
    SELECT
        user_session,
        product_id,
        BOOL_OR(event_type = 'view') AS has_view,
        BOOL_OR(event_type = 'cart') AS has_cart,
        BOOL_OR(event_type = 'purchase') AS has_purchase
    FROM read_csv_auto(
        'E:/ecommerce-analytics-project/data/*.csv',
        union_by_name = true
    )
    GROUP BY 1, 2
)

SELECT
    has_view,
    has_cart,
    COUNT(*) AS purchased_product_sessions
FROM ps
WHERE has_purchase
GROUP BY 1, 2
ORDER BY 3 DESC;
WITH p AS (
    SELECT
        product_id,
        SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS views,
        SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS carts,
        SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases,
        SUM(CASE WHEN event_type = 'purchase' THEN price ELSE 0 END) AS revenue
    FROM read_csv_auto(
        'E:/ecommerce-analytics-project/data/*.csv',
        union_by_name = true
    )
    GROUP BY product_id
)

SELECT
    product_id,
    views,
    carts,
    purchases,
    ROUND(revenue, 2) AS revenue,
    ROUND(100.0 * purchases / NULLIF(views, 0), 2) AS view_to_purchase_pct
FROM p
WHERE purchases > 0
ORDER BY revenue DESC
LIMIT 20;
SELECT
    purchase_sessions >= 6 AS heavy_user,
    COUNT(*) AS users,
    ROUND(
        100 * SUM(revenue) / SUM(SUM(revenue)) OVER (),
        2
    ) AS revenue_pct
FROM customer_segments
GROUP BY 1
ORDER BY heavy_user;
SELECT
    CASE
        WHEN purchase_sessions = 1 THEN '1 session'
        WHEN purchase_sessions = 2 THEN '2 sessions'
        WHEN purchase_sessions = 3 THEN '3 sessions'
        WHEN purchase_sessions <= 5 THEN '4-5 sessions'
        WHEN purchase_sessions <= 10 THEN '6-10 sessions'
        ELSE '11+ sessions'
    END AS bucket,

    COUNT(*) AS users

FROM customer_segments

GROUP BY 1

ORDER BY
    MIN(purchase_sessions);
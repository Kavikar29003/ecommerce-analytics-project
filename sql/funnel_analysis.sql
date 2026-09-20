CREATE OR REPLACE TABLE funnel_analysis AS

WITH product_sessions AS (
    SELECT
        user_session,
        product_id,

        MIN(CASE
            WHEN event_type = 'view' THEN event_time
        END) AS first_view_time,

        MIN(CASE
            WHEN event_type = 'cart' THEN event_time
        END) AS first_cart_time,

        MIN(CASE
            WHEN event_type = 'purchase' THEN event_time
        END) AS first_purchase_time

    FROM read_csv_auto(
        'E:/ecommerce-analytics-project/data/*.csv',
        union_by_name = true
    )

    GROUP BY
        user_session,
        product_id
)

SELECT
    COUNT(*) AS product_sessions,

    SUM(
        CASE
            WHEN first_view_time IS NOT NULL
            THEN 1 ELSE 0
        END
    ) AS viewed,

    SUM(
        CASE
            WHEN first_view_time IS NOT NULL
            AND first_cart_time IS NOT NULL
            AND first_cart_time >= first_view_time
            THEN 1 ELSE 0
        END
    ) AS viewed_then_cart,

    SUM(
        CASE
            WHEN first_view_time IS NOT NULL
            AND first_cart_time IS NOT NULL
            AND first_cart_time >= first_view_time
            AND first_purchase_time IS NOT NULL
            AND first_purchase_time >= first_cart_time
            THEN 1 ELSE 0
        END
    ) AS viewed_cart_purchase

FROM product_sessions;
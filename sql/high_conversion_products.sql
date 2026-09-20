SELECT
    product_id,
    views,
    carts,
    purchases,
    view_to_purchase_pct
FROM product_performance
WHERE views >= 1000
ORDER BY view_to_purchase_pct DESC
LIMIT 10;
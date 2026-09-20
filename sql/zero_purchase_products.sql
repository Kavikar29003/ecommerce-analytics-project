-- Count products with meaningful traffic but no purchases
SELECT
    COUNT(*) AS products
FROM product_performance
WHERE views >= 500
  AND purchases = 0;


-- Top 10 high-view products with no purchases
SELECT
    product_id,
    views,
    carts,
    purchases
FROM product_performance
WHERE views >= 500
  AND purchases = 0
ORDER BY views DESC
LIMIT 10;
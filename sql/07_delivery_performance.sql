-- Delay vs review score
WITH delays AS (
    SELECT order_id,
        CAST(julianday(order_delivered_customer_date)
        - julianday(order_estimated_delivery_date) 
        AS INT) AS delay_days
    FROM delivered_orders
    WHERE order_delivered_customer_date IS NOT NULL
)
SELECT
    CASE
        WHEN d.delay_days <= 0 THEN 'Early/On-time'
        WHEN d.delay_days <= 7 THEN '1-7 Days Late'
        ELSE '8+ Days Late'
    END AS delivery_outcome,
    ROUND(AVG(r.review_score), 2) AS avg_review,
    COUNT(*) AS n_orders
FROM delays d
JOIN clean_reviews r ON r.order_id = d.order_id
GROUP BY delivery_outcome
ORDER BY avg_review DESC;

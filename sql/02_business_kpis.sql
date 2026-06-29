-- Total revenue, orders, AOV
SELECT
    SUM(item_total) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(item_total) / 
    COUNT(DISTINCT order_id) AS avg_order_value
FROM delivered_items;

-- Unique customers
SELECT COUNT(DISTINCT customer_unique_id) 
AS total_customers
FROM customers;

-- Avg review score
SELECT ROUND(AVG(r.review_score), 3) 
AS avg_review_score
FROM clean_reviews r
JOIN delivered_orders o ON o.order_id = r.order_id;

-- On-time delivery rate
SELECT
    ROUND(SUM(CASE 
        WHEN order_delivered_customer_date <= 
             order_estimated_delivery_date 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1)
    AS on_time_rate_pct,
    ROUND(AVG(julianday(order_delivered_customer_date)
    - julianday(order_purchase_timestamp)), 1)
    AS avg_delivery_days
FROM delivered_orders
WHERE order_delivered_customer_date IS NOT NULL;

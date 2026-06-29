-- Review score distribution
SELECT
    r.review_score,
    COUNT(*) AS n_reviews,
    ROUND(COUNT(*) * 100.0 / 
        SUM(COUNT(*)) OVER (), 1) AS pct
FROM clean_reviews r
JOIN delivered_orders o ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;


-- % positive vs % negative
WITH dist AS (
    SELECT r.review_score, COUNT(*) AS n
    FROM clean_reviews r
    JOIN delivered_orders o 
        ON o.order_id = r.order_id
    GROUP BY r.review_score
)
SELECT
    ROUND(SUM(CASE 
        WHEN review_score >= 4 THEN n ELSE 0 END) 
        * 100.0 / SUM(n), 1) AS pct_positive,
    ROUND(SUM(CASE 
        WHEN review_score <= 2 THEN n ELSE 0 END) 
        * 100.0 / SUM(n), 1) AS pct_negative
FROM dist;

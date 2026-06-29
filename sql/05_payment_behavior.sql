-- Revenue share by payment method
SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS total_value,
    ROUND(SUM(payment_value) * 100.0 /
        (SELECT SUM(payment_value) 
         FROM order_payments 
         WHERE payment_type != 'not_defined'), 1) 
    AS pct_of_value
FROM order_payments
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY total_value DESC;


-- Credit card installment distribution
SELECT
    payment_installments,
    COUNT(*) AS transactions
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;

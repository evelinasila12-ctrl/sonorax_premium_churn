SELECT
    payment_method,
    COUNT(*) AS total_users,
    ROUND(AVG(failed_payments_count), 2) AS avg_failed_payments,
    SUM(CASE WHEN failed_payments_count > 0 THEN 1 ELSE 0 END) AS users_with_failed_payment,
    ROUND(SUM(CASE WHEN failed_payments_count > 0 THEN 1 ELSE 0 END)::numeric
        / COUNT(*) * 100, 1 ) AS pct_users_with_failed_payment
FROM users
WHERE payment_method IS NOT NULL
GROUP BY payment_method
ORDER BY avg_failed_payments DESC;

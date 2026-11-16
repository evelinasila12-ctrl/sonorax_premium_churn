SELECT
    CASE WHEN failed_payments_count > 0 THEN 'had_failed_payment' ELSE 'no_failed_payment' END AS group_name,
    COUNT(*) AS total_users,
    SUM(CASE WHEN subscription_status = 'churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN subscription_status = 'churned' THEN 1 ELSE 0 END)::numeric
        / COUNT(*) * 100, 1) AS churn_rate_pct
FROM users
WHERE plan = 'Premium'
GROUP BY CASE WHEN failed_payments_count > 0 THEN 'had_failed_payment' ELSE 'no_failed_payment' END;
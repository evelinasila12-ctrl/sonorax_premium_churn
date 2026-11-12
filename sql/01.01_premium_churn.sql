SELECT
    plan,
    COUNT(*) AS total_users,
    SUM(CASE WHEN subscription_status = 'churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN subscription_status = 'churned' THEN 1 ELSE 0 END)::numeric
        / COUNT(*) * 100, 2
    ) AS churn_rate_pct
FROM users
GROUP BY plan;
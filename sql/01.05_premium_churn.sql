SELECT
    COUNT(*) FILTER (WHERE subscription_status = 'churned') AS churned_premium_users,
    ROUND(SUM(monthly_price) FILTER (WHERE subscription_status = 'churned'), 2) AS lost_monthly_revenue,
    ROUND(
        SUM(monthly_price) FILTER (WHERE subscription_status = 'churned')
        / NULLIF(SUM(monthly_price), 0) * 100, 2
    ) AS pct_revenue_lost
FROM users
WHERE plan = 'Premium';
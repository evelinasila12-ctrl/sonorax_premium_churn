SELECT
    ROUND(SUM(estimated_lost_revenue), 2) AS total_lost_revenue_all,
    ROUND(SUM(monthly_price), 2) AS total_premium_revenue,
    ROUND(SUM(estimated_lost_revenue) / NULLIF(SUM(monthly_price), 0) * 100, 2) AS pct_lost_vs_premium_revenue
FROM users;

SELECT promo_used,
    COUNT(*) AS total_free_signups,
    SUM(CASE WHEN plan = 'Premium' THEN 1 ELSE 0 END) AS converted_users,
    ROUND(SUM(CASE WHEN plan = 'Premium' THEN 1 ELSE 0 END)::numeric
        / COUNT(*) * 100, 1) AS conversion_rate_pct
FROM users
WHERE initial_plan = 'Free'
GROUP BY promo_used;
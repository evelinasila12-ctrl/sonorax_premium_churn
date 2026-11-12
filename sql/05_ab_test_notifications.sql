SELECT
    variant,
    COUNT(*) AS total_users,
    SUM(returned_7d) AS returned_users,
    ROUND(AVG(returned_7d)::numeric * 100, 2) AS return_rate_pct
FROM ab_test_assignments
WHERE test_name = 'push_notifications'
GROUP BY variant
ORDER BY variant;
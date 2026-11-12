SELECT
    u.subscription_status,
    ROUND(AVG(la.listening_minutes), 1) AS avg_listening_minutes
FROM listening_activity la
JOIN users u ON u.user_id = la.user_id
WHERE u.plan = 'Premium'
GROUP BY u.subscription_status;



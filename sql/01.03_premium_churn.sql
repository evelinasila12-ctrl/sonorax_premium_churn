SELECT
    u.subscription_status,
    ROUND(AVG(la.playlists_created), 2) AS avg_playlists_created
FROM listening_activity la
JOIN users u ON u.user_id = la.user_id
WHERE u.plan = 'Premium'
GROUP BY u.subscription_status;
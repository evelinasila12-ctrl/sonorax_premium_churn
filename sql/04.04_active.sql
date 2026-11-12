SELECT
    month,
    ROUND(AVG(listening_minutes), 1) AS avg_listening_minutes
FROM listening_activity
GROUP BY month
ORDER BY month;
WITH ranked AS (
    SELECT user_id, listening_minutes,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY month ASC) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY month DESC) AS rn_desc
    FROM listening_activity)
SELECT
    u.device,
    ROUND(AVG(r.listening_minutes) FILTER (WHERE r.rn_asc <= 3), 1) AS avg_minutes_first_3_months,
    ROUND(AVG(r.listening_minutes) FILTER (WHERE r.rn_desc <= 3), 1) AS avg_minutes_last_3_months
FROM ranked r
JOIN users u ON u.user_id = r.user_id
GROUP BY u.device
ORDER BY u.device;
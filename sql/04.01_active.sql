WITH ranked AS (
    SELECT user_id, listening_minutes,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY month ASC) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY month DESC) AS rn_desc
    FROM listening_activity)
SELECT
    ROUND(AVG(listening_minutes) FILTER (WHERE rn_asc <= 3), 1) AS avg_minutes_first_3_months,
    ROUND(AVG(listening_minutes) FILTER (WHERE rn_desc <= 3), 1) AS avg_minutes_last_3_months
FROM ranked;
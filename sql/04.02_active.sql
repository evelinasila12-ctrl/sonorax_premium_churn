WITH ranked AS (
    SELECT user_id, sessions, listening_minutes,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY month ASC) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY month DESC) AS rn_desc
    FROM listening_activity)
SELECT
    ROUND(AVG(sessions) FILTER (WHERE rn_asc <= 3), 2) AS avg_sessions_first_3_months,
    ROUND(AVG(sessions) FILTER (WHERE rn_desc <= 3), 2) AS avg_sessions_last_3_months,
    ROUND(AVG(listening_minutes / NULLIF(sessions, 0)) FILTER (WHERE rn_asc <= 3), 2) AS avg_min_per_session_first_3_months,
    ROUND(AVG(listening_minutes / NULLIF(sessions, 0)) FILTER (WHERE rn_desc <= 3), 2) AS avg_min_per_session_last_3_months
FROM ranked;
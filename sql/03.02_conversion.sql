SELECT
    ROUND(AVG(plan_change_date - signup_date), 1) AS avg_days_to_convert,
    MIN(plan_change_date - signup_date) AS min_days_to_convert,
    MAX(plan_change_date - signup_date) AS max_days_to_convert
FROM users
WHERE initial_plan = 'Free' AND plan_change_date IS NOT NULL;
 
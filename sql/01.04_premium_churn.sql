SELECT
    ROUND(AVG(churn_date - signup_date) / 30.0, 1) AS avg_months_to_churn,
    MIN(churn_date - signup_date) AS min_days_to_churn,
    MAX(churn_date - signup_date) AS max_days_to_churn
FROM users
WHERE plan = 'Premium' AND subscription_status = 'churned';
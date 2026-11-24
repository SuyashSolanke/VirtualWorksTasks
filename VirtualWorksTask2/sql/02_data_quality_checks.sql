-- ============================================================================
-- DATA QUALITY & INTEGRITY CHECKS
-- Dataset source: Hugging Face (arti199919/synthetic-saas-churn-sample)
-- Purpose: Confirm row counts, key uniqueness, and relational integrity
--          after loading users and user_monthly in PostgreSQL.
-- ============================================================================

-- 1. Row count verification across both tables
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'user_monthly' AS table_name, COUNT(*) AS row_count FROM user_monthly;

-- 2. Primary key uniqueness check on users.user_id
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS distinct_users
FROM users;

-- 3. Composite key check on user_monthly (user_id, month)
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (user_id, month)) AS distinct_user_months
FROM user_monthly;

-- 4. Null check on users
SELECT
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_user_id,
    COUNT(*) FILTER (WHERE churned IS NULL) AS null_churned,
    COUNT(*) FILTER (WHERE total_revenue IS NULL) AS null_total_revenue,
    COUNT(*) FILTER (WHERE plan_type IS NULL) AS null_plan_type
FROM users;

-- 5. Null check on user_monthly
SELECT
    COUNT(*) FILTER (WHERE user_id IS NULL OR month IS NULL) AS null_keys,
    COUNT(*) FILTER (WHERE mrr IS NULL) AS null_mrr,
    COUNT(*) FILTER (WHERE sessions IS NULL) AS null_sessions,
    COUNT(*) FILTER (WHERE churned_next_month IS NULL) AS null_churned_next_month
FROM user_monthly;
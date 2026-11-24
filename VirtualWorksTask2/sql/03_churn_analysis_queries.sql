-- ============================================================================
-- CUSTOMER CHURN ANALYSIS
-- Tables: users (account-level) & user_monthly (monthly snapshot-level)
-- ============================================================================

-- SECTION 1: BASELINE & CHURN OVERVIEW (Table: users)
-- 1.1 Overall Churn Rate: How many total users exist, how many churned (churned = 1) 
-- vs. stayed active (churned = 0), and what is the overall churn rate (%)?
SELECT
	DISTINCT COUNT(*),
	SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_users,
	SUM(CASE WHEN churned = 0 THEN 1 ELSE 0 END) AS stayed_active,
	ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(churned),2)
		AS churn_rate_pct
FROM users;
-- "count"	"churned_users"	"stayed_active"	"churn_rate_pct"
-- 5000		1131			3869			22.62

-- 1.2 Churn by Plan Tier: Which plan_type (Starter, Pro, Business, Enterprise) 
-- has the highest churned count and highest churn rate (%)?
SELECT
	plan_type,
	SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_users,
	ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(churned),2)
		AS churn_rate_pct
FROM users
GROUP BY plan_type
ORDER BY churned_users DESC;
-- Starter plan type has highest churn rate
-- "plan_type"		"churned_users"	"churn_rate_pct"
-- "Starter"		634				27.29
-- "Pro"			355				19.90
-- "Business"		122				15.25
-- "Enterprise"		20				21.51

-- 1.3 Churn by Billing Period: Do monthly subscribers churn at a higher rate (%) 
-- than annual subscribers?
SELECT 
	billing_period,
	SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_users,
	ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(churned),2)
		AS churn_rate_pct
FROM users
GROUP BY billing_period
ORDER BY churned_users DESC;
-- monthly subscribers churn at highest rate(%) than annual subscribers
-- "billing_period"	"churned_users"	"churn_rate_pct"
-- "monthly"		938				23.50
-- "annual"			193				19.15

-- 1.4 Churn by Payment Method & Discounts: How do churn rates compare across 
-- payment_method (card vs. invoice) and discounted (discount_pct > 0) vs. 
-- non-discounted accounts?
WITH categorized AS (
    SELECT
        payment_method,
        CASE
            WHEN discount_pct > 0 THEN 'discounted'
            ELSE 'non-discounted'
        END AS is_discounted,
        churned
    FROM users
)
SELECT
    payment_method,
    is_discounted,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0),2) 
		AS churn_rate_pct
FROM categorized
GROUP BY payment_method, is_discounted
ORDER BY churned_users DESC;
-- every subscriber gets discounts and card users churn more that invoice
-- "payment_method"	"is_discounted"	"churned_users"	"churn_rate_pct"
-- "card"			"discounted"	1028			23.51
-- "invoice"		"discounted"	103				16.43

-- 1.5 Churn by Segment (Industry & Acquisition Channel): Which industry or 
-- acquisition_channel has the highest churn rate (%)?
SELECT 
	industry,
	COUNT(*) AS total_users,
	SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_users,
	ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(churned), 2)
		AS churn_rate_pct
FROM users
GROUP BY industry
ORDER BY churn_rate_pct DESC;
-- Health Industry has the highest churn rate of ~26%, but by seeing total users in each
-- industry SaaS has highest churn rate ~23.4%
-- "industry"	"total_users"	"churned_users"	"churn_rate_pct"
-- "Health"		358				93				25.98
-- "Logistics"	365				92				25.21
-- "SaaS"		1281			300				23.42
-- "E-commerce"	845				188				22.25
-- "DevTools"	848				185				21.82
-- "Media"		376				80				21.28
-- "FinTech"	510				107				20.98
-- "EdTech"		417				86				20.62

SELECT 
	acquisition_channel,
	COUNT(*) AS total_users,
	SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_users,
	ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(churned), 2)
		AS churn_rate_pct
FROM users
GROUP BY acquisition_channel
ORDER BY churn_rate_pct DESC;
-- Paid users has high churn rate overall ~25%, but considering number of users then
-- Organic users churn highest of ~22%
-- "acquisition_channel"	"total_users"	"churned_users"	"churn_rate_pct"
-- "paid"					1104			279				25.27
-- "partner"				705				158				22.41
-- "outbound"				588				131				22.28
-- "organic"				1907			419				21.97
-- "marketplace"			696				144				20.69

-- 1.6 Revenue Impact of Churn: How much total_revenue and average ltv_12m is lost 
-- from churned users compared to active users?
SELECT
    churned,
    COUNT(*) AS users,
    ROUND(SUM(COALESCE(total_revenue, 0)), 2) AS total_revenue,
    ROUND(AVG(ltv_12m), 2) AS avg_ltv_12m
FROM users
GROUP BY churned
ORDER BY churned DESC;
-- "churned"	"users"	"total_revenue"	"avg_ltv_12m"
-- 1			1131	2289384.77		1643.42
-- 0			3869	18078691.40		3161.85

-- SECTION 2: ACTIVITY & ENGAGEMENT TRENDS BEFORE CHURN (Tables: user_monthly & users)
-- 2.1 Pre-Churn Usage Drop: In user_monthly, do users about to churn 
-- (churned_next_month = 1) have lower average sessions and feature_usage_score 
-- than users who stay (churned_next_month = 0)?
SELECT
    um.churned_next_month,
    COUNT(*) AS user_months,
    COUNT(DISTINCT u.user_id) AS distinct_users,
    ROUND(AVG(um.sessions), 2) AS avg_sessions,
    ROUND(AVG(um.feature_usage_score), 2) AS avg_feature_usage_score
FROM users u
INNER JOIN user_monthly um
    ON u.user_id = um.user_id
GROUP BY um.churned_next_month
ORDER BY um.churned_next_month DESC;
-- "churned_next_month"	"user_months"	"distinct_users"	"avg_sessions"	"avg_feature_usage_score"
-- 1					1056			1056				19.14			27.39
-- 0					78761			5000				29.74			46.75

-- 2.2 Seat Under-Utilization: Do accounts with a lower ratio of active_seats to 
-- seats_purchased churn more often?
WITH seat_data AS (
	SELECT 
	u.user_id, 
	um.churned,
	1.0 * (um.active_seats / u.seats_purchased) AS util_ratio
FROM users u
JOIN user_monthly um ON u.user_id = um.user_id)
	SELECT
		CASE
			WHEN util_ratio < 0.25 THEN 'Under 25%'
			WHEN util_ratio < 0.50 THEN '25% - 50%'
			WHEN util_ratio < 0.75 THEN '50% - 75%'
			ELSE '75%+'
		END AS util_tier,
		COUNT(*) AS total_rows,
		SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_rows,
		ROUND(100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
		AS churn_rate_pct
	FROM seat_data
	GROUP BY 1
	ORDER BY util_tier;
-- Yes, accounts with a lower ratio of active_seats to seats_purchased churn more often
-- "util_tier"	"total_rows"	"churned_rows"	"churn_rate_pct"
-- "75%+"		13277			102				0.77
-- "Under 25%"	66540			1029			1.55

-- 2.3 Customer Sentiment (NPS): How does average nps_score compare between 
-- pre-churn months (churned_next_month = 1) and normal active months 
-- (churned_next_month = 0)?
SELECT
    um.churned_next_month,
    COUNT(*) AS user_months,
    COUNT(DISTINCT u.user_id) AS distinct_users,
    ROUND(AVG(um.nps_score), 2) AS avg_nps_score
FROM users u
INNER JOIN user_monthly um
    ON u.user_id = um.user_id
GROUP BY um.churned_next_month
ORDER BY um.churned_next_month DESC;
-- "churned_next_month"	"user_months"	"distinct_users"	"avg_nps_score"
-- 1					1056			1056				2.70
-- 0					78761			5000				4.68

-- SECTION 3: FRICTION, SUPPORT & BILLING PAIN POINTS (Table: user_monthly)
-- 3.1 Support Ticket Load: Do users with higher support_tickets in a month have 
-- a higher rate of churned_next_month = 1?
SELECT
    support_tickets,
    COUNT(*) AS monthly_rows,
    SUM(CASE WHEN churned_next_month = 1 THEN 1 ELSE 0 END) AS next_month_churns,
    ROUND(100.0 * SUM(CASE WHEN churned_next_month = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
	AS next_month_churn_rate_pct
FROM user_monthly
GROUP BY support_tickets
ORDER BY support_tickets ASC;
-- Yes — there is a clear, steady upward trend: as monthly support tickets increase, 
-- the likelihood of churning the next month climbs sharply.
-- "support_tickets"	"monthly_rows"	"next_month_churns"	"next_month_churn_rate_pct"
-- 0					28581			185					0.65
-- 1					27792			302					1.09
-- 2					14750			248					1.68
-- 3					5624			175					3.11
-- 4					2004			87					4.34
-- 5					687				36					5.24
-- 6					233				14					6.01
-- 7					89				6					6.74
-- 8					30				1					3.33
-- 9					16				1					6.25
-- 10					6				0					0.00
-- 11					5				1					20.00

-- 3.2 Product Incidents: Does experiencing a product_incident (product_incident = 1) 
-- increase the likelihood of churning the following month?
SELECT
    product_incident,
    COUNT(*) AS monthly_rows,
    SUM(CASE WHEN churned_next_month = 1 THEN 1 ELSE 0 END) AS next_month_churns,
    ROUND(100.0 * SUM(CASE WHEN churned_next_month = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
	AS next_month_churn_rate_pct
FROM user_monthly
GROUP BY product_incident
ORDER BY product_incident ASC;
-- Yes it increases churn rate by 2.26%
-- "product_incident"	"monthly_rows"	"next_month_churns"	"next_month_churn_rate_pct"
-- 0					78377			1005				1.28
-- 1					1440			51					3.54

-- 3.3 Payment Failures: How strongly do payment_failures (payment_failures > 0) 
-- correlate with churning in the current or next month?
SELECT
    payment_failures,
    COUNT(*) AS monthly_rows,
	SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
	AS churn_rate_pct,
    SUM(CASE WHEN churned_next_month = 1 THEN 1 ELSE 0 END) AS next_month_churns,
    ROUND(100.0 * SUM(CASE WHEN churned_next_month = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
	AS next_month_churn_rate_pct
FROM user_monthly
GROUP BY payment_failures
ORDER BY payment_failures ASC;
-- Next-month churn rises steadily with payment failures 
-- (1.07% at 0 -> 2.70% at 1 -> 4.19% at 2 -> 8.57% at 3),
-- showing a strong lag effect (grace/retry periods). 
-- Current-month churn is noisier (1.38% -> 1.70% -> 0.99% at 2 -> 5.71% at 3),
-- and 4+ failures have too few rows (n=5) for a reliable rate.
-- "payment_failures"	"monthly_rows"	"churned"	"churn_rate_pct"	"next_month_churns"	"next_month_churn_rate_pct"
-- 0					68651			945			1.38				737					1.07
-- 1					10183			173			1.70				275					2.70
-- 2					908				9			0.99				38					4.19
-- 3					70				4			5.71				6					8.57
-- 4					5				0			0.00				0					0.00

-- SECTION 4: LIFECYCLE TIMING & RETENTION PRIORITIES (Tables: users & user_monthly)
-- 4.1 Critical Tenure Window: At which tenure_month 
-- (early onboarding months vs. later months) do cancellations spike the most?
SELECT
    CASE
		WHEN tenure_month <= 6 THEN 'early onboarding months (0-6m)'
		ELSE 'later months (6m+)'
	END AS tenure_stage,
    COUNT(*) AS monthly_rows,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
	AS churn_rate_pct
FROM user_monthly
GROUP BY 1
ORDER BY churn_rate_pct DESC;
-- The churn rate almost remains same but later months show high churn rate
-- "tenure_stage"					"monthly_rows"	"churned"	"churn_rate_pct"
-- "later months (6m+)"				46359			672			1.45
-- "early onboarding months (0-6m)"	33458			459			1.37

-- 4.2 High-Priority Retention Segment: Among currently active users 
-- (churned = 0 in users), which plan_type and billing_period combination holds 
-- the highest total monthly_price / MRR at risk?
SELECT
    u.plan_type,
    u.billing_period,
    COUNT(DISTINCT u.user_id) AS active_users,
    ROUND(SUM(um.mrr), 2) AS total_mrr,
    ROUND(AVG(um.mrr), 2) AS avg_mrr_per_user,
    ROUND(100.0 * SUM(um.mrr) / SUM(SUM(um.mrr)) OVER (),2)
	AS pct_of_total_active_mrr
FROM users u
JOIN user_monthly um
    ON u.user_id = um.user_id
WHERE u.churned = 0
  AND um.month = (SELECT MAX(month) FROM user_monthly)
GROUP BY
    u.plan_type,
    u.billing_period
ORDER BY
    total_mrr DESC;
-- Business plan (monthly) holds the highest MRR at risk with $270,066.95 across 485 active users 
-- (26.49% of total active MRR), followed closely by Pro (monthly) at $251,377.45 across 1,122 users (24.66%).
-- Together, Business and Pro monthly plans account for $521,444.40 (51.15% of all active MRR) and can cancel 
-- any month without annual lock-in, making them the top retention priority over Starter (monthly) ($95,224.64).
-- "plan_type"	"billing_period"	"active_users"	"total_mrr"	"avg_mrr_per_user"	"pct_of_total_active_mrr"
-- "Business"	"monthly"			485				270066.95	556.84				26.49
-- "Pro"		"monthly"			1122			251377.45	224.04				24.66
-- "Business"	"annual"			193				158630.72	821.92				15.56
-- "Starter"	"monthly"			1404			95224.64	67.82				9.34
-- "Pro"		"annual"			307				88978.42	289.83				8.73
-- "Enterprise"	"annual"			30				69112.23	2303.74				6.78
-- "Enterprise"	"monthly"			43				63994.72	1488.25				6.28
-- "Starter"	"annual"			285				22049.58	77.37				2.16
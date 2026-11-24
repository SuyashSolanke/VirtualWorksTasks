-- Table 1: Users
CREATE TABLE users (
    user_id VARCHAR(100) PRIMARY KEY,
    signup_date DATE,
    country VARCHAR(50),
    company_size INT,
    plan_type VARCHAR(50),
    monthly_price NUMERIC(10, 2),
    sessions_per_month INT,
    feature_usage_score NUMERIC(5, 2),
    support_tickets INT,
    payment_failures INT,
    last_active_date DATE,
    churned INT,
    churn_date DATE,
    tenure_months INT,
    total_revenue NUMERIC(12, 2),
    ltv_12m NUMERIC(12, 2),
    industry VARCHAR(100),
    acquisition_channel VARCHAR(100),
    billing_period VARCHAR(50),
    seats_purchased INT,
    discount_pct NUMERIC(5, 2),
    payment_method VARCHAR(50)
);

-- Table 2: User Monthly Time Series
CREATE TABLE user_monthly (
    user_id VARCHAR(100) REFERENCES users(user_id),
    month DATE,
    tenure_month INT,
    plan_type VARCHAR(50),
    monthly_price NUMERIC(10, 2),
    mrr NUMERIC(10, 2),
    sessions INT,
    feature_usage_score NUMERIC(5, 2),
    support_tickets INT,
    payment_failures INT,
    churned INT,
    churned_next_month INT,
    nps_score INT,
    product_incident INT,
    active_seats INT,
    PRIMARY KEY (user_id, month)
);

COPY users 
FROM 'E:\Data Analysis Projects\VirtualWorks Tasks\Task2- Customer Churn Analysis\Datasets\users.csv' 
DELIMITER ',' 
CSV HEADER;

COPY user_monthly 
FROM 'E:\Data Analysis Projects\VirtualWorks Tasks\Task2- Customer Churn Analysis\Datasets\user_monthly.csv' 
DELIMITER ',' 
CSV HEADER;

# SQL Query Results Summary — NexaFlow Churn Analysis

Complete results corresponding to `sql/03_churn_analysis_queries.sql`.

---

## Section 1: Baseline & Churn Overview (`users`)

### 1.1 Overall Churn Rate
* **Total Users:** `5,000`
* **Churned Users (`churned = 1`):** `1,131` (`22.62%`)
* **Active Users (`churned = 0`):** `3,869` (`77.38%`)

### 1.2 Churn by Plan Tier
| Plan Type | Churned Users | Churn Rate (%) |
| :--- | :---: | :---: |
| Starter | 634 | 27.29% |
| Enterprise | 20 | 21.51% |
| Pro | 355 | 19.90% |
| Business | 122 | 15.25% |

### 1.3 Churn by Billing Period
| Billing Period | Churned Users | Churn Rate (%) |
| :--- | :---: | :---: |
| monthly | 938 | 23.50% |
| annual | 193 | 19.15% |

### 1.4 Churn by Payment Method & Discount Status
| Payment Method | Discount Status | Churned Users | Churn Rate (%) |
| :--- | :--- | :---: | :---: |
| card | discounted | 1,028 | 23.51% |
| invoice | discounted | 103 | 16.43% |

### 1.5 Churn by Industry & Acquisition Channel

**By Industry**
| Industry | Total Users | Churned Users | Churn Rate (%) |
| :--- | :---: | :---: | :---: |
| Health | 358 | 93 | 25.98% |
| Logistics | 365 | 92 | 25.21% |
| SaaS | 1,281 | 300 | 23.42% |
| E-commerce | 845 | 188 | 22.25% |
| DevTools | 848 | 185 | 21.82% |
| Media | 376 | 80 | 21.28% |
| FinTech | 510 | 107 | 20.98% |
| EdTech | 417 | 86 | 20.62% |

**By Acquisition Channel**
| Acquisition Channel | Total Users | Churned Users | Churn Rate (%) |
| :--- | :---: | :---: | :---: |
| paid | 1,104 | 279 | 25.27% |
| partner | 705 | 158 | 22.41% |
| outbound | 588 | 131 | 22.28% |
| organic | 1,907 | 419 | 21.97% |
| marketplace | 696 | 144 | 20.69% |

### 1.6 Revenue Impact of Churn
| Status (`churned`) | Users | Total Revenue | Avg LTV (12m) |
| :--- | :---: | :---: | :---: |
| 1 (Churned) | 1,131 | $2,289,384.77 | $1,643.42 |
| 0 (Active) | 3,869 | $18,078,691.40 | $3,161.85 |

---

## Section 2: Activity & Engagement Trends Before Churn (`user_monthly` & `users`)

### 2.1 Pre-Churn Usage Drop & 2.3 Customer Sentiment (NPS)
| `churned_next_month` | User-Months | Distinct Users | Avg Sessions | Avg Feature Usage Score | Avg NPS Score |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | 1,056 | 1,056 | 19.14 | 27.39 | 2.70 |
| 0 | 78,761 | 5,000 | 29.74 | 46.75 | 4.68 |

### 2.2 Seat Under-Utilization
| Utilization Tier | Total Rows | Churned Rows | Churned Row Rate (%) |
| :--- | :---: | :---: | :---: |
| 75%+ | 13,277 | 102 | 0.77% |
| Under 25% | 66,540 | 1,029 | 1.55% |

---

## Section 3: Friction, Support & Billing Pain Points (`user_monthly`)

### 3.1 Support Ticket Load (Next-Month Churn Rate)
| Support Tickets | Monthly Rows | Next-Month Churns | Next-Month Churn Rate (%) |
| :---: | :---: | :---: | :---: |
| 0 | 28,581 | 185 | 0.65% |
| 1 | 27,792 | 302 | 1.09% |
| 2 | 14,750 | 248 | 1.68% |
| 3 | 5,624 | 175 | 3.11% |
| 4 | 2,004 | 87 | 4.34% |
| 5 | 687 | 36 | 5.24% |
| 6 | 233 | 14 | 6.01% |
| 7 | 89 | 6 | 6.74% |
| 8 | 30 | 1 | 3.33% |
| 9 | 16 | 1 | 6.25% |
| 10 | 6 | 0 | 0.00% |
| 11 | 5 | 1 | 20.00% |

### 3.2 Product Incidents
| `product_incident` | Monthly Rows | Next-Month Churns | Next-Month Churn Rate (%) |
| :---: | :---: | :---: | :---: |
| 0 | 78,377 | 1,005 | 1.28% |
| 1 | 1,440 | 51 | 3.54% |

### 3.3 Payment Failures
| Payment Failures | Monthly Rows | Current Churn Rate (%) | Next-Month Churns | Next-Month Churn Rate (%) |
| :---: | :---: | :---: | :---: | :---: |
| 0 | 68,651 | 1.38% | 737 | 1.07% |
| 1 | 10,183 | 1.70% | 275 | 2.70% |
| 2 | 908 | 0.99% | 38 | 4.19% |
| 3 | 70 | 5.71% | 6 | 8.57% |
| 4 | 5 | 0.00% | 0 | 0.00% |

---

## Section 4: Lifecycle Timing & High-Priority Active MRR (`users` & `user_monthly`)

### 4.1 Tenure Stage
| Tenure Stage | Monthly Rows | Churned | Churn Rate (%) |
| :--- | :---: | :---: | :---: |
| later months (6m+) | 46,359 | 672 | 1.45% |
| early onboarding months (0-6m) | 33,458 | 459 | 1.37% |

### 4.2 Active MRR by Plan Type & Billing Period (Latest Month, `churned = 0`)
| Plan Type | Billing Period | Active Users | Total MRR | Avg MRR / User | % of Total Active MRR |
| :--- | :--- | :---: | :---: | :---: | :---: |
| Business | monthly | 485 | $270,066.95 | $556.84 | 26.49% |
| Pro | monthly | 1,122 | $251,377.45 | $224.04 | 24.66% |
| Business | annual | 193 | $158,630.72 | $821.92 | 15.56% |
| Starter | monthly | 1,404 | $95,224.64 | $67.82 | 9.34% |
| Pro | annual | 307 | $88,978.42 | $289.83 | 8.73% |
| Enterprise | annual | 30 | $69,112.23 | $2,303.74 | 6.78% |
| Enterprise | monthly | 43 | $63,994.72 | $1,488.25 | 6.28% |
| Starter | annual | 285 | $22,049.58 | $77.37 | 2.16% |
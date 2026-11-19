# Sonorax — User & Subscription Analytics

**Author:** Ewelina Silina  
**Project Type:** Data Analytics Portfolio Project 
**Tools:** PostgreSQL (SQL) · pgAdmin 4 ·  Google Sheets (pivot tables, XLOOKUP) · Looker Studio · GitHub  
**Dataset:** Synthetic dataset generated with the assistance of AI: 15,000 users, about 215,000 monthly listening records and 6,000 A/B test assignments (January 2024 – September 2026), covering 10 country categories (7 European countries, USA, Brazil and "Other"). All data is fictional and created exclusively for analytical and portfolio purposes.

📊 **[View Dashboard](https://datastudio.google.com/reporting/b7bdd54a-6ee8-45be-aef0-8f65f45b12c4)**  
📊 **[View Google Sheets Analysis](https://docs.google.com/spreadsheets/d/1i2JDQBkH-AwZcbQ26CAiCuM2XQDCLog0N-pFuiwgNQQ/edit?usp=sharing)**

---
# Project Overview

This project explores user behavior, subscription performance, payment activity, and engagement patterns in Sonorax, a fictional music streaming service.

Using a synthetic dataset of 15,000 users, the analysis investigates customer churn, failed payments, Free-to-Premium conversion, listening activity, and evaluates push notifications (A/B test) and promotions.

The goal is to identify factors associated with Premium subscription cancellations, uncover potential revenue risks, and translate  the findings into actionable business recommendations.

The analysis was conducted in PostgreSQL (SQL), cross-checked in Google Sheets, and presented in a 5-page Looker Studio dashboard.   

Each analytical topic follows a structured approach:

**Business Problem → Data → Analysis → Insight → Business Recommendation**

---
# Key Findings 

- **Premium Churn:** 44.9% of Premium users have churned (3,908 users), representing approximately $39K in lost monthly recurring revenue (MRR). Users who leave do so about 11.7 months after signing up, on average. 

- **Payment Failures:** Premium users with failed payments churn more often (54.0%) than Premium users without them (41.5%). Direct Debit (48.1%) and PayPal (43.2%) have the highest share of users with a failed payment, vs 19.0% for Card and 15.4% for Apple Pay. The estimated revenue lost to failed payments is $23.3K.

- **Conversion:** 41% of users who started on the Free plan upgraded to Premium (4,417 of 10,716), on average after 56.5 days. iOS users converted most often (44.2%).
  
- **Listening Activity:** Listening time alone does not meaningfully distinguish Premium users who churn from those who stay (550.6 vs 554.8 minutes per month, on average). Across all users, average monthly listening declined gradually from May 2024 to December 2025 (about 8%) and fell faster between January and September 2026 (about 28%).

- **Push Notification Experiment:** In the A/B test, the 7-day return rate was 72.8% with push notifications vs 50.8% without (about 1,500 users per group), suggesting a positive effect on short-term engagement. Statistical significance was not formally tested.

- **Promotions:** Promotions are associated with lower churn in Europe (−2.1 percentage points), but not in other regions, where the difference is negligible or reversed. This is an observational comparison, not an experiment.
  
---

# Business Problem
Premium is the only paid plan in the dataset, so customer retention is directly tied to recurring revenue. 44.9% of Premium subscribers have cancelled, and the reasons are unclear.

The business needs to understand what is associated with cancellations. Do users listen less before they leave? Do failed payments contribute to subscription loss? Which Free users convert to Premium, how fast, and what influences it? Do push notifications bring users back to the app, and are promotions associated with lower churn?

Without evidence, retention budget is spent on assumptions. This project shows where users are lost and which factors are associated with churn, and turns the findings into data-driven recommendations to protect recurring revenue.

---
# Project Objectives

**The analysis answers these questions:**

**1. Churn:** 

- What percentage of Premium users cancel their subscriptions?   
- How long after signing up do Premium users typically cancel?    
- What is the estimated financial impact of Premium cancellations?

**2. Payments:** 

- Which payment methods have the highest failure rates?   
- Is there an association between failed payments and subscription cancellations?   
- What is the estimated revenue impact of payment failures?

**3. Conversion:** 

- What percentage of Free users convert to Premium?   
- How long does it take users to upgrade to Premium?   
- How do device type, acquisition channel, and use of promotions relate to conversion rates?
  
**4. Engagement:**

- Do users who churn listen less or create fewer playlists than users who stay?   
- How does average listening change over time?  

**5. A/B Testing:** 

- Do push notifications increase the percentage of users who return to the app within 7 days?   

**6. Promotions:**

- Are users who used a promotion less likely to churn?    
- Does the relationship between promotion use and churn vary across regions?
---

# Dataset Description

**Data Source**

The project uses a synthetic dataset generated programmatically (Python/NumPy) with AI assistance (Claude), with realistic relationships built in on purpose. It simulates user behavior, subscriptions, payments, and engagement in a fictional music streaming service, Sonorax.   
The data does not represent real customers or business transactions. All findings demonstrate the analytical workflow using simulated data.

**Dataset Structure**

|Table | Rows | Content |
|------|------|---------|
|`users`|	15,000 | country, age, device, acquisition source, plan, signup / conversion / churn dates, promo flag, payment method and failed payments
|`listening_activity`|	215,324 | listening minutes, sessions, songs played, playlists created, skips
|`ab_test_assignments`|	6,000	| Two A/B tests with variant and 4-week pre/post metrics. This project analyzes the push notifications test (3,000 users)
| country_region | 10 | Google Sheets lookup table: maps each country to a region (Europe, North America, South America, Other). Used with XLOOKUP. |


Simplifications: payments and the conversion date are columns in `users` (no transaction table), there is a single Premium price ($9.99) and currency (USD), and each user converts at most once.

---

# Tools & Technologies

| Tool | Purpose |
|---|---|
| **PostgreSQL + pgAdmin 4** | SQL querying, data manipulation, joins, aggregations, CTEs, and conditional expressions. |
| **Google Sheets** | Data validation, pivot tables, and `XLOOKUP` for data enrichment. |
| **Looker Studio** | Interactive 5-page dashboard with KPI scorecards and visualizations. |
| **GitHub** | Project documentation, SQL code storage, and version control. |

(COS NIE GRA W SQL)

---

# Analysis & Methodology (CALE ZMIENIC)
Defined the business questions and the KPIs for each of them (see section 7).
Loaded the data into PostgreSQL and wrote one SQL file per topic (churn, payments, conversion, engagement, A/B test).
Cross-checked the results in Google Sheets. Pivot tables reproduce the key SQL numbers. A lookup table and `XLOOKUP` add the region to every user.
Validated the numbers. Totals were reconciled between SQL, Sheets and the dashboard (for example, total lost revenue from failed payments is $23,305.72 in all three). This also caught a data-import problem: Google Sheets silently turned some decimals into dates, which was fixed by re-importing with automatic conversion switched off.
Built the dashboard in Looker Studio: one page per topic, each with titled charts and plain-language labels.
A/B test: compared the 7-day return rate of the control and test groups and wrote a short experiment readout (hypothesis, design, result, recommendation, limitations).

---

# Key Performance Indicators (KPIs)

| KPI | Definition | Business Purpose |
| --- | --- | --- |
| Churn Rate | Percentage of users with `subscription_status = 'churned'` within a given group. | Measures subscriber loss. |
| Time to Churn | Difference between `churn_date` and `signup_date`. | Identifies when users leave in their lifecycle. |
| Lost Monthly Revenue (Churn) | Number of churned Premium users × monthly subscription price ($9.99). | Estimates monthly recurring revenue lost due to cancellations. |
| Failed Payment Rate | Percentage of users with at least one failed payment, grouped by payment method. | Identifies payment methods with higher failure rates. |
| Estimated Revenue at Risk (Payments) | Estimated revenue exposure based on failed payment counts and subscription price. | Assesses the potential financial impact of payment failures. |
| Conversion Rate | Percentage of users who started on the Free plan and upgraded to Premium. | Measures Free-to-Premium conversion performance. |
| Time to Convert | Difference between `plan_change_date` and `signup_date`. | Measures how long users take to upgrade. |
| 7-Day Return Rate | Percentage of test users who returned to the app within 7 days (`returned_7d`). | Measures short-term user engagement in the A/B test. |
| Promotional Churn Difference (pp) | Difference in churn rates between users with and without promotions, expressed in percentage points. | Evaluates the relationship between promotions and churn. |

---

# Key Findings & Insights

### 1. Premium Churn and Revenue Impact

- **44.91% of Premium users churned** (3,908 users), compared to 30.07% of Free users.
- Premium cancellations represent an estimated **$39,041 in lost monthly recurring revenue (MRR)**.
- Users remained subscribed for an average of 11.7 months before churning, with subscription durations ranging from 37 to 934 days.

### 2. Payment Failures and Churn

- Premium users with at least one failed payment had a **54.0% churn rate**, compared to 41.5% among users without failed payments.
- Payment failure rates varied significantly across payment methods:

| Payment Method | Failure Rate | Share of Estimated Lost Revenue |
| --- | ---: | ---: |
| Direct Debit | 48.1% | 9.5% |
| PayPal | 43.2% | 43.3% |
| Google Pay | 26.6% | 14.8% |
| Card | 19.0% | 26.9% |
| Apple Pay | 15.4% | 5.5% |

- Estimated revenue at risk from payment failures amounts to **$23,305.72**.
- PayPal accounts for the largest share of estimated revenue at risk, while Direct Debit has the highest payment failure rate.

### 3. User Engagement and Listening Activity

- Average monthly listening time was nearly identical for churned and active Premium users: **550.6 vs. 554.8 minutes**.
- Playlist creation was also similar: **0.74 vs. 0.78 playlists per user**.
- Listening activity remained relatively stable through 2025, then declined by approximately 28% between January and September 2026.

**Insight:** Listening time and playlist creation alone do not meaningfully distinguish churned users from active subscribers.

### 4. Free-to-Premium Conversion

- **41.2% of Free users converted to Premium** (4,417 out of 10,716 users).
- Average time to conversion was 56.5 days.
- Conversion rates varied by device:

| Device | Conversion Rate |
| --- | ---: |
| iOS | 44.2% |
| Android | 40.6% |
| Desktop | 37.6% |
| Web | 37.5% |

- Users associated with promotional offers had a higher conversion rate (64.3%) than users without promotions (28.7%). However, this is an observed association, not evidence of a causal effect.

### 5. Push Notifications – A/B Test

- The notification group achieved a **72.77% 7-day return rate**, compared to 50.84% in the control group.
- This represents an increase of **21.93 percentage points**.
- The test included 3,000 users: 1,513 in the notification group and 1,487 in the control group.

**Insight:** The experiment showed a positive difference in short-term user engagement following push notifications.

### 6. Promotional Campaigns and Regional Churn

Churn rate differences between users with and without promotions varied across regions:

| Region | Churn Rate Difference |
| --- | ---: |
| Europe | -2.06 pp |
| North America | -0.31 pp |
| South America | +0.38 pp |
| Other | +0.84 pp |

- Europe showed the largest negative difference in churn rates among users associated with promotions.
- Other regions showed smaller differences, with slightly higher churn among users associated with promotions.

**Insight:** The relationship between promotions and churn varies by region. These observational results do not establish a causal promotional effect.


---

# Business Recommendations

### 1. Reduce Payment-Related Churn
Prioritize payment recovery by introducing automated payment retries, reminder notifications, and fallback payment methods. Start with PayPal, which accounts for the largest share of estimated revenue at risk, and Direct Debit, which has the highest failure rate. Contact users promptly after a failed payment, as this group shows a higher churn rate (54.0%).

### 2. Strengthen First-Year Retention
Focus retention efforts on the first year of the subscription lifecycle, as users churn after an average of 11.7 months. Introduce targeted engagement campaigns and monitor early signs of disengagement to identify subscribers at risk of cancelling.

### 3. Validate and Expand Push Notifications
Consider rolling out push notifications more broadly, following a statistical significance test to confirm that the observed increase in the 7-day return rate is reliable. If validated, use targeted notifications to encourage users to return to the platform.

### 4. Improve Churn Detection
Do not rely on listening time alone as an early-warning indicator. Combine payment-related signals with changes in individual user activity over time to identify potential churn more effectively.

### 5. Optimize Promotional Campaigns
Evaluate promotional campaigns through controlled experiments before reallocating marketing budgets. Pay particular attention to Europe, where the largest difference in churn rates between users with and without promotions was observed.

### 6. Prioritize Mobile Conversion
Focus conversion optimization efforts on mobile users, particularly iOS, which has the highest Free-to-Premium conversion rate (44.2%), followed by Android (40.6%). Investigate which aspects of the mobile experience may support stronger conversion performance.

---

# Dashboard Preview (OPISAC WAZNE RZECZY Z DASHBOARD)

---

# Repository Structure 

```
sonorax_premium_churn/
├── README.md
├── data_dictionary.md                 # column descriptions
├── users.csv                          # full data (large, no preview on GitHub)
├── listening_activity.csv
├── ab_test_assignments.csv
├── users_sample.csv                   # first 100 rows, for quick preview
├── listening_activity_sample.csv
├── sql/
│   ├── 01_premium_churn.sql           # churn rate, time to churn, lost revenue
│   ├── 02_payments.sql                # failed payments and their impact
│   ├── 03_conversion.sql              # Free -> Premium conversion
│   ├── 04_engagement_decline.sql      # listening activity and trend
│   └── 05_ab_test_notifications.sql   # A/B test of push notifications
└── dashboard/                         # dashboard screenshots
```

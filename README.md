# sonorax_premium_churn
SQL, Google Sheets and Looker Studio analysis of Premium churn for a fictional streaming service (synthetic data)
Sonorax — Premium Churn & Retention Analysis
SQL · Google Sheets · Looker Studio
1. Project Title & Overview
This project analyzes why Sonorax, a fictional music streaming service, is losing Premium subscribers, and what the company could do about it. It uses a synthetic dataset of 15,000 users with their subscription, payment and listening history. The analysis is done in SQL (PostgreSQL), cross-checked in Google Sheets, and presented in a 5-page Looker Studio dashboard. Every topic follows the same path: Problem → Data → Analysis → Insight → Business decision.
Results at a glance
44.9% of Premium users have churned, which is about $39K of monthly recurring revenue lost.
Failed payments are a clear warning sign: those users churn at 54.0% vs 41.5%. Direct Debit and PayPal fail the most.
Push notifications raised the 7-day return rate from 50.8% to 72.8% in an A/B test.
Listening time alone does not separate users who leave from users who stay.
Dashboard: [DASHBOARD_LINK]
---
2. Business Problem
Premium is the only paid plan in the data, so every cancelled subscription is lost recurring revenue. Sonorax sees that many Premium users leave, but does not know why. Is it that users stop listening? Are payments failing? Are the wrong people being converted from Free? And which actions (notifications, promotions) actually help?
Without answers, retention budget is spent blindly. This project gives the business a data-based picture of where users are lost and where to act first.
---
3. Project Objectives
The analysis answers these questions:
Churn: How many Premium users leave, after how long, and how much revenue does it cost?
Payments: Which payment methods fail most? Does a failed payment lead to cancellation? How much revenue is lost?
Conversion: How many Free users become Premium, how fast, and does device, acquisition channel or promotion matter?
Engagement: Do users listen less or create fewer playlists before they leave?
Experiment: Do push notifications increase the number of users who return to the app within 7 days?
Promotions: Do promotions go together with lower churn, and does this differ by region?
---
4. Dataset Description
The data is synthetic: it was generated programmatically (Python/NumPy) with AI assistance (Claude), with realistic relationships built in on purpose. The findings therefore demonstrate the analytical workflow, not the behavior of real customers.
Table	Rows	Content
`users`	15,000	One row per user: country, age, device, acquisition source, plan, signup / conversion / churn dates, promo flag, payment method and failed payments
`listening_activity`	~215,000	One row per user per month: listening minutes, sessions, songs played, playlists created, skips
`ab_test_assignments`	6,000	Two A/B tests with variant and 4-week pre/post metrics. This project analyzes the push notifications test (3,000 users)
A separate lookup table `country_region` (10 rows) maps each country to a region (Europe, North America, South America, Other).
Column descriptions are in `data_dictionary.md`.
Simplifications: payments and the conversion date are columns in `users` (no transaction table), there is a single Premium price ($9.99) and currency (USD), and each user converts at most once.
---
5. Tools & Technologies
Tool	Used for
PostgreSQL + pgAdmin 4	Data storage and analysis: joins, aggregations, conditional logic (`CASE WHEN`, `FILTER`)
Google Sheets	Pivot tables to cross-check SQL results, `XLOOKUP` to add region to users
Looker Studio	5-page interactive-style dashboard with scorecards, bar, line and donut charts
Python (NumPy)	Generating the synthetic dataset (with AI assistance)
GitHub	Version control and portfolio
---
6. Analysis & Methodology
Defined the business questions and the KPIs for each of them (see section 7).
Loaded the data into PostgreSQL and wrote one SQL file per topic (churn, payments, conversion, engagement, A/B test).
Cross-checked the results in Google Sheets. Pivot tables reproduce the key SQL numbers. A lookup table and `XLOOKUP` add the region to every user.
Validated the numbers. Totals were reconciled between SQL, Sheets and the dashboard (for example, total lost revenue from failed payments is $23,305.72 in all three). This also caught a data-import problem: Google Sheets silently turned some decimals into dates, which was fixed by re-importing with automatic conversion switched off.
Built the dashboard in Looker Studio: one page per topic, each with titled charts and plain-language labels.
A/B test: compared the 7-day return rate of the control and test groups and wrote a short experiment readout (hypothesis, design, result, recommendation, limitations).
---
7. Key Performance Indicators (KPIs)
KPI	Definition	Why it matters
Churn rate	Share of users with `subscription_status = churned` in a group	The main measure of lost subscribers
Time to churn	`churn_date` − `signup_date`	Shows when in the lifecycle users leave
Lost monthly revenue (churn)	Churned Premium users × monthly price ($9.99)	Size of the problem in money (one month, not lifetime value)
Failed payment rate	Share of users with at least one failed payment, by payment method	Shows which payment methods are risky
Estimated lost revenue (payments)	Estimate based on the number of failed payments × price	Money at risk from payment failures
Conversion rate	Share of users who started as Free and became Premium	How well Free users turn into customers
Time to convert	`plan_change_date` − `signup_date`	How long conversion takes
7-day return rate	Share of test users who came back within 7 days (`returned_7d`)	The metric of the A/B test
Promo effect (pp)	Churn rate with promotion minus churn rate without, in percentage points	Direction and size of the promo difference
---
8. Key Findings & Insights
1. Premium churn is high and expensive.
44.91% of Premium users churned (3,908 users) vs 30.07% of Free users. That is about $39,041 of lost monthly recurring revenue. Users leave after 11.7 months on average (the fastest after 37 days, the slowest after 934 days).
2. Failed payments are a clear churn signal.
Premium users with a failed payment churned at 54.0%, vs 41.5% for users without one. Failure rates differ a lot by payment method:
Payment method	Users with a failed payment	Share of lost revenue
Direct Debit	48.1%	9.5%
PayPal	43.2%	43.3%
Google Pay	26.6%	14.8%
Card	19.0%	26.9%
Apple Pay	15.4%	5.5%
Estimated lost revenue is $23,305.72. PayPal accounts for the biggest share because it has the most users, even though Direct Debit fails more often.
3. Listening time alone does not explain churn.
Churned and active Premium users listen almost the same: 550.6 vs 554.8 minutes per month, and create about the same number of playlists (0.74 vs 0.78). Across all users, average listening was stable through 2025 (about −8% from May 2024 to December 2025) and fell faster from February 2026 (about −28% from January to September 2026).
4. Conversion: 41% of Free users become Premium.
4,417 of 10,716 users converted, on average after 56.5 days. iOS converts best (44.2%), then Android (40.6%), Desktop (37.6%) and Web (37.5%). Users who used a promotion converted much more often (64.3% vs 28.7%), but this is a correlation: it is not known whether the promotion came before the conversion.
5. Push notifications work in the A/B test.
7-day return rate: 50.84% in the control group (1,487 users) vs 72.77% in the notifications group (1,513 users), a difference of 21.93 percentage points.
6. Promotions and churn differ by region.
Churn with vs without a promotion: Europe 37.33% vs 39.40% (−2.06 pp), North America −0.31 pp, South America +0.38 pp, Other +0.84 pp. Only Europe shows a clear difference. This is an observation, not an experiment.
---
9. Business Recommendations
Fix payment failures first. Add payment retries, reminder messages and a fallback payment method, starting with PayPal (largest revenue at risk) and Direct Debit (highest failure rate). Contact users right after a failed payment, because this group churns most (54.0%).
Focus retention on the first year, because users leave after about 11.7 months on average.
Roll out push notifications, after confirming the result with a statistical significance test.
Do not rely on listening time alone for an early-warning system. Combine it with payment signals and the change in each user's activity over time.
Test promotions in controlled experiments before moving budget, especially in Europe where the difference is largest. In conversion, prioritize mobile (iOS and Android).
---
10. Dashboard Preview
Live dashboard: [DASHBOARD_LINK]
Page 1: Premium Churn
![Premium Churn](dashboard/01_premium_churn.png)
Page 2: Conversion
![Conversion](dashboard/02_conversion.png)
Page 3: Payments
![Payments](dashboard/03_payments.png)
Page 4: A/B Test, Push Notifications
![A/B Test](dashboard/04_ab_test.png)
Page 5: Regional & Promo Insights
![Regional and Promo Insights](dashboard/05_regional_promo.png)
---
11. Repository Structure
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
How to reproduce
Create a database in PostgreSQL and load the three CSV files (header = yes).
Run the SQL files `01` to `05` and export the results as CSV.
In Google Sheets, import `users.csv` with "Convert text to numbers, dates and formulas" switched off, otherwise some numbers turn into dates. Then build the pivot tables and the region column with `XLOOKUP`.
Upload the result files to Looker Studio as data sources.
---
12. Limitations & Future Improvements
Limitations
Synthetic data. Relationships are built in on purpose, so the project shows the analytical workflow and not the behavior of real users.
A/B test: no formal statistical significance test. The conclusion rests on the size of the difference (21.93 pp) and the sample (about 1,500 users per group).
Promotions (conversion and region) are correlations, not proof of cause and effect.
Payments are columns in `users` without transaction history, so lost revenue from failed payments is an estimate.
Lost revenue from churn covers one month, not customer lifetime value.
One price and one currency (no Individual / Duo / Family plans).
Churn is measured over the whole period, without cohort analysis.
The dashboard is static (no filters).
Future improvements
Test statistical significance of the A/B test in Python (two-proportion z-test).
Cohort analysis and per-user change in engagement (first vs last 3 months of activity).
Interactive dashboard with filters (plan, region, device) built on the full `users` table.
A second project on a real public dataset.

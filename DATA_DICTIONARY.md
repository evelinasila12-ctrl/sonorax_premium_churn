## 1. About the data

| Item | Value |
|---|---|
| Signup period | January 2024 – May 2026 |
| Listening activity period | January 2024 – September 2026 |
| Data cut-off  | 1 September 2026 |
| Currency | USD |
| Premium price | $9.99 per month |


## 2. Tables overview

| Object | Where | Grain (one row = ) | Rows |
|---|---|---|---|
| users | PostgreSQL, CSV | one user | 15,000 |
| listening_activity | PostgreSQL, CSV | one user in one month | 215,324 |
| ab_test_assignments | PostgreSQL, CSV | one user in one test | 6,000 |
| country_region | Google Sheets | one country | 10 |

## 3. PostgreSQL tables

### 3.1 users

Primary key: user_id.

| Column | Type | Description |
|---|---|---|
| user_id | VARCHAR(10) | Unique user ID, U000001 to U015000. |
| country | VARCHAR(50) | Poland, USA, Germany, UK, Brazil, France, Spain, Sweden, Netherlands, Other (catch-all category). |
| age | INT | Age in years, 16–65. |
| device | VARCHAR(20) | Main device: Android, iOS, Web, Desktop. |
| acquisition_source | VARCHAR(30) | Acquisition channel: organic, paid_ads, social_media, referral, partnership. |
| signup_date | DATE | Registration date. |
| initial_plan | VARCHAR(10) | Plan at signup: Free (10,716 users) or Premium (4,284 users). |
| plan | VARCHAR(10) | Plan held by the user: Premium (8,701) or Free (6,299). Premium means the user started on Premium or converted to it. Users who cancelled keep plan = Premium; the cancellation is recorded in subscription_status and churn_date. |
| plan_change_date | DATE, NULL | Date of the Free → Premium conversion (4,417 users). NULL for users who never converted and for users who started on Premium. |
| promo_used | BOOLEAN | Whether the user used a promotional offer. User-level flag; the date of the promotion is not recorded. |
| subscription_status | VARCHAR(10) | active (9,198 users) or churned (5,802 users: 3,908 Premium, 1,894 Free). For Free users, churned means they left the service. |
| churn_date | DATE, NULL | Date of cancellation. NULL for active users. |
| payment_method | VARCHAR(20), NULL | Card (3,730), PayPal (2,239), Google Pay (1,392), Apple Pay (941), Direct Debit (399). NULL for users who never had Premium. |
| monthly_price | NUMERIC(6,2) | 9.99 for Premium users, 0.00 for Free users. |
| failed_payments_count | INT | Number of failed payments in the user's history. Always 0 for Free users. 2,381 users have at least one (2,911 failed payments in total). |
| last_payment_status | VARCHAR(10), NULL | Status of the last payment: success or failed. NULL for Free users. |
| last_failed_payment_date | DATE, NULL | Date of the last failed payment. NULL if the user had none. |
| estimated_lost_revenue | NUMERIC(10,2) | Estimate: failed_payments_count × monthly_price × recovery factor. The recovery factor is random between 0.6 and 1.0 and reflects that part of the failed payments is retried successfully. 0 if there were no failed payments. Total: $23,305.72. |

### 3.2 listening_activity

One row per user per month, from the signup month to the churn month (churned users) or to September 2026 (active users), limited to the user's last 20 months.

| Column | Type | Description |
|---|---|---|
| user_id | VARCHAR(10) | Foreign key to users.user_id. |
| month | VARCHAR(7) | Calendar month stored as text, YYYY-MM (2024-01 to 2026-09). |
| listening_minutes | NUMERIC(10,1) | Total listening minutes in the month. |
| sessions | INT | Number of app sessions in the month. |
| songs_played | INT | Number of songs played. |
| playlists_created | INT | Number of new playlists created in the month. |
| skips | INT | Number of skipped songs. |

### 3.3 ab_test_assignments

The A/B test includes 6,000 users, with 3,000 assigned to group A and 3,000 to group B. Eligible users were active and had signed up at least 90 days before the first assignment date. Variants were assigned randomly. Only the push_notifications test is analyzed in this project.

| Column | Type | Description |
|---|---|---|
| user_id | VARCHAR(10) | Foreign key to users.user_id. |
| test_name | VARCHAR(30) | recommendation_engine (B = new recommendation algorithm) or push_notifications (B = push notifications enabled). |
| variant | VARCHAR(1) | A = control group, B = test group. In push_notifications: A has 1,487 users, B has 1,513. |
| assignment_date | DATE | Date the user was assigned to the test (June–July 2026). |
| minutes_4w_pre | NUMERIC(10,1) | Listening minutes in the 4 weeks before assignment. |
| sessions_4w_pre | INT | Sessions in the 4 weeks before assignment. |
| minutes_4w_post | NUMERIC(10,1) | Listening minutes in the 4 weeks after assignment. |
| sessions_4w_post | INT | Sessions in the 4 weeks after assignment. |
| returned_7d | INT | 1 = the user returned to the app within 7 days of assignment, 0 = did not. |

## 4. Google Sheets objects

### 4.1 Lookup table country_region

Maps each country to a region. Used by XLOOKUP to add a region to every user.

| country | region | currency |
|---|---|---|
| Poland | Europe | PLN |
| Germany | Europe | EUR |
| France | Europe | EUR |
| Spain | Europe | EUR |
| Sweden | Europe | SEK |
| Netherlands | Europe | EUR |
| UK | Europe | GBP |
| USA | North America | USD |
| Brazil | South America | BRL |
| Other | Other | n/a |

currency is informational and is not used in any calculation.

### 4.2 Columns added to the users sheet

| Column | Values | Logic |
|---|---|---|
| had_failed_payment | yes / no | yes if failed_payments_count > 0. Used to compare churn with and without a failed payment. |
| is_churned | 1 / 0 | 1 if subscription_status = churned. The average of this column is the churn rate. |
| failed_payment_flag | 1 / 0 | 1 if failed_payments_count > 0. The average by payment_method is the share of users with a failed payment. |
| region | text | Region of the user's country: =XLOOKUP(country, country_region!A:A, country_region!B:B). |

### 4.3 Sheets tabs used in the analysis

| Tab | Content |
|---|---|
| users | Imported users.csv with the four added columns above. |
| country_region | Lookup table (4.1). |
| payment_methods | Pivot table: users, average failed payments and share of users with a failed payment, by payment method. |
| failed_payment_churn | Pivot table: churn rate by had_failed_payment, filtered to Premium users. |
| revenue_lost | Pivot table: sum of estimated_lost_revenue and number of users, by payment method. |
| promo_region_churn | Pivot table: churn rate by region and promo_used, all users. |
| promo_region_clean | Values copied from the pivot above as a clean source for the dashboard: region, no_promo, with_promo (churn rate without and with a promotion) and difference_pp (with_promo − no_promo, in percentage points). |

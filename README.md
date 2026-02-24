# Customer Lifecycle & Retention Cohort Analysis

Cohort-based customer lifecycle and retention analysis using MySQL and Power BI to identify early churn patterns and revenue concentration in an e-commerce business.

---

## Project Overview

This project analyzes how customer behaviour evolves after first purchase using cohort-based retention analysis.

The objective was to determine whether growth challenges stem from low customer value or weak early lifecycle retention.

**Industry:** E-commerce / Consumer Retail  
**Time Period:** January 2023 – March 2024  
**Dataset Size:** ~17,000 transactions | ~5,000 unique customers  

---

## Business Problem

The business wanted to:

- Understand post-acquisition customer behaviour  
- Identify where retention loss occurs  
- Reduce dependency on continuous new customer acquisition  

The analysis supports decisions around improving early retention rather than scaling acquisition alone.

---

## Dataset

**Source:** Kaggle – E-Commerce Customer Behavior & Sales Analysis (TR)

The dataset includes:

- Transaction-level order data  
- Customer ID and order date  
- Revenue, quantity, discount amount  
- Product category, payment method, city  
- Returning customer flag  

---

## Methodology

### 1. Cohort Identification

Each customer's first purchase date was identified to define acquisition cohorts.

```sql
SELECT Customer_ID, MIN(Date) AS first_purchase_date
FROM project2ecom.eccbp2
GROUP BY Customer_ID;
```

Cohort month was derived as:

```sql
DATE_FORMAT(first_purchase_date, '%Y-%m') AS cohort_month
```

---

### 2. Lifecycle (Month_Number) Calculation

Each transaction was mapped to a lifecycle position relative to the first purchase month.

```sql
PERIOD_DIFF(
  EXTRACT(YEAR_MONTH FROM o.Date),
  EXTRACT(YEAR_MONTH FROM fp.first_purchase_date)
) AS month_number
```

- Month 0 → Acquisition month  
- Month 1+ → Post-acquisition activity  

---

### 3. Cohort Activity Matrix

Distinct active customers were counted by cohort and lifecycle month.

```sql
COUNT(DISTINCT Customer_ID) AS active_customers
```

This forms the retention activity matrix.

---

### 4. Retention Calculation

Cohort size was defined as customers active in Month 0.

Retention Percentage:

```sql
ROUND(100 * active_customers / cohort_customers, 2) AS retention_pct
```

Each lifecycle month is measured relative to its original cohort base.

---

### 5. Revenue & Lifecycle Value Analysis

Revenue and Average Order Value (AOV) were aggregated across cohorts and lifecycle months.

```sql
SUM(Total_amount) AS revenue,
AVG(Total_amount) AS avg_order_value
```

This links retention behaviour with revenue impact.

---

## Key Insights

1. ~80% of customers do not return after Month 0  
   Month 1 retention ≈ 20%

2. Retention stabilizes after Month 1, indicating a consistent repeat-buyer base

3. Average Revenue per Active Customer increases across lifecycle months

4. Growth dependency is driven by weak early retention rather than weak customer value

---

## Business Recommendations

- Improve Month 0–1 customer experience  
- Introduce repeat-purchase incentives within 30 days  
- Shift marketing focus toward lifecycle retention  
- Monitor cohort health monthly  

---

## Dashboard Preview

<img width="1150" height="677" alt="Screenshot 2026-02-23 005908" src="https://github.com/user-attachments/assets/27e8793a-6902-4416-9949-203f64a4abb7" />


The dashboard includes:

- Executive retention KPIs  
- Cohort retention heatmap  
- Lifecycle revenue progression  
- Average Order Value trends  

---

## Tools Used

- MySQL – Cohort logic & retention calculations  
- Power BI – Data modeling, DAX measures, visualization  
- Excel – Data validation & exploratory checks  


---

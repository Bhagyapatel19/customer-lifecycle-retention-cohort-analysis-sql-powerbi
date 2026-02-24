SELECT * FROM project2ecom.eccbp2;

/* Cohort activity matrix (customers active in each lifecycle month)
*/
with 
First_purchase as (SELECT Customer_ID, min(date) as first_purchase_date FROM project2ecom.eccbp2
group by Customer_ID),
cohort_base as 
	(select o.Customer_id, 
    o.date as Purchase_date, 
    fp.first_purchase_date, 
    date_format(fp.first_purchase_date,'%Y-%m') as Cohort_month, 
    period_diff(
    Extract(YEAR_MONTH from o.date),
    Extract(YEAR_Month from fp.first_purchase_date)) as Month_number, 
    o.total_amount
    From project2ecom.eccbp2 o join first_purchase fp on o.customer_id = fp.customer_id)
    select Cohort_month, month_number, count(distinct customer_id) as Active_customers
    from cohort_base
    group by cohort_month, month_number
    order by Cohort_month, Month_number;
    
    
    /*  Retention % (based on Month 0 size) using the ACTIVITY matrix 
*/
 with 
First_purchase as (SELECT Customer_ID, min(date) as first_purchase_date FROM project2ecom.eccbp2
group by Customer_ID),
cohort_base as 
	(select o.Customer_id, 
    o.date as Purchase_date, 
    fp.first_purchase_date, 
    date_format(fp.first_purchase_date,'%Y-%m') as Cohort_month, 
    period_diff(
    Extract(YEAR_MONTH from o.date),
    Extract(YEAR_Month from fp.first_purchase_date)) as Month_number, 
    o.total_amount
    From project2ecom.eccbp2 o join first_purchase fp on o.customer_id = fp.customer_id),
    activity AS (
  SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT Customer_ID) AS active_customers
  FROM cohort_base
  GROUP BY cohort_month, month_number),
  cohort_size as (
  select Cohort_month, month_number, Active_Customers as Cohort_customers
  from Activity
  where Month_number = 0)
  select a.cohort_month,
		 a.month_number,
         a.active_customers,
         cs.cohort_customers,
         Round(100* a.active_customers /cs.cohort_customers,2) as Retaintion_PT
   FROM activity a join cohort_size cs on a.cohort_month = cs.cohort_month
   order by Cohort_month, Month_number;
   
   /*  Cohort revenue by lifecycle month 
*/
WITH first_purchase AS (
  SELECT Customer_ID, MIN(Date) AS first_purchase_date
  FROM project2ecom.eccbp2
  GROUP BY Customer_ID
),
cohort_base AS (
  SELECT
    o.Customer_ID,
    DATE_FORMAT(fp.first_purchase_date, '%Y-%m') AS cohort_month,
    PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM o.Date), EXTRACT(YEAR_MONTH FROM fp.first_purchase_date)) AS month_number,
    o.Total_amount
  FROM project2ecom.eccbp2 o
  JOIN first_purchase fp ON o.Customer_ID = fp.Customer_ID
)
SELECT
  cohort_month,
  month_number,
  SUM(Total_amount) AS revenue,
  AVG(Total_amount) AS avg_order_value
FROM cohort_base
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
  


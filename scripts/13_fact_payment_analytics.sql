-- 2. Analyze how much money is spent
-- Per month, quarter, year
-- Per member, based on the age of the rider at account start
SELECT
  dd.year,
  dd.quarter,
  dd.month,
  sum(fp.amount) as sum_value
FROM
  dbo.fact_payment fp
  INNER JOIN dbo.dim_date dd ON fp.date = dd.date
GROUP by
  dd.year,
  dd.quarter,
  dd.month
ORDER BY 
  dd.year,
  dd.quarter,
  dd.month;


SELECT
  fp.rider_id,
  fp.rider_age_account_start,
  sum(fp.amount)
FROM
  dbo.fact_payment fp
GROUP BY
  fp.rider_id,
  fp.rider_age_account_start
ORDER BY
  fp.rider_id,
  fp.rider_age_account_start;
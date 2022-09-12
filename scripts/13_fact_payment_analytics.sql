SELECT
  dd.quarter,
  sum(fp.amount)
FROM
  dbo.fact_payment fp
  INNER JOIN dbo.dim_date dd ON fp.date = dd.date
GROUP by
  dd.quarter;

GO;

SELECT
  dd.month,
  sum(fp.amount)
FROM
  dbo.fact_payment fp
  INNER JOIN dbo.dim_date dd ON fp.date = dd.date
GROUP by
  dd.month;

GO;

SELECT
  dd.year,
  sum(fp.amount)
FROM
  dbo.fact_payment fp
  INNER JOIN dbo.dim_date dd ON fp.date = dd.date
GROUP by
  dd.year;

GO;

SELECT
  fp.rider_id,
  fp.rider_age_account_start,
  sum(fp.amount)
FROM
  dbo.fact_payment fp
  INNER JOIN dbo.dim_date dd ON fp.date = dd.date
GROUP BY
  fp.rider_id,
  fp.rider_age_account_start
ORDER BY
  fp.rider_id,
  fp.rider_age_account_start;

GO;
-- min: 2021-02-01T01:07:04.0000000
-- max: 2022-02-01T00:12:04.0000000
DECLARE @StartDate DATE = '20210101', @NumberOfYears INT = 10;



CREATE TABLE #dimdate
(
  [date]       DATE,  
  [day]        tinyint,
  [month]      tinyint,
  [first_of_month] date,
  [month_name]  varchar(12),
  [week]       tinyint,
  [iso_week]    tinyint,
  [day_week]  tinyint,
  [quarter]    tinyint,
  [year]       smallint,
  [first_of_year]  date,
  [style_112]     char(8),
  [style_101]     char(10)
);


SET DATEFIRST 7;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;

DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);

INSERT #dimdate([date]) 
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, (rn - 1), @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    ORDER BY s1.[object_id]
  ) AS x
) AS y;


UPDATE #dimdate 
set 
  [day]        = DATEPART(DAY,      [date]),
  [month]      = DATEPART(MONTH,    [date]),
  [first_of_month] = CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),
  [month_name]  = DATENAME(MONTH,    [date]),
  [week]       = DATEPART(WEEK,     [date]),
  [iso_week]    = DATEPART(ISO_WEEK, [date]),
  [day_week]  = DATEPART(WEEKDAY,  [date]),
  [quarter]    = DATEPART(QUARTER,  [date]),
  [year]       = DATEPART(YEAR,     [date]),
  [first_of_year]  = CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [date]), 0)),
  [style_112]     = CONVERT(CHAR(8),   [date], 112),
  [style_101]     = CONVERT(CHAR(10),  [date], 101)
;


CREATE TABLE dbo.dim_date
WITH
(
    DISTRIBUTION = HASH ( [date] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT
  [date]        = [date],
  [day]         = CONVERT(TINYINT, [day]),
  day_suffix     = CONVERT(CHAR(2), CASE WHEN [day] / 10 = 1 THEN 'th' ELSE 
                  CASE RIGHT([day], 1) WHEN '1' THEN 'st' WHEN '2' THEN 'nd' 
	              WHEN '3' THEN 'rd' ELSE 'th' END END),
  [weekday]     = CONVERT(TINYINT, [day_week]),
  [weekday_name] = CONVERT(VARCHAR(10), DATENAME(WEEKDAY, [date])),
  [dow_in_month]  = CONVERT(TINYINT, ROW_NUMBER() OVER 
                  (PARTITION BY first_of_month, [day_week] ORDER BY [date])),
  [day_year]   = CONVERT(SMALLINT, DATEPART(dayofyear, [date])),
  [week_of_month]   = CONVERT(TINYINT, DENSE_RANK() OVER 
                  (PARTITION BY [year], [month] ORDER BY [week])),
  [week_of_year]    = CONVERT(TINYINT, [week]),
  [iso_week_of_year] = CONVERT(TINYINT, iso_week),
  [month]       = CONVERT(TINYINT, [month]),
  [month_name]   = CONVERT(VARCHAR(10), [month_name]),
  [quarter]     = CONVERT(TINYINT, [quarter]),
  [quarter_name]   = CONVERT(VARCHAR(6), CASE [quarter] WHEN 1 THEN 'First' 
                  WHEN 2 THEN 'Second' WHEN 3 THEN 'Third' WHEN 4 THEN 'Fourth' END), 
  [year]        = [year],
  [mmyyyy]        = CONVERT(CHAR(6), LEFT(style_101, 2)    + LEFT(style_112, 4)),
  [month_year]     = CONVERT(CHAR(8), LEFT([month_name], 3) + ' ' + LEFT(style_112, 4)),
  [first_day_of_month]     = first_of_month,
  [last_day_of_month]      = MAX([date]) OVER (PARTITION BY [year], [month]),
  [first_day_of_quarter]   = MIN([date]) OVER (PARTITION BY [year], [quarter]),
  [last_day_of_quarter]    = MAX([date]) OVER (PARTITION BY [year], [quarter]),
  [first_day_of_year]      = [first_of_year],
  [last_day_of_year]       = MAX([date]) OVER (PARTITION BY [year]),
  [first_day_of_nextmonth] = DATEADD(MONTH, 1, [first_of_month]),
  [first_day_of_nextyear]  = DATEADD(YEAR,  1, [first_of_year])
FROM #dimdate
;

DROP Table #dimdate;
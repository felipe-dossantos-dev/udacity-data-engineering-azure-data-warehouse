--     - Based on date and time factors such as day of week and time of day
select
  [dd_start].[weekday],
  [dt_start].[hour],
  [dt_start].[minute_15],
  AVG([ft].[time_spent]) AS avg_time_spent
from
  [dbo].[fact_trip] ft
  inner join [dbo].[dim_time] dt_start ON [dt_start].[time] = [ft].[start_at_time_key]
  inner join [dbo].[dim_date] dd_start ON [dd_start].[date] = [ft].[start_at_date]
where
  [dd_start].[weekday] = 1
GROUP BY
  [dd_start].[weekday],
  [dt_start].[hour],
  [dt_start].[minute_15]
ORDER BY
  [dd_start].[weekday],
  [dt_start].[hour],
  [dt_start].[minute_15];


--     - Based on which station is the starting and / or ending station
select
  [dd_start].[weekday],
  [ft].[start_station_id],
  [ft].[end_station_id],
  AVG([ft].[time_spent]) AS avg_time_spent
from
  [dbo].[fact_trip] ft
  inner join [dbo].[dim_time] dt_start ON [dt_start].[time] = [ft].[start_at_time_key]
  inner join [dbo].[dim_time] dt_end ON [dt_end].[time] = [ft].[ended_at_time_key]
  inner join [dbo].[dim_date] dd_start ON [dd_start].[date] = [ft].[start_at_date]
  inner join [dbo].[dim_date] dd_end ON [dd_end].[date] = [ft].[ended_at_date]
where
  [ft].[start_station_id] = 'TA1305000032'
  and [ft].[end_station_id] = 'TA1305000032'
GROUP BY
  [dd_start].[weekday],
  [ft].[start_station_id],
  [ft].[end_station_id]
ORDER BY
  [dd_start].[weekday];

--     - Based on age of the rider at time of the ride
select
  [ft].[rider_age],
  AVG([ft].[time_spent]) AS avg_time_spent,
  SUM([ft].[time_spent]) AS sum_time_spent
from
  [dbo].[fact_trip] ft
where
  [ft].[rider_age] = 25
GROUP BY
  [ft].[rider_age]
ORDER BY
  [ft].[rider_age];


--     - Based on whether the rider is a member or a casual rider
select
  [ft].[is_member],
  AVG([ft].[time_spent]) AS avg_time_spent,
  SUM([ft].[time_spent]) AS sum_time_spent
from
  [dbo].[fact_trip] ft
GROUP BY
  [ft].[is_member]
ORDER BY
  [ft].[is_member];


-- Based on how many rides the rider averages per month
select
  [ft].[rider_id],
  [dd_start].[month],
  COUNT(1) AS rides_per_month
from
  [dbo].[fact_trip] ft
  inner join [dbo].[dim_date] dd_start ON [dd_start].[date] = [ft].[start_at_date]
GROUP BY
  [ft].[rider_id],
  [dd_start].[month]
ORDER BY
  [ft].[rider_id],
  [dd_start].[month];

-- Based on how many minutes the rider spends on a bike per month
select
  [ft].[rider_id],
  [dd_start].[month],
  SUM([ft].[time_spent]) AS rides_per_month
from
  [dbo].[fact_trip] ft
  inner join [dbo].[dim_date] dd_start ON [dd_start].[date] = [ft].[start_at_date]
GROUP BY
  [ft].[rider_id],
  [dd_start].[month]
ORDER BY
  [ft].[rider_id],
  [dd_start].[month];
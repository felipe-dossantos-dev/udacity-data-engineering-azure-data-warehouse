select
  *
from
  [dbo].[fact_trip] ft
where
  [ft].[start_at_date] = '2021-03-16'
  and [ft].[start_at_time_key] = '07:48:00'
  and [ft].[start_station_id] = 'TA1305000032'
  and [ft].[end_station_id] = 'WL-012';

GO;

select
  [dd_start].[weekday],
  [ft].[start_station_id],
  [ft].[end_station_id],
  AVG([ft].time_spent) AS avg_time_spent
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

GO;
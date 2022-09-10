CREATE TABLE [dbo].[fact_trip]
(
    [trip_id] nvarchar(400) null, 
    [time_spent] int null, 
    [rideable_type] nvarchar(50) null, 
    [rider_age] int null, 
    [rider_id] bigint null, 
    [start_station_id] nvarchar(400) null, 
    [start_at_date] date, 
    [start_at_time] time, 
    [end_station_id] nvarchar(400) null, 
    [ended_at_date] date, 
    [ended_at_time] time,
    [is_member] bit
)
WITH
  (
    DISTRIBUTION = HASH ([trip_id]),
    CLUSTERED
    COLUMNSTORE INDEX
  );
GO

INSERT INTO [dbo].[fact_trip] (
    [trip_id],
    [time_spent],
    [rideable_type],
    [rider_age],
    [rider_id],
    [start_station_id],
    [start_at_date],
    [start_at_time],
    [end_station_id],
    [ended_at_date],
    [ended_at_time],
    [is_member]
)  
SELECT
    [st].trip_id,
    DATEDIFF(MINUTE, [st].start_at, [st].ended_at),
    [st].rideable_type,
    DATEDIFF(YEAR, [dr].birthday, [st].start_at),
    [st].rider_id,
    [st].start_station_id,
    CONVERT(date, [st].start_at), --zerar segundos
    CONVERT(time, [st].start_at),
    [st].end_station_id,
    CONVERT(date, [st].ended_at), --zerar segundos
    CONVERT(time, [st].ended_at),
    [dr].is_member
FROM
  [dbo].[staging_trip] AS [st]
INNER JOIN [dbo].[dim_rider] AS dr ON [st].rider_id = [dr].rider_id;
GO

SELECT TOP 100 * FROM dbo.fact_trip
GO
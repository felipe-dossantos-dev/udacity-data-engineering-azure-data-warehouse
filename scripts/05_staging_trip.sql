CREATE EXTERNAL TABLE staging_trip (
	[trip_id] nvarchar(400),
	[rideable_type] nvarchar(50),
	[start_at] datetime2(7),
	[ended_at] datetime2(7),
	[start_station_id] nvarchar(400),
	[end_station_id] nvarchar(400),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'trip.csv',
	DATA_SOURCE = [udacityproject_synapselearnblob_dfs_core_windows_net],
	FILE_FORMAT = [udacityproject_csv]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO
CREATE EXTERNAL TABLE staging_station (
	[station_id] nvarchar(400),
	[name] nvarchar(400),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'station.csv',
	DATA_SOURCE = [udacityproject_synapselearnblob_dfs_core_windows_net],
	FILE_FORMAT = [udacityproject_csv]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO
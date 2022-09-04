CREATE EXTERNAL TABLE staging_rider (
	[rider_id] bigint,
	[first] nvarchar(400),
	[last] nvarchar(400),
	[address] nvarchar(4000),
	[birthday] datetime2(7),
	[account_start_date] datetime2(7),
	[account_end_date] datetime2(7),
	[is_member] bit
	)
	WITH (
	LOCATION = 'rider.csv',
	DATA_SOURCE = [udacityproject_synapselearnblob_dfs_core_windows_net],
	FILE_FORMAT = [udacityproject_csv]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO
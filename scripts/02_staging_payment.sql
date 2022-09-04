CREATE EXTERNAL TABLE staging_payment (
	[payment_id] bigint,
	[date] datetime2(7),
	[amount] decimal(14,2),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'payment.csv',
	DATA_SOURCE = [udacityproject_synapselearnblob_dfs_core_windows_net],
	FILE_FORMAT = [udacityproject_csv]
	)
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO
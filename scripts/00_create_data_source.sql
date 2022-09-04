IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacityproject_synapselearnblob_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacityproject_synapselearnblob_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacityproject@synapselearnblob.dfs.core.windows.net' 
	)
GO
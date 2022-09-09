CREATE TABLE [dbo].[dim_station]
(
    [station_id] nvarchar(400) NOT NULL PRIMARY KEY NONCLUSTERED NOT ENFORCED,
	[name] nvarchar(400),
	[latitude] float,
	[longitude] float
)
WITH
(
    DISTRIBUTION = HASH (station_id),
    CLUSTERED COLUMNSTORE INDEX
)
GO

INSERT INTO [dbo].[dim_station] (
    station_id,
    name,
    latitude,
    longitude
)
SELECT [station_id],
[name],
[latitude],
[longitude]
 FROM [dbo].[staging_station]
GO

SELECT TOP 100 * FROM [dbo].[dim_station]
GO
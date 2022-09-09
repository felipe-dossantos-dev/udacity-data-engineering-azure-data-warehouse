CREATE TABLE [dbo].[dim_rider]
(
    [rider_id] [bigint]  NOT NULL PRIMARY KEY NONCLUSTERED NOT ENFORCED,
	[first] [nvarchar](400)  NULL,
	[last] [nvarchar](400)  NULL,
	[address] [nvarchar](4000)  NULL,
	[birthday] [datetime2](7)  NULL,
	[account_start_date] [datetime2](7)  NULL,
	[account_end_date] [datetime2](7)  NULL,
	[is_member] [bit]  NULL
)
WITH
(
    DISTRIBUTION = HASH (rider_id),
    CLUSTERED COLUMNSTORE INDEX
)
GO

INSERT INTO [dbo].[dim_rider] (rider_id, first, last, address, birthday, account_start_date, account_end_date, is_member)
SELECT [rider_id] 
,[first]
,[last]
,[address]
,[birthday]
,[account_start_date]
,[account_end_date]
,[is_member]
 FROM [dbo].[staging_rider]
GO

SELECT TOP 100 * FROM [dbo].[dim_rider]
GO
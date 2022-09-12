CREATE TABLE [dbo].[fact_payment]
(
    [payment_id] bigint,
	[amount] decimal(14,2),
    [date] date,
	[rider_id] bigint,
    [rider_age_account_start] int null
)
WITH
  (
    DISTRIBUTION = HASH ([payment_id]),
    CLUSTERED COLUMNSTORE INDEX
  );
GO


INSERT INTO [dbo].[fact_payment] (
    [payment_id],
	[amount],
    [date],
	[rider_id],
    [rider_age_account_start]
)  
SELECT
    [sp].[payment_id],
    [sp].[amount],
    [sp].[date],
    [sp].[rider_id],
    DATEDIFF(YEAR, [dr].birthday, [dr].[account_start_date])
FROM
  [dbo].[staging_payment] AS [sp]
INNER JOIN [dbo].[dim_rider] AS dr ON [sp].rider_id = [dr].rider_id;
GO

SELECT TOP 100 * FROM dbo.fact_payment
GO
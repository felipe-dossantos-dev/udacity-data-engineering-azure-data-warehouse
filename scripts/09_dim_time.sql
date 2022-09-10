CREATE TABLE
  [dbo].[dim_time] (
    [time] time NULL,
    [hour] int NULL,
    [minute] int NULL,
    [am_pm] varchar(2) NOT NULL,
    [day_part] varchar(10) NULL,
    [hour_12] varchar(17) NULL,
    [hour_24] varchar(13) NULL,
    [notation_12] varchar(10) NULL,
    [notation_24] varchar(10) NULL,
    [minute_15] int null
  )
WITH
  (
    DISTRIBUTION = HASH ([time]),
    CLUSTERED
    COLUMNSTORE INDEX
  );

GO 

DECLARE @Time as time;
SET @Time = '0:00';

DECLARE @counter as int;
SET @counter = 0;

DECLARE @hour AS int;
SET @hour = 0;

DECLARE @minute AS int;
SET @minute = 0;

DECLARE @daypart as varchar(20);
SET  @daypart = '';

DECLARE @am_pm AS varchar(2);
SET @am_pm = '';

DECLARE @hour_12 AS varchar(17);
SET @hour_12 = '';

DECLARE @hour_24 AS varchar(13);
SET @hour_24 = '';

DECLARE @notation_12 AS varchar(10);
SET @notation_12 = '';

DECLARE @notation_24 AS varchar(10);
SET @notation_24 = '';

DECLARE @minute_15 AS int;
SET @minute_15 = 0;


-- Loop 1440 times (24hours * 60minutes)
WHILE @counter < 1440 BEGIN
SELECT
  @daypart = CASE
    WHEN (
      @Time >= '0:00'
      and @Time < '6:00'
    ) THEN 'Night'
    WHEN (
      @Time >= '6:00'
      and @Time < '12:00'
    ) THEN 'Morning'
    WHEN (
      @Time >= '12:00'
      and @Time < '18:00'
    ) THEN 'Afternoon'
    ELSE 'Evening'
  END;

SELECT
  @am_pm = CASE
    WHEN (DATEPART(Hour, @Time) < 12) THEN 'AM'
    ELSE 'PM'
  END;

SELECT
  @hour_12 = CONVERT(
    varchar(10),
    DATEADD(Minute, - DATEPART(Minute, @Time), @Time),
    100
  ) + ' - ' + CONVERT(
    varchar(10),
    DATEADD(
      Hour,
      1,
      DATEADD(Minute, - DATEPART(Minute, @Time), @Time)
    ),
    100
  );

SELECT
  @hour_24 = CAST(
    DATEADD(Minute, - DATEPART(Minute, @Time), @Time) as varchar(5)
  ) + ' - ' + CAST(
    DATEADD(
      Hour,
      1,
      DATEADD(Minute, - DATEPART(Minute, @Time), @Time)
    ) as varchar(5)
  );

SELECT @notation_12 = CONVERT(varchar(10), @Time, 100);

SELECT @notation_24 = CAST(@Time as varchar(5));

SELECT @hour = DATEPART(Hour, @Time) + 1;

SELECT @minute = DATEPART(Minute, @Time) + 1;

SELECT @minute_15 = (DATEPART(Minute, @Time) + 1) / 15;

INSERT INTO
  dim_time (
    [time],
    [hour],
    [minute],
    [am_pm],
    [day_part],
    [hour_12],
    [hour_24],
    [notation_12],
    [notation_24],
    [minute_15]
  )
VALUES
  (
    @Time,
    @hour,
    @minute,
    @am_pm,
    @daypart,
    @hour_12,
    @hour_24,
    @notation_12,
    @notation_24,
    @minute_15
  );

-- Raise time with one minute
SET
  @Time = DATEADD(minute, 1, @Time);

-- Raise counter by one
set
  @counter = @counter + 1;

END
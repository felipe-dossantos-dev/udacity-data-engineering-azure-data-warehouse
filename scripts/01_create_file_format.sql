IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'udacityproject_csv') 
	CREATE EXTERNAL FILE FORMAT [udacityproject_csv] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS(
			 FIELD_TERMINATOR = ',',
			 STRING_DELIMITER = '"',
			 USE_TYPE_DEFAULT = FALSE,
			 FIRST_ROW = 2,
			 DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss.fffffff',
			 ENCODING = 'UTF8'
			))
GO
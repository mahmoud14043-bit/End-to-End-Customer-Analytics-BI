CREATE OR ALTER PROCEDURE marketing.load_all_data AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	BEGIN TRY		

		    PRINT '-------------------------------';
        PRINT '	Cleaning Tables';
        PRINT '-------------------------------';

        PRINT '>> Truncating Table: marketing.fact_customer_activity';
        TRUNCATE TABLE marketing.fact_customer_activity;

        PRINT '>> Deleting Table: marketing.dim_customer';
        DELETE FROM marketing.dim_customer;

        PRINT '>> Deleting Table: marketing.dim_date';
        DELETE FROM marketing.dim_date;




		PRINT '-------------------------------'
		PRINT 'dimantion table'
		PRINT '-------------------------------'
	
		PRINT '==============================='
		PRINT 'Loading marketing.dim_customer'
		PRINT '==============================='
		
		SET @start_time = GETDATE();	
		PRINT '>> Inserting Data Into: marketing.dim_customer'
		BULK INSERT  marketing.dim_customer
		FROM 'E:\power query\csv\dim_customer.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration :' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------'

		PRINT '==============================='
		PRINT 'Loading marketing.dim_date'
		PRINT '==============================='
		
		SET @start_time = GETDATE();	
		PRINT '>> Inserting Data Into: marketing.dim_date'
		BULK INSERT  marketing.dim_date
		FROM 'E:\power query\csv\dim_date.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration :' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------'

		PRINT '-------------------------------'
		PRINT 'fact table'
		PRINT '-------------------------------'
	
		PRINT '==============================='
		PRINT 'Loading marketing.fact_customer_activity'
		PRINT '==============================='
	
		SET @start_time = GETDATE();	
		PRINT '>> Inserting Data Into: marketing.fact_customer_activity'
		BULK INSERT  marketing.fact_customer_activity
		FROM 'E:\power query\csv\fact_customer_activity.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration :' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------'
	
	END TRY
	BEGIN CATCH
		PRINT '==============================='
		PRINT 'Error Occured During Loading Date'
		Print 'Error Message' + ERROR_MESSAGE();
		Print 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		Print 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==============================='
	END CATCH
END

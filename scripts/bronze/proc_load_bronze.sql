/*
=====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================================
Script Purpose:
	This stored procedure loads data into the 'bronze' schema from external CSV files.
	It performs the following action:
	- Truncates the bronze layer before loading data.
	- Use the BULK INSERT command to load data from CSV files to bronze tables.

Parameters:
	None.
	This stored procedure donot accept any parameters or return any values.

Usage Example:
	EXCE bronze.load_bronze;
=====================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME ,@batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY

		PRINT'=====================================================';
		PRINT'Loading bronze layer';
		PRINT'=====================================================';

		PRINT'-----------------------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'-----------------------------------------------------';

		SET @batch_start_time = GETDATE();

		SET @start_time = GETDATE();
		PRINT'<< Truncating Table: bronze.crm_cst_info';
		TRUNCATE TABLE bronze.crm_cst_info;

		PRINT'<<Inserting Data into: bronze.crm_cst_info';
		BULK INSERT bronze.crm_cst_info
		FROM 'C:\Users\Acer\Desktop\SQL PROJECT\SQL Data Warehousing Project\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '<< Loading duration:' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'---------------------';

		SET @start_time = GETDATE();
		PRINT'<<Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT'<<Inserting Data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Acer\Desktop\SQL PROJECT\SQL Data Warehousing Project\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'<< Loading duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'---------------------';

		SET @start_time = GETDATE();
		PRINT'<<Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT'<<Inserting Data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Acer\Desktop\SQL PROJECT\SQL Data Warehousing Project\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT'<< Loading duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'---------------------';

		PRINT'-----------------------------------------------------';
		PRINT'Loading ERP Tables';
		PRINT'-----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'<<Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT'<<Inserting Data: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Acer\Desktop\SQL PROJECT\SQL Data Warehousing Project\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '<<Loading duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'---------------------';

		SET @start_time = GETDATE();
		PRINT'<<Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT'<<Inserting Data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Acer\Desktop\SQL PROJECT\SQL Data Warehousing Project\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'<< Loading duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'---------------------';

		SET @start_time = GETDATE();
		PRINT'<<Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT'<<Inserting Data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Acer\Desktop\SQL PROJECT\SQL Data Warehousing Project\source_erp\PX_CAT_G1V2.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'Loading duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'---------------------';

		SET @batch_end_time = GETDATE();
		PRINT'=====================================================';
		PRINT'Loading bronze layer is completed';
		PRINT'  -Total duration :' + CAST(DATEDIFF(second,@batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT'=====================================================';
	END TRY
	BEGIN CATCH
		PRINT'========================================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'Error Message' + ERROR_MESSAGE();
		PRINT'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'========================================================';
	END CATCH
END

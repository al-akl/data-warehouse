USE NovaInsights;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		PRINT '<< TRUNCATING TABLE bronze.users';
		TRUNCATE TABLE bronze.users
		PRINT '<< INSERTING DATA INTO: bronze.users';
		BULK INSERT bronze.users
		FROM 'D:\Desktop\data_warehouse\e_commerce_csv_files\users.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT '<< TRUNCATING TABLE bronze.categories';
		TRUNCATE TABLE bronze.categories;

		PRINT '<< INSERTING DATA INTO: bronze.categories';
		BULK INSERT bronze.categories
		FROM 'D:/Desktop\data_warehouse\e_commerce_csv_files\categories.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT '<< TRUNCATE TABLE bronze.products';
		TRUNCATE TABLE bronze.products;

		PRINT '<< INSERTING DATA INTO: bronze.products';
		BULK INSERT bronze.products
		FROM 'D:/Desktop\data_warehouse\e_commerce_csv_files\products.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT '<< TRUNCATING TABLE bronze.orders';
		TRUNCATE TABLE bronze.orders;
		PRINT '<< INSERTING DATA INTO: bronze.orders';
		BULK INSERT bronze.orders
		FROM 'D:\Desktop\data_warehouse\e_commerce_csv_files\orders.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT '<< TRUNCATING TABLE bronze.order_lines';
		TRUNCATE TABLE bronze.order_lines;
		PRINT '<< INSERTING DATA INTO: bronze.order_lines';
		BULK INSERT bronze.order_lines
		FROM 'D:\Desktop\data_warehouse\e_commerce_csv_files\order_lines.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '==========================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message ' + ERROR_MESSAGE();
		PRINT 'Error Message ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==========================================';
	END CATCH;
END;
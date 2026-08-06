CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		PRINT '<< TRUNCATING TABLE silver.users';
		TRUNCATE TABLE silver.users

		PRINT '<< INSERTING DATA INTO silver.users';
		INSERT INTO silver.users (
			userID,
			firstName,
			lastName,
			email,
			role,
			balance,
			registrationDate
		)
		SELECT 
			userID,
			TRIM(firstName),
			TRIM(lastName),
			email,
			role,
			balance,
			registrationDate
		FROM (
			SELECT *,
				ROW_NUMBER() OVER (PARTITION BY userID ORDER BY registrationDate) AS flag_last
			FROM bronze.users
			WHERE userID IS NOT NULL
		) temp
		WHERE flag_last = 1;

		PRINT '<< TRUNCATING TABLE silver.categories';
		TRUNCATE TABLE silver.categories;

		PRINT '<< INSERTING DATA INTO silver.categories';
		INSERT INTO silver.categories (
			categoryID,
			categoryName
		)
		SELECT *
		FROM bronze.categories;

		PRINT '<< TRUNCATING TABLE silver.products';
		TRUNCATE TABLE silver.products;

		PRINT '<< INSERTING DATA INTO silver.products';
		INSERT INTO silver.products (
			barcode,
			name,
			description,
			unitPrice,
			stockQuantity,
			insertionDate,
			categoryID
		)
		SELECT *
		FROM bronze.products;

		PRINT '<< TRUNCATING TABLE silver.orders';
		TRUNCATE TABLE silver.orders;

		PRINT '<< INSERTING DATA INTO silver.orders'
		INSERT INTO silver.orders (
			orderID,
			userID,
			totalPrice,
			orderDate
		)
		SELECT 
			o.orderID,
			o.userID,
			SUM(ol.totalPrice) AS totalPrice,
			o.orderDate
		FROM bronze.orders o 
		LEFT JOIN bronze.order_lines ol ON o.orderID = ol.orderID
		GROUP BY o.orderID, o.userID, o.orderDate;

		PRINT '<< TRUNCATING TABLE silver.order_lines';
		TRUNCATE TABLE silver.order_lines;

		PRINT '<< INSERTING DATA INTO silver.order_lines';
		INSERT INTO silver.order_lines (
			lineID,
			barcode,
			orderID,
			priceAtPurchase,
			quantity,
			totalPrice
		)
		SELECT *
		FROM bronze.order_lines;
	END TRY
	BEGIN CATCH
		PRINT '==========================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message ' + ERROR_MESSAGE();
		PRINT 'Error Message ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==========================================';
	END CATCH
END;
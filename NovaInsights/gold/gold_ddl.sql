USE NovaInsights;

IF OBJECT_ID('gold.dim_users', 'V') IS NOT NULL
	DROP VIEW gold.dim_users;
GO

CREATE VIEW gold.dim_users AS
SELECT 
	userID AS user_id,
	firstName AS first_name,
	lastName AS last_name,
	email AS user_email,
	role AS user_role,
	balance AS user_balance,
	registrationDate as create_date
FROM silver.users;
GO

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT 
	p.barcode,
	c.categoryID AS category_id,
	c.categoryName AS category,
	p.name AS product_name,
	p.description AS product_description,
	p.unitPrice AS unit_price,
	p.stockQuantity AS stock_quantity,
	p.insertionDate AS inserted_at
FROM silver.categories c 
LEFT JOIN silver.products p ON c.categoryID = p.categoryID;
GO

IF OBJECT_ID('gold.dim_date', 'V') IS NOT NULL
	DROP VIEW gold.dim_date;
GO

CREATE VIEW gold.dim_date AS
SELECT
	DISTINCT
	CAST(CONVERT(VARCHAR(8), orderDate, 112) AS INT) AS date_id,
	orderDate AS order_date,
	DATEPART(day, orderDate) AS [day],
    DATEPART(month, orderDate) AS [month],
	DATENAME(month, orderDate) AS month_name,
    DATEPART(quarter, orderDate) AS [quarter],
    DATEPART(year, orderDate) AS [year],
	DATENAME(weekday, orderDate) AS week_day,
	CASE WHEN DATENAME(weekday, orderDate) IN ('Saturday', 'Sunday') THEN 'Yes'
		 ELSE 'No'
	END AS is_weekend
FROM silver.orders;
GO

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
	o.orderID AS order_id,
	ol.barcode,
	u.userID AS user_id,
	o.orderDate AS order_date,
	ol.quantity,
	ol.priceAtPurchase AS unit_price,
	o.totalPrice AS revenue
FROM silver.users u
LEFT JOIN silver.orders o ON u.userID = o.userID
LEFT JOIN silver.order_lines ol ON o.orderID = ol.orderID;
GO

SELECT * FROM gold.dim_users;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.dim_date;
SELECT * FROM gold.fact_sales;
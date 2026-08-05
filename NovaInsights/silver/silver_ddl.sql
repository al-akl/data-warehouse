USE NovaInsights;

-- DROPS silver.USERS TABLE IF IT EXISTS
IF OBJECT_ID('silver.users', 'U') IS NOT NULL
	DROP TABLE silver.users;
GO

-- CREATES silver.USERS TABLE
CREATE TABLE silver.users (
	userID INT,
	firstName NVARCHAR(50),
	lastName NVARCHAR(50),
	email NVARCHAR(255),
	role NVARCHAR(50),
	balance DECIMAL(10,2),
	registrationDate DATE,
	dwh_create_date DATETIME DEFAULT GETDATE()
);

-- DROPS silver.CATEGORIES TABLE IF IT EXISTS
IF OBJECT_ID('silver.categories', 'U') IS NOT NULL
	DROP TABLE silver.categories;
GO

-- CREATES silver.CATEGORIES TABLE
CREATE TABLE silver.categories (
	categoryID INT,
	categoryName NVARCHAR(50),
	dwh_create_date DATETIME DEFAULT GETDATE()
);

-- DROPS silver.PRODUCTS TABLE IF IT EXISTS
IF OBJECT_ID('silver.products', 'U') IS NOT NULL
	DROP TABLE silver.products;
GO

-- CREATES silver.PRODUCTS TABLE
CREATE TABLE silver.products (
	barcode NVARCHAR(50),
	name NVARCHAR(50),
	description NVARCHAR(200),
	unitPrice DECIMAL(10,2),
	stockQuantity INT,
	insertionDate DATETIME,
	categoryID INT,
	dwh_create_date DATETIME DEFAULT GETDATE()
);

-- DROPS silver.ORDERS TABLE IF IT EXISTS
IF OBJECT_ID('silver.orders', 'U') IS NOT NULL
	DROP TABLE silver.orders;
GO

-- CREATES silver.ORDERS TABLE
CREATE TABLE silver.orders (
	orderID INT,
	userID INT,
	totalPrice DECIMAL(10,2),
	orderDate DATE,
	dwh_create_date DATETIME DEFAULT GETDATE()
);

-- DROPS silver.ORDER_LINES TABLE
IF OBJECT_ID('silver.order_lines', 'U') IS NOT NULL
	DROP TABLE silver.order_lines;
GO

-- CREATES silver.ORDER_LINES TABLE
CREATE TABLE silver.order_lines (
	lineID INT,
	barcode NVARCHAR(50),
	orderID INT,
	priceAtPurchase DECIMAL(10,2),
	quantity INT,
	totalPrice DECIMAL(10,2),
	dwh_create_date DATETIME DEFAULT GETDATE()
);
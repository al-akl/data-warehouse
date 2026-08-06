USE NovaInsights;

-- DROPS BRONZE.USERS TABLE IF IT EXISTS
IF OBJECT_ID('bronze.users', 'U') IS NOT NULL
	DROP TABLE bronze.users;
GO

-- CREATES BRONZE.USERS TABLE
CREATE TABLE bronze.users (
	userID INT,
	firstName NVARCHAR(50),
	lastName NVARCHAR(50),
	email NVARCHAR(255),
	role NVARCHAR(50),
	balance DECIMAL(10,2),
	registrationDate DATE
);

-- DROPS BRONZE.CATEGORIES TABLE IF IT EXISTS
IF OBJECT_ID('bronze.categories', 'U') IS NOT NULL
	DROP TABLE bronze.categories;
GO

-- CREATES BRONZE.CATEGORIES TABLE
CREATE TABLE bronze.categories (
	categoryID INT,
	categoryName NVARCHAR(50)
);

-- DROPS BRONZE.PRODUCTS TABLE IF IT EXISTS
IF OBJECT_ID('bronze.products', 'U') IS NOT NULL
	DROP TABLE bronze.products;
GO

-- CREATES BRONZE.PRODUCTS TABLE
CREATE TABLE bronze.products (
	barcode NVARCHAR(50),
	name NVARCHAR(50),
	description NVARCHAR(200),
	unitPrice DECIMAL(10,2),
	stockQuantity INT,
	insertionDate DATETIME,
	categoryID INT
);

-- DROPS BRONZE.ORDERS TABLE IF IT EXISTS
IF OBJECT_ID('bronze.orders', 'U') IS NOT NULL
	DROP TABLE bronze.orders;
GO

-- CREATES BRONZE.ORDERS TABLE
CREATE TABLE bronze.orders (
	orderID INT,
	userID INT,
	totalPrice DECIMAL(10,2),
	orderDate DATE
);

-- DROPS BRONZE.ORDER_LINES TABLE
IF OBJECT_ID('bronze.order_lines', 'U') IS NOT NULL
	DROP TABLE bronze.order_lines;
GO

-- CREATES BRONZE.ORDER_LINES TABLE
CREATE TABLE bronze.order_lines (
	lineID INT,
	barcode NVARCHAR(50),
	orderID INT,
	priceAtPurchase DECIMAL(10,2),
	quantity INT,
	totalPrice DECIMAL(10,2)
);
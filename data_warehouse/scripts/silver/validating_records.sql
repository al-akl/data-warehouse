-- bronze.users TABLE

-- CHECKING IF THERE ARE DUPLICATED RECORDS
SELECT userID, COUNT(*)
FROM bronze.users
GROUP BY userID
HAVING COUNT(*) > 1;

-- REMOVE DUPLICATED RECORDS
SELECT *
FROM (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY userID ORDER BY registrationDate) AS flag_last
	FROM bronze.users
	WHERE userID IS NOT NULL
) temp
WHERE flag_last = 1;

-- CHECKING FOR UNWANTED SPACES IN FIRST NAME
SELECT firstName
FROM bronze.users
WHERE firstName != TRIM(firstName);

-- REMOVING UNWANTED SPACES FROM FIRST NAME
SELECT TRIM(firstName)
FROM bronze.users;

-- CHECKING FOR UNWANTED SPACES IN LAST NAME
SELECT lastName
FROM bronze.users
WHERE lastName != TRIM(lastName);

-- REMOVING UNWANTED SPACES FROM LAST NAME
SELECT TRIM(lastName)
FROM bronze.users;

-- CHECKING IF EMAILS ARE IN THE CORRECT FORMAT
SELECT userID, email
FROM bronze.users
WHERE email NOT LIKE '%_@_%._%' OR email LIKE '%[ ,;]%';

-- CHECKING IF THE ROLE IS VALID
SELECT userID, role 
FROM bronze.users
WHERE role NOT IN ('CUSTOMER', 'ADMINISTRATOR');

-- CHECKING THAT THE BALANCE IS NOT NEGATIVE OR NOT TOO BIG
SELECT userID, balance 
FROM bronze.users
WHERE balance < 0 OR balance > 10000;

-- CHECKING IF THE REGISTRATION DATE > CURRENT DATE
SELECT userID, registrationDate
FROM bronze.users
WHERE registrationDate > GETDATE();

-- bronze.categories TABLE

-- => EVERYTHING LOOKS GREAT IN THE bronze.categories TABLE

-- bronze.products TABLE

-- CHECKING FOR DUPLICATED RECORDS
SELECT barcode, COUNT(*)
FROM bronze.products
GROUP BY barcode
HAVING COUNT(*) > 1;

-- CHECKING FOR UNWANTED SPACES IN THE PRODUCT NAME
SELECT barcode, name
FROM bronze.products
WHERE name != TRIM(name)

-- CHECKING FOR UNWANTED SPACES IN THE PRODUCT DESCRIPTION
SELECT barcode, description
FROM bronze.products
WHERE description != TRIM(description)

-- CHECKING IF THE UNIT PRICE < 0 OR A BIG NUMBER
SELECT barcode, unitPrice
FROM bronze.products
WHERE unitPrice < 0 OR unitPrice > 1000;

-- CHECKING IF THE STOCK QUANITTY < 0 OR NULL
SELECT barcode, stockQuantity
FROM bronze.products
WHERE stockQuantity < 0 OR stockQuantity IS NULL;

-- CHECKING IF THE INSERTION DATE > CURRENT DATE
SELECT barcode, insertionDate
FROM bronze.products
WHERE insertionDate > GETDATE();

-- CHECKING THE INTEGRITY OF THE FOREIGN KEY (categoryID)
SELECT barcode, categoryID
FROM bronze.products
WHERE categoryID NOT IN (
	SELECT categoryID
	FROM bronze.categories
);

-- bronze.orders TABLE

SELECT * FROM bronze.orders;

-- CHECKING FOR DUPLICATED RECORDS
SELECT orderID, COUNT(*)
FROM bronze.orders
GROUP BY orderID
HAVING COUNT(*) > 1;

-- CHECKING THE INTEGRITY OF THE FOREIGN KEY (userID)
SELECT orderID, userID
FROM bronze.orders
WHERE userID NOT IN (
	SELECT userID
	FROM bronze.users
);

-- CHECKING THE TOTAL PRICE IS NOT < 0 OR NULL
SELECT orderID, totalPrice
FROM bronze.orders
WHERE totalPrice < 0 OR totalPrice IS NULL;

-- CHECKING THAT THE DATE IS NOT > CURRENT DATE
SELECT orderID, orderDate
FROM bronze.orders
WHERE orderDate > GETDATE();

-- bronze.order_lines TABLE

SELECT * FROM bronze.order_lines;

-- CHECKING FOR DUPLICATED RECORDS
SELECT lineID, COUNT(*)
FROM bronze.order_lines
GROUP BY lineID
HAVING COUNT(*) > 1;

-- CHECKING THE INTEGRITY OF THE FOREIGN KEY (barcode)
SELECT lineID, barcode
FROM bronze.order_lines
WHERE barcode NOT IN (
	SELECT barcode
	FROM bronze.products
);

-- CHECKING THE INTEGRITY OF THE FOREIGN KEY (orderID)
SELECT lineID, orderID
FROM bronze.order_lines
WHERE orderID NOT IN (
	SELECT orderID
	FROM bronze.orders
);

-- CHECKING THAT THE PRICE AT PURCHASE NOT < 0 OR NULL
SELECT lineID, priceAtPurchase
FROM bronze.order_lines
WHERE priceAtPurchase < 0 OR priceAtPurchase IS NULL;

-- CHECKING THAT THE QUANTITY NOT < 0 OR NULL
SELECT lineID, quantity
FROM bronze.order_lines
WHERE quantity < 0 OR quantity IS NULL;

-- CHECKING THAT THE TOTAL PRICE NOT < 0 OR NULL
SELECT lineID, totalPrice
FROM bronze.order_lines
WHERE totalPrice < 0 OR totalPrice IS NULL;

-- VALIDATING THAT priceAtPurchase * quantity = totalPrice
SELECT * 
FROM bronze.order_lines
WHERE priceAtPurchase * quantity != totalPrice;

-- VALIDATING THAT order line total prices = totalPrice (bronze.orders)
SELECT o.orderID, o.totalPrice, SUM(ol.totalPrice) AS total_cost
FROM bronze.orders o
LEFT JOIN bronze.order_lines ol ON o.orderID = ol.orderID
GROUP BY o.orderID, o.totalPrice
HAVING o.totalPrice != SUM(ol.totalPrice);

-- => o.totalPrice != sum(ol.totalPrice) we need to fix it
SELECT 
	o.orderID, 
	o.userID,
	SUM(ol.totalPrice) AS totalPrice,
	o.orderDate
FROM bronze.orders o
LEFT JOIN bronze.order_lines ol ON o.orderID = ol.orderID
GROUP BY o.orderID, o.userID, o.orderDate;

-- Let's revalidate

SELECT temp.orderID, temp.totalPrice, SUM(ol.totalPrice) AS total_cost
FROM (
	SELECT 
	o.orderID, 
	o.userID,
	SUM(ol.totalPrice) AS totalPrice,
	o.orderDate
	FROM bronze.orders o
	LEFT JOIN bronze.order_lines ol ON o.orderID = ol.orderID
	GROUP BY o.orderID, o.userID, o.orderDate
) temp
LEFT JOIN bronze.order_lines ol ON temp.orderID = ol.orderID
GROUP BY temp.orderID, temp.totalPrice
HAVING temp.totalPrice = SUM(ol.totalPrice);
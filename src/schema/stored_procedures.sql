/*
AD350 E-Commerce Project
Team Fire 1: Aune Mitchell, Phillip Huynh

Online Marketplace Stored Procedures
*/

USE ecommerce;

DELIMITER $

-- Stored procedure for checking if a product exists in the inventory
CREATE PROCEDURE CheckProductInInventory(
    IN product INT,
    OUT numProduct INT
)
BEGIN
    SELECT COUNT(*)
    INTO numProduct
    FROM Inventory
    WHERE ProductID = product;
END $

-- Stored procedure for creating a new product
CREATE PROCEDURE CreateNewProduct(
    IN productName VARCHAR(20),
    IN productBrand VARCHAR(20),
    IN productDescription VARCHAR(50),
    IN productDepartment VARCHAR(15),
    IN productBuyPrice DECIMAL(8, 2),
    IN productSellPrice DECIMAL(8, 2)
)
BEGIN
    INSERT INTO Products (Name, Brand, Description, Department, BuyPrice, SellPrice)
    VALUES  (productName, productBrand, productDescription, productDepartment, productBuyPrice, productSellPrice);
END $

-- Stored procedure for modifying a product's quantity in inventory
CREATE PROCEDURE ModifyProductInventoryQuantity(
    IN productToUpdate INT,
    IN newQuantity INT
)
BEGIN
    UPDATE Inventory
    SET Quantity = newQuantity
    WHERE ProductID = productToUpdate;
END $

-- Stored procedure for deleting a product from the Inventory Table
CREATE PROCEDURE DeleteProductFromInventory(
	IN productToDelete INT
)
BEGIN
    DELETE FROM Inventory
    WHERE ProductID = productToDelete;
END $

-- Stored Procedure for getting the most popular products for a given time range
CREATE PROCEDURE GetMostPopularProducts(
	IN rangeStart DATETIME,
    IN rangeEnd DATETIME 
)
BEGIN
	-- CTE to receive average rating per product
	WITH GetAvgRating AS (
		SELECT ProductID, AVG(Rating) AS AvgRating
		FROM Reviews
		GROUP BY ProductID
    )

	SELECT P.ProductID, P.Name, P.Brand, P.SellPrice, COUNT(T.ProductID) AS TransactionCount,
		ROUND(LEAST((COUNT(T.ProductID) * 0.7 + R.AvgRating * 0.3), 5), 2) AS WeightedAvgRating
    FROM Products AS P
    INNER JOIN Transactions AS T
		ON P.ProductID = T.ProductID
	LEFT JOIN GetAvgRating AS R
		ON P.ProductID = R.ProductID
    WHERE T.DateTime BETWEEN rangeStart AND rangeEnd
    GROUP BY P.ProductID
    ORDER BY WeightedAvgRating DESC
    LIMIT 5;
END $

-- Stored procedure for getting the least popular products for a given time range
CREATE PROCEDURE GetLeastPopularProducts(
	IN rangeStart DATETIME,
    IN rangeEnd DATETIME 
)
BEGIN
	-- CTE to receive average rating per product
	WITH GetAvgRating AS (
		SELECT ProductID, AVG(Rating) AS AvgRating
		FROM Reviews
		GROUP BY ProductID
    )
    
	SELECT P.ProductID, P.Name, P.Brand, P.SellPrice, COUNT(T.ProductID) AS TransactionCount,
		ROUND(LEAST((COUNT(T.ProductID) * 0.7 + R.AvgRating * 0.3), 5), 2) AS WeightedAvgRating
    FROM Products AS P
    INNER JOIN Transactions AS T
		ON P.ProductID = T.ProductID
	LEFT JOIN GetAvgRating AS R
		ON P.ProductID = R.ProductID
    WHERE T.DateTime BETWEEN rangeStart AND rangeEnd
    GROUP BY P.ProductID
    ORDER BY WeightedAvgRating
    LIMIT 5;
END $

-- Stored procedure for getting a list of inactive users
CREATE PROCEDURE GetInactiveUsers()
BEGIN
    WITH GetLastPurchase AS (
        SELECT T.BuyerID, MAX(T.DateTime) AS LastPurchase
		FROM Transactions AS T
		GROUP BY T.BuyerID
    )
    
	SELECT U.UserID, U.FirstName, U.LastName, U.Email, LP.LastPurchase
	FROM Users AS U
	LEFT JOIN GetLastPurchase AS LP ON U.UserID = LP.BuyerID
	-- Get the date 2 months ago and check if the user's
	-- last purchase date is older than it
	WHERE LP.LastPurchase IS NULL OR LP.LastPurchase < DATE_SUB(CURDATE(), INTERVAL 2 MONTH);
END $

-- Stored procedure for getting a user's total number of transactions
CREATE PROCEDURE GetUserNumOfTransactions(
	IN UserID INTEGER
)
BEGIN
    	SELECT COUNT(*) AS NumOfTransactions
		FROM Transactions AS T
		LEFT JOIN Products AS P
		ON T.ProductID = P.ProductID
		WHERE UserID = T.BuyerID;
END $

-- Stored procedure for getting the top 5 popular products of all time
CREATE PROCEDURE GetAllTimeTop5Products ()
BEGIN
    -- CTE to receive average rating per product
	 WITH GetAvgRating AS (
		SELECT ProductID, AVG(Rating) AS AvgRating
		FROM Reviews
		GROUP BY ProductID
    )

		SELECT P.ProductID, P.Name, P.Brand, P.SellPrice, COUNT(T.ProductID) AS TransactionCount,
			ROUND(LEAST((COUNT(T.ProductID) * 0.7 + R.AvgRating * 0.3), 5), 2) AS WeightedAvgRating
		FROM Products AS P
		INNER JOIN Transactions AS T
			ON P.ProductID = T.ProductID
		LEFT JOIN GetAvgRating AS R
				ON P.ProductID = R.ProductID
		INNER JOIN Users AS U ON U.UserID = T.BuyerID
		GROUP BY P.ProductID
		ORDER BY WeightedAvgRating DESC
		LIMIT 5;

END $

-- Stored procedure to get a user's top 5 products
CREATE PROCEDURE GetUserTop5Products(
	IN UserID INTEGER
)
BEGIN
	-- CTE to receive average rating per product
	 WITH GetAvgRating AS (
		SELECT ProductID, AVG(Rating) AS AvgRating
		FROM Reviews
		GROUP BY ProductID
    ),
    
    -- CTE to receieve a user's purchased product history
    GetUserPurchases AS (
		SELECT T.ProductID, P.Name, P.Brand, P.SellPrice
		FROM Transactions AS T
		LEFT JOIN Products AS P
		ON T.ProductID = P.ProductID
		WHERE UserID = T.BuyerID
    )

		-- Does not count repeated product purchases
		SELECT P.ProductID, P.Name, P.Brand, P.SellPrice,
			ROUND(LEAST((COUNT(T.ProductID) * 0.7 + R.AvgRating * 0.3), 5), 2) AS WeightedAvgRating
		FROM GetUserPurchases AS P
		INNER JOIN Transactions AS T
			ON P.ProductID = T.ProductID
		LEFT JOIN GetAvgRating AS R
				ON P.ProductID = R.ProductID
		INNER JOIN Users AS U ON U.UserID = T.BuyerID
		GROUP BY P.ProductID
		ORDER BY WeightedAvgRating DESC
		LIMIT 5;
END $

DELIMITER ;

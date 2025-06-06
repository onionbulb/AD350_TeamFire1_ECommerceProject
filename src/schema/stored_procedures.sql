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

-- Get the most popular products for a given time range
CREATE PROCEDURE GetMostPopularProducts(
	IN rangeStart DATETIME,
    IN rangeEnd DATETIME 
)
BEGIN
	SELECT P.ProductID, P.Name, P.Brand, P.SellPrice, COUNT(T.ProductID) AS TransactionCount
    FROM Products AS P
    INNER JOIN Transactions AS T ON P.ProductID = T.ProductID
    WHERE T.DateTime BETWEEN rangeStart AND rangeEnd
    GROUP BY P.ProductID
    ORDER BY TransactionCount DESC
    LIMIT 5;
END $

-- Get the least popular products for a given time range
CREATE PROCEDURE GetLeastPopularProducts(
	IN rangeStart DATETIME,
    IN rangeEnd DATETIME 
)
BEGIN
	SELECT P.ProductID, P.Name, P.Brand, P.SellPrice, COUNT(T.ProductID) AS TransactionCount    
    FROM Products AS P
    INNER JOIN Transactions AS T ON P.ProductID = T.ProductID
    WHERE T.DateTime BETWEEN rangeStart AND rangeEnd
    GROUP BY P.ProductID
    ORDER BY TransactionCount
    LIMIT 5;
END $
    
 -- Get inactive users and their commonly purchased products
CREATE PROCEDURE GetInactiveUsersAndCommonPurchases()
BEGIN
	-- CTE to retrieve last purchase date of users
    WITH GetLastPurchase AS (
        SELECT T.BuyerID, MAX(T.DateTime) AS LastPurchase
		FROM Transactions AS T
		GROUP BY T.BuyerID
    ),
    
    -- CTE to get inactive users
	GetInactiveUsers AS (
		SELECT U.UserID, U.FirstName, U.LastName, U.Email, LP.LastPurchase
        FROM Users AS U
        LEFT JOIN GetLastPurchase AS LP ON U.UserID = LP.BuyerID
        -- Get the date 2 months ago and check if the user's
        -- last purchase date is older than it
        WHERE LP.LastPurchase IS NULL OR LP.LastPurchase < DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
    ),
    
    -- CTE to get a user's most commonly purchased item
    GetCommonPurchase AS (
		SELECT T.ProductID, T.BuyerID, COUNT(*) AS NumOfPurchases
		FROM Users AS U
		INNER JOIN Transactions AS T ON U.UserID = T.BuyerID
		GROUP BY T.ProductID, T.BuyerID
        ORDER BY NumOfPurchases DESC
	)
    
	SELECT U.UserID, U.FirstName, U.LastName, U.Email, U.LastPurchase, CP.ProductID, P.Name, P.Brand, CP.NumOfPurchases
    FROM GetInactiveUsers AS U
    INNER JOIN GetCommonPurchase AS CP ON U.UserID = CP.BuyerID
    LEFT JOIN Products AS P ON CP.ProductID = P.ProductID;
    
END $

DELIMITER ;

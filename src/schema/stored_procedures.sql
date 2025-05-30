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

DELIMITER ;

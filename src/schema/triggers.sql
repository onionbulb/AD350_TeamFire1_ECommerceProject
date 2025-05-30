/*
AD350 E-Commerce Project
Team Fire 1: Aune Mitchell, Phillip Huynh

Online Marketplace Triggers
*/

USE ecommerce;

DELIMITER $

-- Trigger adds a new product to the inventory with the quantity of 0 if not already in inventory
CREATE TRIGGER AfterProductInsert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    -- Check if new ProductID is already in inventory
    DECLARE productExists BOOLEAN;
    SELECT COUNT(*) INTO productExists
    FROM Inventory
    WHERE ProductID = NEW.ProductID;

    -- If new ProductID isn't in inventory, add it with a default quantity of 0
    IF NOT productExists THEN
        INSERT INTO Inventory (ProductID, Quantity)
        VALUES (NEW.ProductID, 0);
    END IF;
END $


-- Trigger updates inventory quantity when inserting
CREATE TRIGGER AfterProductInsert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    -- Check if new ProductID is already in inventory
    DECLARE productExists BOOLEAN;
    SELECT COUNT(*) INTO productExists
    FROM Inventory
    WHERE ProductID = NEW.ProductID;

    -- If new ProductID isn't in inventory, add it with a default quantity of 0
    IF NOT productExists THEN
        INSERT INTO Inventory (ProductID, Quantity)
        VALUES (NEW.ProductID, 0);
    END IF;
END $

-- Trigger blocks transactions if quantity is higher than the available inventory
CREATE TRIGGER PreventInvalidQuantityTransaction
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Check if new ProductID is already in inventory
    DECLARE availableQuantity INT;
    SELECT Quantity INTO availableQuantity
    FROM Inventory
    WHERE ProductID = NEW.ProductID;

    -- If transaction quantity exceeds inventory quantity, block it
    IF availableQuantity IS NULL OR NEW.Quantity > availableQuantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction failed due to insufficient inventory quantity.';
    END IF;
END $

DELIMITER ;

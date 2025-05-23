/*
AD350 E-Commerce Project
Team Fire 1: Aune Mitchell, Phillip Huynh

Online Marketplace Schema
*/

SET FOREIGN_KEY_CHECKS = 0; -- Disable FK_CHECK to drop existing tables w/o Error 3730
DROP DATABASE IF EXISTS ecommerce;
SET FOREIGN_KEY_CHECKS = 1; -- Reenable FK_Check
CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE Product (
	ProductID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    Name VARCHAR(20) NOT NULL,
    Brand VARCHAR(20) NOT NULL,
    Description VARCHAR(50) NOT NULL,
    Department VARCHAR(15),
    BuyPrice DECIMAL(7, 2) NOT NULL,
    SellPrice DECIMAL(7, 2) NOT NULL,
    PRIMARY KEY (ProductID)
);

CREATE TABLE Inventory (
    ProductID INTEGER,
    Quantity SMALLINT NOT NULL,
    PRIMARY KEY (ProductID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE User (
	UserID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Street VARCHAR(95) NOT NULL,
    City VARCHAR(35) NOT NULL,
    State CHAR(2) NOT NULL,
    ZipCode CHAR(5) NOT NULL,
    Country VARCHAR(70),
    PRIMARY KEY (UserID)
);

CREATE TABLE Buyer (
	UserID INTEGER NOT NULL UNIQUE,
    LoyaltyStatus BIT NOT NULL, -- BIT uses 1 and 0 to represent True and False respectively
    PRIMARY KEY (UserID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE Seller (
	UserID INTEGER NOT NULL UNIQUE,
    StoreName VARCHAR(50) NOT NULL,
    PRIMARY KEY (UserID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

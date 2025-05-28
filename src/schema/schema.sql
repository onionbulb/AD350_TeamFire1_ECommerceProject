/*
AD350 E-Commerce Project
Team Fire 1: Aune Mitchell, Phillip Huynh

Online Marketplace Schema
*/

SET FOREIGN_KEY_CHECKS = 0; -- Disable FK_CHECK to drop existing tables w/o Error 3730
DROP DATABASE IF EXISTS ecommerce;
SET FOREIGN_KEY_CHECKS = 1; -- Re-enable FK_Check
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

CREATE TABLE IF NOT EXISTS Products (
	ProductID       INTEGER             AUTO_INCREMENT NOT NULL UNIQUE,
    Name            VARCHAR(20)         NOT NULL,
    Brand           VARCHAR(20)         NOT NULL,
    Description     VARCHAR(50)         NOT NULL,
    Department      VARCHAR(15)         NULL,
    BuyPrice        DECIMAL(7, 2)       NOT NULL,
    SellPrice       DECIMAL(7, 2)       NOT NULL,
    CONSTRAINT      ProductsPK          PRIMARY KEY (ProductID),
    CONSTRAINT      PositivePrice       CHECK ((BuyPrice > 0) AND (SellPrice > 0))
);

CREATE TABLE IF NOT EXISTS Inventory (
    ProductID       INTEGER             NOT NULL UNIQUE,
    Quantity        SMALLINT            NOT NULL,
    CONSTRAINT      InventoryPK         PRIMARY KEY (ProductID),
    CONSTRAINT      InventoryProductsFK FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
	    ON UPDATE CASCADE
	    ON DELETE CASCADE,
    CONSTRAINT      InventoryQuantityCheck   CHECK (Quantity >= 0)
    );

CREATE TABLE Users (
    UserID          INTEGER             AUTO_INCREMENT NOT NULL UNIQUE,
    FirstName       VARCHAR(50)         NOT NULL,
    LastName        VARCHAR(50)         NOT NULL,
    Email           VARCHAR(255)        NOT NULL UNIQUE,
    Street          VARCHAR(95)         NOT NULL,
    City            VARCHAR(35)         NOT NULL,
    State           CHAR(2)             NOT NULL,
    ZipCode         CHAR(5)             NOT NULL,
    Country         VARCHAR(70)         NOT NULL,
    CONSTRAINT      UsersPK             PRIMARY KEY (UserID)
);

CREATE TABLE Buyers (
	UserID          INTEGER             NOT NULL UNIQUE,
    LoyaltyStatus   BIT                 NOT NULL, -- BIT uses 1 and 0 to represent True and False respectively
    CONSTRAINT      BuyersPK            PRIMARY KEY (UserID),
    CONSTRAINT      BuyersUsersFK       FOREIGN KEY (UserID) REFERENCES Users(UserID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE Sellers (
    UserID          INTEGER             NOT NULL UNIQUE,
    StoreName       VARCHAR(50)         NOT NULL,
    CONSTRAINT      SellersPK           PRIMARY KEY (UserID),
    CONSTRAINT      SellersUsersFK      FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID   INTEGER             NOT NULL AUTO_INCREMENT,
    ProductID       INTEGER             NOT NULL,
    BuyerID         INTEGER             NOT NULL,
    SellerID		INTEGER				NOT NULL,
    Quantity 		SMALLINT			NOT NULL,
    DateTime		DATETIME	 		NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- TransactionsPK confirms that TransactionID is a primary key
    CONSTRAINT 		TransactionsPK		PRIMARY KEY (TransactionID),
    -- TransactionsProductsFK confirms that ProductID is a foreign key
    -- If ProductID is part of a transaction, block deletion
    -- If ProductID is updated in Products, update in transactions
    CONSTRAINT 		TransactionsProductsFK    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    -- Similar constraint for BuyerID
    CONSTRAINT 		TransactionsBuyersFK    FOREIGN KEY (BuyerID) REFERENCES Users(UserID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    -- Similar constraint for SellerID
    CONSTRAINT 		TransactionsSellersFK	FOREIGN KEY (SellerID) REFERENCES Users(UserID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    -- TransactionsQuantityCheck checks that the quantity is positive
    CONSTRAINT		TransactionsQuantityCheck	CHECK (Quantity > 0)
);

-- Reviews table
CREATE TABLE IF NOT EXISTS Reviews (
    ReviewID        INTEGER				NOT NULL AUTO_INCREMENT,
    ProductID       INTEGER				NOT NULL,
    UserID          INTEGER				NOT NULL,
    Rating          SMALLINT            NOT NULL,
    Review 			VARCHAR(4000)		NULL,
    DateTime		DATETIME			NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- ReviewsPK confirms that ReviewID is a primary key
    CONSTRAINT 		ReviewsPK			PRIMARY KEY (ReviewID),
    -- ReviewsProductsFK confirms that ProductID is a foreign key
    -- If ProductID is updated or deleted in Products,
    -- associated reviews are also updated or deleted
    CONSTRAINT 		ReviewsProductsFK   FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    -- ReviewsUsersFK confirms that UserID is a foreign key
    -- If UserID is updated or deleted in Users, the review is also updated or deleted
    CONSTRAINT 		ReviewsUsersFK      FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    -- ReviewUniqueCheck confirms that ProductID and UserID combined are unique
    CONSTRAINT		ReviewProductUserUnique	UNIQUE (ProductID, UserID),
    -- ReviewRatingCheck checks that the rating is between 1 and 5
    CONSTRAINT		ReviewRatingCheck		CHECK (Rating BETWEEN 1 AND 5)
);

-- Promotions table
CREATE TABLE IF NOT EXISTS Promotions (
    PromotionID     INTEGER             NOT NULL AUTO_INCREMENT,
    UserID			INTEGER             NOT NULL,
    Subject			VARCHAR(50)         NOT NULL,
    Body			VARCHAR(4000)       NOT NULL,
    DateTime 		DATETIME			NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- PromotionsPK confirms that PromotionID is a primary key
    CONSTRAINT 		PromotionsPK		PRIMARY KEY (PromotionID),
    -- PromotionsUsersFK confirms that UserID is a foreign key
    -- If UserID is updated or deleted in Users,
    -- associated promotions are also updated or deleted
    CONSTRAINT 		PromotionsUsersFK	FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

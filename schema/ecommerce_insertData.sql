/*
AD350 E-Commerce Project
Team Fire 1: Aune Mitchell, Phillip Huynh

Data Insertion
*/

-- ADD ROWS TO PRODUCT
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Blender", "Ninja", "A motorized food blender", "Appliances", 99.99, 119.99);
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Recliner", "La-Z-Boy", "A one-seater sofa made out of leather", "Furniture", 800.00, 1050.99); 
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Cardigan", "Old Navy", "Made out of high-quality cashmere", "Clothing", 34.00, 40); 
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Headphones", "Bose", "Noise-cancelling with Bluetooth support", "Electronics", 349.99, 206.00); 
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Clogs", "Crocs", "Made with black croslite polymer", "Clothing", 29.99, 34.99);
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Scooter", "AOVOPRO", "Unused, can holds up to 120kg", "Outdoors", 255.00, 280.00); 
INSERT INTO Product (Name, Brand, Description, BuyPrice, SellPrice)
VALUES ("Security Camera", "eufy", "Solar-powered stationary camera with 360 view", 139.99, 111.99); 
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Air Mattress", "Intex", "10\" Queen Size with Battery Pump", "Furniture", 28.95, 44.95); 
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Pool Weights", "eladiko", "To use with ladders/steps, 2 Pack 25 LBS each", "Watersports", 16.72, 19.45);
INSERT INTO Product (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES ("Shorts", "Chino", "Men's 7\" dress pants", "Clothing", 41.99, 32.99);

-- ADD ROWS TO INVENTORY
INSERT INTO Inventory (ProductID, Quantity)
VALUES (1, 24);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (2, 19);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (3, 85);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (4, 36);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (5, 120);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (6, 44);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (7, 190);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (8, 254);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (9, 15);
INSERT INTO Inventory (ProductID, Quantity)
VALUES (10, 174);

-- ADD ROWS TO USER
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Alice', 'Johnson', 'alice.johnson@email.com', '123 Elm St', 'Seattle', 'WA', '98101', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Bob', 'Smith', 'bob.smith@email.com', '456 Oak Ave', 'Portland', 'OR', '97205', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Charlie', 'Brown', 'charlie.brown@email.com', '789 Maple Dr', 'San Francisco', 'CA', '94107', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Diana', 'Martinez', 'diana.martinez@email.com', '321 Pine Rd', 'Los Angeles', 'CA', '90015', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Ethan', 'Williams', 'ethan.williams@email.com', '654 Cedar Ln', 'Chicago', 'IL', '60610', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Emily', 'Taylor', 'emily.taylor@email.com', '222 Birch St', 'Denver', 'CO', '80203', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Michael', 'Anderson', 'michael.anderson@email.com', '550 Walnut Ave', 'Austin', 'TX', '78701', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Jessica', 'Harris', 'jessica.harris@email.com', '789 Spruce Ct', 'Boston', 'MA', '02108', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Daniel', 'Roberts', 'daniel.roberts@email.com', '1200 Palm Dr', 'Miami', 'FL', '33101', 'USA');
INSERT INTO User (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES ('Lauren', 'White', 'lauren.white@email.com', '900 Redwood Rd', 'Seattle', 'WA', '98109', 'USA');

-- ADD ROWS TO Buyer AND Seller
INSERT INTO Buyer (UserID, LoyaltyStatus)
VALUES (1, 0), (2, 0), (3, 1), (4, 1), (5, 0), (6, 1), (7, 1), (8, 1), (9, 0), (10, 0);
INSERT INTO Seller (UserID, StoreName)
VALUES (1, "ValueMart"), (2, "QuickBuy"), (3, "SmartShop"), (4, "Budget Bazaar"), (5, "Everyday Essentials"),
	   (6, "SuperStore"), (7, "Urban Goods"), (8, "Cloud9"), (9, "RainbowMart"), (10, "Goodwill");

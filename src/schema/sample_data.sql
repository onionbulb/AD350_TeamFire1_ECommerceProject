/*
AD350 E-Commerce Project
Team Fire 1: Aune Mitchell, Phillip Huynh

Data Insertion
*/

USE ecommerce;

-- Add rows to Products
INSERT INTO Products (Name, Brand, Description, Department, BuyPrice, SellPrice)
VALUES  ('Blender', 'Ninja', 'A motorized food blender', 'Appliances', 99.99, 119.99),
        ('Recliner', 'La-Z-Boy', 'A one-seater sofa made out of leather', 'Furniture', 800.00, 1050.99),
        ('Cardigan', 'Old Navy', 'Made out of high-quality cashmere', 'Clothing', 34.00, 40),
        ('Headphones', 'Bose', 'Noise-cancelling with Bluetooth support', 'Electronics', 349.99, 206.00),
        ('Clogs', 'Crocs', 'Made with black croslite polymer', 'Clothing', 29.99, 34.99),
        ('Scooter', 'AOVOPRO', 'Unused, can holds up to 120kg', 'Outdoors', 255.00, 280.00),
        ('Security Camera', 'eufy', 'Solar-powered stationary camera with 360 view', NULL, 139.99, 111.99),
        ('Air Mattress', 'Intex', '10\' Queen Size with Battery Pump', 'Furniture', 28.95, 44.95),
        ('Pool Weights', 'eladiko', 'To use with ladders/steps, 2 Pack 25 LBS each', 'Watersports', 16.72, 19.45),
        ('Pants', 'Chino', 'Men\'s dress pants', 'Clothing', 41.99, 32.99);

-- Add rows to Inventory
INSERT INTO Inventory (ProductID, Quantity)
VALUES  (1, 24),
        (2, 19),
        (3, 85),
        (4, 50),
        (5, 120),
        (6, 44),
        (7, 190),
        (8, 254),
        (9, 15),
        (10, 174)
ON DUPLICATE KEY UPDATE Quantity = Quantity + VALUES(Quantity);

-- Add rows to Users
INSERT INTO Users (FirstName, LastName, Email, Street, City, State, ZipCode, Country)
VALUES  ('Alice', 'Johnson', 'alice.johnson@email.com', '123 Elm St', 'Seattle', 'WA', '98101', 'USA'),
        ('Bob', 'Smith', 'bob.smith@email.com', '456 Oak Ave', 'Portland', 'OR', '97205', 'USA'),
        ('Charlie', 'Brown', 'charlie.brown@email.com', '789 Maple Dr', 'San Francisco', 'CA', '94107', 'USA'),
        ('Diana', 'Martinez', 'diana.martinez@email.com', '321 Pine Rd', 'Los Angeles', 'CA', '90015', 'USA'),
        ('Ethan', 'Williams', 'ethan.williams@email.com', '654 Cedar Ln', 'Chicago', 'IL', '60610', 'USA'),
        ('Emily', 'Taylor', 'emily.taylor@email.com', '222 Birch St', 'Denver', 'CO', '80203', 'USA'),
        ('Michael', 'Anderson', 'michael.anderson@email.com', '550 Walnut Ave', 'Austin', 'TX', '78701', 'USA'),
        ('Jessica', 'Harris', 'jessica.harris@email.com', '789 Spruce Ct', 'Boston', 'MA', '02108', 'USA'),
        ('Daniel', 'Roberts', 'daniel.roberts@email.com', '1200 Palm Dr', 'Miami', 'FL', '33101', 'USA'),
        ('Lauren', 'White', 'lauren.white@email.com', '900 Redwood Rd', 'Seattle', 'WA', '98109', 'USA')
        ('Tyler', 'Jackson', 'tylerjackson@email.com', '455 Rexford Hill', 'Beverly Hills', 'CA', '90210', 'USA');

-- Add rows to Buyers
INSERT INTO Buyers (UserID, LoyaltyStatus)
VALUES  (1, 0),
        (2, 0),
        (3, 1),
        (4, 1),
        (5, 0),
        (6, 1),
        (7, 1),
        (8, 1),
        (9, 0),
        (10, 0);

-- Add rows to Sellers
INSERT INTO Sellers (UserID, StoreName)
VALUES  (1, 'ValueMart'),
        (2, 'QuickBuy'),
        (3, 'SmartShop'),
        (4, 'Budget Bazaar'),
        (5, 'Everyday Essentials'),
        (6, 'SuperStore'),
        (7, 'Urban Goods'),
        (8, 'Cloud9'),
        (9, 'RainbowMart'),
        (10, 'Goodwill');

-- Add rows to Transactions
INSERT INTO Transactions (ProductID, BuyerID, SellerID, Quantity)
VALUES  (1, 1, 2, 3),
        (2, 2, 1, 1),
        (3, 7, 2, 10),
        (3, 8, 2, 5),
        (4, 3, 2, 4),
        (4, 6, 10, 18),
        (7, 5, 1, 29),
        (4, 3, 8, 5),
        (4, 3, 10, 14),
        (8, 1, 3, 6),
        (8, 3, 6, 7);

INSERT INTO Transactions (ProductID, BuyerID, SellerID, Quantity, DateTime)
VALUES  (5, 6, 5, 100, '2025-05-23 06:00:00'),
        (6, 8, 4, 40, '2025-05-22 08:30:00'),
        (8, 4, 6, 20, '2025-05-22 08:30:00'),
        (9, 5, 3, 10, '2025-05-21 16:45:30'),
        (10, 6, 9, 30, '2025-05-21 22:38:42'),
		(3, 10, 4, 20, '2025-02-18 07:00:00'),
		(1, 9, 4, 20, '2025-02-14 19:30:00'),
        (3, 10, 4, 20, '2025-01-29 04:00:00');

-- Add rows to Reviews
INSERT INTO Reviews (ProductID, UserID, Rating, Review)
VALUES  (1, 1, 5, 'Does it blend? It truly blends everything!'),
        (2, 2, 3, 'This sofa eats things. Comfy but not worth the price.'),
        (3, 8, 2, 'The fabric tore quickly.'),
        (3, 7, 1, 'Came in the wrong size.'),
        (4, 10, 5, 'Incredible noise cancellation.'),
        (4, 3, 3.5, 'Very good! Bought it for the whole family!'),
        (5, 7, 4, 'Great water shoes!'),
		(8, 3, 4, 'Solid air mattress for a reasonable price.');

INSERT INTO Reviews (ProductID, UserID, Rating, Review, DateTime)
VALUES  (6, 4, 1, 'Doesn\'t go very fast and broke after the warranty.', '2025-05-20 04:00:00'),
        (7, 3, 4, 'Like that it\'s solar powered!', '2025-05-21 22:30:47'),
        (8, 6, 3, 'Not super comfy but not terrible.', '2025-05-22 12:45:15'),
        (9, 3, 5, 'Works great in my pool aerobic fitness class!', '2025-04-21 14:20:59'),
        (10, 1, 4, 'These pants look great!', '2025-05-20 15:24:12');

-- Add rows to Promotions
INSERT INTO Promotions (UserID, Subject, Body)
VALUES  (1, 'Flash sale!', 'Want to buy more kitchen supplies?'),
        (2, 'Want to get even lazier?', 'More recliners available now!'),
        (3, 'More electronics in stock!', 'Now on sale!'),
        (4, 'Can\'t miss offer!', 'Check out these home supplies!'),
        (5, 'Special exercise deals!', 'Lift heavy!');

INSERT INTO Promotions (UserID, Subject, Body, DateTime)
VALUES  (6, 'Your favorite clothes on sale!', 'Check out these deals on your top brands!', '2025-04-25 13:24:32'),
        (8, 'Sweaters and more!', 'Stop on by!', '2025-05-01 01:02:03'),
        (9, 'Can\'t miss offer!', 'Check out these home supplies!', '2025-05-19 15:00:40'),
        (7, 'Check out our new deals!', 'Special deals, just for you!', '2025-05-16 18:22:11'),
        (6, 'Need more shoes?', 'Everyone loves shoes!', '2025-05-23 12:12:12');

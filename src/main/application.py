"""
AD350 E-Commerce Project Application
Team Fire 1: Aune Mitchell, Phillip Huynh
"""

import os
import re
from datetime import datetime

import mysql.connector
from mysql.connector import errorcode
from mysql.connector.connection import MySQLConnection
from mysql.connector.cursor import MySQLCursor


def get_database_connection() -> MySQLConnection:
    """
    Validates the connection to the MySQL database.

    Returns:
        MySQLConnection: The MySQLConnection.
    """
    # Validates the connection to the MySQL ecommerce database.
    try:
        print("Attempting to connect with the database.")
        db_connection = mysql.connector.connect(
            user = "testuser",         # Insert a MySQL username for access
            password = os.environ.get('MYSQL_PASSWORD'),     # Use env variable MYSQL_PASSWORD value
            host = "127.0.0.1",        # DB address to local host/machine
            database = "ecommerce"     # See README.md to create a local user for access
        )
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print('Invalid credentials.')
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print('Database not found.')
        else:
            print('Cannot connect to database:', err)
        return None
    print("Connection was successful.")
    return db_connection


def display_menu():
    """Displays the application options menu."""

    print("\n----------------------------")
    print("Welcome to our marketplace!\n")
    print("Please select an option from the following menu:")
    print("1. Get a list of the products in inventory.")
    print("2. Create a new product.")
    print("3. Modify the quantity of a product in inventory.")
    print("4. Delete a product from inventory.")
    print("5. Get a list of the most popular products for a date/time range.")
    print("6. Get a list of the least popular products for a date/time range.")
    print("7. Get a list of users who haven't purchased something in 60 days "
          + "and products to promote.")
    print("8. Exit the program.")
    print("----------------------------\n")


def get_user_menu_choice(lowest_choice: int, highest_choice: int) -> int:
    """
    Gets a user choice from a range of numbers (inclusive).

    Args:
        lowest_choice (int): The low end of the range.
        highest_choice (int): The high end of the range.

    Returns:
        int: The valid user choice.
    """

    valid = False
    while valid is False:
        print(f"Enter a number between {lowest_choice} and {highest_choice}:")
        user_menu_choice = input()
        try:
            user_menu_int = int(user_menu_choice)
            # Re-prompt for choice if invalid input
            if (user_menu_int < lowest_choice or user_menu_int > highest_choice):
                print(f"\nChoice must be a number between {lowest_choice} " \
                      f"and {highest_choice} inclusive.\n")
            else:
                valid = True
        except ValueError:
            print("\nChoice must be an integer.")
    return user_menu_int


def get_user_datetime_choice() -> datetime:
    """Gets the user datetime choice."""

    valid = False
    while valid is False:
        print("Please use the YYYY-MM-DD HH:MM:SS format:")
        user_date_choice = input()
        # Re-prompt until valid datetime format is provided
        try:
            datetime_choice = datetime.strptime(user_date_choice, "%Y-%m-%d %H:%M:%S")
        except ValueError:
            print("\nInvalid format. Format must be YYYY-MM-DD HH:MM:SS")
        else:
            if datetime_choice > datetime.now():
                print("\nStart date must be before the current time.")
            else:
                valid = True
    return datetime_choice


def get_datetime_range() -> tuple[str, str]:
    """Gets an inclusive date range."""

    valid = False
    while valid is False:
        # Re-prompt until valid range is provided
        print("\nEnter the start of the range.")
        start_datetime = get_user_datetime_choice()
        print("\nEnter the end of the range.")
        end_datetime = get_user_datetime_choice()
        if start_datetime >= end_datetime:
            print("Start date must be before the end date.")
        else:
            valid = True
    return (str(start_datetime), str(end_datetime))


def validate_price(price: str, max_amount: float) -> bool:
    """
    Validates the given price.
    
    Args:
        price (str): The price in string form.
        max_amount (float): The max supported price.

    Returns:
        bool: True if the given string is a valid price, otherwise false.
    """

    # Regex match for valid price
    if not re.match(r"^(\d+|\d*\.\d{1,2})$", price):
        return False
    try:
        price_float = float(price)
        if price_float <= 0 or price_float > max_amount:
            return False
    except ValueError:
        return False
    return True


def get_validated_price(name: str, max_amount: float) -> float:
    """
    Gets a validated price from the user.

    Args:
        name: The name of the price type.
        max_amount: The max allowed amount for the price.
    """

    while True:
        print(f"\nPlease enter a {name} price:")
        value = input()
        if validate_price(value, max_amount):
            return value
        print(f"\nPrices must be valid (positive, up to two decimal points,"
              f" and with a max value of {max_amount}).")


def validate_string(user_string: str, required: bool, char_limit: int) -> bool:
    """
    Validates a string based on the character limit.

    Args:
        user_string (str): The string to validate.
        required (bool): Whether the string is required (not empty)
        char_limit (int): The max allowed length for the string.

    Returns:
        bool: True if the string is valid, otherwise false.
    """

    if len(user_string) <= char_limit:
        if (required and len(user_string) == 0):
            return False
        return True
    return False


def get_validated_string(name: str, required: bool, char_limit: int) -> str:
    """
    Gets a validated string from the user.

    Args:
        name: The name of the string type.
        required (bool): Whether the string is required (not empty)
        char_limit (int): The max allowed length for the string.

    Returns:
        str: The validated string.
    """

    while True:
        print(f"\nPlease enter a {name}:")
        value = input()
        if validate_string(value, required, char_limit):
            if len(value) == 0:
                return None
            return value
        null_warning = ""
        if required:
            null_warning = "Input cannot be null (empty)."
        print(f"\nInvalid input. Max character limit is {char_limit}."
              f" {null_warning}")


def get_product_id(db_cursor: MySQLCursor) -> int:
    """
    Gets a product ID from the user.

    Args:
        db_cursor (MySQLCursor): The database cursor.

    Returns:
        int: The product ID.
    """

    valid_product = False
    while valid_product is False:
        print("\nEnter a product ID:")
        product_id = input()
        try:
            product_id_int = int(product_id)
        except ValueError:
            print("\nProduct id must be an integer.")
        else:
            # Check that the product is in the inventory table
            if validate_product_in_inventory(db_cursor, product_id_int):
                valid_product = True
            else:
                print("\nInvalid product ID.")
    return product_id_int


def validate_product_in_inventory(db_cursor: MySQLCursor, product_id: int) -> bool:
    """
    Validates that the given product ID is in the inventory table.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
        product_id (int): The product id.

    Returns:
        bool: True if the product id is in the inventory table, otherwise false.
    """

    try:
        args = [product_id, 0]
        results = db_cursor.callproc('CheckProductInInventory', args)
        num_product = results[1]
        if num_product == 1:
            return True
        return False
    except mysql.connector.Error as err:
        print(f"Error querying Products table: {err}")
        return False


def confirm_change() -> bool:
    """
    Gets yes/no user confirmation.

    Returns:
        bool: True if user inputs y, otherwise false.
    """

    valid = False
    while valid is False:
        print("\nPlease confirm the change by entering y for yes or n to cancel:")
        user_confirmation = input().lower()
        if user_confirmation in ("y", "n"):
            valid = True
        else:
            print("\nInvalid option, please enter either y or n.")
    if user_confirmation == "y":
        return True
    return False


def list_products_in_inventory(db_cursor: MySQLCursor):
    """
    Lists products in inventory and their quantity.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nList of products in the inventory:")
    try:
        query = "SELECT Inventory.ProductID, Products.Name, Inventory.Quantity \
                FROM Inventory INNER JOIN Products ON Inventory.ProductID = Products.ProductID"
        db_cursor.execute(query)
        results = db_cursor.fetchall()
        if not results:
            print("No products found in the inventory.")
        else:
            print("Product ID      Product Name              Quantity")
            print("--------------------------------------------------")
            for row in results:
                print(f"{row[0]:<15} {row[1]:<25} {row[2]:<10}")
    except mysql.connector.Error as err:
        print(f"Error querying Products table: {err}")


def create_new_product(db_cursor: MySQLCursor, db_connection: MySQLConnection):
    """
    Creates a new product.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nCreate new product form:")
    name = get_validated_string("name", True, 20)
    brand = get_validated_string("brand", True, 20)
    description = get_validated_string("description", True, 50)
    department = get_validated_string("department", False, 15)
    buy_price = get_validated_price("buy", 999999.99)
    sell_price = get_validated_price("sell", 999999.99)

    # Confirm selection
    print("\nYou selected:")
    print(f"Name: {name}, brand: {brand}, description: {description},"
          f" department: {department}, buy price: {buy_price}, sell price: {sell_price}\n")
    if confirm_change():
        try:
            args = [name, brand, description, department, buy_price, sell_price]
            db_cursor.callproc('CreateNewProduct', args)
            # Commit the change
            db_connection.commit()
            print("\nProduct added successfully.")
        except mysql.connector.Error as err:
            print(f"\nError adding product: {err}")
            # Undo change if commit fails
            db_connection.rollback()


def modify_product_quantity(db_cursor: MySQLCursor, db_connection: MySQLConnection):
    """
    Modifies the quantity of a product in inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nModify product quantity form:")
    product_id = get_product_id(db_cursor)
    valid_quantity = False
    while valid_quantity is False:
        print("\nEnter a quantity:")
        product_quantity = input()
        try:
            product_quantity_int = int(product_quantity)
        except ValueError:
            print("\nProduct quantity must be an integer.")
        else:
            if product_quantity_int < 0:
                print("\nQuantity cannot be negative.")
            else:
                valid_quantity = True
    print(f"\nProduct ID: {product_id}, new quantity: {product_quantity_int}")
    if confirm_change():
        try:
            args = [product_id, product_quantity_int]
            db_cursor.callproc('ModifyProductInventoryQuantity', args)
            # Commit the change
            db_connection.commit()
            print(f"Product ID {product_id} inventory quantity updated to {product_quantity_int} successfully.")
        except mysql.connector.Error as err:
            print(f"\nError updating product ID {product_id} inventory quantity: {err}")
            # Undo change if commit fails
            db_connection.rollback()


def delete_product_from_inventory(db_cursor: MySQLCursor, db_connection: MySQLConnection):
    """
    Delete a product from inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nDelete product from inventory form:")
    product_id = get_product_id(db_cursor)
    if confirm_change():
        try:
            args = [product_id]
            db_cursor.callproc('DeleteProductFromInventory', args)
            # Commit the change
            db_connection.commit()
            print(f"Product ID {product_id} deleted from inventory successfully.")
        except mysql.connector.Error as err:
            print(f"\nError deleting product ID {product_id} from inventory: {err}")
            # Undo change if commit fails
            db_connection.rollback()


def list_most_popular_products(db_cursor: MySQLCursor):
    """
    Lists the most popular products in inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nList of most popular products for a datetime range:")
    datetime_range = get_datetime_range()
    start = datetime_range[0]
    end = datetime_range[1]
    print(f"\nDisplaying popular products from {start} to {end}:")
    try:
        args = [start, end]
        query = "CALL GetMostPopularProducts(%s, %s)"
        db_cursor.execute(query, args)
        rows = db_cursor.fetchall()

        if not rows:
            print("\nNo available products to show.")
        else:
            print("\nProductID       Name                      Brand      SellPrice            TransactionCount     WeightedAvgRating")
            print("---------------------------------------------------------------------------------------------------------")
            for row in rows:
                print(f"{row[0]:<15} {row[1]:<25} {row[2]:<10} {row[3]:<20} {row[4]:<20} {row[5]:<10}")  
            db_cursor.nextset()
    except mysql.connector.Error as err:
            print(f"\nError retrieving most popular products from a time range: {err}")


def list_least_popular_products(db_cursor: MySQLCursor):
    """
    Lists the least popular products in inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nList of least popular products for a datetime range:")
    datetime_range = get_datetime_range()
    start = datetime_range[0]
    end = datetime_range[1]
    print(f"\nDisplaying least popular products from {start} to {end}:")
    try:
        args = [start, end]
        query = "CALL GetLeastPopularProducts(%s, %s)"
        db_cursor.execute(query, args)
        rows = db_cursor.fetchall()

        if not rows:
            print("\nNo available products to show.")
        else:
            print("\nProductID       Name                      Brand      SellPrice            TransactionCount     WeightedAvgRating")
            print("---------------------------------------------------------------------------------------------------------")
            for row in rows:
                print(f"{row[0]:<15} {row[1]:<25} {row[2]:<10} {row[3]:<20} {row[4]:<20} {float(row[5]):<10}")  
            db_cursor.nextset() 
    except mysql.connector.Error as err:
            print(f"\nError retrieving least popular products from a time range: {err}")


def list_inactive_users(db_cursor: MySQLCursor):
    """
    Gets a list of users who haven't purchased something in 60 days,
    and their normally purchased products.

    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    try:
        inactiveUsers_query = "CALL GetInactiveUsers()"
        db_cursor.execute(inactiveUsers_query)
        inactiveUsers_rows = db_cursor.fetchall()
        db_cursor.nextset()

        if not inactiveUsers_rows:
            print("\nNo inactive users to view")
        else:
            print("\n\nList of inactive users and recommended promotional products")
            print("-----------------------------------------------------------\n")

            # Outputs each inactive user
            for row in inactiveUsers_rows:
                print(f"UserID: {row[0]:<8} \nFirstName: {row[1]:<11}")
                print(f"LastName: {row[2]:<11} \nEmail: {row[3]:<27} \nLastPurchase: {str(row[4]).split(' ')[0]:<15}")

                userID = row[0]
                db_cursor.execute("CALL GetUserNumOfTransactions(%s)", (userID,))
                result = db_cursor.fetchone()

                if (result[0] == 0):
                    # No purchase history; get All-Time Top 5
                    db_cursor.nextset()
                    db_cursor.execute("CALL GetAllTimeTop5Products()")
                    productRows = db_cursor.fetchall()

                else:
                    # Existing purchase history; get user's Top 5
                    db_cursor.nextset()
                    db_cursor.execute("CALL GetUserTop5Products(%s)", (userID,))
                    productRows = db_cursor.fetchall()

                # Print products
                print("\nProducts to promote based on user's purchase history:\n")
                for row in productRows:
                    print(f"ProductID: {row[0]:<8} Name: {row[1]:<15} Brand: {row[2]:<11} Rating: {(row[3]):<11}")
                print("\n\n-------------------------------------------------------------------------\n")
                db_cursor.nextset()

            db_cursor.nextset()
    except mysql.connector.Error as err:
            print(f"\nError retrieving list of inactive users: {err}")
    

def main():
    """Main application driver."""

    # Get database connection and cursor
    db_connection = get_database_connection()
    if db_connection is None:
        print("Please rerun the program once the database connection issues are resolved.")
        return
    db_cursor = db_connection.cursor()

    # Text menu choices
    user_exit = False
    while user_exit is False:
        display_menu()
        user_menu_choice = get_user_menu_choice(1, 8)
        if user_menu_choice == 1:
            list_products_in_inventory(db_cursor)
        elif user_menu_choice == 2:
            create_new_product(db_cursor, db_connection)
        elif user_menu_choice == 3:
            modify_product_quantity(db_cursor, db_connection)
        elif user_menu_choice == 4:
            delete_product_from_inventory(db_cursor, db_connection)
        elif user_menu_choice == 5:
            list_most_popular_products(db_cursor)
        elif user_menu_choice == 6:
            list_least_popular_products(db_cursor)
        elif user_menu_choice == 7:
            list_inactive_users(db_cursor)
        elif user_menu_choice == 8:
            print("\nThank you for visiting! Exiting...\n")
            db_cursor.close()
            db_connection.close()
            return


if __name__ == "__main__":
    main()

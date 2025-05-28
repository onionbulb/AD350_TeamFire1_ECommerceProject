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
    print("1. List which products we currently have in inventory.")
    print("2. Create a new product.")
    print("3. Modify the quantity of a product in inventory.")
    print("4. Delete a product from inventory.")
    print("5. Get a list of the most popular products for a date/time range.")
    print("6. Get a list of the least popular products for a date/time range.")
    print("7. Get a list of users who haven't purchased something in 90 days "
          + "and their normally purchased products.")
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


def validate_price(price: str) -> bool:
    """
    Validates the given price.
    
    Args:
        price (str): The price in string form.

    Returns:
        bool: True if the given string is a valid price, otherwise false.
    """

    # Regex match for valid price
    if not re.match(r"^(\d+|\d*\.\d{1,2})$", price):
        return False
    try:
        price_float = float(price)
        if price_float <= 0:
            return False
    except ValueError:
        return False
    return True


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
        print("Enter a product ID:")
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
                print("\nProduct id not found in inventory.")
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
    query = "SELECT COUNT(*) FROM Inventory WHERE ProductID = %s"
    value = (product_id,)
    try:
        db_cursor.execute(query, value)
        results = db_cursor.fetchall()
        if not results:
            print("Product ID is not in the inventory.")
            return False
        if results[0][0] == 1:
            return True
    except mysql.connector.Error as err:
        print(f"Error querying Products table: {err}")
        return False
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
    # This is just an example, could move this to a stored procedure if we want
    # Just wanted to confirm we can pull data properly and that cursor reuse is ok
    query = "SELECT Inventory.ProductID, Products.Name, Inventory.Quantity \
            FROM Inventory, Products WHERE Inventory.ProductID = Products.ProductID"
    try:
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


def create_new_product(db_cursor: MySQLCursor):
    """
    Creates a new product.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nCreate new products placeholder.")
    valid = False
    while valid is False:
        print("\nPlease enter a product name:")
        name = input()
        print("\nPlease enter a brand:")
        brand = input()
        print("\nPlease enter a department or leave blank and press enter for no department:")
        department = input()
        # Handle null department
        if len(department) == 0:
            department = "NULL"
        valid_price = False
        while valid_price is False:
            print("\nPlease enter a buy price:")
            buy_price = input()
            print("\nPlease enter a sell price:")
            sell_price = input()
            if (validate_price(buy_price) is True and validate_price(sell_price) is True):
                valid_price = True
                valid = True
            else:
                print("\nPrices must be valid.")
    print(f"\nName: {name}, brand: {brand}, department: {department}, " \
          f"buy price: {buy_price}, sell price: {sell_price}\n")
    if confirm_change():
        print("\nAdd new product placeholder")


def modify_product_quantity(db_cursor: MySQLCursor):
    """
    Modifies the quantity of a product in inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nModify product quantity placeholder.")
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
        print("Modify the product quantity placeholder")


def delete_product_from_inventory(db_cursor: MySQLCursor):
    """
    Delete a product from inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nDelete product from inventory placeholder.")
    product_id = get_product_id(db_cursor)
    print(f"Product id: {product_id}")
    if confirm_change():
        print("Delete the product")


def list_most_popular_products(db_cursor: MySQLCursor):
    """
    Lists the most popular products in inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nList most popular products placeholder.")
    datetime_range = get_datetime_range()
    start = datetime_range[0]
    end = datetime_range[1]
    print(f"Start datetime: {start}, end datetime: {end}")


def list_least_popular_products(db_cursor: MySQLCursor):
    """
    Lists the least popular products in inventory.
    
    Args:
        db_cursor (MySQLCursor): The database cursor.
    """

    print("\nList least popular products placeholder.")
    datetime_range = get_datetime_range()
    start = datetime_range[0]
    end = datetime_range[1]
    print(start)
    print(end)


def list_absent_users(db_cursor: MySQLCursor):
    """
    Gets a list of users who haven't purchased something in 90 days,
    and their normally purchased products.

    Args:
        db_cursor (MySQLCursor): The database cursor.
    """
    print("\nList absent users placeholder.")


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
            create_new_product(db_cursor)
        elif user_menu_choice == 3:
            modify_product_quantity(db_cursor)
        elif user_menu_choice == 4:
            delete_product_from_inventory(db_cursor)
        elif user_menu_choice == 5:
            list_most_popular_products(db_cursor)
        elif user_menu_choice == 6:
            list_least_popular_products(db_cursor)
        elif user_menu_choice == 7:
            list_absent_users(db_cursor)
        elif user_menu_choice == 8:
            print("\nThank you for visiting! Exiting...\n")
            db_cursor.close()
            db_connection.close()
            return


if __name__ == "__main__":
    main()

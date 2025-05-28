import os
import mysql.connector
from mysql.connector import errorcode

try:
    testConnection = mysql.connector.connect(
        user = 'testuser',         # Insert a MySQL username for access
        password = os.environ.get('MYSQL_PASSWORD'),     # Use env variable MYSQL_PASSWORD value
        host = '127.0.0.1',        # DB address to local host/machine
        database = "ecommerce"     # See README.md to create a local user for access
    )

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print('Invalid Credentials')
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print('Database not found')
    else:
        print('Cannot connect to database:', err)

else:
    # this is where we put our database operations
    print("Connection was successful")
    testConnection.close()
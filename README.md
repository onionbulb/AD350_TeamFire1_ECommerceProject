# AD350_TeamFire1_ECommerceProject
Repository for AD350 E-Commerce Project.

# Collaborator Instructions
Before running the project, please follow the following steps:

1. Activate the virtual environment to isolate dependencies from other projects
    - Type the statement below in the terminal/Bash:
    - If the terminal displays the prefix "(venv) $" or "(.venv)", it has been activated.
    - Alternatively, if working in VS Code, type ">Python: Select Interpretor" and check if the virtual environment has been selected.
````
Windows: .venv/Scripts/activate
Mac/Linux: source .venv/bin/activate
````

2. Install dependencies for the virtual environment
    - Dependencies are local to the virtual environment, so dependencies must be reinstalled every time a new virtual environment is initialized
````
pip install -r requirements.txt
````

3. To close the virtual environment, enter the command in the terminal:
    - Afterwards, the project will return to your default system.
    - Git is unaffected by the virtual environment, so you do not need to close the environment to use Git

````
deactivate
````

4. To create local users to connect to the database locally, see: https://www.geeksforgeeks.org/mysql-create-user-statement/.
   - For granting access privileges, see: https://www.slingacademy.com/article/mysql-8-how-to-grant-privileges-to-a-user-for-a-database/#granting-basic-privileges
````
CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'password'; # Creates the user
GRANT ALL PRIVILEGES ON ecommerce.* TO 'testuser'@'localhost'; # Grants access privileges
FLUSH PRIVILEGES; # To apply changes

SELECT user, host FROM mysql.user; # To view all users
````
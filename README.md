# sql
a database for PLP COURSE
# Warehouse Inventory Management System Database

## Project Title
Warehouse Inventory Management System Database

## Description of what your project does
This project designs and implements a relational database schema for a `Warehouse Inventory Management System`. The system aims to track products, their suppliers, their storage locations in various warehouses, customer information, and detailed records of customer orders.

The database is structured to support common inventory operations, including:
-   **Product Management**: Keeping records of all products, their descriptions, pricing, and stock-keeping units (SKUs).
-   **Supplier Management**: Storing details of vendors providing the products.
-   **Category Management**: Organizing products into logical categories.
-   **Warehouse Management**: Tracking physical storage locations.
-   **Inventory Tracking**: Recording exact quantities of products in specific warehouses.
-   **Customer Management**: Maintaining a database of customers.
-   **Order Management**: Recording customer orders and their current status.
-   **Order Item Details**: Linking specific products to individual orders with quantities and prices at the time of purchase.
-   **Audit Logging (Optional)**: A basic framework for tracking changes to critical data.

The schema uses proper relational database principles, including Primary Keys (PK), Foreign Keys (FK), and other constraints (`NOT NULL`, `UNIQUE`, `CHECK`) to ensure data integrity and consistency.

## How to run/setup the project (or import SQL)

1.  **Prerequisites:** You need a MySQL server installed and running on your system. You can use tools like MySQL Workbench, XAMPP (for Windows/Linux), MAMP (for macOS), or a direct MySQL installation.
2.  **Download the SQL File:** Clone this repository or download the `warehouse_inventory_db.sql` file.
3.  **Access MySQL:**
    * **Using MySQL Workbench (GUI):**
        * Open MySQL Workbench and connect to your MySQL server.
        * Go to `File > Open SQL Script...` and select the downloaded `warehouse_inventory_db.sql` file.
        * Click the "Execute" (lightning bolt) icon to run the script.
    * **Using MySQL Command Line Client:**
        * Open your terminal or command prompt.
        * Log in to your MySQL server: `mysql -u your_username -p` (you will be prompted for your password).
        * Execute the script: `SOURCE /path/to/your/warehouse_inventory_db.sql;` (Replace `/path/to/your/` with the actual path to the file).
        * Alternatively, you can pipe the file directly: `mysql -u your_username -p < warehouse_inventory_db.sql`
4.  **Verification:**
    * Once the script finishes, a new database named `warehouse_inventory_db` will be created.
    * You can verify the tables by running `USE warehouse_inventory_db;` and then `SHOW TABLES;` in your MySQL client.

## Screenshot or link to your ERD

Since I cannot directly generate images, you can create the ERD using a tool like **MySQL Workbench** or an online ERD tool.

**Steps to generate ERD using MySQL Workbench:**
1.  Open MySQL Workbench and connect to your MySQL server.
2.  Go to `Database > Reverse Engineer...`.
3.  Follow the wizard:
    * Select your MySQL connection.
    * Choose the `warehouse_inventory_db` schema.
    * Execute the reverse engineering process.
4.  MySQL Workbench will generate an ERD. You can then take a screenshot of this diagram.

**Expected ERD Overview:**
The ERD will show the following entities and their relationships:
-   `Suppliers` (1) --- (M) `Products`
-   `Categories` (1) --- (M) `Products`
-   `Products` (M) --- (M) `Warehouses` (via `Inventory` junction table)
-   `Customers` (1) --- (M) `Orders`
-   `Orders` (M) --- (M) `Products` (via `Order_Items` junction table)
-   `Audit_Log` (optional, stands alone, logs changes to other tables)

## Repository Contents
-   `warehouse_inventory_db.sql`: The complete SQL script for creating the database schema.
-   `README.md`: This documentation file.

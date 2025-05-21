-- warehouse_inventory_db.sql
--
-- Database for a Warehouse Inventory Management System
--
-- Objective: Design and implement a full-featured database for tracking products, suppliers,
--           warehouses, customers, and orders within an inventory context.
--
-- Author: Your Name/Gemini
-- Date: May 21, 2025
-- Database System: MySQL

-- -----------------------------------------------------
-- Database Creation and Selection
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS warehouse_inventory_db;
USE warehouse_inventory_db;

-- -----------------------------------------------------
-- Table: Suppliers
-- Description: Stores information about product suppliers.
-- Relationships: One-to-Many with Products (one supplier provides many products)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Suppliers;
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE,
    contact_person VARCHAR(100),
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255)
);

-- -----------------------------------------------------
-- Table: Categories
-- Description: Stores different categories for products.
-- Relationships: One-to-Many with Products (one category can have many products)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Categories;
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- -----------------------------------------------------
-- Table: Products
-- Description: Stores information about individual products.
-- Relationships:
--   - Many-to-One with Suppliers (each product comes from one supplier)
--   - Many-to-One with Categories (each product belongs to one category)
--   - Many-to-Many with Warehouses (via Inventory table)
--   - Many-to-Many with Orders (via Order_Items table)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    sku VARCHAR(50) UNIQUE, -- Stock Keeping Unit
    supplier_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table: Warehouses
-- Description: Stores information about physical warehouses where products are stored.
-- Relationships: Many-to-Many with Products (via Inventory table)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Warehouses;
CREATE TABLE Warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(255) NOT NULL,
    capacity_sqft INT CHECK (capacity_sqft >= 0)
);

-- -----------------------------------------------------
-- Table: Inventory (Junction Table for Products and Warehouses)
-- Description: Manages the stock quantity of each product in specific warehouses.
-- Relationships: Many-to-Many between Products and Warehouses
-- -----------------------------------------------------
DROP TABLE IF EXISTS Inventory;
CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity_in_stock INT NOT NULL CHECK (quantity_in_stock >= 0),
    last_restock_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (product_id, warehouse_id) -- A product can only have one entry per warehouse
);

-- -----------------------------------------------------
-- Table: Customers
-- Description: Stores information about customers who place orders.
-- Relationships: One-to-Many with Orders (one customer can place many orders)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address VARCHAR(255)
);

-- -----------------------------------------------------
-- Table: Orders
-- Description: Stores details of customer orders.
-- Relationships:
--   - Many-to-One with Customers (each order placed by one customer)
--   - Many-to-Many with Products (via Order_Items table)
-- -----------------------------------------------------
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table: Order_Items (Junction Table for Orders and Products)
-- Description: Details individual items within an order.
-- Relationships: Many-to-Many between Orders and Products
-- -----------------------------------------------------
DROP TABLE IF EXISTS Order_Items;
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_order DECIMAL(10, 2) NOT NULL CHECK (price_at_order >= 0), -- Price at the time of order
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (order_id, product_id) -- A product can only be listed once per order item entry
);

-- -----------------------------------------------------
-- Optional: Adding an audit log table for critical changes
-- -----------------------------------------------------
DROP TABLE IF EXISTS Audit_Log;
CREATE TABLE Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    change_details JSON, -- Store old/new values in JSON format
    changed_by VARCHAR(100),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

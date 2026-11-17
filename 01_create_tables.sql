-- =====================================================
-- Baking Supply Shop Database: table definitions
-- Run order: 01_create_tables.sql, 02_insert_data.sql, 03_queries.sql
-- Requires MySQL 8.0.16+ or MariaDB 10.2.1+ (CHECK constraints are enforced)
-- =====================================================

DROP DATABASE IF EXISTS baking_shop;
CREATE DATABASE baking_shop;
USE baking_shop;

CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity_in_stock INT DEFAULT 0,
    reorder_level INT DEFAULT 10,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    -- Business rule: product price has to be greater than $0
    CONSTRAINT chk_product_price CHECK (price > 0),
    CONSTRAINT chk_product_stock CHECK (quantity_in_stock >= 0),
    CONSTRAINT chk_product_reorder CHECK (reorder_level >= 0)
);

CREATE TABLE `order` (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT chk_order_total CHECK (total_amount IS NULL OR total_amount >= 0),
    CONSTRAINT chk_order_status CHECK (status IN ('pending', 'completed', 'cancelled'))
);

CREATE TABLE order_item (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_time DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT chk_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_item_price CHECK (price_at_time > 0)
);

-- Business rule NOT enforced by CHECK: "each order must have at least one item".
-- MySQL cannot check this at insert time (the order row is inserted before its items),
-- so 03_queries.sql includes a query that finds any orders with no items.

USE baking_shop;

INSERT INTO supplier (supplier_name, contact_name, phone) VALUES
('Flour Direct', 'Mike Johnson', '555-0101'),
('Sweet Supply Co.', 'Sarah Baker', '555-0102'),
('Tool Masters', 'Tom Williams', '555-0103');

INSERT INTO customer (first_name, last_name, phone, email) VALUES
('Alice', 'Brown', '555-1001', 'alice@email.com'),
('Bob', 'Smith', '555-1002', 'bob@email.com'),
('Carol', 'Davis', '555-1003', 'carol@email.com');

INSERT INTO product (product_name, category, price, quantity_in_stock, supplier_id) VALUES
('All-Purpose Flour', 'Flour', 4.99, 50, 1),
('Granulated Sugar', 'Sugar', 3.99, 40, 2),
('Baking Powder', 'Leavening', 2.49, 30, 2),
('Chocolate Chips', 'Add-ins', 5.99, 25, 2),
('9" Cake Pan', 'Tools', 12.99, 15, 3);

INSERT INTO `order` (customer_id, total_amount, status) VALUES
(1, 14.97, 'completed'),
(2, 12.99, 'completed'),
(1, 8.98, 'pending');

INSERT INTO order_item (order_id, product_id, quantity, price_at_time) VALUES
(1, 1, 2, 4.99),
(1, 2, 1, 3.99),
(2, 5, 1, 12.99),
(3, 1, 1, 4.99),
(3, 3, 1, 2.49);
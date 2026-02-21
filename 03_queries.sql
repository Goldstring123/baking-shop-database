USE baking_shop;

SELECT * FROM customer;

SELECT p.product_name, p.category, p.price, p.quantity_in_stock, s.supplier_name
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id;

SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.total_amount, o.status
FROM `order` o
JOIN customer c ON o.customer_id = c.customer_id;

SELECT o.order_id, p.product_name, oi.quantity, oi.price_at_time
FROM order_item oi
JOIN `order` o ON oi.order_id = o.order_id
JOIN product p ON oi.product_id = p.product_id;

SELECT product_name, quantity_in_stock, reorder_level
FROM product
WHERE quantity_in_stock <= reorder_level;
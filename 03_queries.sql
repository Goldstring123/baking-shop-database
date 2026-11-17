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

-- ---------------------------------------------------------
-- Additional queries
-- ---------------------------------------------------------

-- Low-stock products with the supplier to call for each reorder
SELECT p.product_name, p.quantity_in_stock, p.reorder_level,
       s.supplier_name, s.contact_name, s.phone
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id
WHERE p.quantity_in_stock <= p.reorder_level
ORDER BY p.quantity_in_stock;

-- Revenue and units sold per product (best sellers first)
SELECT p.product_name,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.price_at_time) AS revenue
FROM order_item oi
JOIN product p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;

-- Total spent by each customer on completed orders
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS completed_orders,
       SUM(o.total_amount) AS total_spent
FROM customer c
JOIN `order` o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Check that each order's total matches its line items
SELECT o.order_id, o.total_amount,
       SUM(oi.quantity * oi.price_at_time) AS calculated_total
FROM `order` o
JOIN order_item oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> calculated_total;

-- Business-rule check: orders that have no items (should return zero rows)
SELECT o.order_id, o.customer_id, o.order_date
FROM `order` o
LEFT JOIN order_item oi ON o.order_id = oi.order_id
WHERE oi.order_item_id IS NULL;

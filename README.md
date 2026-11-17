# Baking Supply Shop Database (MySQL)

A relational database for a small baking supply shop. It tracks customers, products and inventory, suppliers, orders, and the individual items on each order. Built for CIS 344 (Database Design) at Lehman College, Spring 2026.

![Chen ER diagram](uml_diagram.pdf)

## What it covers
- **Customers:** contact details and join date.
- **Products and inventory:** category, price, quantity in stock, and a reorder level for low-stock alerts.
- **Suppliers:** who supplies each product, with a contact person and phone number.
- **Orders and order items:** each order belongs to a customer, and each line item records the quantity and the **price at the time of purchase**, so old orders stay accurate if prices change later.

## Tables
| Table | Purpose | Key relationships |
|-------|---------|-------------------|
| `customer` | Customer contact information | Parent of `order` |
| `supplier` | Supplier company details | Parent of `product` |
| `product` | Items for sale and stock levels | References `supplier` |
| `order` | A customer purchase | References `customer` |
| `order_item` | Products on each order (many-to-many link) | References `order` and `product` |

## Data rules
| Rule | How it is enforced |
|------|--------------------|
| Every customer has a name and phone number | `NOT NULL` columns |
| Product price must be greater than $0 | `CHECK (price > 0)` |
| Stock and reorder level cannot be negative | `CHECK` constraints |
| Order item quantity and price must be positive | `CHECK` constraints |
| Order status is pending, completed, or cancelled | `CHECK (status IN (...))` |
| Products belong to a real supplier, orders to a real customer | Foreign keys |
| Every order has at least one item | Cannot be checked at insert time in MySQL (the order is inserted before its items), so `03_queries.sql` has a query that finds orders with no items |

## How to run it
1. Open **MySQL Workbench** (or phpMyAdmin) on MySQL 8.0.16+ or MariaDB 10.2.1+.
2. Run the files in this order:
   1. `01_create_tables.sql` creates the `baking_shop` database and tables.
   2. `02_insert_data.sql` loads sample suppliers, customers, products, and orders.
   3. `03_queries.sql` runs the example queries.

## Example queries (in `03_queries.sql`)
- Products with their suppliers, and orders with customer names
- Order line items with product names (three-table join)
- **Low-stock report** with the supplier to contact for each reorder
- Revenue and units sold per product
- Total spent per customer on completed orders
- Checks that order totals match their line items and that no order is empty

## Files
| File | Description |
|------|-------------|
| `01_create_tables.sql` | Table definitions, keys, and constraints |
| `02_insert_data.sql` | Sample data |
| `03_queries.sql` | Example and data-quality queries |
| `baking_shop.mwb` | MySQL Workbench model |
| `chen_diagram.jpg` | Chen-notation ER diagram |
| `uml_diagram.pdf` | UML diagram |
| `Documentation_Matthew_Triano.pdf` | Design process and mini-world description |
| `Final_Report_Matthew_Triano.pdf` | Final report |

## What I learned
- Turning a real-world business into entities, attributes, and relationships.
- Using a linking table (`order_item`) to model a many-to-many relationship between orders and products.
- Storing the price on each order line so historical orders stay correct.
- Enforcing business rules with constraints, and recognizing which rules a database cannot enforce on its own.

## Possible next steps
- Add a trigger to update stock automatically when an order is completed.
- Add a view for the low-stock report and a stored procedure to place an order.
- Build a simple web front end for the shop.

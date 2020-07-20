-- 1. Get all customers and their addresses.
SELECT customers.id, first_name, last_name, addresses.street, addresses.city, addresses.state, addresses.zip 
FROM customers 
JOIN addresses on customers.id = addresses.customer_id;

-- 2. Get all orders and their line items.
SELECT orders.id as order_id, products.description, line_items.quantity FROM orders
JOIN line_items on orders.id = line_items.order_id
JOIN products on products.id = line_items.product_id;

-- 3. Which warehouses have cheetos?
SELECT warehouse.warehouse FROM warehouse 
JOIN warehouse_product on warehouse.id = warehouse_product.warehouse_id
JOIN products on warehouse_product.product_id = products.id
WHERE products.description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT warehouse.warehouse FROM warehouse 
JOIN warehouse_product on warehouse.id = warehouse_product.warehouse_id
JOIN products on warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- 5. Get the number of orders for each customer. 
-- NOTE: It is OK if those without orders are not included in results.
SELECT customers.*, count(*) as order_count from customers
JOIN addresses on customers.id = addresses.customer_id
JOIN orders on addresses.id = orders.address_id
GROUP BY customers.id;



-- 6. How many customers do we have?
SELECT count(id) FROM customers;

-- 7. How many products do we carry?
SELECT count(id) FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT sum(warehouse_product.on_hand) 
FROM warehouse_product 
JOIN products on warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- STRETCH
-- 9. How much was the total cost for each order?
SELECT addresses.customer_id, orders.id as order_id, SUM(products.unit_price * line_items.quantity) as cost 
FROM orders
JOIN line_items on orders.id = line_items.order_id
JOIN products on products.id = line_items.product_id
JOIN addresses on orders.address_id = addresses.id
GROUP BY orders.id, addresses.customer_id
ORDER BY customer_id;

-- 10. How much has each customer spent in total?
SELECT customers.id, customers.first_name, customers.last_name, SUM(products.unit_price * line_items.quantity) as total_spend  
FROM customers
JOIN addresses on customers.id = addresses.customer_id
JOIN orders on orders.address_id = addresses.id
JOIN line_items on orders.id = line_items.order_id
JOIN products on products.id = line_items.product_id
GROUP BY customers.id
ORDER BY customers.id;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.id, customers.first_name, customers.last_name, COALESCE(SUM(products.unit_price * line_items.quantity), 0) as total_spend  
FROM customers
JOIN addresses on customers.id = addresses.customer_id
FULL JOIN orders on orders.address_id = addresses.id
FULL JOIN line_items on orders.id = line_items.order_id
FULL JOIN products on products.id = line_items.product_id
GROUP BY customers.id
ORDER BY customers.id;

Chapter 1:

Q1.

SELECT
    first_name,
    last_name,
    city,
    email
FROM sales.customers
WHERE state IN ('NY', 'CA')
    AND last_name LIKE 'M%'
ORDER BY city, last_name ASC;



Q2.

SELECT
    product_name,
    list_price,
    list_price * 0.90 AS discounted_price
FROM production.products
WHERE list_price > 500
ORDER BY list_price DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


Q3.

SELECT
    order_id,
    order_date,
    required_date,
    order_status
FROM sales.orders
WHERE order_status = 1 OR order_status = 2
    AND shipped_date IS NULL
    AND order_date BETWEEN '2018-01-01' AND '2018-06-30';






Chapter 2
Q4.

SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    s.store_name,
    p.product_name,
    oi.quantity
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 4
    AND o.order_date >= '2018-01-01'
    AND o.order_date < '2019-01-01'
ORDER BY o.order_date DESC;
     


Q5.

SELECT 
     p.product_name,
     c.category_name,
     b.brand_name
FROM production.products AS p
LEFT JOIN production.categories AS c
     ON p.product_name = c.category_name
LEFT JOIN production.brands AS b
     ON  b.brand_name = b.brand_name;


     
     
     
Q6. 

SELECT
    e.first_name + ' ' + e.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name,
    s.store_name
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id
INNER JOIN sales.stores AS s
    ON e.store_id = s.store_id
ORDER BY staff_name ASC;





Chapter 3

Q7.

CREATE VIEW sales.vw_order_details AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.customer_id,
    c.first_name,
    c.last_name,
    p.product_name,
    oi.quantity,
    (oi.quantity * p.list_price * (1 - oi.discount)) AS line_total
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id;




Chapter 4

Q8.

SELECT TOP 5
    c.category_name,
    b.brand_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.order_items AS oi
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
GROUP BY c.category_name, b.brand_name
HAVING COUNT(DISTINCT oi.order_id) >= 20
ORDER BY total_revenue DESC;



Q9.

SELECT
    s.store_name,
    YEAR(o.order_date) AS order_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name,
    YEAR(o.order_date)
ORDER BY s.store_name, order_year ASC;





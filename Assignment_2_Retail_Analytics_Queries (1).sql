-- Assignment 2: Retail Business SQL Analysis
-- Database: PostgreSQL (pgAdmin 4)
-- Contains Q1-Q15 from the assignment brief.
-- Run one question at a time by selecting that question's query and pressing F5.
-- Business rule: normal revenue questions include only Delivered orders.
-- Gross line value = quantity * unit_price_at_sale.
-- Net line value = quantity * unit_price_at_sale * (1 - discount_rate).

-- Q1. Delivered orders in the required date range, newest date first.
SELECT order_id, order_date, customer_id, payment_method
FROM orders
WHERE order_status = 'Delivered'
  AND order_date >= DATE '2024-10-01'
  AND order_date < DATE '2025-04-01'
ORDER BY order_date DESC;

-- Q2. Delivered orders with the matching customer and employee names.
SELECT Customers.customer_name,
       Orders.order_id,
       Orders.order_date,
       Employees.employee_name,
       Orders.order_status
FROM Orders
INNER JOIN Customers
    ON Orders.customer_id = Customers.customer_id
INNER JOIN Employees
    ON Orders.employee_id = Employees.employee_id
WHERE Orders.order_status = 'Delivered';

-- Q3. Total units and net revenue for each category; keep revenue above 10000.
SELECT Products.category,
       SUM(Order_Items.quantity) AS total_units,
       SUM(Order_Items.quantity * Order_Items.unit_price_at_sale
           * (1 - Order_Items.discount_rate)) AS net_revenue
FROM Orders
JOIN Order_Items
    ON Orders.order_id = Order_Items.order_id
JOIN Products
    ON Order_Items.product_id = Products.product_id
WHERE Orders.order_status = 'Delivered'
GROUP BY Products.category
HAVING SUM(Order_Items.quantity * Order_Items.unit_price_at_sale
           * (1 - Order_Items.discount_rate)) > 10000
ORDER BY net_revenue DESC;

-- Q4. Customers with at least two delivered orders and their net spend.
SELECT Customers.customer_id,
       Customers.customer_name,
       COUNT(DISTINCT Orders.order_id) AS total_orders,
       SUM(Order_Items.quantity * Order_Items.unit_price_at_sale
           * (1 - Order_Items.discount_rate)) AS net_spend
FROM Customers
JOIN Orders
    ON Customers.customer_id = Orders.customer_id
JOIN Order_Items
    ON Orders.order_id = Order_Items.order_id
WHERE Orders.order_status = 'Delivered'
GROUP BY Customers.customer_id, Customers.customer_name
HAVING COUNT(DISTINCT Orders.order_id) >= 2;

-- Q5. All customers and the count of their delivered orders, including zero.
SELECT Customers.customer_id,
       Customers.customer_name,
       COUNT(Orders.order_id) AS delivered_orders
FROM Customers
LEFT JOIN Orders
    ON Customers.customer_id = Orders.customer_id
    AND Orders.order_status = 'Delivered'
GROUP BY Customers.customer_id, Customers.customer_name
ORDER BY Customers.customer_id;

-- Q6. Products priced above the average price of all products.
SELECT product_name,
       category,
       unit_price,
       (SELECT AVG(unit_price) FROM products) AS average_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY unit_price DESC;

-- Q7. Customers who have never placed a delivered order.
SELECT customer_id, customer_name, city
FROM customers
WHERE NOT EXISTS (
    SELECT 1
    FROM orders
    WHERE orders.customer_id = customers.customer_id
      AND order_status = 'Delivered'
);

-- Q8. Delivered order count and net revenue by month, oldest month first.
SELECT DATE_TRUNC('month', Orders.order_date)::date AS order_month,
       COUNT(DISTINCT Orders.order_id) AS total_orders,
       SUM(Order_Items.quantity * Order_Items.unit_price_at_sale
           * (1 - Order_Items.discount_rate)) AS net_revenue
FROM Orders
JOIN Order_Items
    ON Orders.order_id = Order_Items.order_id
WHERE Orders.order_status = 'Delivered'
GROUP BY DATE_TRUNC('month', Orders.order_date)
ORDER BY order_month;

-- Q9. Label each product by its stock quantity.
SELECT product_name,
       stock_quantity,
       CASE
           WHEN stock_quantity < 20 THEN 'Low Stock'
           WHEN stock_quantity <= 40 THEN 'Moderate Stock'
           ELSE 'High Stock'
       END AS stock_label
FROM products;

-- Q10. Delivered, returned and cancelled order counts for every employee.
SELECT Employees.employee_id,
       Employees.employee_name,
       SUM(CASE WHEN Orders.order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
       SUM(CASE WHEN Orders.order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
       SUM(CASE WHEN Orders.order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
FROM Employees
LEFT JOIN Orders
    ON Employees.employee_id = Orders.employee_id
GROUP BY Employees.employee_id, Employees.employee_name
ORDER BY Employees.employee_id;

-- Q11. Rank every product within its category by delivered net revenue.
-- Products with no delivered sales are included with revenue zero.
WITH ProductSales AS (
    SELECT Products.product_id,
           Products.category,
           Products.product_name,
           SUM(
               CASE
                   WHEN Orders.order_status = 'Delivered'
                   THEN Order_Items.quantity
                        * Order_Items.unit_price_at_sale
                        * (1 - Order_Items.discount_rate)
                   ELSE 0
               END
           ) AS net_revenue
    FROM Products
    LEFT JOIN Order_Items
        ON Products.product_id = Order_Items.product_id
    LEFT JOIN Orders
        ON Order_Items.order_id = Orders.order_id
    GROUP BY Products.product_id,
             Products.category,
             Products.product_name
)
SELECT category,
       product_name,
       net_revenue,
       RANK() OVER (
           PARTITION BY category
           ORDER BY net_revenue DESC
       ) AS product_rank
FROM ProductSales
ORDER BY category, product_rank;

-- Q12. Monthly delivered net revenue and the cumulative running total.
WITH MonthlySales AS (
    SELECT DATE_TRUNC('month', Orders.order_date)::date AS order_month,
           SUM(Order_Items.quantity * Order_Items.unit_price_at_sale
               * (1 - Order_Items.discount_rate)) AS net_revenue
    FROM Orders
    JOIN Order_Items
        ON Orders.order_id = Order_Items.order_id
    WHERE Orders.order_status = 'Delivered'
    GROUP BY DATE_TRUNC('month', Orders.order_date)
)
SELECT order_month,
       net_revenue,
       SUM(net_revenue) OVER (ORDER BY order_month) AS running_total
FROM MonthlySales
ORDER BY order_month;

-- Q13. Returned orders and their total value before discount.
SELECT Customers.customer_name,
       Returns.return_date,
       Returns.return_reason,
       SUM(Order_Items.quantity * Order_Items.unit_price_at_sale) AS total_before_discount
FROM Returns
JOIN Orders
    ON Returns.order_id = Orders.order_id
JOIN Customers
    ON Orders.customer_id = Customers.customer_id
JOIN Order_Items
    ON Orders.order_id = Order_Items.order_id
GROUP BY Returns.return_id,
         Customers.customer_name,
         Returns.return_date,
         Returns.return_reason
ORDER BY Returns.return_date;

-- Q14. Customers whose net revenue is above the average for all customers.
-- Assumption: the average includes all customers, including zero-revenue customers.
WITH CustomerRevenue AS (
    SELECT Customers.customer_id,
           Customers.customer_name,
           COALESCE(SUM(
               Order_Items.quantity * Order_Items.unit_price_at_sale
               * (1 - Order_Items.discount_rate)
           ), 0) AS net_revenue
    FROM Customers
    LEFT JOIN Orders
        ON Customers.customer_id = Orders.customer_id
        AND Orders.order_status = 'Delivered'
    LEFT JOIN Order_Items
        ON Orders.order_id = Order_Items.order_id
    GROUP BY Customers.customer_id, Customers.customer_name
)
SELECT customer_name, net_revenue
FROM CustomerRevenue
WHERE net_revenue > (
    SELECT AVG(net_revenue)
    FROM CustomerRevenue
)
ORDER BY net_revenue DESC;

-- Q15. Top three customers by delivered net spend and their share of total delivered revenue.
WITH CustomerSales AS (
    SELECT Customers.customer_id,
           Customers.customer_name,
           COUNT(DISTINCT Orders.order_id) AS total_orders,
           SUM(Order_Items.quantity * Order_Items.unit_price_at_sale
               * (1 - Order_Items.discount_rate)) AS net_spend
    FROM Customers
    JOIN Orders
        ON Customers.customer_id = Orders.customer_id
    JOIN Order_Items
        ON Orders.order_id = Order_Items.order_id
    WHERE Orders.order_status = 'Delivered'
    GROUP BY Customers.customer_id, Customers.customer_name
)
SELECT customer_name,
       total_orders,
       net_spend,
       ROUND(net_spend * 100.0 / SUM(net_spend) OVER (), 2) AS contribution_percent
FROM CustomerSales
ORDER BY net_spend DESC
LIMIT 3;

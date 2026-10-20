-- Set B: Retail Sales & Customer Analytics
-- PostgreSQL / pgAdmin 4 setup script
-- IMPORTANT: Create/connect to a separate database named retail_analytics first.
-- Then run this whole script ONCE in that database.
-- This script creates the six tables and loads the provided sample data.
-- Do not run it a second time after tables/data have already been created.

-- Table schema and supplied sample data, prepared for PostgreSQL.

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  city VARCHAR(60),
  state VARCHAR(60),
  signup_date DATE
);
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(120) NOT NULL,
  category VARCHAR(60),
  unit_price DECIMAL(10,2),
  stock_quantity INT
);
CREATE TABLE Employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100) NOT NULL,
  department VARCHAR(60),
  branch_city VARCHAR(60),
  monthly_salary DECIMAL(10,2)
);
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  employee_id INT,
  order_status VARCHAR(30),
  payment_method VARCHAR(30),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
CREATE TABLE Order_Items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price_at_sale DECIMAL(10,2),
  discount_rate DECIMAL(4,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Returns (
  return_id INT PRIMARY KEY,
  order_id INT,
  return_date DATE,
  return_reason VARCHAR(120),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers (customer_id, customer_name, email, city, state, signup_date) VALUES
(1001, 'Aarav Sharma', 'aarav.sharma@example.com', 'Lucknow', 'Uttar Pradesh', '2024-01-15'),
(1002, 'Diya Verma', 'diya.verma@example.com', 'Kanpur', 'Uttar Pradesh', '2024-02-10'),
(1003, 'Kabir Singh', 'kabir.singh@example.com', 'Delhi', 'Delhi', '2023-11-22'),
(1004, 'Meera Patel', 'meera.patel@example.com', 'Jaipur', 'Rajasthan', '2024-03-05'),
(1005, 'Ishaan Gupta', 'ishaan.gupta@example.com', 'Lucknow', 'Uttar Pradesh', '2023-08-19'),
(1006, 'Ananya Rao', 'ananya.rao@example.com', 'Bhopal', 'Madhya Pradesh', '2024-04-12'),
(1007, 'Reyansh Khan', 'reyansh.khan@example.com', 'Delhi', 'Delhi', '2024-05-01'),
(1008, 'Saanvi Joshi', 'saanvi.joshi@example.com', 'Pune', 'Maharashtra', '2023-12-09'),
(1009, 'Vivaan Mishra', 'vivaan.mishra@example.com', 'Lucknow', 'Uttar Pradesh', '2024-06-17'),
(1010, 'Aditi Das', 'aditi.das@example.com', 'Kolkata', 'West Bengal', '2024-07-02'),
(1011, 'Arjun Mehta', 'arjun.mehta@example.com', 'Jaipur', 'Rajasthan', '2023-09-14'),
(1012, 'Myra Nair', 'myra.nair@example.com', 'Mumbai', 'Maharashtra', '2024-08-21');

INSERT INTO Products (product_id, product_name, category, unit_price, stock_quantity) VALUES
(201, 'Wireless Mouse', 'Accessories', 799.0, 80),
(202, 'Mechanical Keyboard', 'Accessories', 2499.0, 35),
(203, 'USB-C Hub', 'Accessories', 1899.0, 42),
(204, '27-inch Monitor', 'Displays', 14999.0, 18),
(205, 'Laptop Stand', 'Accessories', 1299.0, 55),
(206, 'Webcam HD', 'Peripherals', 3299.0, 24),
(207, 'Noise-Cancelling Headphones', 'Audio', 5999.0, 20),
(208, 'Bluetooth Speaker', 'Audio', 2199.0, 30),
(209, 'External SSD 1TB', 'Storage', 7499.0, 16),
(210, 'Ergonomic Chair', 'Furniture', 11999.0, 12);

INSERT INTO Employees (employee_id, employee_name, department, branch_city, monthly_salary) VALUES
(301, 'Nisha Kapoor', 'Sales', 'Lucknow', 52000),
(302, 'Rahul Bansal', 'Sales', 'Delhi', 58000),
(303, 'Pooja Iyer', 'Support', 'Lucknow', 44000),
(304, 'Karan Malhotra', 'Operations', 'Jaipur', 49000),
(305, 'Sneha Kulkarni', 'Sales', 'Pune', 61000);

INSERT INTO Orders (order_id, customer_id, order_date, employee_id, order_status, payment_method) VALUES
(5001, 1001, '2024-09-02', 301, 'Delivered', 'UPI'),
(5002, 1002, '2024-09-05', 302, 'Delivered', 'Card'),
(5003, 1003, '2024-09-07', 302, 'Returned', 'Card'),
(5004, 1001, '2024-09-15', 301, 'Delivered', 'UPI'),
(5005, 1004, '2024-10-01', 304, 'Delivered', 'Cash'),
(5006, 1005, '2024-10-04', 301, 'Delivered', 'Card'),
(5007, 1006, '2024-10-11', 303, 'Cancelled', 'UPI'),
(5008, 1007, '2024-10-18', 302, 'Delivered', 'Card'),
(5009, 1008, '2024-11-02', 305, 'Delivered', 'Wallet'),
(5010, 1009, '2024-11-10', 301, 'Returned', 'UPI'),
(5011, 1010, '2024-11-15', 304, 'Delivered', 'Card'),
(5012, 1011, '2024-12-01', 304, 'Delivered', 'Cash'),
(5013, 1012, '2024-12-09', 305, 'Delivered', 'Wallet'),
(5014, 1003, '2025-01-05', 302, 'Delivered', 'Card'),
(5015, 1002, '2025-01-12', 302, 'Delivered', 'UPI'),
(5016, 1005, '2025-01-20', 301, 'Delivered', 'Card'),
(5017, 1006, '2025-02-02', 303, 'Delivered', 'UPI'),
(5018, 1007, '2025-02-14', 302, 'Returned', 'Card'),
(5019, 1008, '2025-03-01', 305, 'Delivered', 'Wallet'),
(5020, 1009, '2025-03-15', 301, 'Delivered', 'UPI'),
(5021, 1010, '2025-04-03', 304, 'Cancelled', 'Cash'),
(5022, 1011, '2025-04-22', 304, 'Delivered', 'Card'),
(5023, 1012, '2025-05-07', 305, 'Delivered', 'Wallet'),
(5024, 1004, '2025-05-19', 304, 'Delivered', 'UPI');

INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price_at_sale, discount_rate) VALUES
(1, 5001, 201, 2, 799.0, 0.05),
(2, 5001, 203, 1, 1899.0, 0.0),
(3, 5002, 202, 1, 2499.0, 0.1),
(4, 5002, 205, 2, 1299.0, 0.0),
(5, 5003, 207, 1, 5999.0, 0.0),
(6, 5004, 204, 1, 14999.0, 0.08),
(7, 5004, 201, 1, 799.0, 0.0),
(8, 5005, 210, 1, 11999.0, 0.05),
(9, 5006, 209, 1, 7499.0, 0.1),
(10, 5006, 203, 2, 1899.0, 0.0),
(11, 5007, 206, 1, 3299.0, 0.0),
(12, 5008, 207, 1, 5999.0, 0.15),
(13, 5008, 208, 2, 2199.0, 0.0),
(14, 5009, 202, 1, 2499.0, 0.05),
(15, 5009, 206, 1, 3299.0, 0.0),
(16, 5010, 204, 1, 14999.0, 0.0),
(17, 5011, 208, 3, 2199.0, 0.1),
(18, 5012, 210, 1, 11999.0, 0.0),
(19, 5013, 209, 2, 7499.0, 0.05),
(20, 5014, 202, 2, 2499.0, 0.0),
(21, 5014, 203, 1, 1899.0, 0.05),
(22, 5015, 205, 1, 1299.0, 0.0),
(23, 5015, 201, 3, 799.0, 0.1),
(24, 5016, 204, 1, 14999.0, 0.05),
(25, 5017, 206, 2, 3299.0, 0.0),
(26, 5017, 208, 1, 2199.0, 0.0),
(27, 5018, 207, 1, 5999.0, 0.0),
(28, 5019, 209, 1, 7499.0, 0.1),
(29, 5020, 203, 2, 1899.0, 0.0),
(30, 5020, 201, 1, 799.0, 0.0),
(31, 5021, 210, 1, 11999.0, 0.0),
(32, 5022, 202, 1, 2499.0, 0.0),
(33, 5022, 205, 1, 1299.0, 0.0),
(34, 5023, 209, 1, 7499.0, 0.0),
(35, 5024, 204, 1, 14999.0, 0.1),
(36, 5024, 205, 2, 1299.0, 0.0);

INSERT INTO Returns (return_id, order_id, return_date, return_reason) VALUES
(9001, 5003, '2024-09-20', 'Damaged item'),
(9002, 5010, '2024-11-17', 'Changed mind'),
(9003, 5018, '2025-02-20', 'Product not as expected');


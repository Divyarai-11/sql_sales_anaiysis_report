CREATE DATABASE sales_analysis;
USE sales_analysis;

CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
region VARCHAR(50)
);

CREATE TABLE transactions (
transaction_id INT PRIMARY KEY,
customer_id INT,
product_name VARCHAR(100),
quantity INT,
price DECIMAL(10,2),
tax_percent DECIMAL(5,2),
transaction_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

INSERT INTO customers VALUES
(1,'Rahul Sharma', 'North'),
(2, 'Priya Gupta', 'South'),
(3, 'Amit Verma', 'East'),
(4, 'Neha Kapoor', 'West');

INSERT INTO transactions VALUES
(101, 1, 'Laptop', 1, 50000, 18, '2026-01-01'),
(102, 2, 'Mobile', 2, 20000, 12, '2026-01-15'),
(103, 3, 'Tablet', 3, 15000, 18, '2026-02-10'),
(104, 4, 'Monitor', 5, 2000, 5, '2026-02-05'),
(105, 1, 'Headphones', 2, 10000, 18, '2026-03-12');

SELECT YEAR(transaction_date) AS year,
MONTH(transaction_date) AS month,
SUM(quantity*price) AS total_revenue,
SUM((quantity*price)*tax_percent/100) AS total_tax,
SUM((quantity*price)-((quantity*price)*tax_percent/100)) AS net_revenue
FROM transactions GROUP BY YEAR(transaction_date),
MONTH(transaction_date)
ORDER BY year, month;

SELECT c.region,
SUM(t.quantity*t.price) AS total_revenue,
SUM((t.quantity*t.price)*t.tax_percent/100) AS total_tax
FROM transactions t JOIN customers c ON
t.customer_id= c.customer_id GROUP BY c.region;

SELECT c.customer_name,
SUM(t.quantity*t.price) AS total_purchase, CASE 
WHEN SUM(t.quantity*t.price)> 50000 THEN 'Premium Customer'
WHEN SUM(t.quantity*t.price) BETWEEN 20000 AND 50000 THEN 'Gold Customer'
ELSE 'Regular Customer' END AS customer_category
FROM transactions t JOIN customers c ON
t.customer_id=c.customer_id
GROUP BY c.customer_name;

SELECT customer_name FROM customers
WHERE customer_id IN (
SELECT customer_id FROM transactions
GROUP BY customer_id HAVING SUM(quantity*price)>
(SELECT AVG(total_amount) FROM(
SELECT SUM(quantity*price) AS total_amount
FROM transactions GROUP BY customer_id)
AS avg_table)
);

SELECT SUM(quantity*price) AS current_month_sales
FROM transactions WHERE MONTH (transaction_date)=
MONTH(NOW()) AND YEAR(transaction_date)=
YEAR(NOW());

SELECT c.customer_name,
c.region,
t.product_name,
t.quantity,
t.price,
(t.quantity*t.price) AS total_amount,
(t.quantity*t.price)*t.tax_percent/100 AS tax_amount,
((t.quantity*t.price)-((t.quantity*t.price)*
t.tax_percent/100)) AS net_amount,
MONTH(t.transaction_date) AS month,
YEAR(t.transaction_date) AS year
FROM transactions t JOIN customers c ON t.customer_id= 
c.customer_id ORDER BY year,month;
-- Calculate the average order amount of each country

select country, AVG(priceEach*quantityOrdered) as order_amount  from customers c 
INNER JOIN orders o ON o.customerNumber = c.customerNumber
INNER JOIN orderdetails od ON od.orderNumber = o.orderNumber
GROUP BY 1
ORDER BY order_amount DESC;

-- Calculate the total sales amount for each product line.

SELECT pl.productLine as Product_Line
,SUM(quantityOrdered*priceEach) as sales_amount FROM classicmodels.orderdetails od 
INNER JOIN products p ON p.productCode = od.productCode
INNER JOIN productlines pl ON pl.productLine = p.productLine
GROUP BY 1
ORDER BY sales_amount DESC;

-- List the top 10 best-selling products based on total quantity sold

SELECT p.productName as Product,SUM(od.quantityOrdered) as QuantitySold 
FROM products p INNER JOIN orderdetails od 
ON p.productCode = od.productCode
GROUP BY 1
ORDER BY QuantitySold DESC
LIMIT 10;

-- Evaluate the sales performance of each sales representative

SELECT CONCAT(e.firstName,' ',e.lastName) as  SaleRep , 
SUM(p.amount) as TotalSalesAmount
FROM classicmodels.employees e 
LEFT JOIN customers c on e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN payments p on c.customerNumber = p.customerNumber
GROUP BY 1
ORDER BY TotalSalesAmount DESC;

-- Calculate the average number of orders placed by the each customer?

select count(o.orderNumber) / count(DISTINCT c.customerNumber) as Average_order_placed
from customers c JOIN orders o ON c.customerNumber = o.customerNumber;

-- Percent of Orders Shipped on time? 
SELECT 
SUM(CASE WHEN shippedDate <= requiredDate THEN 1 ELSE 0 END) / count(*) * 100 as `percent of orders shipped on time`	   
FROM classicmodels.orders;

-- Calculate the profit margin for each product by subtracting the cost of goods sold (COGS) from the sales revenue

SELECT p.productCode,p.productName,
(SUM(od.priceEach*od.quantityOrdered) - SUM(od.quantityOrdered*p.buyPrice))  as profitAmount
from orderdetails od JOIN products p ON od.productCode = p.productCode
group by 1;

-- Segment customers based on their total purchase amount

SELECT customerNumber ,total_purchase_amount,
CASE WHEN total_purchase_amount > 100000 then 'High Value'
WHEN total_purchase_amount > 50000 then 'Medium Value'
ELSE 'Low Value'
END AS customer_segment
FROM 
(SELECT customerNumber, sum(quantityOrdered*priceEach) as total_purchase_amount 
FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 1) as c;

-- 
SELECT * 
FROM customers c LEFT JOIN (
SELECT customerNumber ,total_purchase_amount,
CASE WHEN total_purchase_amount > 100000 then 'High Value'
WHEN total_purchase_amount > 50000 then 'Medium Value'
ELSE 'Low Value'
END AS customer_segment
FROM 
(SELECT customerNumber, sum(quantityOrdered*priceEach) as total_purchase_amount 
FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 1) as c
) V 
ON c.customerNumber = V.customerNumber; 

-- Identify frequently co-purchased products to understand cross-selling opportunities

SELECT od1.productCode as product1,
p1.productName as productname1,
od2.productCode AS product2,
p2.productname AS productname2,
COUNT(*) AS co_purchase_count
FROM orderdetails od1 JOIN orderdetails od2 ON od1.orderNumber = od2.orderNumber and od1.productCode <> od2.productCode
JOIN products p1 ON p1.productCode = od1.productCode
JOIN products p2 ON p2.productCode = od2.productCode
GROUP BY 1,2,3,4
ORDER BY co_purchase_count desc;

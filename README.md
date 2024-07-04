# SQL- Classic Model 

In this project, I analyzed customer purchases and orders across different countries to evaluate the revenue generated for the company. The analysis focused on various product types and assessed the associated profit or loss. Key insights include identifying the most sold product, understanding customer payment statuses, and analyzing customer order rates.

### Steps followed 

- Importing the data by running the script on the sql workbench.
- There are 8 tables which will be added post running the script in the newly created schema
        
### Questions raised from the analysis 

-Q1. Calculate the average order amount of each country?
    
      select country, AVG(priceEach*quantityOrdered) as order_amount  from customers c 
      INNER JOIN orders o ON o.customerNumber = c.customerNumber
      INNER JOIN orderdetails od ON od.orderNumber = o.orderNumber
      GROUP BY 1
      ORDER BY order_amount DESC;

![Q1](https://github.com/prakashkathait/classicModels_Sql/assets/166843819/ab32d037-31bb-4917-bde7-e0dcceb06d4c)

Q2. Calculate the total sales amount for each product line?
     
      SELECT pl.productLine as Product_Line
      ,SUM(quantityOrdered*priceEach) as sales_amount FROM classicmodels.orderdetails od 
      INNER JOIN products p ON p.productCode = od.productCode
      INNER JOIN productlines pl ON pl.productLine = p.productLine
      GROUP BY 1
      ORDER BY sales_amount DESC;
![Q2](https://github.com/prakashkathait/classicModels_Sql/assets/166843819/7dc48325-10e8-42cf-bdcc-3ab02e0611a3)

Q3. List the top 10 best-selling products based on total quantity sold?
   
      SELECT p.productName as Product,SUM(od.quantityOrdered) as QuantitySold 
      FROM products p INNER JOIN orderdetails od 
      ON p.productCode = od.productCode
      GROUP BY 1
      ORDER BY QuantitySold DESC
      LIMIT 10;

![Q3](https://github.com/prakashkathait/classicModels_Sql/assets/166843819/02ef7cf4-9d5f-4b1a-8bcf-54bf9778101f)

Q4.Evaluate the sales performance of each sales representative?

      SELECT CONCAT(e.firstName,' ',e.lastName) as  SaleRep , 
      SUM(p.amount) as TotalSalesAmount
      FROM classicmodels.employees e 
      LEFT JOIN customers c on e.employeeNumber = c.salesRepEmployeeNumber
      LEFT JOIN payments p on c.customerNumber = p.customerNumber
      GROUP BY 1
      ORDER BY TotalSalesAmount DESC;

![Q4](https://github.com/prakashkathait/classicModels_Sql/assets/166843819/77ce4192-9c88-4d62-b839-095fe010e0b4)

Q5. Identify frequently co-purchased products to understand cross-selling opportunities

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

![Q5](https://github.com/prakashkathait/classicModels_Sql/assets/166843819/d5c1eeda-bfee-4c46-a5db-7019553dfb51)

Q6.Segment customers based on their total purchase amount

      SELECT customerNumber ,total_purchase_amount,
      CASE WHEN total_purchase_amount > 100000 then 'High Value'
      WHEN total_purchase_amount > 50000 then 'Medium Value'
      ELSE 'Low Value'
      END AS customer_segment
      FROM 
      (SELECT customerNumber, sum(quantityOrdered*priceEach) as total_purchase_amount 
      FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber
      GROUP BY 1) as c;

![Q6](https://github.com/prakashkathait/classicModels_Sql/assets/166843819/0080717d-d493-45d9-84c5-83e2f4c8ba3a)


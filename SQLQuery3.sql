USE StoreDB ;

--List all products with list price greater than 1000  
SELECT * FROM production.products WHERE list_price >= 1000;

-- Get customers from "CA" or "NY" states 
SELECT * FROM sales.customers WHERE state = 'CA' OR state = 'NY' ;
SELECT (first_name + ' ' + last_name)as Full_Name FROM sales.customers  
WHERE state = 'CA' OR state = 'NY' ;

--Retrieve all orders placed in 2023
SELECT * FROM sales.orders WHERE order_date >= '01-01-2023' AND order_date < '01-01-2024' ;

--Show customers whose emails end with @gmail.com

SELECT (first_name + ' ' + last_name)as Full_Name  FROM sales.customers  
WHERE email like  '%@gmail.com' ;


SELECT (first_name + ' ' + last_name)as Full_Name  , email FROM sales.customers  
WHERE email like  '%@gmail.com' ;

--Show all inactive staff
SELECT * FROM sales.staffs WHERE active = 0 ;

-- List top 5 most expensive products
SELECT TOP 5 *  
FROM production.products 
ORDER BY list_price DESC  ;

-- Show latest 10 orders sorted by date 
SELECT TOP 10 * FROM sales.orders  
ORDER BY order_date DESC;

-- Retrieve the first 3 customers alphabetically by last name


SELECT TOP 3  last_name FROM sales.customers
ORDER BY last_name;


-- Find customers who did not provide a phone number
SELECT (first_name + ' ' + last_name)as Full_Name FROM sales.customers  
WHERE phone IS NULL ; 

-- Show all staff who have a manager assigned
SELECT * FROM sales.staffs 
WHERE manager_id IS NOT NULL ;

-- Count number of products in each category
SELECT category_id , COUNT(category_id ) as CNT FROM production.products
GROUP BY (category_id ) ;
 

 -- Count number of customers in each state
  SELECT state , COUNT(state) AS numberOfCustomers  FROM sales.customers 
  GROUP BY state ;

  -- Get average list price of products per brand
  SELECT brand_id , avg(list_price) FROM production.products 
  GROUP BY (brand_id)  ;

  -- Show number of orders per staff
  SELECT staff_id, COUNT(order_id) AS numberOfOrder  FROM sales.orders 
  GROUP BY(staff_id);

  -- Find customers who made more than 2 orders
  SELECT (first_name + ' ' + last_name)as Full_Name  FROM sales.customers 
  WHERE customer_id IN (
  SELECT customer_id FROM sales.orders
  GROUP BY( customer_id) 
  HAVING COUNT(customer_id ) > 2  
  );

  -- Products priced between 500 and 1500
  SELECT product_name  FROM production.products
  WHERE list_price > 500 AND list_price < 1500 ;

  -- Customers in cities starting with "S"
SELECT city , (first_name + ' ' + last_name)as Full_Name FROM sales.customers  
WHERE city like 'S%' ;
 

 -- Orders with order_status either 2 or 4
SELECT * FROM sales.orders
WHERE order_status = 2 or order_status = 4 ;

-- Products from category_id IN (1, 2, 3)

SELECT product_id , product_name FROM production.products 
WHERE category_id IN(1 , 2 , 3) ;

-- Staff working in store_id = 1 OR without phone number
SELECT staff_id , first_name , last_name FROM sales.staffs  
WHERE store_id = 1 OR  phone IS NULL;
USE StoreDB 

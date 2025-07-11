--  1. Count the total number of products in the database. 
 SELECT TOP 1 product_id  FROM production.products 
 ORDER BY product_id DESC ;


 -- 2. Find the average, minimum, and maximum price of all products.
 SELECT AVG(list_price) AS AVG_PRICE , MIN(list_price) AS MIN_PRICE , MAX(list_price) AS MAX_PRICE
 FROM production.products ;
 

 -- 3. Count how many products are in each category.
 SELECT category_id , COUNT(product_id)   AS  NUM_PRODUCTs FROM production.products
 GROUP BY(category_id);
 
 -- 4. Find the total number of orders for each store.
 SELECT store_id , COUNT(order_id)  AS NUM_ORDERs  FROM sales.orders
 GROUP BY(store_id);


 -- 5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.
  SELECT TOP 10 UPPER(first_name) AS firstName , LOWER(last_name) AS lastName FROM sales.customers   ;


  --6. Get the length of each product name. Show product name and its length for the first 10 products.
  SELECT TOP 10 product_name , LEN(product_name) AS lenName   FROM production.products ;

  -- 7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.

  SELECT LEFT(phone , 3)  FROM sales.customers 
  WHERE customer_id between 1 and 15 ;


  -- 8. Show the current date and extract the year and month from order dates for orders 1-10.

  SELECT   GETDATE() AS CurrentDate;  -- TO show the current date 
  SELECT  order_id , GETDATE()AS CurrentDate,YEAR(order_date) AS TheYear , MONTH (order_date) TheMonth  FROM sales.orders 
  WHERE order_id between 1 and 10 ;

  -- 9. Join products with their categories. Show product name and category name for first 10 products.

SELECT TOP 10   product_name , category_name FROM production.products  
JOIN production.categories 
ON production.products.category_id =  production.categories.category_id ;

  -- 10. Join customers with their orders. Show customer name and order date for first 10 orders.
  SELECT TOP 10 (first_name + ' ' + last_name) AS custName , order_date  FROM sales.customers 
  JOIN sales.orders 
  ON sales.customers.customer_id = sales.orders.customer_id ; 


  -- 11. Show all products with their brand names,
 -- even if some products don't have brands. Include product name, brand name (show 'No Brand' if null).
   SELECT product_id ,product_name , COALESCE(brand_name ,'No Brand' ) AS brandName  FROM  production.products 
   JOIN  production.brands
   ON  production.products.brand_id =  production.products.brand_id ;

   -- 12. Find products that cost more than the average product price. Show product name and price.
   SELECT  product_id ,product_name,list_price  FROM production.products 
   WHERE list_price > (
   
  SELECT AVG(list_price) FROM production.products 
   )  ;

  -- 13. Find customers who have placed at least one order.
  --Use a subquery with IN. Show customer_id and customer_name.

  SELECT customer_id , first_name + '  ' + last_name  AS custName  FROM sales.customers  
  WHERE customer_id IN(SELECT customer_id FROM sales.orders   ) ;


  -- 14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.
  SELECT customer_id , first_name + '  ' + last_name  AS custName , (
  SELECT  COUNT(customer_id) FROM sales.orders 
  WHERE sales.customers.customer_id = sales.orders.customer_id
  ) AS NUM_Orders 
  FROM sales.customers ;

  -- 15. Create a simple view called easy_product_list that shows product name, 
  --category name, and price. Then write a query to select all products from this view where price > 100.

  CREATE VIEW easy_product_list AS
  SELECT 
   production.categories.category_name , 
  production.products.product_name , 

  production.products.list_price 
  FROM production.products
  JOIN production.categories ON production.products.category_id = production.categories.category_id ;
  

  SELECT * FROM easy_product_list 
  WHERE list_price > 100 


  -- 16. Create a view called customer_info that shows customer ID
  -- , full name (first + last), email, and city and state combined. 
  --Then use this view to find all customers from California (CA). 

  CREATE VIEW customer_info  AS 
  SELECT 
  sales.customers.city ,
  (sales.customers.first_name + ' ' + sales.customers.last_name) AS fullName , 
  sales.customers.email , 
  sales.customers.city +' ' + sales.customers.state AS CityState  
  FROM sales.customers ;


  SELECT * FROM customer_info 
  WHERE CityState like '%CA';


-- 17. Find all products that cost between $50 and $200. Show product name and price,
--ordered by price from lowest to highest.
SELECT  product_name, list_price   FROM production.products 
WHERE list_price between 50 and 200 
ORDER BY list_price ;
  


  -- 18. Count how many customers live in each state. Show state and customer count, 
  -- ordered by count from highest to lowest.
  SELECT state , COUNT(customer_id) AS custCNT FROM sales.customers
  GROUP BY state  
  ORDER BY custCNT ; 

  -- 19. Find the most expensive product in each category. Show category name, product name, and price.
  SELECT TOP 1 category_name, product_name, list_price FROM  production.products P
  JOIN  production.categories C
  ON P.category_id = C.category_id 
  ORDER BY list_price DESC;
  
   
   -- 20. Show all stores and their cities, 
   --including the total number of orders from each store. Show store name, city, and order count.

   SELECT S.store_name , COUNT(O.order_id)AS ToatalOrders FROM sales.stores S
   JOIN sales.orders  O
   ON S.store_id =  O.store_id 
   GROUP BY S.store_name ; 

 

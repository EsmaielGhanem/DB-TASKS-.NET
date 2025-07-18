/*
1.Write a query that classifies all products into price categories:

Products under $300: "Economy"
Products $300-$999: "Standard"
Products $1000-$2499: "Premium"
Products $2500 and above: "Luxury"
*/

SELECT 
list_price ,   
 CASE 
    WHEN list_price < 300 THEN 'Economy' 
    WHEN list_price between 300 and 999 THEN 'Standard' 
    WHEN list_price between 1000 and 2499 THEN 'Premium' 
    ELSE  'Luxury' 
    END AS prodCategory
 FROM production.products
 ORDER by list_price ;

 /*

2.Create a query that shows order processing information with user-friendly status descriptions:

Status 1: "Order Received"
Status 2: "In Preparation"
Status 3: "Order Cancelled"
Status 4: "Order Delivered"

Also add a priority level:

Orders with status 1 older than 5 days: "URGENT"
Orders with status 2 older than 3 days: "HIGH"
All other orders: "NORMAL"
 */

 SELECT 
 order_status, order_date ,
     CASE 
          WHEN order_status = 1 THEN 'Order Received'
          WHEN order_status = 2 THEN 'In Preparation'
          WHEN order_status = 3 THEN 'Order Cancelled'
          WHEN order_status = 4 THEN 'Order Delivered' 
     END AS [ processing information] , 
     CASE 
          WHEN order_status = 1 and (DATEDIFF(day , order_date , GETDATE()))  > 5 THEN 'URGENT'
          WHEN order_status = 1 and (DATEDIFF(day , order_date , GETDATE()))  > 3 THEN 'URGENT'
          ELSE 'NORMAL'
     END AS [priority level] 
   
   from sales.orders;


   /*
   
   3.Write a query that categorizes staff based on the number of orders they've handled:

0 orders: "New Staff"
1-10 orders: "Junior Staff"
11-25 orders: "Senior Staff"
26+ orders: "Expert Staff"
   */

WITH res AS (

SELECT  staff_id , COUNT(order_id) AS cntOrders  FROM sales.orders GROUP By Staff_id 
)
SELECT staff_id  ,   
  CASE
     WHEN cntOrders = 0  THEN 'New Staff'
     WHEN cntOrders between 1 and 10 THEN 'Junior Staff'
     WHEN  cntOrders between 11 and 25 THEN 'Senior Staff'
     ELSE 'Expert Staff'
   END AS [Staff Category]
FROM res;

/*

4.Create a query that handles missing customer contact information:

Use ISNULL to replace missing phone numbers with "Phone Not Available"
Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")
Show complete customer information
*/
SELECT 
    customer_id,
    first_name,
    last_name,
    ISNULL(phone, 'Phone Not Available') AS phone,
    email,
    COALESCE(phone, email, 'No Contact Method') AS preferred_contact , 
    street , city , state , zip_code


FROM 
    sales.customers;



    /*
    
    
    5.Write a query that safely calculates price per unit in stock:

Use NULLIF to prevent division by zero when quantity is 0
Use ISNULL to show 0 when no stock exists
Include stock status using CASE WHEN
Only show products from store_id = 1

*/
  

  SELECT  p.product_id,
    p.product_name,
    s.store_id,
    s.quantity,
    p.list_price , 
    ISNULL(list_price / NULLIF(S.quantity , 0) , -1) AS pricePerUnit , 
    CASE  
            WHEN S.quantity = 0 THEN 'Not Found' 
            ELSE 'Found' 
    END AS [stock Status]


    
    
    
    FROM  production.stocks  S
  JOIN production.products P
  ON p.product_id = s.product_id
  WHERE store_id = 1  ;
  

  /*
  
  6.Create a query that formats complete addresses safely:

Use COALESCE for each address component
Create a formatted_address field that combines all components
Handle missing ZIP codes gracefully
  */

SELECT 
    customer_id,  first_name, last_name,
    COALESCE(street, '') AS street,
    COALESCE(city, '') AS city,
    COALESCE(state, '') AS state,
    COALESCE(zip_code, '') AS zip_code, 
    COALESCE(street, '') + ' , ' +
    COALESCE(city, '') + ' , ' +
    COALESCE(state, '') + ' ' +
    COALESCE(zip_code, 'No ZIP') AS formatted_address

FROM 
    sales.customers;

     
    /*
    7.Use a CTE to find customers who have spent more than $1,500 total:

Create a CTE that calculates total spending per customer
Join with customer information
Show customer details and spending
Order by total_spent descending
    
    */

    WITH [total spending]   AS(
     SELECT S.customer_id , S.first_name , S.last_name , (OI.list_price * quantity* (1 - discount)) AS [all Spent] FROM  sales.customers S
     JOIN sales.orders  O
     ON  S.customer_id =  O.customer_id
     JOIN sales.order_items OI  
     ON O.order_id = OI.order_id 
     )
     SELECT * FROM [total spending] TS
     WHERE [all Spent] > 1500
     ORDER BY TS.[all Spent] DESC;


     /*
     
     8.Create a multi-CTE query for category analysis:

        CTE 1: Calculate total revenue per category
        CTE 2: Calculate average order value per category
        Main query: Combine both CTEs
        Use CASE to rate performance: >$50000 = "Excellent", >$20000 = "Good", else = "Needs Improvement"
     */



    
    WITH CategoryRevenue AS (
    SELECT 
        pr.category_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM 
        sales.order_items oi
    JOIN 
        production.products pr ON oi.product_id = pr.product_id
    GROUP BY 
        pr.category_id
),
CategoryAvgOrder AS (
    SELECT 
        pr.category_id,
        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
    FROM 
        sales.order_items oi
    JOIN 
        production.products pr ON oi.product_id = pr.product_id
    GROUP BY 
        pr.category_id
)

SELECT * ,
   CASE  
         WHEN cr.total_revenue > 50000 THEN 'Excellent'
         WHEN cr.total_revenue > 20000 THEN 'Good'
         ELSE 'Needs Improvement'
    END AS  performance_rating FROM  CategoryRevenue CR 
   
    
FULL JOIN  CategoryAvgOrder CO
ON CR.category_id = CO.category_id ; 


/*
9.Use CTEs to analyze monthly sales trends:

CTE 1: Calculate monthly sales totals
CTE 2: Add previous month comparison
Show growth percentage

*/
    
    WITH MonthlySales AS (
    SELECT 
        FORMAT(o.order_date, 'yyyy-MM') AS sales_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        FORMAT(o.order_date, 'yyyy-MM')
)
,
MonthlyGrowth AS (
    SELECT 
        sales_month,
        total_sales,
         (SELECT  total_sales FROM MonthlySales MP 
           WHERE (CAST(RIGHT(MM.sales_month, 2)AS INT) - CAST(RIGHT(MP.sales_month, 2)AS INT)  = 1  
             AND
             CAST(LEFT(MP.sales_month, 4)AS INT) = CAST(LEFT(MM.sales_month, 4)AS INT)   
           )
          ) AS prev_month_sales

     FROM 
        MonthlySales MM
)

SELECT 
    sales_month,
    total_sales,
    prev_month_sales,
    CASE 
        WHEN prev_month_sales IS NULL OR prev_month_sales = 0 THEN NULL
        ELSE (((total_sales - prev_month_sales) / prev_month_sales) * 100)
    END AS growth_percentage
FROM 
    MonthlyGrowth
ORDER BY 
    sales_month;

 

 /*
 10.Create a query that ranks products within each category:

Use ROW_NUMBER() to rank by price (highest first)
Use RANK() to handle ties
Use DENSE_RANK() for continuous ranking
Only show top 3 products per category
 
 */

 WITH RankedProducts AS (
    SELECT 
        p.product_id, p.product_name   ,  p.category_id   , p.list_price,

      
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS row_num,
        RANK()       OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS rank_num,
        DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS dense_rank_num
    FROM 
        production.products p
)

SELECT 
    product_id, product_name ,  category_id,
    list_price,
    row_num,
    rank_num,
    dense_rank_num
FROM 
    RankedProducts
WHERE 
    row_num <= 3
ORDER BY 
    category_id, row_num;

    /*
    
    11.Rank customers by their total spending:

Calculate total spending per customer
Use RANK() for customer ranking
Use NTILE(5) to divide into 5 spending groups
Use CASE for tiers: 1="VIP", 2="Gold", 3="Silver", 4="Bronze", 5="Standard"
    
    */

    WITH CustomerSpending AS (
    SELECT 
        O.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        o.customer_id
),
RankedCustomers AS (
    SELECT 
        cs.customer_id,
        cs.total_spent,
        RANK() OVER (ORDER BY cs.total_spent DESC) AS spending_rank,
        NTILE(5) OVER (ORDER BY cs.total_spent DESC) AS spending_group
    FROM 
        CustomerSpending cs
)

SELECT 
    rc.customer_id,
    c.first_name,
    c.last_name,
    rc.total_spent,
    rc.spending_rank,
    rc.spending_group,
    
    CASE 
        WHEN rc.spending_group = 1 THEN 'VIP'
        WHEN rc.spending_group = 2 THEN 'Gold'
        WHEN rc.spending_group = 3 THEN 'Silver'
        WHEN rc.spending_group = 4 THEN 'Bronze'
        WHEN rc.spending_group = 5 THEN 'Standard'
    END AS customer_tier

FROM 
    RankedCustomers rc
JOIN 
    sales.customers c ON rc.customer_id = c.customer_id
ORDER BY 
    rc.total_spent DESC;

  

 /*
 
 12.Create a comprehensive store performance ranking:

Rank stores by total revenue
Rank stores by number of orders
Use PERCENT_RANK() to show percentile performance
 */
 WITH StorePerformance AS (
    SELECT 
        s.store_id,
        s.store_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM 
        sales.stores s
     JOIN 
        sales.orders o ON s.store_id = o.store_id
     JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        s.store_id, s.store_name
),
RankedStores AS (
    SELECT 
        store_id,
        store_name,
        total_orders,
        total_revenue,
        
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        

        RANK() OVER (ORDER BY total_orders DESC) AS order_count_rank,
       
        PERCENT_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_percentile

    FROM 
        StorePerformance
)

SELECT 
    store_id,
    store_name,
    total_orders,
    total_revenue,
    revenue_rank,
    order_count_rank,
    ROUND(revenue_percentile * 100, 2) AS revenue_percentile
FROM 
    RankedStores
ORDER BY 
    revenue_rank;


    /*
    
    13.Create a PIVOT table showing product counts by category and brand:

Rows: Categories
Columns: Top 4 brands (Electra, Haro, Trek, Surly)
Values: Count of products
    
    */
    -- Pivot base query: Get category, brand, and product count
WITH ProductCounts AS (
    SELECT 
        c.category_name,
        b.brand_name,
        COUNT(p.product_id) AS product_count
    FROM 
        production.products p
    JOIN 
        production.categories c ON p.category_id = c.category_id
    JOIN 
        production.brands b ON p.brand_id = b.brand_id
    WHERE 
        b.brand_name IN ('Electra', 'Haro', 'Trek', 'Surly')
    GROUP BY 
        c.category_name, b.brand_name
)

SELECT 
    category_name,
    ISNULL([Electra], 0) AS Electra,
    ISNULL([Haro], 0) AS Haro,
    ISNULL([Trek], 0) AS Trek,
    ISNULL([Surly], 0) AS Surly
FROM 
    ProductCounts
PIVOT (
    SUM(product_count) 
    FOR brand_name IN ([Electra], [Haro], [Trek], [Surly])
) AS PivotTable;


/*
14.Create a PIVOT showing monthly sales revenue by store:

Rows: Store names
Columns: Months (Jan through Dec)
Values: Total revenue
Add a total column
*/

WITH MonthlyStoreRevenue AS (
    SELECT 
        s.store_name,
        DATENAME(MONTH, o.order_date) AS sales_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    JOIN 
        sales.stores s ON o.store_id = s.store_id
    GROUP BY 
        s.store_name, DATENAME(MONTH, o.order_date), MONTH(o.order_date)
)

SELECT 
    store_name,
    ISNULL([January], 0) AS Jan,
    ISNULL([February], 0) AS Feb,
    ISNULL([March], 0) AS Mar,
    ISNULL([April], 0) AS Apr,
    ISNULL([May], 0) AS May,
    ISNULL([June], 0) AS Jun,
    ISNULL([July], 0) AS Jul,
    ISNULL([August], 0) AS Aug,
    ISNULL([September], 0) AS Sep,
    ISNULL([October], 0) AS Oct,
    ISNULL([November], 0) AS Nov,
    ISNULL([December], 0) AS Dec,

    ISNULL([January], 0) + ISNULL([February], 0) + ISNULL([March], 0) +
    ISNULL([April], 0) + ISNULL([May], 0) + ISNULL([June], 0) +
    ISNULL([July], 0) + ISNULL([August], 0) + ISNULL([September], 0) +
    ISNULL([October], 0) + ISNULL([November], 0) + ISNULL([December], 0) 
    AS Total_Revenue

FROM 
    MonthlyStoreRevenue
PIVOT (
    SUM(revenue)
    FOR sales_month IN (
        [January], [February], [March], [April], [May], [June],
        [July], [August], [September], [October], [November], [December]
    )
) AS PivotResult
ORDER BY 
    Total_Revenue DESC;




    /*
    
    15.PIVOT order statuses across stores:

    Rows: Store names
    Columns: Order statuses (Pending, Processing, Completed, Rejected)
    Values: Count of orders
    
    */


WITH StoreOrderStatus AS (
    SELECT 
        s.store_name,
        CASE 
            WHEN o.order_status = 1 THEN 'Pending'
            WHEN o.order_status = 2 THEN 'Processing'
            WHEN o.order_status = 3 THEN 'Rejected'
            WHEN o.order_status = 4 THEN 'Completed'
            ELSE 'Unknown'
        END AS status_label
    FROM 
        sales.orders o
    JOIN 
        sales.stores s ON o.store_id = s.store_id
)

SELECT 
    store_name,
    ISNULL([Pending], 0) AS Pending,
    ISNULL([Processing], 0) AS Processing,
    ISNULL([Completed], 0) AS Completed,
    ISNULL([Rejected], 0) AS Rejected
FROM 
    StoreOrderStatus
PIVOT (
    COUNT(status_label)
    FOR status_label IN ([Pending], [Processing], [Completed], [Rejected])
) AS PivotTable
ORDER BY 
    store_name;


    /*
    
    16.Create a PIVOT comparing sales across years:

Rows: Brand names
Columns: Years (2016, 2017, 2018)
Values: Total revenue
Include percentage growth calculations
    */

WITH BrandYearRevenue AS (
    SELECT 
        b.brand_name,
        YEAR(o.order_date) AS sales_year,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM 
        sales.orders o
    JOIN 
        sales.order_items oi ON o.order_id = oi.order_id
    JOIN 
        production.products p ON oi.product_id = p.product_id
    JOIN 
        production.brands b ON p.brand_id = b.brand_id
    WHERE 
        YEAR(o.order_date) IN (2016, 2017, 2018)
    GROUP BY 
        b.brand_name, YEAR(o.order_date)
)

SELECT 
    brand_name,
    ISNULL([2016], 0) AS Revenue_2016,
    ISNULL([2017], 0) AS Revenue_2017,
    ISNULL([2018], 0) AS Revenue_2018,

    CASE 
        WHEN ISNULL([2016], 0) = 0 THEN NULL
        ELSE ROUND((([2017] - [2016]) * 100.0) / [2016], 2)
    END AS Growth_2016_2017_Percent,

    
    CASE 
        WHEN ISNULL([2017], 0) = 0 THEN NULL
        ELSE ROUND((([2018] - [2017]) * 100.0) / [2017], 2)
    END AS Growth_2017_2018_Percent

FROM 
    BrandYearRevenue
PIVOT (
    SUM(total_revenue)
    FOR sales_year IN ([2016], [2017], [2018])
) AS PivotTable
ORDER BY 
    brand_name;
   


   /*
   
   17.Use UNION to combine different product availability statuses:

Query 1: In-stock products (quantity > 0)
Query 2: Out-of-stock products (quantity = 0 or NULL)
Query 3: Discontinued products (not in stocks table)
*/

SELECT 
    p.product_id,
    p.product_name,
    'In Stock' AS availability_status
FROM 
    production.products p
JOIN 
    production.stocks s ON p.product_id = s.product_id
WHERE 
    s.quantity > 0

UNION
SELECT 
    p.product_id,
    p.product_name,
    'Out of Stock' AS availability_status
FROM 
    production.products p
JOIN 
    production.stocks s ON p.product_id = s.product_id
WHERE 
    ISNULL(s.quantity, 0) = 0
UNION
SELECT 
    p.product_id,
    p.product_name,
    'Discontinued' AS availability_status
FROM 
    production.products p
LEFT JOIN 
    production.stocks s ON p.product_id = s.product_id
WHERE 
    s.product_id IS NULL;



    /*
    18.Use INTERSECT to find loyal customers:

Find customers who bought in both 2017 AND 2018
Show their purchase patterns

*/

WITH LoyalCustomers AS (
    SELECT DISTINCT customer_id
    FROM sales.orders
    WHERE YEAR(order_date) = 2017

    INTERSECT

    SELECT DISTINCT customer_id
    FROM sales.orders
    WHERE YEAR(order_date) = 2018
)

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(o.order_date) AS purchase_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
FROM 
    LoyalCustomers lc
JOIN 
    sales.customers c ON lc.customer_id = c.customer_id
JOIN 
    sales.orders o ON c.customer_id = o.customer_id
JOIN 
    sales.order_items oi ON o.order_id = oi.order_id
WHERE 
    YEAR(o.order_date) IN (2017, 2018)
GROUP BY 
    c.customer_id, c.first_name, c.last_name, YEAR(o.order_date)
ORDER BY 
    c.customer_id, purchase_year;


    /*
    19.Use multiple set operators to analyze product distribution:

INTERSECT: Products available in all 3 stores
EXCEPT: Products available in store 1 but not in store 2
UNION: Combine above results with different labels

*/

SELECT 
    p.product_id,
    p.product_name,
    'Available in All Stores' AS status
FROM 
    production.products p
WHERE 
    p.product_id IN (
        SELECT product_id FROM production.stocks WHERE store_id = 1
        INTERSECT
        SELECT product_id FROM production.stocks WHERE store_id = 2
        INTERSECT
        SELECT product_id FROM production.stocks WHERE store_id = 3
    )

UNION
SELECT 
    p.product_id,
    p.product_name,
    'Only in Store 1 (Not in Store 2)' AS status
FROM 
    production.products p
WHERE 
    p.product_id IN (
        SELECT product_id FROM production.stocks WHERE store_id = 1
        EXCEPT
        SELECT product_id FROM production.stocks WHERE store_id = 2
    );

    /*
    20.Complex set operations for customer retention:

    Find customers who bought in 2016 but not in 2017 (lost customers)
    Find customers who bought in 2017 but not in 2016 (new customers)
    Find customers who bought in both years (retained customers)
    Use UNION ALL to combine all three groups

    
    */
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    'Lost' AS status
FROM 
    sales.customers c
WHERE 
    c.customer_id IN (
        SELECT DISTINCT customer_id FROM sales.orders WHERE YEAR(order_date) = 2016
        EXCEPT
        SELECT DISTINCT customer_id FROM sales.orders WHERE YEAR(order_date) = 2017
    )

UNION ALL

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    'New' AS status
FROM 
    sales.customers c
WHERE 
    c.customer_id IN (
        SELECT DISTINCT customer_id FROM sales.orders WHERE YEAR(order_date) = 2017
        EXCEPT
        SELECT DISTINCT customer_id FROM sales.orders WHERE YEAR(order_date) = 2016
    )

UNION ALL

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    'Retained' AS status
FROM 
    sales.customers c
WHERE 
    c.customer_id IN (
        SELECT DISTINCT customer_id FROM sales.orders WHERE YEAR(order_date) = 2016
        INTERSECT
        SELECT DISTINCT customer_id FROM sales.orders WHERE YEAR(order_date) = 2017
    );


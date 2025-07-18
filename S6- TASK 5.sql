/*
1. Customer Spending Analysis#
Write a query that uses variables to find the total amount spent by customer ID 1. Display a message 
showing whether they are a VIP customer (spent > $5000) or regular customer.

*/
DECLARE @customer_id INT = 1;
DECLARE @total_spent DECIMAL(10, 2);
DECLARE @status VARCHAR(20);

SELECT @total_spent = SUM(oi.quantity * (oi.list_price * (1 - oi.discount)))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id = @customer_id;

IF @total_spent > 5000
    SET @status = 'VIP Customer';
ELSE
    SET @status = 'Regular Customer';

SELECT 
    @customer_id AS customer_id,
    @total_spent AS total_spent,
    @status AS customer_status;



    /*
    
    2. Product Price Threshold Report#
Create a query using variables to count how many products cost more than $1500. 
Store the threshold price in a variable and display both the threshold and count in a formatted message.
   
    */

DECLARE @price_threshold DECIMAL(10, 2) = 1500;
DECLARE @product_count INT;

SELECT @product_count = COUNT(*)
FROM production.products
WHERE list_price > @price_threshold;

SELECT 
    'Number of products with price greater than $' 
    + CAST(@price_threshold AS VARCHAR) 
    + ' is ' 
    + CAST(@product_count AS VARCHAR) AS ReportMessage;

    PRINT  'Number of products with price greater than $' 
    + CAST(@price_threshold AS VARCHAR) 
    + ' is ' 
    + CAST(@product_count AS VARCHAR) ;
  /* 

3. Staff Performance Calculator#
Write a query that calculates the total sales for staff member ID 2 in the year 2017.
Use variables to store the staff ID, year, and calculated total. Display the results with appropriate labels.
 
 */

 DECLARE @staff_id INT = 2;
DECLARE @year INT = 2017;
DECLARE @total_sales DECIMAL(18, 2);

SELECT @total_sales = SUM(oi.quantity * oi.list_price * (1 - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.staff_id = @staff_id
  AND YEAR(o.order_date) = @year;

SELECT 
    @staff_id AS StaffID,
    @year AS SalesYear,
    @total_sales AS TotalSales;

    
    /*
    4. Global Variables Information#
Create a query that displays the current server name, 
SQL Server version, and the number of rows affected by the last statement. Use appropriate global variables.
    */

SELECT 
    @@SERVERNAME AS ServerName,
    @@VERSION AS SqlServerVersion,
    @@ROWCOUNT AS RowsAffected;

/* 
5.Write a query that checks the inventory level for product ID 1 in store ID 1.
Use IF statements to display different messages based on stock levels:#
If quantity > 20: Well stocked
If quantity 10-20: Moderate stock
If quantity < 10: Low stock - reorder needed

*/

DECLARE @store_id INT = 1;
DECLARE @product_id INT = 1;
DECLARE @quantity INT;
DECLARE @status_message VARCHAR(100);

SELECT @quantity = quantity
FROM production.stocks
WHERE store_id = @store_id AND product_id = @product_id;

IF @quantity > 20
    SET @status_message = 'Well stocked';
ELSE IF @quantity BETWEEN 10 AND 20
    SET @status_message = 'Moderate stock';
ELSE IF @quantity < 10
    SET @status_message = 'Low stock - reorder needed';
ELSE
    SET @status_message = 'Product not found or quantity is NULL';

SELECT 
    @store_id AS StoreID,
    @product_id AS ProductID,
    @quantity AS QuantityInStock,
    @status_message AS StockStatus;



    /*
    6.Create a WHILE loop that updates low-stock items (quantity < 5) in batches of 3 products at a time.
    Add 10 units to each product and display progress messages after each batch.
    */

    DECLARE @batch_size INT = 3;
DECLARE @updated_count INT = 1;

WHILE @updated_count > 0
BEGIN
    
    WITH TopLowStock AS (
        SELECT TOP (@batch_size) store_id, product_id
        FROM production.stocks
        WHERE quantity < 5
        ORDER BY quantity ASC
    )
    UPDATE s
    SET quantity = quantity + 10
    FROM production.stocks s
    JOIN TopLowStock t
      ON s.store_id = t.store_id AND s.product_id = t.product_id;

    SET @updated_count = @@ROWCOUNT;

    PRINT 'Updated ' + CAST(@updated_count AS VARCHAR) + ' low-stock products in this batch';
END



/*

7. Product Price Categorization#
Write a query that categorizes all products using CASE WHEN based on their list price:

Under $300: Budget
$300-$800: Mid-Range
$801-$2000: Premium
Over $2000: Luxury
*/

SELECT 
    product_id,
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Budget'
        WHEN list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
        WHEN list_price BETWEEN 801 AND 2000 THEN 'Premium'
        WHEN list_price > 2000 THEN 'Luxury'
        ELSE 'Uncategorized'
    END AS PriceCategory
FROM production.products;

/*
8. Customer Order Validation#
Create a query that checks if customer ID 5 exists in the database. If they exist, show their order count.
If not, display an appropriate message.*/
DECLARE @customer_id INT = 5;
DECLARE @order_count INT;

IF EXISTS (
    SELECT 1 
    FROM sales.customers 
    WHERE customer_id = @customer_id
)
BEGIN
    SELECT @order_count = COUNT(*)
    FROM sales.orders
    WHERE customer_id = @customer_id;

    SELECT 
        @customer_id AS CustomerID,
        @order_count AS OrderCount;
END
ELSE
BEGIN
    SELECT 
        'Customer ID ' + CAST(@customer_id AS VARCHAR) + ' does not exist.' AS Message;
END


/*

9. Shipping Cost Calculator Function#
Create a scalar function named CalculateShipping that takes an order total as input and returns shipping cost:

Orders over $100: Free shipping ($0)
Orders $50-$99: Reduced shipping ($5.99)
Orders under $50: Standard shipping ($12.99)
*/

CREATE FUNCTION dbo.CalculateShipping (@order_total DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @shipping_cost DECIMAL(10, 2);

    SET @shipping_cost = 
        CASE 
            WHEN @order_total > 100 THEN 0.00
            WHEN @order_total BETWEEN 50 AND 99.99 THEN 5.99
            ELSE 12.99
        END;

    RETURN @shipping_cost;
END;


/*
10. Product Category Function#
Create an inline table-valued function named GetProductsByPriceRange that accepts minimum and maximum price parameters
and returns all products within that price range with their brand and category information.
*/
CREATE FUNCTION dbo.GetProductsByPriceRange
(
    @min_price DECIMAL(10, 2),
    @max_price DECIMAL(10, 2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.product_id,
        p.product_name,
        p.list_price,
        b.brand_name,
        c.category_name
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE p.list_price BETWEEN @min_price AND @max_price
);

/*

11. Customer Sales Summary Function#
Create a multi-statement function named GetCustomerYearlySummary that 
takes a customer ID and returns a table with yearly sales data including total orders, 
total spent, and average order value for each year

*/

CREATE FUNCTION dbo.GetCustomerYearlySummary
(
    @customer_id INT
)
RETURNS @summary TABLE
(
    SalesYear INT,
    TotalOrders INT,
    TotalSpent DECIMAL(18, 2),
    AverageOrderValue DECIMAL(18, 2)
)
AS
BEGIN
    INSERT INTO @summary
    SELECT 
        YEAR(o.order_date) AS SalesYear,
        COUNT(DISTINCT o.order_id) AS TotalOrders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS TotalSpent,
        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS AverageOrderValue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
    GROUP BY YEAR(o.order_date);

    RETURN;
END;

/*
12. Discount Calculation Function#
Write a scalar function named CalculateBulkDiscount that determines discount percentage based on quantity:

1-2 items: 0% discount
3-5 items: 5% discount
6-9 items: 10% discount
10+ items: 15% discount

*/
CREATE FUNCTION dbo.CalculateBulkDiscount (@quantity INT)
RETURNS DECIMAL(4, 2)
AS
BEGIN
    DECLARE @discount DECIMAL(4, 2);

    SET @discount = 
        CASE 
            WHEN @quantity BETWEEN 1 AND 2 THEN 0.00
            WHEN @quantity BETWEEN 3 AND 5 THEN 0.05
            WHEN @quantity BETWEEN 6 AND 9 THEN 0.10
            WHEN @quantity >= 10 THEN 0.15
            ELSE 0.00 
        END;

    RETURN @discount;
END;


/*
13. Customer Order History Procedure#
Create a stored procedure named sp_GetCustomerOrderHistory that accepts a customer ID and optional start/end dates.
Return the customer's order history with order totals calculated.
*/

CREATE PROCEDURE sp_GetCustomerOrderHistory
    @customer_id INT,
    @start_date DATE = NULL,
    @end_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        o.order_id,
        o.order_date,
        o.required_date,
        o.shipped_date,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS TotalAmount
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
      AND (@start_date IS NULL OR o.order_date >= @start_date)
      AND (@end_date IS NULL OR o.order_date <= @end_date)
    GROUP BY 
        o.order_id,
        o.order_date,
        o.required_date,
        o.shipped_date
    ORDER BY o.order_date;
END;


/*

14. Inventory Restock Procedure#
Write a stored procedure named sp_RestockProduct with input parameters for store ID, product ID, and restock quantity. 
Include output parameters for old quantity, new quantity, and success status.
*/
CREATE PROCEDURE sp_RestockProduct
    @store_id INT,
    @product_id INT,
    @restock_qty INT,
    @old_qty INT OUTPUT,
    @new_qty INT OUTPUT,
    @success BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

   
    SET @success = 0;
    SET @old_qty = NULL;
    SET @new_qty = NULL;

    IF EXISTS (
        SELECT 1
        FROM production.stocks
        WHERE store_id = @store_id AND product_id = @product_id
    )
    BEGIN
        SELECT @old_qty = quantity
        FROM production.stocks
        WHERE store_id = @store_id AND product_id = @product_id;

        UPDATE production.stocks
        SET quantity = quantity + @restock_qty
        WHERE store_id = @store_id AND product_id = @product_id;

        SELECT @new_qty = quantity
        FROM production.stocks
        WHERE store_id = @store_id AND product_id = @product_id;

        SET @success = 1;
    END
END;


/*

15. Order Processing Procedure#
Create a stored procedure named sp_ProcessNewOrder that handles complete order creation with proper transaction control and error handling. 
Include parameters for customer ID, product ID, quantity, and store ID.
*/
CREATE PROCEDURE sp_ProcessNewOrder
    @customer_id INT,
    @product_id INT,
    @quantity INT,
    @store_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @order_id INT;
    DECLARE @staff_id INT;
    DECLARE @item_price DECIMAL(10,2);
    DECLARE @discount DECIMAL(4,2) = 0; 
    DECLARE @item_id INT = 1;           
    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT TOP 1 @staff_id = staff_id
        FROM sales.staffs
        WHERE store_id = @store_id;

        IF @staff_id IS NULL
        BEGIN
            RAISERROR('No staff found for the given store.', 16, 1);
        END

        SELECT @item_price = list_price
        FROM production.products
        WHERE product_id = @product_id;

        IF @item_price IS NULL
        BEGIN
            RAISERROR('Invalid product ID.', 16, 1);
        END

        IF NOT EXISTS (
            SELECT 1 FROM production.stocks
            WHERE store_id = @store_id AND product_id = @product_id AND quantity >= @quantity
        )
        BEGIN
            RAISERROR('Insufficient stock.', 16, 1);
        END

        INSERT INTO sales.orders (
            customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id
        )
        VALUES (
            @customer_id, 1, GETDATE(), GETDATE(), NULL, @store_id, @staff_id
        );

        SET @order_id = SCOPE_IDENTITY();

        INSERT INTO sales.order_items (
            order_id, item_id, product_id, quantity, list_price, discount
        )
        VALUES (
            @order_id, @item_id, @product_id, @quantity, @item_price, @discount
        );

        UPDATE production.stocks
        SET quantity = quantity - @quantity
        WHERE store_id = @store_id AND product_id = @product_id;

        COMMIT TRANSACTION;

        PRINT 'Order processed successfully. Order ID = ' + CAST(@order_id AS VARCHAR);
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Order failed: ' + @ErrorMessage;
    END CATCH
END;



/*

16. Dynamic Product Search Procedure#
Write a stored procedure named sp_SearchProducts that builds dynamic SQL based on optional parameters
: product name search term, category ID, minimum price, maximum price, and sort column.
*/
CREATE PROCEDURE sp_SearchProducts
    @product_name NVARCHAR(255) = NULL,
    @category_id INT = NULL,
    @min_price DECIMAL(10, 2) = NULL,
    @max_price DECIMAL(10, 2) = NULL,
    @sort_column NVARCHAR(50) = 'product_name'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @params NVARCHAR(MAX);
    DECLARE @search_name NVARCHAR(255);

   
    IF @product_name IS NOT NULL
        SET @search_name = '%' + @product_name + '%';

   
    SET @sql = '
    SELECT 
        p.product_id,
        p.product_name,
        p.list_price,
        b.brand_name,
        c.category_name
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE 1 = 1';

    
    IF @product_name IS NOT NULL
        SET @sql += ' AND p.product_name LIKE @search_name';

    IF @category_id IS NOT NULL
        SET @sql += ' AND p.category_id = @category_id';

    IF @min_price IS NOT NULL
        SET @sql += ' AND p.list_price >= @min_price';

    IF @max_price IS NOT NULL
        SET @sql += ' AND p.list_price <= @max_price';

   
    IF @sort_column IS NOT NULL
        SET @sql += ' ORDER BY ' + QUOTENAME(@sort_column);

    
    SET @params = '
        @search_name NVARCHAR(255),
        @category_id INT,
        @min_price DECIMAL(10,2),
        @max_price DECIMAL(10,2)';

    
    EXEC sp_executesql 
        @sql,
        @params,
        @search_name = @search_name,
        @category_id = @category_id,
        @min_price = @min_price,
        @max_price = @max_price;
END;


/*

17. Staff Bonus Calculation System#
Create a complete solution that calculates quarterly bonuses for all staff members. 
Use variables to store date ranges and bonus rates. 
Apply different bonus percentages based on sales performance tiers.
*/

DECLARE 
    @start_date DATE = '2017-01-01',  
    @end_date DATE = '2017-03-31';    

DECLARE 
    @bonus_high DECIMAL(4,2) = 0.10,   
    @bonus_mid_high DECIMAL(4,2) = 0.07,
    @bonus_mid DECIMAL(4,2) = 0.05,    
    @bonus_low DECIMAL(4,2) = 0.02;    

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,

    CASE 
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 50000 THEN 
            ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_high, 2)
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 25000 THEN 
            ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_mid_high, 2)
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 THEN 
            ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_mid, 2)
        ELSE 
            ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_low, 2)
    END AS bonus_amount

FROM sales.staffs s
JOIN sales.orders o ON o.staff_id = s.staff_id
JOIN sales.order_items oi ON oi.order_id = o.order_id
WHERE o.order_date BETWEEN @start_date AND @end_date
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_sales DESC;


/*
18. Smart Inventory Management#
Write a complex query with nested IF statements that manages inventory restocking. 
Check current stock levels and apply different reorder quantities based on product categories and current stock levels.

*/
SELECT 
    s.store_id,
    s.product_id,
    p.product_name,
    c.category_name,
    s.quantity AS current_quantity,

    CASE 
        WHEN s.quantity >= 50 THEN 0  

        WHEN s.quantity < 10 THEN
            CASE 
                WHEN c.category_name = 'Electronics' THEN 50
                WHEN c.category_name = 'Accessories' THEN 100
                ELSE 30
            END

        WHEN s.quantity BETWEEN 10 AND 49 THEN
            CASE 
                WHEN c.category_name = 'Electronics' THEN 20
                WHEN c.category_name = 'Accessories' THEN 40
                ELSE 15
            END

        ELSE 0 
    END AS reorder_quantity

FROM production.stocks s
JOIN production.products p ON s.product_id = p.product_id
JOIN production.categories c ON p.category_id = c.category_id
ORDER BY s.store_id, reorder_quantity DESC;


/*
19. Customer Loyalty Tier Assignment#
Create a comprehensive solution that assigns loyalty tiers to customers based on their total spending.
Handle customers with no orders appropriately and use proper NULL checking.

*/

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_spent,

    CASE 
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) IS NULL OR SUM(oi.quantity * oi.list_price * (1 - oi.discount)) = 0 THEN 'New'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 THEN 'Platinum'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 5000 THEN 'Gold'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier

FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;


/*

20. Product Lifecycle Management#
Write a stored procedure that handles product discontinuation including checking for pending orders,
optional product replacement in existing orders, clearing inventory, and providing detailed status messages.


*/


-- ??????
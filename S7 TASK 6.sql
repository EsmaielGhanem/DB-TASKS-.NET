/*
1.Create a non-clustered index on the email column in the sales.customers table 
to improve search performance when looking up customers by email.

*/
--select *  from sales.customers ;
create nonClustered Index IDX_customerEmail  on sales.customers(email)


/*
2.Create a composite index on the
production.products table that includes category_id and brand_id columns to
optimize searches that filter by both category and brand.
*/

--select * from production.products ;
create nonClustered index IDX_COMP on production.products(category_ID , brand_ID);

/*
3.Create an index on
sales.orders table for the
order_date column and include customer_id, store_id, and order_status 
as included columns to improve reporting queries.
*/
--select * from sales.orders

create nonClustered index IDX_SalesTable 
on sales.orders(order_date) 
INCLUDE (customer_id, store_id, order_status) ;



/*
4.Create a trigger that automatically inserts a welcome record 
into a customer_log table whenever a new customer is added to sales.customers. 
(First create the log table, then the trigger)
*/

create table customer_log (
log_ID int primary key identity(1 , 1) , 
customer_ID int foreign key references sales.customers(customer_id) , 
log_message varchar(255) , 
log_dae dateTime default GETDATE()
);


create trigger tr_welcomeCustomer 
On sales.customers
after insert
As 
begin
	insert into customer_log (customer_ID , log_message) 
	  select i.customer_ID ,  'Welcome, customer ID ' + cast(i.customer_ID AS varChar)  + 
	'has been added.' 
	from inserted i 

end ;

/*
select * from sales.customers where customer_id 

insert into sales.customers(first_name , last_name , email )
values ('mmmmmm' , 'kkkk', 'b.worthington@privateequity.com' )
*/


/*
5.Create a trigger on production.products 
that logs any changes to the list_price column into a price_history table,
storing the old price, new price, and change date.
*/

create table production.price_history (
ID int primary key identity(1 , 1) ,
product_ID int foreign key references production.products(product_Id) ,
Old_Price money , 
new_price money , 
modyfiedDate dateTime default getDate() 

)

create trigger tr_changePrice
on production.products 
after update 
as 
insert into production.price_history(product_ID , old_price , new_price)
select i.product_id , (select d.list_price  from deleted d) , i.list_price
from inserted i ;
/*
select * from production.products
 update  production.products 
 set list_price = 395 where product_id = 1
 */


 /*
 6.Create an INSTEAD OF DELETE trigger on production.categories 
 that prevents deletion of categories that have associated products. Display an appropriate error message.
 */

 select * from production.categories C
 join production.products  P
 ON  C.category_id = P.category_id ;


 create trigger tr_categoryDeletion 
 on  production.categories 
 instead of delete 
 AS 
 begin
		 IF EXISTS (
			select 1  from deleted d
			 join production.products  P
			 ON  d.category_id = P.category_id 
		 )
			 BEGIN
					select 'you can not delete this '

			 end
		ELSE 
			begin
				delete from production.categories  
				where category_id IN (select category_id from deleted )
			end 	

 end ;

 /*
 7.Create a trigger on sales.order_items 
 that automatically reduces the quantity in production.stocks 
 when a new order item is inserted.

 */

 /*
 select * from sales.order_items
 select * from production.stocks 
 */
 create trigger tr_reduceQuantity 
 On sales.order_items 
 after insert 
 as 
 begin
	 update ST 
	 set st.quantity = st.quantity - i.quantity from inserted i
	 join production.stocks St 
	 ON i.product_id = st.product_id   
	 

 end ;

 /*
 8.Create a trigger that logs all new orders into an order_audit table, 
 capturing order details and the date/time when the record was created.

 */
 /*
 select * from sales.orders ;
 select * from sales.order_audit ;
 */
 create trigger tr_newOreders 
 on sales.orders 
 after insert 
 as 
 begin
insert into sales.order_audit(order_id, customer_id, order_date ,[audit_timestamp] )
select i.order_id , i.customer_id , i.order_date , GETDATE()  from inserted i
 end ;
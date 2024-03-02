/*Lab | SQL Iterations*/

/*In this lab, we will continue working on the Sakila database of movie rentals.

Instructions
Write queries to answer the following questions:*/

-- 1. Write a query to find what is the total business done by each store.
select s.store_id, sum(p.amount) total_sales
from sakila.store s
join sakila.staff st
on s.store_id = st.store_id
join sakila.payment p
on st.staff_id = p.staff_id
group by s.store_id;

-- 2. Convert the previous query into a stored procedure.
drop procedure if exists return_total_sales_by_store;

DELIMITER //
create procedure return_total_sales_by_store()
begin

  select s.store_id, sum(p.amount) total_sales
  from sakila.store s
  join sakila.staff st
  on s.store_id = st.store_id
  join sakila.payment p
  on st.staff_id = p.staff_id
  group by s.store_id;
  
end //
DELIMITER ;

-- 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
drop procedure if exists return_total_sales_by_store;

DELIMITER //
create procedure return_total_sales_by_store(in store_param int)
begin

  select s.store_id, sum(p.amount) total_sales
  from sakila.store s
  join sakila.staff st
  on s.store_id = st.store_id
  join sakila.payment p
  on st.staff_id = p.staff_id
  where s.store_id = store_param
  group by s.store_id;
  
end //
DELIMITER ;

call return_total_sales_by_store(1);
call return_total_sales_by_store(2);

/* 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
Call the stored procedure and print the results.*/
drop procedure if exists return_total_sales_by_store;

DELIMITER //
create procedure return_total_sales_by_store(in store_param int, out sales_param float)
begin

	declare total_sales_value float default 0.0;

	select total_sales into total_sales_value
	from(
			select s.store_id, sum(p.amount) total_sales
			from sakila.store s
			join sakila.staff st
			on s.store_id = st.store_id
			join sakila.payment p
			on st.staff_id = p.staff_id
			where s.store_id = store_param
			group by s.store_id
	  ) sub1;
	  
	  select total_sales_value into sales_param;
  
end //
DELIMITER ;

call return_total_sales_by_store(1, @sales);
select @sales;

call return_total_sales_by_store(2, @sales);
select @sales;

/* 5. In the previous query, add another variable flag. 
If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.*/
drop procedure if exists return_total_sales_by_store;

DELIMITER //
create procedure return_total_sales_by_store(in store_param int, out sales_param float, out flag_param varchar(20))
begin

	declare total_sales_value float default 0.0;
    
    declare flag varchar(20) default "";

	select total_sales into total_sales_value
	from(
			select s.store_id, sum(p.amount) total_sales
			from sakila.store s
			join sakila.staff st
			on s.store_id = st.store_id
			join sakila.payment p
			on st.staff_id = p.staff_id
			where s.store_id = store_param
			group by s.store_id
	  ) sub1;
	  
	  select total_sales_value into sales_param;
      
      case
		when total_sales_value > 30000 then
			set flag = 'green_flag';
		else
			set flag = 'red_flag';
	  end case;
      
      select flag into flag_param;
  
end //
DELIMITER ;

call return_total_sales_by_store(1, @sales, @flag);
select @sales, @flag;

call return_total_sales_by_store(2, @sales, @flag);
select @sales, @flag;

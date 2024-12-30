CREATE DATABASE assigment;
USE assigment;

-- 1) Which bike is most expensive? What could be the motive behind  pricing this bike at the high price?
select product_id , max(list_price) as high from products 
group by product_id 
order by high desc
limit 1;

-- 2) How many total customers does BikeStore have? Would you consider  people with order status 3 as customers substantiate your answer? 
select count(customer_id) from orders where order_status=3;

-- 3) How many stores does BikeStore have? 
select count(store_id) from stores ;

-- 4) What is the total price spent per order? 
SELECT order_id, SUM(list_price * quantity * (1 - discount)) AS total_price FROM order_items
GROUP BY order_id;

-- 5) What’s the sales/revenue per store?
SELECT  ord.store_id, SUM(os.list_price * os.quantity * (1 - os.discount)) AS sales_revenue FROM order_items AS os
JOIN orders AS ord ON os.order_id = ord.order_id
GROUP BY 
    ord.store_id;

-- 6) Which category is most sold?
select c.category_name, sum(oi.quantity) as total_sold from order_items oi 
join products p on oi.product_id = p.product_id 
join categories c on p.category_id = c.category_id 
group by c.category_name order by total_sold desc limit 1;


-- 7) Which category rejected more orders?
select c.category_name, count(o.order_id) as rejected_orders from orders o 
join order_items oi on o.order_id = oi.order_id 
join products p on oi.product_id = p.product_id 
join categories c on p.category_id = c.category_id 
where o.order_status = 'rejected' 
group by c.category_name order by rejected_orders desc limit 1;

 -- 8) Which bike is the least sold?
select p.product_name, sum(oi.quantity) as total_sold from order_items oi 
join products p on oi.product_id = p.product_id 
group by p.product_name order by total_sold asc limit 1;

-- 9) Full name of customer with ID 259?
select concat(first_name, ' ', last_name) as full_name 
from customers where customer_id = 259;

-- 10) What did customer 259 buy and when?
select p.product_name, o.order_date, o.order_status from orders o 
join order_items oi on o.order_id = oi.order_id 
join products p on oi.product_id = p.product_id where o.customer_id = 259;

-- 11) Which staff processed the order of customer 259?
select concat(s.first_name, ' ', s.last_name) as staff_name, st.store_name from orders o 
join staffs s on o.staff_id = s.staff_id 
join stores st on s.store_id = st.store_id where o.customer_id = 259;


-- 12) Staff count and lead staff at BikeStore?
select 
(select count(*) from staffs where active = 1) as total_staff,
    concat(s.first_name, ' ', s.last_name) as lead_staff
from staffs s
where s.manager_id is null;

-- 13) Which brand is most liked?
select b.brand_name, sum(oi.quantity) as total_sales from order_items oi 
join products p on oi.product_id = p.product_id 
join brands b on p.brand_id = b.brand_id 
group by b.brand_name order by total_sales desc limit 1;


-- 14) Categories count and least liked category?
select count(distinct c.category_id) as total_categories, c.category_name, sum(oi.quantity) as total_sales 
from categories c
join products p on c.category_id = p.category_id 
join order_items oi on p.product_id = oi.product_id 
group by c.category_name order by total_sales asc limit 1;

-- 15) Store with more products of most liked brand?
with most_liked_brand as (
    select b.brand_id from brands b join products p on b.brand_id = p.brand_id 
    join order_items oi on p.product_id = oi.product_id 
    group by b.brand_id order by sum(oi.quantity) desc limit 1)
select st.store_name, sum(stk.quantity) as total_stock 
from stocks stk join stores st on stk.store_id = st.store_id 
join products p on stk.product_id = p.product_id 
where p.brand_id = (select brand_id from most_liked_brand) 
group by st.store_name order by total_stock desc limit 1;


-- 16) State with highest sales?
select st.state, sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_sales from order_items oi 
join orders o on oi.order_id = o.order_id 
join stores st on o.store_id = st.store_id 
group by st.state order by total_sales desc limit 1;


-- 17) Discounted price of product ID 259?
select list_price * (1 - discount) as discounted_price from order_items where product_id = 259;

-- 18) Details of product number 44?
select p.product_name, s.quantity, p.list_price, c.category_name, p.model_year, b.brand_name 
from products p 
join stocks s on p.product_id = s.product_id 
join categories c on p.category_id = c.category_id 
join brands b on p.brand_id = b.brand_id 
where p.product_id = 44;


-- 19) Zip code of CA?
select distinct zip_code from stores where state = 'CA';

-- 20) States BikeStore operates in?
select count(distinct state) as total_states from stores;

-- 21) Children bikes sold in the last 8 months?
select count(oi.quantity) as total_sold
from order_items oi
join products p on oi.product_id = p.product_id
join categories c on p.category_id = c.category_id
join orders o on oi.order_id = o.order_id
where c.category_name = 'Children Bicyclse' 
  and o.order_date >= date_sub(curdate(), interval 8 month);

-- 22) Shipped date for customer 523's order?
select shipped_date from orders where customer_id = 523;

-- 23) Pending orders count?
select count(*) as pending_orders from orders where shipped_date is null;

-- 24) Category and brand of "Electra white water 3i - 2018"?
select c.category_name, b.brand_name from products p 
join categories c on p.category_id = c.category_id 
join brands b on p.brand_id = b.brand_id 
where p.product_name = 'Electra white water 3i - 2018';



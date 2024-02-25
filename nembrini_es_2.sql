-- tabella sales --
create table sales
(
sale_id integer primary key not null unique,
sale_date date,
region_id integer,
product_id integer not null,
unit_price double,
quantity integer);
insert into sales (sale_id, sale_date, region_id, product_id, unit_price, quantity) values
(1, '2024-02-01', 1, 1001, 24.99, 10),
(2, '2024-02-02', 2, 1002, 14.99, 8),
(3, '2024-02-03', 1, 1003, 29.99, 5),
(4, '2024-02-04', 3, 1004, 39.99, 12),
(5, '2024-02-05', 2, 1005, 19.99, 6),
(6, '2024-02-06', 1, 1006, 9.99, 15),
(7, '2024-02-07', 3, 1007, 12.99, 9),
(8, '2024-02-08', 2, 1008, 34.99, 7),
(9, '2024-02-09', 1, 1009, 18.99, 11),
(10, '2024-02-10', 3, 1010, 49.99, 4),
(11, '2024-02-11', 2, 1001, 24.99, 3),
(12, '2024-02-12', 1, 1002, 14.99, 14),
(13, '2024-02-13', 3, 1003, 29.99, 8),
(14, '2024-02-14', 2, 1004, 39.99, 10),
(15, '2024-02-15', 1, 1005, 19.99, 6);

update sales set product_id = 1006 where product_id = 1001;
update sales set product_id = 1009 where product_id = 1003;
update sales set sale_date = '2023-02-10' where sale_id < 5;

-- tabella products --
create table products
(
product_id int not null unique primary key,
product_name varchar (100),
product_category varchar (100),
unit_price double);
INSERT INTO products (product_id, product_name, product_category, unit_price) VALUES
(1001, 'Super Robot Action Figure', 'Toys & Games', 24.99),
(1002, 'Magical Unicorn Plush Toy', 'Toys & Games', 14.99),
(1003, 'Racing Car Remote Control', 'Toys & Games', 29.99),
(1004, 'Dollhouse Playset', 'Toys & Games', 39.99),
(1005, 'Building Blocks Set', 'Toys & Games', 19.99),
(1006, 'Stuffed Animal Assortment', 'Toys & Games', 9.99),
(1007, 'Puzzle Game Collection', 'Toys & Games', 12.99),
(1008, 'Science Experiment Kit', 'Educational', 34.99),
(1009, 'Art Supplies Box', 'Educational', 18.99),
(1010, 'Outdoor Sports Equipment', 'Sports & Outdoors', 49.99);

-- tabella region --
create table region
(
region_id int not null unique primary key,
region_name varchar (25) not null unique);
insert into region (region_id, region_name) values
(1, 'italy'),
(2, 'spain'),
(3, 'france'),
(4, 'germany'),
(5, 'belgium');


-- esercizio 1 --
select case when count(distinct sale_id) = count(sale_id)
then "unique" else "not unique" end
from sales;

select case when count(distinct product_id) = count(product_id)
then "unique" else "not unique" end
from products;

select case when count(distinct region_id) = count(region_id)		
then "unique" else "not unique" end
from region;


-- esercizio 2 --
select 
    year(sale_date) as sale_year,
    round(sum(unit_price * quantity), 3) AS total_sales
from sales
group by year(sale_date), product_id;


-- esercizio 3 --
select 
	s.quantity, 
	year(s.sale_date) as sale_years, 
	s.unit_price, 
	s.quantity * s.unit_price as total_sale, 
	r.region_id, r.region_name
from sales s
left join region r on s.region_id = r.region_id;

select 
    r.region_id,
    r.region_name,
    year(s.sale_date) as sale_years,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * s.unit_price) as total_sale
from sales s 
join region r on s.region_id = r.region_id 
group by r.region_id, r.region_name, sale_years 
order by total_sale desc, sale_years;

-- esercizio 4 --
select 
    p.product_category,
    sum(s.quantity) as total_quantity
from products p
join sales s on p.product_id = s.product_id
group by p.product_category;

-- esercizio 5 modalità 1 --
select 
    p.product_id,
    p.product_name,
    s.product_id,
    s.sale_id
from products p
left join sales s on p.product_id = s.product_id
where sale_id is null;

-- esercizio 5 modalità 2 --
select 
    p.product_id,
    p.product_name
from products p
where not exists
	(select 1
	from sales s
	where p.product_id = s.product_id);
    
    
-- esercizio 6 --
select distinct
	p.product_name,
    p.product_id,
    s.sale_date
from products p
left join sales s on p.product_id = s.product_id
where s.sale_date = (
        select max(sale_date)
        from sales
        where product_id = p.product_id);
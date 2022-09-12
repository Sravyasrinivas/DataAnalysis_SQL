-- printing some records from the table
select * from raw_sales limit 10;

-- distinct postcodes
select count(distinct postcode) from raw_sales;

-- distinct datesold
select count(distinct year(datesold)) from raw_sales;

-- Which date corresponds to the highest number of sales?

select max(rn),datesold from (select count(*) as rn,datesold from raw_sales group by datesold order by rn desc)tmp;

-- Find out the postcode with the highest average price per sale?

select postcode,round(avg(price),2) as avg_price from raw_sales group by postcode order by avg_price desc limit 1;

-- Which year witnessed the lowest number of sales?

select min(rn),yr from (select count(*) as rn,year(datesold) as yr from raw_sales group by year(datesold) order by rn)tmp;

--  Use the window function to deduce the top six postcodes by year's price.
-- first from every year we take the highest price for each postcode and then from all those highest prices from each year
-- we take the top 6 postcodes by year

select yr,price,postcode 
from
	(select yr,price,postcode,row_number() over (partition by t.yr order by t.price desc) as rn 
from 
	(select year(datesold) as yr,price,postcode,
	dense_rank() over (partition by year(datesold),postcode order by price desc) as rnk 
	from raw_sales)t 
	where t.rnk=1)tmp 
		where rn between 1 and 6;

-- how many sales of houses and units are there for each year 

select count(*) as tot,year(datesold) as yr,propertytype from raw_sales group by yr,propertyType;
-- (or)
select year(datesold) as yr,sum(case when propertytype='house' then 1 else 0 end) as house_count,
sum(case when propertytype='unit' then 1 else 0 end) as unit_count
from raw_sales group by yr;

-- number of bedrooms sold for each property for each year

select year(datesold) as yr,sum(case when propertytype='house' then bedrooms else 0 end) as house_count,
sum(case when propertytype='unit' then bedrooms else 0 end) as unit_count
from raw_sales group by yr


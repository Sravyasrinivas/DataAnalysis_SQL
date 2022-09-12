-- total number of fish in each species 
select count(*),species_name from fish group by species_name;

-- max weight,height for each species
select max(weight),max(height),species_name from fish group by species_name;

-- analysing the max,min and avgs of length1 an length3
select max(length1) as max,min(length1) as min,round(avg(length1),1) as avg from fish;

-- x values ( length1) , y values (length3)  
-- y = mx + b ( y is what we are trying to predict , x is the input , b is the bias)
-- linear regression creates a line that predicts y from x. 
select round(slope,2) as slope,round((y_bar_max - x_bar_max * slope),2) as intercept 
from 
(select sum((x-x_bar) * (y-y_bar))/sum((x-x_bar) * (x-x_bar)) as slope,
max(x_bar) as x_bar_max,max(y_bar) as y_bar_max 
from
(select length1 as x,avg(length1) over() as x_bar,length3 as y,avg(length3) over()  as y_bar from fish)tmp)tmp1;

-- y is weight and x is length1 ( length1 is the vertical length)

select round(slope,2) as slope,round((y_bar_max - x_bar_max * slope),2) as intercept 
from 
(select sum((x-x_bar) * (y-y_bar))/sum((x-x_bar) * (x-x_bar)) as slope,
max(x_bar) as x_bar_max,max(y_bar) as y_bar_max 
from
(select length1 as x,avg(length1) over() as x_bar,weight as y,avg(weight) over()  as y_bar from fish)tmp)tmp1;
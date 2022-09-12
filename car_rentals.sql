-- insert the details of a new customer

insert into customer(first_name,last_name,dob,driver_license_number,email) 
values('Nancy','Perry','1988-05-16','K59042656E','nancy@gmail.com');

-- inserting values for the above inserted customer

INSERT INTO `rental`(`start_date`, `end_date`, `customer_id`, `vehicle_type_id`,
`fuel_option_id`, `pickup_location_id`, `drop_off_location_id`) VALUES ("2020-08-25", "2020-08-30", (SELECT customer.id FROM customer WHERE
customer.driver_license_number="K59042656E"), (SELECT vehicle_type.id FROM vehicle_type
WHERE vehicle_type.name="Economy SUV"), (SELECT fuel_option.id FROM fuel_option WHERE
fuel_option.name="Market"), (SELECT location.id FROM location WHERE
location.zipcode=60638),(SELECT location.id FROM location WHERE
location.zipcode=90045));

-- Fetch all rental details with their equipment type

select *,eq.name from rental r inner join rental_has_equipment_type rq on r.id=rq.rental_id
inner join equipment_type eq on eq.id=rq.equipment_type_id;

-- Fetch all details of vehicles

select brand,model,model_year,mileage,color,vt.name,city from vehicle v 
left join vehicle_type vt on vt.id=v.vehicle_type_id
left join location l on l.id=v.current_location_id;

-- Get driving license of the customer with most rental insurances.

select count(insurance_id) as number_of_ins,driver_license_number 
from rental_has_insurance 
left join rental on rental.id=rental_has_insurance.rental_id
inner join customer on customer.id=rental.customer_id
group by rental_id  order by number_of_ins desc limit 1;

-- insert new equipment type with the details given 

insert into equipment_type(name,rental_value) values('Mini TV',8.99);

-- new equipment 

INSERT INTO `equipment`(`name`, `equipment_type_id`, `current_location_id`) VALUES("Garmin Mini TV", (SELECT equipment_type.id FROM equipment_type WHERE
equipment_type.name = "Mini TV"), (SELECT location.id FROM location WHERE
location.zipcode = 60638));

-- inserting invoice for the customers

INSERT INTO `rental_invoice`(`car_rent`, `equipment_rent_total`, `insurance_cost_total`,
`tax_surcharges_and_fees`, `total_amount_payable`, `discount_amount`,
`net_amount_payable`, `rental_id`) VALUES (785.4, 114.65, 688.2, 26.2, 1614.45, 213.25,1401.2, (SELECT rental.id FROM rental INNER JOIN customer ON customer.id =
rental.customer_id WHERE customer.driver_license_number = "K59042656E"));

-- which rental has the most number of equipment 

select count(equipment_type_id) as num,rental_id from rental_has_equipment_type rh 
group by rental_id order by num desc limit 1;

-- Get driving license of a customer with least number of rental licenses.

select driver_license_number,count(rh.rental_id) from customer 
left join rental r on r.customer_id=customer.id
left join rental_has_insurance rh on rh.rental_id=r.id
group by rh.rental_id order by count(rh.rental_id) asc limit 1;

-- Insert new location with following details.
-- Street address : 1460 Thomas Street
-- City : Burr Ridge , State : IL, Zip-61257

insert into location(street_address,city,state,zipcode) values('1460 Thomas Street','Burr Ridge','IL',61257);

-- inserting vehicle details

insert into vehicle(brand,model,model_year,mileage,color,vehicle_type_id,current_location_id)
values('Tata','Nexon',2020,17000,'Blue',(select id from vehicle_type where name='Economy SUV'),
(select id from location where zipcode=20011));

-- Add new fuel option Pre-paid (refunded)

insert into fuel_option(name,description) values('Pre-paid','refunded');

-- Assign the insurance : Cover My Belongings (PEP), Cover The Car (LDW) to the rental
-- started on 25-08-2020 (created in Q2) by customer (Driving License:K59042656E).

insert into rental_has_insurance(rental_id,insurance_id) 
values((select rental.id from rental
inner join customer on customer.id=rental.customer_id where start_date='2020-08-25' and driver_license_number='K59042656E'),1)
,((select rental.id from rental
inner join customer on customer.id=rental.customer_id where start_date='2020-08-25' and driver_license_number='K59042656E'),3);

-- remove equipment_type 

delete from rental_has_equipment_type where rental_id=(select rental.id from rental 
where start_date='2018-07-14' and end_date='2018-07-23') and equipment_type_id=2;

-- Updatephone to 510-624-4188 of customer (Driving License: K59042656E)

update customer set phone='510-624-4188' where driver_license_number='K59042656E';

-- Increase the insurance cost of Cover The Car (LDW) by 5.65

update insurance set cost= cost + 5.65 where id=1;

-- Increase the rental value of all equipment types by 11.25

update equipment_type set rental_value=rental_value + 11.25;

-- Increase the cost of all rental insurances except Cover The Car (LDW) by twice the current cost

update insurance set cost= cost*2 where id != 1;

-- Fetch the maximum net amount of invoice generated.

select max(net_amount_payable) from rental_invoice;

-- Calculate the total sum of all insurance costs of all rentals.

select sum(insurance.cost) from rental_has_insurance rh inner join insurance on rh.insurance_id=insurance.id;

-- How much discount we gave to customers in total in the rental invoice.

select sum(discount_amount) from rental_invoice;

-- The Nissan Versa has been repainted to black. Update the record

update vehicle set color='black' where brand='Nisan' and model='Versa';
-- Which categories of movies released in 2018? Fetch with the number of movies.

select count(c.category_id) as tot,c.name as num from category c 
right join film_category fc on fc.category_id=c.category_id
left join film f on f.film_id=fc.film_id 
where release_year='2018' 
group by c.category_id;

-- Update the address of actor id 36 to “677 Jazz Street”.

update address inner join actor on actor.address_id = address.address_id 
set address='677 Jazz Street' where actor_id=36;

-- Add the new actors (id : 105 , 95) in film ARSENIC INDEPENDENCE (id:41).

insert into film_actor(actor_id,film_id) values(105,41),(95,41) on duplicate key update film_id=values(film_id)
,actor_id=values(actor_id);

-- Get the name of films of the actors who belong to India.

select (f.title) from film f 
left join film_actor fa on fa.film_id=f.film_id 
left join actor a on a.actor_id=fa.actor_id
right join address ad on ad.address_id=a.address_id
left join city c on c.city_id=ad.city_id
right join country  cn on cn.country_id=c.country_id
where cn.country='India'
group by f.title order by f.title;

-- How many actors are from the United States?

select count(distinct actor_id) from actor a 
left join address ad on a.address_id=ad.address_id
right join city c on c.city_id=ad.city_id
left join country cn on c.country_id=cn.country_id
where cn.country='United States';

-- Get all languages in which films are released in the year between 2001 and 2010.

select distinct l.name as cnt from language l 
right join film f on l.language_id=f.language_id 
where release_year between 2001 and 2010;

-- The film ALONE TRIP (id:17) was actually released in Mandarin, update the info

update film set language_id = 4 where film_id=17;

-- Fetch cast details of films released during 2005 and 2015 with PG rating.

select concat(first_name,' ',last_name) as name,release_year,title,l.name as language,length from film 
left join language l on l.language_id=film.language_id 
right join film_actor on film.film_id=film_actor.film_id
right join actor on actor.actor_id=film_actor.actor_id
where rating='PG' and release_year between 2005 and 2015;

-- In which year most films were released?

select count(*) as rn,release_year,title from film group by release_year order by rn desc limit 1;

-- In which year least number of films were released ?

select count(*) as rn,release_year,title from film group by release_year order by rn limit 1;

-- Get the details of the film with maximum length released in 2014 .

select title,l.name from film 
inner join language l on film.language_id=l.language_id 
where length=(select max(length) from film ) and release_year=2014; 

-- Get all SciFi movies with NC17 ratings and language they are screened in.

select title,l.name as language from film 
inner join language l on l.language_id=film.language_id
inner join film_category fc on film.film_id=fc.film_id
inner join category c on c.category_id=fc.category_id
where rating='NC-17' and c.name='Sci-Fi';

-- The actor FRED COSTNER (id:16) shifted to a new address:055, Piazzale Michelangelo, Postal Code-50125 , District-Rifredi at Florence, Italy.
-- Insert the new city and update the address of the actor.

insert into city(city,country_id) values('Florence',(select country_id from country where country='Italy'));

UPDATE `address` INNER JOIN actor ON actor.address_id = address.address_id SET
address.address = "055, Piazzale Michelangelo", address.district = "Rifredi ", address.city_id =
(SELECT city_id FROM city WHERE city.city = "Florence") , address.postal_code = "50125"
WHERE actor.actor_id = 16;

-- inserting all the details 

INSERT INTO `film`(`title`, `description`, `release_year`, `language_id`,
`original_language_id`, `rental_duration`, `rental_rate`, `length`, `replacement_cost`, `rating`,
`special_features`) VALUES ("No Time to Die", "Recruited to rescue a kidnapped scientist,globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, who'sarmed with a dangerous new technology.", 2020 , 
(SELECT language.language_id FROM
language WHERE language.name = "English"), (SELECT language.language_id FROM language
WHERE language.name = "English"), 6, 3.99, 100, 20.99, "PG-13", "Trailers,Deleted Scenes" );

-- Assign the category Action, Classics, Drama to the movie “No Time to Die” 

insert into film_category(film_id,category_id) values(1001,1),(1001,4),(1001,7);

-- Assign the cast: PENELOPE GUINESS, NICKWAHLBERG, JOE SWANK to the movie “No Time to Die” .

INSERT INTO `film_actor`(`actor_id`, `film_id`) VALUES ((SELECT actor_id FROM actor
WHERE actor.first_name = "PENELOPE" AND actor.last_name = "GUINESS") ,
(SELECT film_id FROM film WHERE film.title = "No Time to Die" )),
((SELECT actor_id FROM actor
WHERE actor.first_name = "NICK" AND actor.last_name =
"WAHLBERG") , (SELECT film_id FROM film WHERE film.title = "No Time to Die" )) ,
((SELECT actor_id FROM actor WHERE actor.first_name = "JOE" AND actor.last_name ="SWANK") , 
(SELECT film_id FROM film WHERE film.title = "No Time to Die" ));

-- Assign a new category Thriller to the movie ANGELS LIFE

insert into category(name) values ('Thriller');
insert into film_category(film_id,category_id) values ((select film_id from film where title='ANGELS LIFE'),17);

-- Which actor acted in most movies?

select concat(first_name,' ',last_name),actor_id
from actor where actor_id=(
select actor_id from 
(select count(*) as tot,actor_id from film_actor group by actor_id order by tot desc limit 1)tmp);

-- The actor JOHNNY LOLLOBRIGIDA was removed from the movie GRAIL FRANKENSTEIN.
-- How would you update that record?

delete from film_actor where film_id=(select film_id from film where title='GRAIL FRANKENSTEIN') 
and actor_id=(select actor_id from actor where first_name='JOHNNY' and last_name='LOLLOBRIGIDA');

-- The HARPER DYING movie is an animated movie with Drama and Comedy. Assign these categories to the movie

insert into film_category(film_id,category_id) values ((select film_id from film where title='HARPER DYING'),7)
,((select film_id from film where title='HARPER DYING'),5);

-- how many actors acted in the films released in the year 2017?

select count(distinct actor_id) from film_actor 
inner join film on film.film_id = film_actor.film_id where release_year=2017;

-- How many Sci-Fi films released between the year 2007 to 2017?

select count(*) from film_category inner join film on film_category.film_id=film.film_id 
where release_year between 2007 and 2017 and category_id=14;

-- Fetch the actors of the movie WESTWARD SEABISCUIT with the city they live in.

select concat(first_name,' ',last_name) as actors,city,title from actor a inner join film_actor fa on a.actor_id=fa.actor_id 
inner join address ad on ad.address_id=a.address_id 
inner join city c on c.city_id=ad.city_id
inner join film f on f.film_id=fa.film_id
where title='WESTWARD SEABISCUIT';

-- What is the total length of all movies played in 2008?

select sum(length) from film where release_year=2008;

-- Which film has the shortest length? In which language and year was it released?

SELECT language.name, film.title, film.release_year, film.length FROM `film` LEFT JOIN
language ON language.language_id=film.language_id WHERE film.length = (SELECT
MIN(film.length) FROM film);

-- How many movies were released each year?

select count(*),release_year from film group by release_year;

-- How many languages of movies were released each year?.

select name,release_year,count(title) from film left join language on language.language_id=film.language_id 
group by release_year,name;

-- Which actor did least movies?

select concat(first_name,' ',last_name),count(film_actor.film_id) as cnt,film_actor.actor_id from actor 
right join film_actor on actor.actor_id=film_actor.actor_id 
group by actor_id order by cnt limit 1;

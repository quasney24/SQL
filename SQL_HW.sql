
## Homework Assignment

-- 1a. Display the first and last names of all actors from the table `actor`. 
SELECT first_name, last_name FROM sakila.actor;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
SELECT CONCAT (first_name, ' ', last_name) AS Actor_Name FROM sakila.actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM sakila.actor
WHERE first_name = 'JOE';  	


-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * FROM sakila.actor
WHERE last_name LIKE  '%GEN%';
  	
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM sakila.actor
WHERE last_name LIKE '%LI%';

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM sakila.country
WHERE country IN ('AFGHANISTAN', 'BANGLADESH', 'CHINA'); 

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER Table sakila.actor
	add middle_name varchar(50) AFTER first_name;
    
    
-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE sakila.actor 
MODIFY middle_name blob;


-- 3c. Now delete the `middle_name` column.
ALTER TABLE sakila.actor DROP middle_name


-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT count(actor_id), last_name
FROM sakila.actor
GROUP BY last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) 
FROM actor 
GROUP BY last_name
HAVING COUNT(last_name) >= 2;  	


-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';  	


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor 
SET first_name = CASE 
    WHEN first_name = 'GROUCHO' AND last_name = 'Williams' THEN 'MUCHO GROUCHO' 
    WHEN first_name = 'HARPO' AND last_name = 'Williams' THEN 'GROUCHO'
    ELSE first_name
    END
WHERE actor_id = '172';


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON s.address_id=a.address_id;


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
SELECT s.staff_id, s.first_name, s.last_name, SUM(s.amount) as 'Total Amount'
FROM staff s
INNER JOIN payment p 
ON s.staff_id = p.staff_id
GROUP BY s.staff_id;  	


-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.title, f.film_id, COUNT(a.actor_id) as 'Number of Actors'
FROM film f
INNER JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY f.film_id;   	


-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT COUNT(film_id) As 'Count'
FROM inventory
WHERE film_id in (
    SELECT (film_id) FROM film
    WHERE title = ('Hunchback Impossible')
);
-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.last_name, SUM(p.amount) as 'Total Payment'
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.last_name; 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
SELECT title
FROM film 
WHERE (title LIKE 'Q%' or title LIKE 'K%') AND language_id IN
(
  SELECT language_id
  FROM language 
  WHERE name = 'English'
);
-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor 
  WHERE film_id IN
  (
    SELECT film_id
    FROM film 
    WHERE title = 'Alone Trip'
  ) 
);   
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT cus.first_name, cus.last_name, cus.email
FROM customer cus
LEFT JOIN address a 
ON c.address_id = a.address_id
LEFT JOIN city ci
ON ci.city_id = a.city_id
LEFT JOIN country co
ON co.country_id = ci.country_id
WHERE country = "Canada";


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title 
FROM film 
WHERE film_id IN
(
  SELECT film_id
  FROM film_category 
  WHERE category_id IN
  (
    SELECT category_id
    FROM catgory 
    WHERE name = 'Family'
  ) 
);
-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS 'Number of Rentals' 
FROM film f
JOIN inventory i
ON (f.film_id = i.film_id)
JOIN rental r
ON (r.inventory_id = i.inventory_id)
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC; 	


-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS "Total Business" 
  FROM payment p
  JOIN rental r
  ON (p.rental_id = r.rental_id)
  JOIN inventory i
  ON (i.inventory_id = r.inventory_id)
  JOIN store s
  ON (s.store_id = i.store_id)
  GROUP BY s.store_id;
  
  
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country
  FROM store s
  JOIN address a
  ON (s.address_id = a.address_id)
  JOIN city ci
  ON (a.city_id = ci.city_id)
  JOIN country co
  ON (ci.country_id = co.country_id)
  GROUP BY s.store_id;  	
  
  
-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name as "GENRE", SUM(p.amount) AS "GROSS REVENUE"
    FROM category c
    JOIN film_category f 
    ON (c.category_id = f.category_id)
    JOIN inventory i 
    ON (f.film_id = i.film_id)
    JOIN rental r 
    ON (i.inventory_id = r.inventory_id)
    JOIN payment p
    ON (r.rental_id = p.rental_id)
    GROUP BY c.name
    ORDER BY SUM(p.amount) DESC
LIMIT 5;  	


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
(SELECT c.name as GENRE, SUM(p.amount) 
    FROM category c
    JOIN film_category f 
    ON (c.category_id = f.category_id)
    JOIN inventory i 
    ON (f.film_id = i.film_id)
    JOIN rental r 
    ON (i.inventory_id = r.inventory_id)
    JOIN payment p
    ON (r.rental_id = p.rental_id)
    GROUP BY c.name
    ORDER BY SUM(p.amount) DESC
LIMIT 5);  	


-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;


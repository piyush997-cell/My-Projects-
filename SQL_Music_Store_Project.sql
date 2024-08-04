Q.1 Who is the senior most employees based on job title?

SELECT * FROM employee
ORDER bY levels DESC
limit 1

Q.2 Which countries have the most invoices

SELECT COUNT(*) as c, billing_country
FROM invoice
GROUP bY billing_country
ORDER bY c desc

Q.3 Which City has the best customers? we would like to throw a promorional music festival in the city we made 
the most money wrtite a query that returns one city that has the highest sum of invoice totals Return both the 
city name & sum of all invoce total 

SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP bY billing_city
ORDER bY invoice_total DESC 

Q.4 Who ois the best customer? the customer who has spent the most money will be declared the best customer.
	write a query that returns the person who has spent the most money?

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP bY customer.customer_id 
ORDER bY total desc 
limit 1



Q.5 Write query to return the email first name, last name & genre of all rock music listners. 
	Returns ypur list ordered alphabetically by email starting with A 

SELECT DISTINCT email, first_name, last_name 
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER bY email;

--Q.6 Let's invite the artist who have written the most rock music in our dataset 
  --  Write a query that returns the Artist name and total track count of the top 10
   -- Rock bands

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP bY artist.artist_id
ORDER bY number_of_songs DESC
LIMIT 10;



-- Q.7 Find how much amount spent by each customer on artists? write a query to return customer name, artist name and 
-- total spent

WITH best_selling_artist AS (
	SELECT artist.asrtis_id AS artist_id, artist.name AS artist_name,
	SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales 
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP bY 1
	ORDER bY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c,last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent 
FROM invoice i 

JOIN customer c on c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album.id = t.album_id 
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id 

GROUP bY 1,2,3,4
ORDER bY DESC;



-- Q.8 We want find out the most popular music genre for each country we determine the most popular genre as the genre with 
--     the highest amount of purchase. write a query that return each country along with the top genre. for countries where
--     The maximum number of countries where the maximum numver of purchase is showed return all genres

WITH RECURSIVE 
customer_with_country AS (
	SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending 
	FROM invoice 

	JOIN customer ON customer.customer_id = invoice.customer_id
	GROUP bY 1,2,3,4
	ORDER bY 2,3 DESC),

	Country_max_spending AS (

	SELECT billing_country, MAX (total_spending)	
	AS max_spending
	FROM customer_with_country
	GROUP bY billing_country)

	SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
	FROM customer_with_country cc
	JOIN country_max_spending ms
	ON cc.billing_country = ms.billing_country
	ORDER bY 1;






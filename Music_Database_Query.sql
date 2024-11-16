Q1: Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1



Q2: Which countries have the most Invoices?

select 
count(*) as invoice_count,
billing_country
from invoice
group by 2
order by 1 desc



Q3: What are top 3 values of total invoice? 

select 
total 
from invoice
order by total desc
limit 3



Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals

select 
billing_city,
sum(total) as invoice_totals
from invoice
group by 1
order by 2 desc
limit 1




Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.

select 
c.first_name,c.last_name,sum(i.total) as total_spending
from customer c 
join invoice i 
on c.customer_id = i.customer_id
group by 1, 2 
order by 3 desc
limit 1




Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A

select 
distinct c.email as email, c.first_name as first_name, c.last_name as last_name, g.name as genre_name
from customer c 
join invoice i 
on c.customer_id = i.customer_id
join invoice_line il
on i.invoice_id = il.invoice_id
join track t 
on il.track_id = t.track_id
join genre g
on t.genre_id = g.genre_id
where g.name ilike 'rock'
order by 1 asc




Q7: Lets invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands.

select a.name, count(t.track_id) as no_of_counts
from genre g 
join track t 
on g.genre_id = t.genre_id
join album ab 
on t.album_id = ab.album_id
join artist a 
on ab.artist_id = a.artist_id
where g.name ilike 'rock'
group by 1
order by 2 desc
limit 10




Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

select 
name, milliseconds from track
where milliseconds > (select (avg(milliseconds) )from track)
order by 2 desc




Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

with table1 as (
select 
ar.artist_id as artist_id,ar.name as artist_name,sum(il.unit_price * il.quantity) as total_sales
from invoice_line il 
join track t on il.track_id = t.track_id
join album a on t.album_id = a.album_id
join artist ar on a.artist_id = ar.artist_id
group by 1,2
order by 3 desc
limit 1
)

select 
c.customer_id as customer_id, c.first_name as firstname, c.last_name as lastname, t1.artist_name as artistname, sum(il.unit_price * il.quantity) as total_spent
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id 
join track t on t.track_id = il.track_id 
join album a on t.album_id = a.album_id
join table1 t1 on t1.artist_id = a.artist_id
group by 1,2,3,4
order by 5 desc




Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres.

with table1 as (
select
g.name as genre_name,
g.genre_id as genre_id,
c.country as country,
count(il.quantity) as purchases,
dense_rank() over (partition by c.country order by count(il.quantity) desc) as rnk 
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id 
join track t on t.track_id = il.track_id 
join genre g on t.genre_id = g.genre_id
group by 1,2,3
order by 3 asc, 4 desc
)

select genre_name, genre_id, country, purchases from table1
where rnk = 1

WITH popular_genre AS 




Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.

with table1 as (
select
c.customer_id as customer_id,
c.first_name as first_name,
c.last_name as last_name,
c.country as country,
sum(i.total) as total_spent,
dense_rank() over (partition by c.country order by sum(i.total) desc) as rnk 
from customer c 
join invoice i on c.customer_id = i.customer_id
group by 1,2,3,4
order by 4 asc, 5 desc
)

select customer_id, first_name, last_name, country, total_spent, rnk
from table1
where rnk = 1

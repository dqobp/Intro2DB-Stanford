/* Movie-Rating Query Exercise 1 */

/* 1. Find the titles of all movies directed by Steven Spielberg */
Select title
From Movie
Where director = 'Steven Spielberg';

/* 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order */
Select distinct year
From Movie natural join Rating
Where stars in (4,5)/* stars = 4 or stars = 5 */
Order by year
;

/* 3. Find the titles of all movies that have no ratings. */
Select  distinct title
From Movie left outer join Rating using(mID)
where stars is null;
--*--
Select title
From Movie
Where mID not in 
	(Select distinct mID
    From Rating);

/* 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.  */
Select name
From Reviewer natural join Rating
Where ratingDate is null;
--*--
Select name
From Reviewer
Where rID  in (
	Select distinct rID
    From Rating
    Where ratingDate is null);

/* 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
 */
Select name, title, stars, ratingDate
From Movie natural join Rating natural join Reviewer
Order by name, title, stars;

/* 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie */
select name, title
from Rating R1 join Rating R2 using (rID, mID) natural join Reviewer natural join Movie
where R1.ratingDate > R2.ratingDate and R1.stars > R2.stars
--*--
Select name, title
From 
	(SELECT mID,rID 
	FROM Rating R1
	Where rID in
		(Select rID
		From Rating R2
		Where R1.rID = R2.rID and R1.mID = R2.mID and R1.stars <> R2.stars and R1.ratingDate > R2.ratingDate and R1.stars > R2.stars)
	) G natural join Movie natural join Reviewer

;

/* 7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title */
select title, max(stars)
from Rating natural join Movie
group by mID
order by title;
--*--
Select title, stars
From
	(Select distinct mID, stars
	From Rating R1
	Where R1.stars>= all
		(Select stars
		From Rating R2
		Where R1.mID = R2.mID
		)
	) G natural join Movie
order by title;
--*--
Select title, stars
From
	(select distinct mID, stars
	from Rating C1
	where not exists (select * from Rating C2
		where C1.mID = C2.mID and C2.stars > C1.stars)
	) G natural join Movie
order by title
;

/* 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.  */
select *
from
(select title as title, max(stars)-min(stars) as GS
from Rating natural join Movie
group by title) A
order by GS desc, title
--*--
Select title, hstars-lstars as ratingspread
From
	(select distinct mID, stars as hstars
	from Rating C1
	where not exists (select * from Rating C2
		where C1.mID = C2.mID and C2.stars > C1.stars)
	) H join 
    (select distinct mID, stars as lstars
	from Rating C1
	where not exists (select * from Rating C2
		where C1.mID = C2.mID and C2.stars < C1.stars)
	) L using(mID)
    natural join Movie
order by ratingspread desc, title
;

/* 9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */
select abs(b1980star - a1980star)
from

(select avg(mstar) as b1980star
from 
(select mID, year, avg(stars) as mstar
from Rating join Movie using(mID)
group by mID, year) B natural join Movie
where year < 1980) as B1980,

(select avg(mstar) as a1980star
from 
(select mID, year, avg(stars) as mstar
from Rating join Movie using(mID)
group by mID, year) B natural join Movie
where year > 1980) as A1980
--*--
select SA-BA
from
(select avg(average) as SA
from 
	(
    select mID, average, year
	from
		(select distinct R1.mID, 
			(select avg(R2.stars)
			from Rating R2
			where R1.mID = R2.mID
			) as average
		from Rating R1
		) A natural join Movie 
    ) B
where year<1980 ) as C join
(select avg(average) as BA
from 
	(
    select mID, average, year
	from
		(select distinct R1.mID, 
			(select avg(R2.stars)
			from Rating R2
			where R1.mID = R2.mID
			) as average
		from Rating R1
		) A natural join Movie 
    ) B
where year>1980 ) as D
;































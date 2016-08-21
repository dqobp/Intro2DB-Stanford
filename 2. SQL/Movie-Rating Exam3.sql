/* Movie-Rating Query Exercise 1 */

/* 1. Add the reviewer Roger Ebert to your database, with an rID of 209 */
insert into Reviewer values ('209', 'Roger Ebert');

/* 2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.  */
insert into Rating 
select '207', mID,'5', null
from Movie

/* 3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)  */
update Movie
	set year = year + 25
	where mID in
	(select mID
	from (select mID, avg(stars) as AVG from Rating group by mID)
	where AVG >= 4)

/* 4. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.  */
delete from Rating
	where stars < 4 and mID in
	(select mID from Movie natural join Rating where year < 1970 or year > 2000)
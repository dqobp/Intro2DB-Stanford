/* Movie-Rating Query Exercise 2 Extra */

/* 1. Find the names of all reviewers who rated Gone with the Wind */
select distinct name
from Rating natural join Reviewer natural join Movie
where title = 'Gone with the Wind'
--*--
select name
from Reviewer
where rID in (select rID from Rating where mID in (select mID from Movie where title = 'Gone with the Wind'));

/* 2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars */
select name, title, stars
from Movie natural join Rating natural join Reviewer
where name = director;

/* 3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */
select name
from Reviewer

union

select title
from Movie
order by name
;

/* 4. Find the titles of all movies not reviewed by Chris Jackson */
select title
from Movie
where mID not in
(select distinct Rating.mID
from Rating natural join Reviewer natural join Movie
where name = 'Chris Jackson')
--*--
select title
from Movie
where mID not in (select mID from Rating where rID in (select rID from Reviewer where name = 'Chris Jackson'));

/* 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.  */
select distinct Re1.name as AName, Re2.name as BName
from Rating R1 join Rating R2 join Reviewer Re1 join Reviewer Re2
where R1.mID = R2.mID and R1.rID <> R2.rID and R1.rID = Re1.rID and R2.rID = Re2.rID and Re1.name < Re2.name
order by Re1.name
--*--




/* 6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.  */
select name, title, stars
from Rating natural join Movie natural join Reviewer
where stars in (select min(stars) from Rating)
order by name
;


/* 7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.  */
select title, average
from
	(select distinct mID, avg(stars) as average
	from Rating
    group by mID
	) A natural join Movie
order by average desc, title
--*-- 
select title, average
from
	(select distinct R1.mID, 
		(select avg(R2.stars)
		from Rating R2
		where R1.mID = R2.mID
		) as average
	from Rating R1
	) A natural join Movie
order by average desc, title


/* 8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)  */
select name
from Reviewer
where rID  in
	(select distinct R1.rID
	from Rating R1 join Rating R2 join Rating R3
	where 
		R1.rID = R2.rID and R2.rID = R3.rID and R1.rID = R3.rID
	and 
		((R1.ratingDate is null and R2.ratingDate <> R3.ratingDate) 
			or
    	 (R1.ratingDate <> R2.ratingDate and R2.ratingDate <> R3.ratingDate and R1.ratingDate <> R3.ratingDate)
    	 )
    )
; 


/* 9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) */
select title, director
from Movie
where director in 
	(
    select distinct director
	from Movie M1 join Movie M2 using(director)
	where M1.mID <> M2.mID
    )
order by director, title

--*-- with count()
select title, director
from Movie
where director in
(select director
from
(select director, count(*) as NUM
from Movie
group by director) A
where NUM > 1)
order by director, title

/* 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)  */
select title, average

from
	(select distinct R1.mID, 
		(select avg(R2.stars)
		from Rating R2
		where R1.mID = R2.mID
		) as average
	from Rating R1
	) A natural join Movie
    
where average in
	(
    select max(average)
from
	(select distinct R1.mID, 
		(select avg(R2.stars)
		from Rating R2
		where R1.mID = R2.mID
		) as average
	from Rating R1
	) A natural join Movie
    )


/* 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)  */
select title, average

from
	(select distinct R1.mID, 
		(select avg(R2.stars)
		from Rating R2
		where R1.mID = R2.mID
		) as average
	from Rating R1
	) A natural join Movie
    
where average in
	(
    select min(average)
from
	(select distinct R1.mID, 
		(select avg(R2.stars)
		from Rating R2
		where R1.mID = R2.mID
		) as average
	from Rating R1
	) A natural join Movie
    )


/* 12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.  */
select distinct director, title, stars
from 
	(select distinct director,
		(select max(stars)
		from Movie M2 natural join Rating R2
		where M1.director = M2.director
		) as mstars
	from Movie M1 natural join Rating R1
	where director is not null
	order by mstars desc
	) A natural join Movie M3 natural join Rating R3
where R3.stars = A.mstars
order by stars desc;
	













/* Constraints */

/* 1. Non-null constraints */
create table Student (sID int, sName text, GPA real not null, sizeHS int);
/* not null is a constraint */

/* 2 */
insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, null);
insert into Student values (345, 'Craig', null, 500); /* fail */

/* 3 */
update Student set GPA = null where sID = 123; /* cause constraint violation */
update Student set GPA = null where sID = 456; /* not, but no row will be affected */


/* 1. Key constraints - Primary Key */
create table Student (sID int primary key, sName text, GPA real, sizeHS int);

/* 2 */
insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (123, 'Craig', 3.5, 500);

/* 3 */

/* 4 */
update Student set sID = sID - 111; /* no violation */

/* 5 */
update Student set sID = sID + 111; /* violation */

/* 6 */
create table Student (sID int primary key, sName text primary key, GPA real, sizeHS int); /*only one primary key*/

/* 7 */
create table Student (sID int primary key, sName text unique, GPA real, sizeHS int); /* sName also a key*/
/* 8 */

/* 9 */
create table College (cName text, state text, enrollment int, primary key(cName, state)); /*combination of values to be unique in tuple*/

/* 1. Key Constraints - Two Key */
create table Apply (sID int, cName text, major text, decision text, unique(sID, cName), unique(sID, major));

/* 2 */

/* 3 */

/* 4 */
insert into Student values (123, null, null, 'Y');
insert into Student values (234, null, null, 'N');

/* 1. Attribute-based constraints */
create table Student (sID int, sName text, GPA real check(GPA <= 4.0 and GPA > 0.0), sizeHS int check(sizeHS <5000));

/* 2 */

/* 3 */

/* 1 Tuple-based constraints */
create table Apply (sID int, cName text, major text, decision text, check(decision = 'N' or cName <> 'Stanford' or major <> 'CS'));

/* 2 */

/* 3 */

/* 1 */
create table T (A int check(A not in (select A from T)));
/* try to make A unique, but can't execute*/

/* 1 */
create table T (A int check((select count(distinct A) from T) = (select count(*) from T)));
/* problem that we're referring to table T within the check constraint that we're putting in the definition of table T */

/* 1 */
create table Student (sID int, sName text, GPA real, sizeHS int);
create table Apply (sID int, cName text, major text, decision text, check(sID in (select sID from Student)));
/* no SQL support, referential integrity */
create table College (cName text, state text, enrollment int, check(enrollment > (select max(sizeHS) from Student)));
/* tricky, you can delete from other table, so the constraint no longer exist */

/* 1. Assertion */
create assertion Key
	check((select count(distinct A) from T) = 
		  (select count(*) from T));
/* trying to declare or trying to enforce a key constraint without using the built-in facilities. */
/* assertion: this condition always be true on the database */

/* 2 */

/* 3 */










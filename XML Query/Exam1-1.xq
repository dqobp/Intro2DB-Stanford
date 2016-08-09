----------------- NO DONE --------------------

// 1. Return all Title elements (of both departments and courses)
doc("courses.xml")/Course_Catalog//Title

// 2. Return last names of all department chairs
doc("courses.xml")/Course_Catalog/Department/Chair//Last_Name

// 3. Return titles of courses with enrollment greater than 500
doc("courses.xml")/Course_Catalog//Course[@Enrollment > 500]/Title

// 4. Return titles of departments that have some course that takes "CS106B" as a prerequisite
doc("courses.xml")/Course_Catalog/Department[Course/Prerequisites/Prereq = "CS106B"]/Title

// 5. Return last names of all professors or lecturers who use a middle initial. Don't worry about eliminating duplicates
doc("courses.xml")/Course_Catalog//Middle_Initial/parent::*/Last_Name

// 6. 
let $b := doc("courses.xml")/Course_Catalog
return count($b//Course[contains(Description, "Cross-listed")])
--*--
doc("courses.xml")/Course_Catalog//Course[contains(Description,"Cross-listed")]/Title

// 7.
for $b in doc('courses.xml')/Course_Catalog/Department[@Code = 'CS']
return avg($b/Course/@Enrollment)

// 8.
for $b in doc('courses.xml')/Course_Catalog//Course
where $b/contains(Description,"system")
    and $b/@Enrollment >100
return $b/Instructors//Last_Name

// 9.
for $b in doc('courses.xml')/Course_Catalog//Course
where $b/@Enrollment = (for $c in doc('courses.xml')/Course_Catalog
return max($c//Course/@Enrollment))
return $b/Title
----------------- :( --------------------
let $catalog := doc('courses.xml'),
 $courses := $catalog//Course
 for $c in $courses
 where $c/@Enrollment = max($courses/@Enrollment)
 return $c/Title
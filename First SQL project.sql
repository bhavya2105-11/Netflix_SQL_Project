CREATE TABLE Netflx(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(110),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(55),
	release_year INT,
	rating VARCHAR(15),
	duration VARCHAR(15),
	listed_in VARCHAR(250),
	description VARCHAR(450)
)
ALTER Table Netflx
RENAME TO Netflix;

SELECT * FROM Netflix;

--Q1 Count the no. of movies vs shows
SELECT type,
COUNT(*) as total_number
FROM Netflix
GROUP BY type;

--Q2Show all distinct rating
SELECT Distinct rating,title 
From Netflix
ORDER BY rating desc;

--Find all Movies released after 2020.
SELECT *
FROM netflix
WHERE type='Movie'
AND release_year>2020;


--Find all TV Shows.
SELECT * FROM Netflix
WHERE type='TV Show';

--List the first 10 titles alphabetically.
SELECT title
FROM netflix
ORDER BY title
LIMIT 10;

SELECT * FROM Netflix;

--Find content with rating TV-MA.
SELECT * FROM Netflix;
WHERE rating ='TV-MA';

--Count the number of titles for each rating.
SELECT
    rating,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY rating
ORDER BY total_titles DESC;


--Find the oldest movie.
SELECT type,title,release_year 
From Netflix
ORDER BY release_year
LIMIT 1;

--Find the newest release year
SELECT MAX(release_year) AS latest_year
FROM netflix;


--Find rows with NULL values.
SELECT
    COUNT(*) FILTER (WHERE show_id IS NULL) AS show_id_nulls,
    COUNT(*) FILTER (WHERE type IS NULL) AS type_nulls,
    COUNT(*) FILTER (WHERE title IS NULL) AS title_nulls,
    COUNT(*) FILTER (WHERE director IS NULL) AS director_nulls,
    COUNT(*) FILTER (WHERE casts IS NULL) AS cast_nulls,
    COUNT(*) FILTER (WHERE country IS NULL) AS country_nulls,
    COUNT(*) FILTER (WHERE date_added IS NULL) AS date_added_nulls,
    COUNT(*) FILTER (WHERE release_year IS NULL) AS release_year_nulls,
    COUNT(*) FILTER (WHERE rating IS NULL) AS rating_nulls,
    COUNT(*) FILTER (WHERE duration IS NULL) AS duration_nulls,
    COUNT(*) FILTER (WHERE listed_in IS NULL) AS listed_in_nulls,
    COUNT(*) FILTER (WHERE description IS NULL) AS description_nulls
FROM netflix;


--Replace NULL countries with 'Unknown'.
UPDATE netflix
SET country = 'Unknown'
WHERE country IS NULL;

--Verify
SELECT *
FROM netflix
WHERE country = 'Unknown';


--Find duplicate titles.
SELECT
    title,
    COUNT(*) AS duplicate_count
FROM netflix
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, title;

--Count how many titles have missing directors.
SELECT COUNT(*) AS missing_directors
FROM Netflix
WHERE director is NUll;

--Find content with missing cast information.
SELECT title,casts
FROM Netflix
WHERE casts is NUll;


--Find all titles containing "Love".
SELECT title 
FROM Netflix
WHERE title LIKE '%Love%';

--Find titles starting with "The".
SELECT title 
FROM Netflix
WHERE title LIKE 'The%';


--Find titles ending with "Man".
SELECT title 
FROM Netflix
WHERE title LIKE '%Man';


--Find all titles where the description contains "murder".
SELECT title , description 
FROM Netflix
WHERE Description LIKE '%murder%';


--Which year had the most releases?
SELECT
    release_year,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY release_year
ORDER BY total_titles DESC
LIMIT 1;


--Which country produces the most Netflix content?
SELECT
    country,
    COUNT(*) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 1;


--Which genre is the most common?
SELECT
    listed_in,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY listed_in
ORDER BY total_titles DESC
LIMIT 1;


--Which director has directed the most Movies?
SELECT
    director,
    COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
  AND director IS NOT NULL
GROUP BY director
ORDER BY total_movies DESC
LIMIT 1;


--Which actor appears in the highest number of titles?
SELECT
    TRIM(actor) AS actor,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL UNNEST(STRING_TO_ARRAY(cast, ',')) AS actor
WHERE cast IS NOT NULL
GROUP BY actor
ORDER BY total_titles DESC
LIMIT 1;


--Which decade has the most releases?
SELECT
    (release_year / 10) * 10 AS decade,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY decade
ORDER BY total_titles DESC
LIMIT 1;


--Top 10 longest movies
SELECT
    title,
    duration,
    release_year
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS INTEGER) DESC
LIMIT 10;


--Which Movies were added to Netflix more than 5 years after their release?
SELECT
    title,
    release_year,
    date_added,
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS added_year
FROM netflix
WHERE type = 'Movie'
AND date_added IS NOT NULL
AND (EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) - release_year) > 5;


--Find actors who worked with the most different directors
SELECT
    TRIM(actor) AS actor,
    COUNT(DISTINCT director) AS total_directors
FROM netflix,
LATERAL UNNEST(STRING_TO_ARRAY(cast, ',')) AS actor
WHERE director IS NOT NULL
  AND cast IS NOT NULL
GROUP BY actor
ORDER BY total_directors DESC
LIMIT 10;


--Find directors who have both Movies and TV Shows.
SELECT
    director
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
HAVING COUNT(DISTINCT type) = 2;





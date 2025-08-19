DROP TABLE IF EXISTS Netflix;
CREATE TABLE Netflix (
    show_id VARCHAR(5) PRIMARY KEY,
    type VARCHAR(10) NOT NULL,
    title VARCHAR(250) NOT NULL,
    director VARCHAR(550),
    casts VARCHAR(1050),
    country VARCHAR(550),
    date_added VARCHAR(55),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(15),
    listed_in VARCHAR(250),
    description VARCHAR(550)
);

SELECT * FROM Netflix;

-- 1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS Total
FROM Netflix
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows
WITH Rating_Counts AS (
SELECT type, rating, COUNT(*) AS rating_count
FROM netflix
GROUP BY type, rating
),
Ranked_Ratings AS (
SELECT type, rating, rating_count, RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
FROM Rating_Counts
)
SELECT type, rating AS most_frequent_rating
FROM Ranked_Ratings
WHERE rank = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT show_id, type, title, director, rating, duration, release_year
FROM Netflix
WHERE release_year = '2020' AND type = 'Movie'
ORDER BY show_id;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT country, COUNT(*) as content_count 
FROM netflix
WHERE country IS NOT NULL
GROUP BY country 
ORDER BY content_count DESC 
LIMIT 5;

-- 5. Identify the longest movie
SELECT * 
FROM Netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;

-- 6. Find content added in the last 5 years
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT * 
FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
SELECT * 
FROM Netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5
ORDER BY SPLIT_PART(duration, ' ', 1)::INT;

-- 9. Count the number of content items in each genre
WITH split_genres AS (
  SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS single_genre
  FROM Netflix
)
SELECT single_genre, COUNT(*) AS Total_Content
FROM split_genres
GROUP BY single_genre
ORDER BY Total_Content DESC;;

-- 10. Find each year and the average numbers of content release in India on netflix. 
--     Return top 5 year with highest avg content release!
WITH Indian_Content AS (
  SELECT release_year, COUNT(*) AS Total_Content
  FROM netflix
  WHERE country ILIKE '%India%'
  GROUP BY release_year
)
SELECT release_year, Total_Content AS Average_Content_Released
FROM Indian_Content
ORDER BY Total_Content DESC
LIMIT 5;

-- 11. List all movies that are documentaries
SELECT * 
FROM Netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT * 
FROM Netflix
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT * 
FROM netflix
WHERE type = 'Movie' AND casts ILIKE '%Salman Khan%' AND release_year >= EXTRACT(Year FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
WITH Actor_Apperance AS (
SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS Actor, COUNT(*) AS Movies_Count
FROM Netflix
WHERE type = 'Movie' AND country ILIKE '%India%'
GROUP BY Actor
)
SELECT Actor, Movies_Count
FROM Actor_Apperance
ORDER BY Movies_Count DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--     the description field. Label content containing these keywords as 'Bad' and all other 
--     content as 'Good'. Count how many items fall into each category
SELECT
CASE 
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
END AS content_category,
COUNT(*) AS content_count
FROM 
    Netflix
GROUP BY 
    content_category
ORDER BY 
    content_count DESC;
	

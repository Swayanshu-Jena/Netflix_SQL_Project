# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/Swayanshu-Jena/Netflix_SQL_Project/blob/main/Netflix_logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS Total
FROM Netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT show_id, type, title, director, rating, duration, release_year
FROM Netflix
WHERE release_year = '2020' AND type = 'Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT country, COUNT(*) as content_count 
FROM netflix
WHERE country IS NOT NULL
GROUP BY country 
ORDER BY content_count DESC 
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM Netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM Netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5
ORDER BY SPLIT_PART(duration, ' ', 1)::INT;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
WITH split_genres AS (
  SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS single_genre
  FROM Netflix
)
SELECT single_genre, COUNT(*) AS Total_Content
FROM split_genres
GROUP BY single_genre
ORDER BY Total_Content DESC;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT *
FROM Netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM Netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * FROM netflix
WHERE type = 'Movie'
AND casts ILIKE '%Salman Khan%' AND release_year >= EXTRACT(Year FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Swayanshu Jena

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated

Make sure to follow me on social media:

- **Instagram**: [Follow me](https://www.instagram.com/sway_anshu_jena/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/swayanshu-jena)

❤️ Thank you for your support, and I look forward to connecting with you!

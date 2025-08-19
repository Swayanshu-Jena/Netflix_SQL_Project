-- SCHEMAS of Netflix

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

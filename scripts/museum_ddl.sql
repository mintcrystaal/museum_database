CREATE SCHEMA IF NOT EXISTS museum;

CREATE TABLE IF NOT EXISTS museum.country (
	country_id INTEGER PRIMARY KEY,
	country_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS museum.city (
	city_id INTEGER PRIMARY KEY,
	city_name VARCHAR(128) NOT NULL,
	country_id INTEGER NOT NULL,
	FOREIGN KEY (country_id) REFERENCES museum.country (country_id)
);

CREATE TABLE IF NOT EXISTS museum.museum (
	museum_id INTEGER PRIMARY KEY,
	museum_name VARCHAR(128) NOT NULL,
	museum_address VARCHAR(128) NOT NULL,
	city_id INTEGER NOT NULL,
	FOREIGN KEY (city_id) REFERENCES museum.city (city_id)
);

CREATE TABLE IF NOT EXISTS museum.exhibition (
	exhibition_id INTEGER PRIMARY KEY,
	exhibition_name VARCHAR(128) NOT NULL,
	museum_id INTEGER NOT NULL,
	start_date DATE DEFAULT CURRENT_DATE,
	end_date DATE DEFAULT NULL,
	FOREIGN KEY (museum_id) REFERENCES museum.museum (museum_id)
);

CREATE TABLE IF NOT EXISTS museum.guide (
	guide_id INTEGER PRIMARY KEY,
	guide_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS museum.language (
	language_id INTEGER PRIMARY KEY,
	language_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS museum.genre (
	genre_id INTEGER PRIMARY KEY,
	genre_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS museum.artist (
	artist_id INTEGER PRIMARY KEY,
	artist_name VARCHAR(128) NOT NULL,
	birthplace_city_id INTEGER NOT NULL,
	artist_birth_date DATE NOT NULL,
	artist_death_date DATE DEFAULT NULL,
	FOREIGN KEY (birthplace_city_id) REFERENCES museum.city (city_id)
);

CREATE TABLE IF NOT EXISTS museum.artwork (
	artwork_id INTEGER PRIMARY KEY,
	artwork_name VARCHAR(128) NOT NULL,
	year_created INTEGER DEFAULT NULL,
	artist_id INTEGER DEFAULT NULL,
	genre_id INTEGER NOT NULL,
	exhibition_id INTEGER NOT NULL,
	FOREIGN KEY (genre_id) REFERENCES museum.genre (genre_id),
	FOREIGN KEY (exhibition_id) REFERENCES museum.exhibition (exhibition_id),
	FOREIGN KEY (artist_id) REFERENCES museum.artist (artist_id)
);

CREATE TABLE IF NOT EXISTS museum.guided_tour (
	guided_tour_id INTEGER PRIMARY KEY,
	duration INTEGER NOT NULL DEFAULT 60,
	exhibition_id INTEGER NOT NULL,
	guide_id INTEGER NOT NULL,
	language_id INTEGER NOT NULL,
	FOREIGN KEY (exhibition_id) REFERENCES museum.exhibition (exhibition_id),
	FOREIGN KEY (guide_id) REFERENCES museum.guide (guide_id),
	FOREIGN KEY (language_id) REFERENCES museum.language (language_id)
);

CREATE TABLE IF NOT EXISTS museum.ticket (
	ticket_id INTEGER PRIMARY KEY,
	ticket_price DECIMAL(18, 2) NOT NULL CHECK (ticket_price >= 0) DEFAULT 0,
	guided_tour_id INTEGER NOT NULL,
	FOREIGN KEY (guided_tour_id) REFERENCES museum.guided_tour (guided_tour_id)
);

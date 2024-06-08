# Physical Model

### Table `country'
| Name | Description | Data Type | Restriction |
| ------------ | ------------------------------------ | ----------- | --------------------------------- |
| country_id | unique identifier for each country | integer | Primary Key |
| country_name | name of the country | varchar(128)| Not Null |

```postgresql
CREATE TABLE IF NOT EXISTS museum.country (
	country_id INTEGER PRIMARY KEY,
	country_name VARCHAR(128) NOT NULL
);
```


### Table `city'
| Name | Description | Data Type | Restriction |
| ------------ | ------------------------------------ | ----------- | --------------------------------------------- |
| city_id | unique identifier for each city | integer | Primary Key |
| city_name | name of the city | varchar(128)| Not Null |
| country_id | identifier of the country the city belongs to | integer | Not Null, Foreign Key to country.country_id |

```postgresql
CREATE TABLE IF NOT EXISTS museum.city (
	city_id INTEGER PRIMARY KEY,
	city_name VARCHAR(128) NOT NULL,
	country_id INTEGER NOT NULL,
	FOREIGN KEY (country_id) REFERENCES museum.country (country_id)
);
```


### Table `museum'
| Name | Description | Data Type | Restriction |
| -------------- | ------------------------------------ | ----------- | --------------------------------------------- |
| museum_id | unique identifier for each museum | integer | Primary Key |
| museum_name | name of the museum | varchar(128)| Not Null |
| museum_address | address of the museum | varchar(128)| Not Null |
| city_id | identifier of the city where the museum is located | integer | Not Null, Foreign Key to city.city_id |

```postgresql
CREATE TABLE IF NOT EXISTS museum.museum (
	museum_id INTEGER PRIMARY KEY,
	museum_name VARCHAR(128) NOT NULL,
	museum_address VARCHAR(128) NOT NULL,
	city_id INTEGER NOT NULL,
	FOREIGN KEY (city_id) REFERENCES museum.city (city_id)
);
```


### Table `exhibition'
| Name | Description | Data Type | Restriction |
| -------------- | ------------------------------------ | ----------- | --------------------------------------------- |
| exhibition_id | unique identifier for each exhibition | integer | Primary Key |
| exhibition_name| name of the exhibition | varchar(128)| Not Null |
| museum_id | identifier of the museum hosting the exhibition | integer | Not Null, Foreign Key to museum.museum_id |
| start_date | start date of the exhibition | date | Default: Current Date |
| end_date | end date of the exhibition | date | Default: Null |

```postgres
CREATE TABLE IF NOT EXISTS museum.exhibition (
	exhibition_id INTEGER PRIMARY KEY,
	exhibition_name VARCHAR(128) NOT NULL,
	museum_id INTEGER NOT NULL,
	start_date DATE DEFAULT CURRENT_DATE,
	end_date DATE DEFAULT NULL,
	FOREIGN KEY (museum_id) REFERENCES museum.museum (museum_id)
);
```


### Table `guided_tour'
| Name | Description | Data Type | Restriction |
| ------------ | ------------------------------------ | ----------- | --------------------------------- |
| guide_id | unique identifier for each guide | integer | Autoincrement, Primary Key |
| guide_name | name of the guide | varchar(128)| Not Null |

```postgres
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
```

### Table `language'
| Name | Description | Data Type | Restriction |
| ------------- | ------------------------------------ | ----------- | --------------------------------- |
| language_id | unique identifier for each language | integer | Autoincrement, Primary Key |
| language_name | name of the language | varchar(128)| Not Null |

```postgres
CREATE TABLE IF NOT EXISTS museum.language (
	language_id INTEGER PRIMARY KEY,
	language_name VARCHAR(128) NOT NULL
);
```

### Table `genre'
| Name | Description | Data Type | Restriction |
| ---------- | ------------------------------------ | ----------- | --------------------------------- |
| genre_id | unique identifier for each genre | integer | Autoincrement, Primary Key |
| genre_name | name of the genre | varchar(128)| Not Null |

```postgres
CREATE TABLE IF NOT EXISTS museum.genre (
	genre_id INTEGER PRIMARY KEY,
	genre_name VARCHAR(128) NOT NULL
);
```

### Table `artist'
| Name | Description | Data Type | Restriction |
| ----------------- | ------------------------------------ | ----------- | --------------------------------------------- |
| artist_id | unique identifier for each artist | integer | Primary Key |
| artist_name | name of the artist | varchar(128)| Not Null |
| birthplace_city_id| identifier of the city where the artist was born | integer | Not Null, Foreign Key to city.city_id |
| artist_birth_date | birth date of the artist | date | Not Null |
| artist_death_date | death date of the artist | date | Default: Null |

```postgres

CREATE TABLE IF NOT EXISTS museum.artist (
	artist_id INTEGER PRIMARY KEY,
	artist_name VARCHAR(128) NOT NULL,
	birthplace_city_id INTEGER NOT NULL,
	artist_birth_date DATE NOT NULL,
	artist_death_date DATE DEFAULT NULL,
	FOREIGN KEY (birthplace_city_id) REFERENCES museum.city (city_id)
);
```

### Table `artwork'
| Name | Description | Data Type | Restriction |
| ------------- | ------------------------------------ | ----------- | --------------------------------------------- |
| artwork_id | unique identifier for each artwork | integer | Primary Key |
| artwork_name | name of the artwork | varchar(128)| Not Null |
| artwork_year | year the artwork was created | integer | Default: Null |
| artist_id | identifier of the artist who created the artwork | integer | Default: Null, Foreign Key to artist.artist_id |
| genre_id | identifier of the genre of the artwork | integer | Not Null, Foreign Key to genre.genre_id |
| exhibition_id | identifier of the exhibition the artwork is displayed in | integer | Not Null, Foreign Key to exhibition.exhibition_id |

```postgres
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
```

### Table `guided_tour'
| Name | Description | Data Type | Restriction |
| ------------ | ------------------------------------------ | ----------- | --------------------------------- |
| guided_tour_id| unique identifier for each guided tour | integer | Primary Key |
| duration | duration of the guided tour (in minutes) | integer | Not Null, Default: 60 |
| exhibition_id| identifier of the exhibition the guided tour is associated with | integer | Not Null, Foreign Key to exhibition.exhibition_id |
| guide_id | identifier of the guide leading the tour | integer | Not Null, Foreign Key to guide.guide_id |
| language_id | identifier of the language used for the tour | integer | Not Null, Foreign Key to language.language_id |

```postgres
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
```

### Table `ticket'
| Name | Description | Data Type | Restriction |
| ------------ | ------------------------------------------ | ----------- | --------------------------------- |
| ticket_id | unique identifier for each ticket | integer | Primary Key |
| ticket_price | price of the ticket | decimal(18, 2) | Not Null, Check (ticket_price >= 0), Default: 0 |
| guided_tour_id| identifier of the guided tour the ticket is for | integer | Not Null, Foreign Key to guided_tour.guided_tour_id |
```postgres
CREATE TABLE IF NOT EXISTS museum.ticket (
	ticket_id INTEGER PRIMARY KEY,
	ticket_price DECIMAL(18, 2) NOT NULL CHECK (ticket_price >= 0) DEFAULT 0,
	guided_tour_id INTEGER NOT NULL,
	FOREIGN KEY (guided_tour_id) REFERENCES museum.guided_tour (guided_tour_id)
);
```

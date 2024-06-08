-- View для получения информации о выставках, экскурсиях и билетах
CREATE VIEW museum_exhibitions_v AS
SELECT museum_name, exhibition.exhibition_name, ticket.ticket_price, language.language_name, guided_tour.duration
FROM museum.museum
JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id
JOIN museum.guided_tour ON exhibition.exhibition_id = guided_tour.exhibition_id
JOIN museum.ticket ON guided_tour.guided_tour_id = ticket.guided_tour_id
JOIN museum.language ON language.language_id = guided_tour.language_id;

-- View для получения информации о произведениях искусства и их авторах
CREATE VIEW museum_artworks_v AS
SELECT artwork.artwork_name, artwork.year_created, genre.genre_name, artist.artist_name
FROM museum.artwork
JOIN museum.artist ON artwork.artist_id = artist.artist_id
JOIN museum.exhibition ON artwork.exhibition_id = exhibition.exhibition_id
JOIN museum.museum ON exhibition.museum_id = museum.museum_id
JOIN museum.genre ON artwork.genre_id = genre.genre_id;

-- View для получения информации о музеях и их адресах
CREATE VIEW museum_addresses_v AS
SELECT museum.museum_name, museum.museum_address, country.country_name, city.city_name
FROM museum.museum
JOIN museum.city ON museum.city_id = city.city_id
JOIN museum.country ON city.country_id = country.country_id;

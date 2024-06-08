-- выбрать все музеи, в которых находятся работы Vincent van Gogh, вывести названия работ, адрес музеев и упорядочить по названию работ
SELECT museum.museum_name, artwork.artwork_name, museum.museum_address
FROM museum.museum
JOIN museum.exhibition ON exhibition.museum_id = museum.museum_id
JOIN museum.artwork ON exhibition.exhibition_id = artwork.exhibition_id
JOIN museum.artist ON artwork.artist_id = artist.artist_id
WHERE artist.artist_name = 'Vincent van Gogh'
ORDER BY artwork.artwork_name;

-- выбрать все действующие на 04.04.2024 выставки в Лондоне с названием музея, упорядоченные в алфавитном порядке
SELECT museum.museum_name, exhibition.exhibition_name, exhibition.start_date, exhibition.end_date
FROM museum.museum
JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id
WHERE museum.city_id = (SELECT city_id FROM museum.city WHERE city_name = 'London') AND exhibition.end_date >= '2024-04-04' AND exhibition.start_date <= '2024-04-04'
ORDER BY exhibition.exhibition_name;

-- вывести страны, в которых больше двух музей
SELECT country.country_name, COUNT(*) AS museum_count
FROM museum.museum
JOIN museum.city ON museum.city_id = city.city_id
JOIN museum.country ON country.country_id = city.country_id
GROUP BY country.country_id
HAVING COUNT(*) > 2;

-- вывести выставку в музее, на которой больше всего картин
SELECT museum.museum_name, exhibition.exhibition_name, COUNT(*) AS artwork_count
FROM museum.museum
JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id
GROUP BY museum.museum_name, exhibition.exhibition_name
HAVING COUNT(*) = (SELECT MAX(artwork_count) FROM(
    SELECT museum.museum_name, exhibition.exhibition_name, COUNT(*) AS artwork_count
    FROM museum.museum
    JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id
    GROUP BY museum.museum_name, exhibition.exhibition_name
) AS subquery);

-- выбрать все картины Vincent van Gogh, которые будут находиться в Metropolitan Museum of Art
SELECT artwork.artwork_name, artwork.year_created, artist.artist_name
FROM museum.artwork
JOIN museum.artist ON artwork.artist_id = artist.artist_id
JOIN museum.exhibition ON artwork.exhibition_id = exhibition.exhibition_id
JOIN museum.museum ON exhibition.museum_id = museum.museum_id
WHERE artist.artist_name = 'Vincent van Gogh' AND museum.museum_name = 'Metropolitan Museum of Art';

-- вывести все картины жанра Impressionism, год написания, автора картины
SELECT artwork.artwork_name, artwork.year_created, artist.artist_name
FROM museum.artwork
JOIN museum.artist ON artwork.artist_id = artist.artist_id
JOIN museum.genre ON artwork.genre_id = genre.genre_id
WHERE genre.genre_name = 'Impressionism';

-- вывести все возможные экскурсии на выставке Impressionist Masterpieces, язык, гида, длительность, стоимость билета
SELECT guide.guide_name, guided_tour.duration, ticket.ticket_price, language.language_name
FROM museum.exhibition
JOIN museum.guided_tour ON exhibition.exhibition_id = guided_tour.exhibition_id
JOIN museum.guide ON guided_tour.guide_id = guide.guide_id
JOIN museum.ticket ON guided_tour.guided_tour_id = ticket.guided_tour_id
JOIN museum.language ON guided_tour.language_id = language.language_id
WHERE exhibition.exhibition_name = 'Impressionist Masterpieces'
ORDER BY guide_name;

-- вывести адреса и названия всех музеев в United Kingdom
SELECT museum.museum_name, museum.museum_address
FROM museum.museum
JOIN museum.city ON museum.city_id = city.city_id
JOIN museum.country ON city.country_id = country.country_id
WHERE country.country_name = 'United Kingdom';

-- вывести количество картин каждого жанра в музее Metropolitan Museum of Art
SELECT genre.genre_name, COUNT(*) AS artwork_count
FROM museum.artwork
JOIN museum.genre ON artwork.genre_id = genre.genre_id
JOIN museum.artist ON artwork.artist_id = artist.artist_id
JOIN museum.exhibition ON artwork.exhibition_id = exhibition.exhibition_id
JOIN museum.museum ON exhibition.museum_id = museum.museum_id
WHERE museum.museum_name = 'Metropolitan Museum of Art'
GROUP BY genre.genre_name;

-- вывести название музея, количество выставок, упорядоченное по убыванию количества выставок
SELECT museum_name, COUNT(*) OVER(PARTITION BY exhibition_name) AS exhibit_count
FROM museum.exhibition
JOIN museum.museum ON museum.museum_id = exhibition.museum_id
ORDER BY exhibit_count DESC;

-- вывести название музея, название выставки, стоимость билета, язык экскурсии, среднюю стоимость билета в каждом музее
SELECT museum_name, exhibition.exhibition_name, ticket.ticket_price, language.language_name, avg(ticket.ticket_price) OVER (PARTITION BY museum_name)
FROM museum.museum
JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id
JOIN museum.guided_tour ON exhibition.exhibition_id = guided_tour.exhibition_id
JOIN museum.ticket ON guided_tour.guided_tour_id = ticket.guided_tour_id
JOIN museum.language ON language.language_id = guided_tour.language_id;

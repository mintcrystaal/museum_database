import decimal
import unittest
from cursor import execute_query
import datetime
from decimal import *

class TestQueries(unittest.TestCase):
    def test_van_gogh_museums(self):
        query = "SELECT museum.museum_name, artwork.artwork_name, museum.museum_address \
                                        FROM museum.museum \
                                        JOIN museum.exhibition ON exhibition.museum_id = museum.museum_id \
                                        JOIN museum.artwork ON exhibition.exhibition_id = artwork.exhibition_id \
                                        JOIN museum.artist ON artwork.artist_id = artist.artist_id \
                                        WHERE artist.artist_name = 'Vincent van Gogh' \
                                        ORDER BY artwork.artwork_name;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], str)
            self.assertIsInstance(row[2], str)
        print('Tests of Van Gogh museums finished')

    def test_london_exhibitions(self):
        query_result = "SELECT museum.museum_name, exhibition.exhibition_name, exhibition.start_date, exhibition.end_date \
                                        FROM museum.museum \
                                        JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id \
                                        WHERE museum.city_id = (SELECT city_id FROM museum.city WHERE city_name = 'London') \
                                        AND exhibition.end_date >= '2024-04-04' AND exhibition.start_date <= '2024-04-04' \
                                        ORDER BY exhibition.exhibition_name;"
        result = execute_query(query_result)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 4)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], str)
            self.assertIsInstance(row[2], datetime.date)
            self.assertIsInstance(row[3], datetime.date)        
        print('Tests of London exhibitions finished')

    def test_more_than_two_museums(self):
        query = "SELECT country.country_name, COUNT(*) AS museum_count \
                                        FROM museum.museum \
                                        JOIN museum.city ON city.city_id = museum.city_id \
                                        JOIN museum.country ON country.country_id = city.country_id \
                                        GROUP BY country.country_id \
                                        HAVING COUNT(*) > 2;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)
        print('Tests of more than two museums finished')
    
    def test_most_artworks_exhibitions(self):
        query = " SELECT museum.museum_name, exhibition.exhibition_name, COUNT(*) AS artwork_count \
                                FROM museum.museum \
                                JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id \
                                GROUP BY museum.museum_name, exhibition.exhibition_name \
                                HAVING COUNT(*) = (SELECT MAX(artwork_count) FROM( \
                                    SELECT museum.museum_name, exhibition.exhibition_name, COUNT(*) AS artwork_count \
                                    FROM museum.museum \
                                    JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id \
                                    GROUP BY museum.museum_name, exhibition.exhibition_name \
                                ) AS subquery);"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], str)
            self.assertIsInstance(row[2], int)
        print('Tests of exhibition with most artworks finished')
    
    def test_van_gogh_metropolitan_museum(self):
        query = "SELECT artwork.artwork_name, artwork.year_created, artist.artist_name \
                FROM museum.artwork \
                JOIN museum.artist ON artwork.artist_id = artist.artist_id \
                JOIN museum.exhibition ON artwork.exhibition_id = exhibition.exhibition_id \
                JOIN museum.museum ON exhibition.museum_id = museum.museum_id \
                WHERE artist.artist_name = 'Vincent van Gogh' AND museum.museum_name = 'Metropolitan Museum of Art';"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)
            self.assertIsInstance(row[2], str)
        print('Tests of Van Gogh Artworks in Metropolitan Museum finished')
    
    def test_impressionism_artworks(self):
        query = "SELECT artwork.artwork_name, artwork.year_created, artist.artist_name FROM museum.artwork JOIN museum.artist ON artwork.artist_id = artist.artist_id JOIN museum.genre ON artwork.genre_id = genre.genre_id WHERE genre.genre_name = 'Impressionism';"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)
            self.assertIsInstance(row[2], str)
        print('Tests of Impressionism artworks finished')


    def test_all_exhibitions_Impressionist_Masterpieces(self):
        query = "SELECT exhibition.exhibition_name, guided_tour.duration, language.language_name, guide.guide_name \
                                FROM museum.exhibition \
                                JOIN museum.guided_tour ON exhibition.exhibition_id = guided_tour.exhibition_id \
                                JOIN museum.guide ON guided_tour.guide_id = guide.guide_id \
                                JOIN museum.language ON guided_tour.language_id = language.language_id \
                                WHERE exhibition.exhibition_name = 'Impressionist Masterpieces' \
                                ORDER BY guided_tour.duration DESC;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 4)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)
            self.assertIsInstance(row[2], str)
            self.assertIsInstance(row[3], str)
        print('Tests of all exhibitions Impressionist Masterpieces finished')

    def test_uk_museums(self):
        query = "SELECT museum.museum_name, museum.museum_address \
                                FROM museum.museum \
                                JOIN museum.city ON museum.city_id = city.city_id \
                                JOIN museum.country ON city.country_id = country.country_id \
                                WHERE country.country_name = 'United Kingdom';"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], str)
        print('Tests of UK Museums finished')
    def test_count_artworks_metropolitan_museum(self):
        query = "SELECT genre.genre_name, COUNT(*) AS artwork_count \
                                FROM museum.artwork \
                                JOIN museum.genre ON artwork.genre_id = genre.genre_id \
                                JOIN museum.artist ON artwork.artist_id = artist.artist_id \
                                JOIN museum.exhibition ON artwork.exhibition_id = exhibition.exhibition_id \
                                JOIN museum.museum ON exhibition.museum_id = museum.museum_id \
                                WHERE museum.museum_name = 'Metropolitan Museum of Art' \
                                GROUP BY genre.genre_name;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)  
        print('Tests of count artworks Metropolitan Museum finished')

    def test_exhibitions_count(self):
        query = "SELECT museum_name, COUNT(*) OVER(PARTITION BY exhibition_name) AS exhibit_count FROM museum.exhibition JOIN museum.museum ON museum.museum_id = exhibition.museum_id ORDER BY exhibit_count DESC;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)  
        print('Tests of exhibitions count finished')

    def test_exhibitions_avg_price(self):
        query = "SELECT museum.museum_name, exhibition.exhibition_name, ticket.ticket_price, language.language_name, avg(ticket.ticket_price) OVER (PARTITION BY museum_name) \
                                FROM museum.museum \
                                JOIN museum.exhibition ON museum.museum_id = exhibition.museum_id \
                                JOIN museum.guided_tour ON exhibition.exhibition_id = guided_tour.exhibition_id \
                                JOIN museum.ticket ON guided_tour.guided_tour_id = ticket.guided_tour_id \
                                JOIN museum.language ON language.language_id = guided_tour.language_id;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        # Проверяем, каждую строку
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 5)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], str)
            self.assertIsInstance(row[2], Decimal)
            self.assertIsInstance(row[3], str)
            self.assertIsInstance(row[4], Decimal)
        print('Tests of exhibitions avg price finished')


# Запуск тестов
if __name__ == '__main__':
    unittest.main()
    print('Tests finished')

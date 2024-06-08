-- Обновление стоимости билета на экскурсию
CREATE PROCEDURE update_guided_tour_price(
    p_guided_tour_id INTEGER,
    p_price INTEGER
) LANGUAGE SQL
AS $$
    UPDATE museum.ticket
    SET ticket_price = p_price
    WHERE guided_tour_id = p_guided_tour_id;
$$;


-- Поиск произведений искусства по имени автора
CREATE FUNCTION find_artwork_by_artist(
    p_artist_name VARCHAR(128)
) RETURNS TABLE(artwork_name text)
AS $$
    SELECT a.artwork_name
    FROM museum.artwork a
    JOIN museum.artist ar ON a.artist_id = ar.artist_id
    WHERE ar.artist_name = p_artist_name;
$$
LANGUAGE SQL;


-- Обновление выставки, на которой находится произведение искусства
CREATE PROCEDURE update_artwork_exhibion(
    p_artwork_id INTEGER,
    p_exhibition_id INTEGER
) LANGUAGE SQL
AS $$
    UPDATE museum.artwork
    SET exhibition_id = p_exhibition_id
    WHERE artwork_id = p_artwork_id;
$$;

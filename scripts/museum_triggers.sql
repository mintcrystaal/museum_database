-- Триггер проверяет, что дата окончания выставки не может быть раньше даты начала
CREATE OR REPLACE FUNCTION exhibition_end_date_check_f()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.end_date < NEW.start_date THEN
        RAISE EXCEPTION 'End date cannot be earlier than start date';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exhibition_end_date_check
BEFORE INSERT ON museum.exhibition
FOR EACH ROW
EXECUTE FUNCTION exhibition_end_date_check_f();


-- Триггер для удаления билетов при удалении экскурсии
CREATE OR REPLACE FUNCTION delete_tickets_on_exhibition_f()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM museum.ticket
    WHERE guided_tour_id IN (
        SELECT guided_tour_id
        FROM museum.guided_tour
        WHERE exhibition_id = OLD.exhibition_id
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_tickets
AFTER DELETE ON museum.exhibition
FOR EACH ROW
EXECUTE FUNCTION delete_tickets_on_exhibition_f();


-- Триггер обновляет цену билета в соответствии с новой продолжительностью экскурсии
CREATE OR REPLACE FUNCTION update_ticket_price_f()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE museum.ticket
    SET ticket_price = (NEW.duration / 60) * ticket_price
    WHERE guided_tour_id = NEW.guided_tour_id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_ticket_price
AFTER UPDATE ON museum.guided_tour
FOR EACH ROW
EXECUTE FUNCTION update_ticket_price_f();

DELIMITER $$

CREATE TRIGGER TicketInsertTimeCheck
BEFORE INSERT ON Train_Station.Tickets
FOR EACH ROW
BEGIN
    DECLARE departure_time DATETIME;

    -- Получаем время отправления с начальной станции маршрута
    SELECT r.departure INTO departure_time
    FROM Train_Station.Routes r
    WHERE r.flight_id = NEW.flight_id AND r.stop_type = 'Начало'
    LIMIT 1;

    -- Проверка: билет нельзя продать менее чем за 30 минут до отправления
    -- или если поезд уже ушёл (текущее время позже отправления)
    IF NEW.sell_date > departure_time OR TIMESTAMPDIFF(MINUTE, NEW.sell_date, departure_time) < 30 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: билет нельзя продать менее чем за 30 минут до отправления или после отправления поезда.';
    END IF;
END$$

DELIMITER ;

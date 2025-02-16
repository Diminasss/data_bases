DELIMITER //

CREATE FUNCTION GetAvailableSeats(p_route VARCHAR(500), p_departure DATETIME) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_seats INT;
    DECLARE blocked_seats INT;
    DECLARE flight_id_funk INT;
    DECLARE train_id_funk INT;
    DECLARE type_funk VARCHAR(45);

    -- Получение train_id по маршруту и дате отправления
    SELECT train_id INTO train_id_funk
    FROM schedule
    WHERE route = p_route AND departure = p_departure
    LIMIT 1;

    -- Получение типа поезда по train_id
    SELECT type INTO type_funk
    FROM trains
    WHERE train_id = train_id_funk
    LIMIT 1;

    -- Установка total_seats в зависимости от типа поезда
    IF type_funk = 'Скорый' THEN
        SET total_seats = 180;
    ELSEIF type_funk = 'Пассажирский' THEN
        SET total_seats = 150;
    ELSE
        SET total_seats = 0; -- Значение по умолчанию, если тип неизвестен
    END IF;

    -- Получение flight_id по маршруту и дате отправления
    SELECT flight_id INTO flight_id_funk
    FROM schedule
    WHERE route = p_route AND departure = p_departure
    LIMIT 1;

    -- Получение количества забронированных мест по flight_id
    SELECT COUNT(*) INTO blocked_seats
    FROM tickets
    WHERE flight_id = flight_id_funk AND status = 'Забронирован';

    -- Возврат количества доступных мест
    RETURN total_seats - blocked_seats;
END //

DELIMITER ;

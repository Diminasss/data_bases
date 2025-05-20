DELIMITER $$

CREATE PROCEDURE GetRoutesByCategoryAndFlightDirection(
    IN route_category ENUM('Внутренний', 'Международный', 'Туристический', 'Специальный'),
    IN direction_flight_id INT
)
BEGIN
    DECLARE start_station INT;
    DECLARE end_station INT;

    -- Получаем начальную и конечную станции маршрута по заданному flight_id
    SELECT station_id INTO start_station
    FROM Routes
    WHERE flight_id = direction_flight_id AND stop_type = 'Начало'
    LIMIT 1;

    SELECT station_id INTO end_station
    FROM Routes
    WHERE flight_id = direction_flight_id AND stop_type = 'Конец'
    LIMIT 1;

    -- Выводим подходящие маршруты
    SELECT 
        s.flight_id,
        s.train_name,
        s.ticket_price
    FROM Schedule s
    WHERE s.category = route_category
      AND EXISTS (
          SELECT 1 FROM Routes r1 
          WHERE r1.flight_id = s.flight_id AND r1.station_id = start_station AND r1.stop_type = 'Начало'
      )
      AND EXISTS (
          SELECT 1 FROM Routes r2 
          WHERE r2.flight_id = s.flight_id AND r2.station_id = end_station AND r2.stop_type = 'Конец'
      );

    -- И общее их количество
    SELECT COUNT(*) AS total_routes
    FROM Schedule s
    WHERE s.category = route_category
      AND EXISTS (
          SELECT 1 FROM Routes r1 
          WHERE r1.flight_id = s.flight_id AND r1.station_id = start_station AND r1.stop_type = 'Начало'
      )
      AND EXISTS (
          SELECT 1 FROM Routes r2 
          WHERE r2.flight_id = s.flight_id AND r2.station_id = end_station AND r2.stop_type = 'Конец'
      );
END$$

DELIMITER ;

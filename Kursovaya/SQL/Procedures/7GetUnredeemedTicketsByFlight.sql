DELIMITER $$

CREATE PROCEDURE GetUnredeemedTicketsByFlight(IN in_flight_id INT)
BEGIN
    SELECT 
        s.flight_id AS Идентификатор,
        s.category AS Категория,
        tr.train_type AS "Тип поезда",
        tr.carriage_number * 81 AS Всего,
        COUNT(b.ticket_id) AS Выкуплено,
        (tr.carriage_number * 81 - COUNT(b.ticket_id)) AS "Не выкуплено"
    FROM schedule s
    JOIN trains tr ON s.train_id = tr.train_id
    LEFT JOIN tickets b ON b.flight_id = s.flight_id AND b.status = 'Куплен'
    WHERE s.flight_id = in_flight_id
    GROUP BY s.flight_id, tr.train_type, tr.carriage_number;
END$$

DELIMITER ;

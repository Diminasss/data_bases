DELIMITER $$

CREATE PROCEDURE GetPassengerStatsByDate(IN target_date DATE)
BEGIN
    SELECT
        COUNT(t.passenger_id) AS total_passengers,

        SUM(CASE WHEN s.category = 'Международный' THEN 1 ELSE 0 END) AS international_passengers,

        SUM(CASE WHEN t.luggage = 1 THEN 1 ELSE 0 END) AS with_luggage,
        SUM(CASE WHEN t.luggage = 0 THEN 1 ELSE 0 END) AS without_luggage,

        SUM(CASE WHEN p.sex = '1' THEN 1 ELSE 0 END) AS male,
        SUM(CASE WHEN p.sex = '0' THEN 1 ELSE 0 END) AS female,

        SUM(CASE WHEN TIMESTAMPDIFF(YEAR, p.date_of_birth, target_date) < 18 THEN 1 ELSE 0 END) AS age_under_18,
        SUM(CASE WHEN TIMESTAMPDIFF(YEAR, p.date_of_birth, target_date) BETWEEN 18 AND 60 THEN 1 ELSE 0 END) AS age_18_to_60,
        SUM(CASE WHEN TIMESTAMPDIFF(YEAR, p.date_of_birth, target_date) > 60 THEN 1 ELSE 0 END) AS age_above_60

    FROM tickets t
    JOIN passengers p ON t.passenger_id = p.passenger_id
    JOIN schedule s ON t.flight_id = s.flight_id
    JOIN routes r ON t.flight_id = r.flight_id
    WHERE t.status = 'Использован'
      AND r.stop_type = 'Начало'
      AND DATE(r.departure) = target_date;
END$$

DELIMITER ;

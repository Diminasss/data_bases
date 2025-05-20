DELIMITER $$

CREATE PROCEDURE GetAvgTickets(
    IN start_date DATETIME,
    IN end_date DATETIME,
    IN route_flight_id INT
)
BEGIN
    SELECT 
        s.flight_id,
        s.train_name,
        s.ticket_price,
        COUNT(DISTINCT t.ticket_id) AS total_tickets_sold,
        ROUND(COUNT(DISTINCT t.ticket_id) / DATEDIFF(end_date, start_date), 2) AS avg_tickets_per_day,
        COUNT(DISTINCT r.stop_id) AS station_count
    FROM Schedule s
    JOIN Routes r ON s.flight_id = r.flight_id
    LEFT JOIN Tickets t ON t.flight_id = s.flight_id
        AND t.status = 'Куплен'
        AND t.sell_date BETWEEN start_date AND end_date
    WHERE 
        s.flight_id = route_flight_id
    GROUP BY s.flight_id, s.train_name, s.ticket_price;
END$$

DELIMITER ;

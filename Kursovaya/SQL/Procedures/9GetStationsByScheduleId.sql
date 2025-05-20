DELIMITER $$

CREATE PROCEDURE GetStationsByScheduleId(IN in_schedule_id INT)
BEGIN
    SELECT 
        s.train_name,
        st.location, 
        r.arrival, 
        r.departure, 
        r.stop_type
    FROM 
        Train_Station.Routes r
    JOIN 
        Train_Station.Schedule s ON r.flight_id = s.flight_id
    JOIN 
        Train_Station.Stations st ON r.station_id = st.station_id
    WHERE 
        r.flight_id = in_schedule_id
    ORDER BY 
        r.arrival;
END$$

DELIMITER ;

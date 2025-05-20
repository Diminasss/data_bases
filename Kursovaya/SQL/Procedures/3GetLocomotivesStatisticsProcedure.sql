DELIMITER $$

CREATE PROCEDURE GetLocomotiveStatistics (
    IN start_date DATETIME,
    IN end_date DATETIME,
    IN repair_count INT
)
BEGIN
    SELECT 
        COUNT(DISTINCT l.locomotive_id) AS total_locomotives
    FROM 
        Train_Station.Locomotives l
    JOIN 
        Train_Station.Inspection i ON l.locomotive_id = i.locomotive_id
    LEFT JOIN 
        Train_Station.Repair r ON l.locomotive_id = r.locomotive_id
    WHERE 
        i.inspection_type = 'плановый'
        AND i.datetime BETWEEN start_date AND end_date
    GROUP BY 
        l.locomotive_id
    HAVING 
        COUNT(r.repair_id) = repair_count;
END $$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE SelectAllTablesWithSleep(sleep_time INT)
BEGIN

    SELECT * FROM `Train_Station`.`Stations`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Passengers`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Administration`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Departments`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Teams`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Locomotives`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Employees`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Medical_examinations`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Trains`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Tickets`;
    SELECT SLEEP(sleep_time);

    SELECT * FROM `Train_Station`.`Schedule`;
    SELECT SLEEP(sleep_time);
END //

DELIMITER ;

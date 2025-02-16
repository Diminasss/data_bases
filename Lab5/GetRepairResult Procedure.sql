DELIMITER //

CREATE PROCEDURE GetRepairResult()
BEGIN
    DROP TEMPORARY TABLE IF EXISTS `Train_Station`.`repair_result`;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS `Train_Station`.`repair_result` (
        recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
        locomotive_id INT
    );

    -- Вставляем данные в временную таблицу repair_result
    INSERT INTO `Train_Station`.`repair_result` (locomotive_id)
    SELECT locomotive_id
    FROM `Train_Station`.`Locomotives`
    WHERE regular_inspection < NOW() - INTERVAL 24 HOUR;

    SELECT * FROM `Train_Station`.`repair_result`;

    DROP TEMPORARY TABLE IF EXISTS `Train_Station`.`repair_result`;
END //

DELIMITER ;

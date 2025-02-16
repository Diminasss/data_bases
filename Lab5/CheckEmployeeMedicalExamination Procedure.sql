DELIMITER //

CREATE PROCEDURE CheckEmployeeMedicalExamination()
BEGIN

	 -- Удаляем временную таблицу после использования
    DROP TEMPORARY TABLE IF EXISTS `Train_Station`.`medical_examination_result`;
    
    -- Создаем временную таблицу medical_examination_result
    CREATE TEMPORARY TABLE IF NOT EXISTS `Train_Station`.`medical_examination_result` (
        recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
        employee_id INT
    );

    -- Вставляем данные в временную таблицу medical_examination_result
    INSERT INTO `Train_Station`.`medical_examination_result` (employee_id)
    SELECT employee_id
    FROM `Train_Station`.`Medical_examinations`
    WHERE medical_examination LIKE '%Предстоит пройти%';

    -- Проверяем, есть ли сотрудники, требующие медицинского осмотра
    IF (SELECT COUNT(*) FROM `Train_Station`.`medical_examination_result`) > 0 THEN
        -- Выводим содержимое временной таблицы medical_examination_result
        SELECT * FROM `Train_Station`.`medical_examination_result`;
    ELSE
        -- Выводим сообщение, что все сотрудники в порядке
        SELECT 'Все сотрудники в порядке' AS message;
    END IF;

    -- Удаляем временную таблицу после использования
    DROP TEMPORARY TABLE IF EXISTS `Train_Station`.`medical_examination_result`;
END //

DELIMITER ;

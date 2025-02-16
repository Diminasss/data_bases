DELIMITER $$

CREATE PROCEDURE show_temp_log()
BEGIN
    -- Запросим и выведем данные из временной таблицы temp_log
    SELECT * FROM temp_log;
    -- Удаляем временную таблицу
    DROP TEMPORARY TABLE IF EXISTS temp_log;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER check_employee_before_delete
BEFORE DELETE ON `Employees`
FOR EACH ROW
BEGIN
    DECLARE employee_exists INT;

    -- Создаём временную таблицу для логирования
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_log (
        message TEXT
    );

    -- Проверяем, существует ли работник
    SELECT COUNT(*) INTO employee_exists
    FROM `Employees`
    WHERE `employee_id` = OLD.employee_id;

    -- Если работник найден, записываем его данные в временную таблицу
    IF employee_exists > 0 THEN
        INSERT INTO temp_log (message) 
        VALUES (CONCAT('Работник ', OLD.full_name, ' с ID ', OLD.employee_id, ' был снят с должности ', OLD.post));
    ELSE
        -- Если работник не найден, записываем сообщение об ошибке в временную таблицу
        INSERT INTO temp_log (message) 
        VALUES ('Работник для удаления не найден.');
    END IF;

END$$

DELIMITER ;

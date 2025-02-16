DELIMITER //

CREATE FUNCTION CountTicketsByStatus() RETURNS VARCHAR(500)
READS SQL DATA
BEGIN
    DECLARE current_status VARCHAR(45);
    DECLARE ticket_count INT;
    DECLARE result VARCHAR(500) DEFAULT '';
    DECLARE finished INT DEFAULT 0;

    -- Курсор для перебора уникальных статусов
    DECLARE status_cursor CURSOR FOR 
    SELECT DISTINCT status 
    FROM `Train_Station`.`Tickets`;

    -- Обработка окончания курсора
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Открываем курсор
    OPEN status_cursor;

    status_loop: LOOP
        FETCH status_cursor INTO current_status;
        IF finished THEN
            LEAVE status_loop;
        END IF;

        -- Считаем количество билетов для текущего статуса
        SELECT COUNT(*) INTO ticket_count
        FROM `Train_Station`.`Tickets`
        WHERE status = current_status;

        -- Формируем строку результата
        SET result = CONCAT(result, current_status, ': ', ticket_count, '; ');
    END LOOP;

    -- Закрываем курсор
    CLOSE status_cursor;

    -- Возвращаем результат
    RETURN result;
END //

DELIMITER ;

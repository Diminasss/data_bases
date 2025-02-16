DELIMITER //

CREATE TRIGGER `train_station`.`after_employee_update`
AFTER UPDATE ON `train_station`.`employees`
FOR EACH ROW
BEGIN
  -- Проверим, изменилась ли должность
  IF OLD.post != NEW.post THEN
    -- Если должность изменилась, обновим медосмотр сотрудника
    UPDATE `train_station`.`medical_examinations`
    SET `medical_examination` = 'Предстоит пройти'
    WHERE `employee_id` = NEW.employee_id;
  END IF;
END //

DELIMITER ;

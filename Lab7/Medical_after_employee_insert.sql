DELIMITER //

CREATE TRIGGER `train_station`.`Medical_after_employee_insert`
AFTER INSERT ON `train_station`.`Employees`
FOR EACH ROW
BEGIN
		-- Автоматически добавляем запись о необходимости медосмотра
	INSERT INTO `train_station`.`Medical_examinations` (
		`employee_id`,
		`medical_examination`
	) VALUES (
		NEW.employee_id,
		'Предстоит пройти'
	);
END//

DELIMITER ;

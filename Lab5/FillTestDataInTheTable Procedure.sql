DELIMITER //
CREATE PROCEDURE FillTestDataInTheTable()
	BEGIN
		DECLARE i INT DEFAULT 1; -- Для обновления в конце
		-- Вставка данных в таблицу Stations
		INSERT INTO `Train_Station`.`Stations` (`location`) VALUES
		('Новосибирск-Главный'),
		('Бердск'),
		('Обь');

		INSERT INTO `Train_Station`.`Passengers` (`full_name`) VALUES
		('Пассажир А'),
		('Пассажир Б'),
		('Пассажир В');

		INSERT INTO `Train_Station`.`Administration` (`employee_id`) VALUES
		(NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL);

		INSERT INTO `Train_Station`.`Departments` (`department_name`, `station_id`, `administrator_id`) VALUES
		('Водители', 1, 1),
		('Диспетчеры', 1, 2),
		('Ремонтники подвижного состава', 1, 3),
		('Служба ремонта путей', 1, 4),
		('Кассиры', 1, 5),
		('Служба подготовки составов', 1, 6),
		('Справочная служба', 1, 7);

		INSERT INTO `Train_Station`.`Teams` (`department_id`) VALUES
		(1), (2), (3), (4), (5), (6), (7);

		INSERT INTO `Train_Station`.`Locomotives` (`repair_team_id`, `repair`, `regular_inspection`, `scheduled_inspection`, `maintenance`, `locomotive_crew_id`) VALUES
		(3, 'Мелкий ремонт', '2024-10-01 08:00:00', '2024-10-15 08:00:00', '2024-10-30 08:00:00', 1),
		(3, 'Крупный ремонт', '2024-10-02 08:00:00', '2024-10-16 08:00:00', '2024-10-31 08:00:00', 2);

		INSERT INTO `Train_Station`.`Employees` (`full_name`, `post`, `date_of_birth`, `team_id`) VALUES
		('Иван Иванов', 'Водитель', '1980-01-01', 1),
		('Анна Петрова', 'Диспетчер', '1985-02-15', 2),
		('Алексей Смирнов', 'Ремонтник', '1990-03-20', 3),
		('Дмитрий Кузнецов', 'Путеец', '1995-04-25', 4),
		('Екатерина Соколова', 'Кассир', '2000-05-30', 5),
		('Мария Федорова', 'Служба подготовки составов', '2001-06-05', 6),
		('Ольга Морозова', 'Справочная служба', '2000-07-10', 7);

		INSERT INTO `Train_Station`.`Medical_examinations` (`employee_id`, `medical_examination`) VALUES
		(1, 'Пройден'),
		(2, 'Пройден'),
		(3, 'Пройден'),
		(4, 'Пройден'),
		(5, 'Пройден'),
		(6, 'Пройден'),
		(7, 'Предстоит пройти');

		INSERT INTO `Train_Station`.`Trains` (`type`, `train_number`, `repair_team_id`, `civil_service_team_id`, `locomotive_id`) VALUES
		('Скорый', '101', 3, 6, 1),
		('Пассажирский', '102', 3, 6, 2);

		INSERT INTO `Train_Station`.`Schedule` (`category`, `administrator_id`, `departure`, `arrival`, `train_id`, `route`) VALUES
		('Внутренний', 1, '2024-10-10 08:00:00', '2024-10-10 12:00:00', 1, 'Новосибирск-Главный - Бердск'),
		('Международный', 2, '2024-10-11 09:00:00', '2024-10-11 13:00:00', 2, 'Новосибирск-Главный - Обь');

		INSERT INTO `Train_Station`.`Tickets` (`luggage`, `passenger_id`, `status`, `price`, `flight_id`) VALUES
		(1, 1, 'Забронирован', 50, 1),
		(0, 2, 'Забронирован', 30, 2),
		(1, 3, 'Отменен', 40, 1);
		-- цикл для обновления данных
        
        WHILE i <= 7 DO
        UPDATE `Train_Station`.`Administration`
        SET `employee_id` = i
        WHERE `administrator_id` = i;

        SET i = i + 1;
    END WHILE;
	END //
DELIMITER ;
-- Выдача прав администратору базы данных ОК
-- имеет полное право доступа к БД, отвечает за её работу
GRANT ALL PRIVILEGES ON *.* TO 'administrator'@'localhost' WITH GRANT OPTION;


-- Выдача прав начальнику отдела расписаний ОК
-- планирует маршруты и разделяет их на категории
GRANT SELECT, INSERT, UPDATE, DELETE ON `train_station`.`schedule` TO 'main_dispatcher'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `train_station`.`routes` TO 'main_dispatcher'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `train_station`.`trains` TO 'main_dispatcher'@'localhost';
-- Выдача прав на вызов процедур для main_dispatcher
GRANT EXECUTE ON PROCEDURE `train_station`.`GetAvgTickets` TO 'main_dispatcher'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetRoutesByCategoryAndFlightDirection` TO 'main_dispatcher'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetPassengerStatsByDate` TO 'main_dispatcher'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetUnredeemedTicketsByFlight` TO 'main_dispatcher'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetStationsByScheduleId` TO 'main_dispatcher'@'localhost';


-- Выдача прав начальнику бригады по техническому осмотру ОК
-- просматривает расписание поездов ОК
GRANT SELECT ON `train_station`.`schedule` TO 'repair_master'@'localhost';
GRANT SELECT ON `train_station`.`routes` TO 'repair_master'@'localhost';
GRANT SELECT ON `train_station`.`trains` TO 'repair_master'@'localhost';
-- назначает время тех.осмотра; выносит решение о готовности состава отправляться в путь ОК
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`inspection` TO 'repair_master'@'localhost';
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`repair` TO 'repair_master'@'localhost';
-- формирует бригаду на каждый осмотр ОК
GRANT SELECT, UPDATE, INSERT (`team_id`) ON `train_station`.`employees` TO 'repair_master'@'localhost';
-- Выдача прав на вызов процедур для repair_master
GRANT EXECUTE ON PROCEDURE `train_station`.`GetLocomotiveStatistics` TO 'repair_master'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetStationsByScheduleId` TO 'repair_master'@'localhost';


-- Выдача прав директоу ЖД ОК
-- формирует кадровый состав железнодорожной станции; ОК
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`employees` TO 'hr_director'@'localhost';
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`departments` TO 'hr_director'@'localhost';
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`salary` TO 'hr_director'@'localhost';
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`locomotives` TO 'hr_director'@'localhost';
-- Выдача прав на вызов процедур для hr_director
GRANT EXECUTE ON `train_station`.* TO 'hr_director'@'localhost';


-- Выдача прав кассиру ОК
-- может просмотреть расписание поездов ОК
GRANT SELECT ON `train_station`.`schedule` TO 'cashier'@'localhost';
GRANT SELECT ON `train_station`.`routes` TO 'cashier'@'localhost';
GRANT SELECT (`train_id`, `train_type`, `carriage_number`) ON `train_station`.`trains` TO 'cashier'@'localhost';
-- осуществляет продажу билетов и их возврат ОК
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`tickets` TO 'cashier'@'localhost';
-- может регистрировать пользователей
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`passengers` TO 'cashier'@'localhost';
-- Выдача прав на вызов процедур для cashier
GRANT EXECUTE ON PROCEDURE `train_station`.`GetStationsByScheduleId` TO 'cashier'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetAvgTickets` TO 'cashier'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetRoutesByCategoryAndFlightDirection` TO 'cashier'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetUnredeemedTicketsByFlight` TO 'cashier'@'localhost';


-- Выдача прав пассажиру
-- может просмотреть расписание поездов
GRANT SELECT (`train_id`, `train_type`, `carriage_number`) ON `train_station`.`trains` TO 'passanger'@'localhost';
GRANT SELECT ON `train_station`.`schedule` TO 'passanger'@'localhost';
GRANT SELECT ON `train_station`.`routes` TO 'passanger'@'localhost';
-- выдача прав на вызов процедур для passanger
GRANT EXECUTE ON PROCEDURE `train_station`.`GetUnredeemedTicketsByFlight` TO 'passanger'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetStationsByScheduleId` TO 'passanger'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`GetRoutesByCategoryAndFlightDirection` TO 'passanger'@'localhost';


-- Выдача прав медцентру
-- отвечает за медосмотры
GRANT SELECT, UPDATE, INSERT, DELETE ON `train_station`.`medical_examinations` TO 'medical_center'@'localhost';
-- Может посмотреть список всех сотрудников
GRANT SELECT ON `train_station`.`employees` TO 'medical_center'@'localhost';
GRANT EXECUTE ON PROCEDURE `train_station`.`CheckAndUpdateMedicalExaminations` TO 'medical_center'@'localhost';


-- Применение привелений
FLUSH PRIVILEGES;

-- Проверка
SHOW GRANTS FOR 'administrator'@'localhost';
SELECT SLEEP(2);
SHOW GRANTS FOR 'main_dispatcher'@'localhost';
SELECT SLEEP(2);
SHOW GRANTS FOR 'repair_master'@'localhost';
SELECT SLEEP(2);
SHOW GRANTS FOR 'hr_director'@'localhost';
SELECT SLEEP(2);
SHOW GRANTS FOR 'cashier'@'localhost';
SELECT SLEEP(2);
SHOW GRANTS FOR 'passanger'@'localhost';
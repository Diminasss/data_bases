-- Показываем таблицы с данными до использования триггера
select * from `train_station`.employees;
select sleep(3);
SELECT * FROM `Train_Station`.`Medical_examinations`;
select sleep(3);

-- Вставляем строку с работником
INSERT INTO `Train_Station`.`Employees` (
    `full_name`, `post`, `date_of_birth`, `team_id`
) VALUES (
    'Михаил Ярошенко',
    'Водитель локомотива',
    '1985-03-12',
    1
);

SELECT MAX(employee_id) INTO @max_id FROM train_station.employees;

-- Изменяем строку медосмотра на пройден

UPDATE `train_station`.`medical_examinations`
    SET `medical_examination` = 'Пройден'
    WHERE `employee_id` = @max_id;
    
-- Показываем таблицы с данными после полной подготовки к использованию триггера
select * from `train_station`.employees;
select sleep(5);
SELECT * FROM `Train_Station`.`Medical_examinations`;
select sleep(5);

-- Обновляем должность тестовому человеку
UPDATE `train_station`.`employees`
    SET `post` = 'Помощник машиниста'
    WHERE `employee_id` = @max_id;
    
-- Показываем таблицы с данными после обновления данных
select * from `train_station`.employees;
select sleep(5);
SELECT * FROM `Train_Station`.`Medical_examinations`;
select sleep(5);

-- Удаялем добавленного для теста работника
DELETE FROM train_station.employees where employee_id = @max_id;

-- Проверка удаления
select * from `train_station`.employees;
select sleep(5);
SELECT * FROM `Train_Station`.`Medical_examinations`;
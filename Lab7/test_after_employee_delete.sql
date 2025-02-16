-- Показываем таблицы с данными до использования триггера
select * from `train_station`.employees;
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

-- Показываем таблицы с данными после полной подготовки к использованию триггера
select * from `train_station`.employees;
select sleep(3);

-- Удаялем добавленного для теста работника
DELETE FROM train_station.employees where employee_id = @max_id;
CALL `train_station`.`show_temp_log`();
SELECT sleep(3);

-- Проверка удаления
select * from `train_station`.employees;
select sleep(3);
SELECT * FROM `Train_Station`.`Medical_examinations`;
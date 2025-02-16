-- Показываем таблицы с данными до вставки
select * from `train_station`.employees;
select sleep(5);
SELECT * FROM `Train_Station`.`Medical_examinations`;
select sleep(5);

-- Вставляем строку с работником
INSERT INTO `Train_Station`.`Employees` (
    `full_name`, `post`, `date_of_birth`, `team_id`
) VALUES (
    'Михаил Ярошенко',
    'Водитель локомотива',
    '1985-03-12',
    1
);

-- Показываем таблицы с данными после вставки
select * from `train_station`.employees;
select sleep(5);
SELECT * FROM `Train_Station`.`Medical_examinations`;
select sleep(5);

-- Удаялем добавленного для теста работника
SELECT MAX(employee_id) INTO @max_id FROM train_station.employees;

DELETE FROM train_station.employees where employee_id = @max_id;

-- Проверка удаления
select * from `train_station`.employees;
select sleep(5);
SELECT * FROM `Train_Station`.`Medical_examinations`;
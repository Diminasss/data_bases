-- Получить данные по всем отделам и локомотивам
CALL GetEmployeeStatistics(NULL, NULL, NULL, NULL);
SELECT SLEEP(2);

-- Получить данные для отдела с ID = 1
CALL GetEmployeeStatistics(1, NULL, NULL, NULL);
SELECT SLEEP(2);

-- Получить данные для локомотива с ID = 1
CALL GetEmployeeStatistics(NULL, 1, NULL, NULL);
SELECT SLEEP(2);

-- Получить данные для сотрудников младше 40 лет
CALL GetEmployeeStatistics(NULL, NULL, 40, NULL);
SELECT SLEEP(2);

-- Получить данные для сотрудников с зарплатой не менее 50000
CALL GetEmployeeStatistics(NULL, NULL, NULL, 50000);
SELECT SLEEP(2);

--  Получить данные для отдела с ID = 1, локомотива с ID = 1, сотрудников младше 40 лет и с зарплатой не менее 50000
CALL GetEmployeeStatistics(1, 1, 40, 50000);
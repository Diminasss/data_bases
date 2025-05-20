DELIMITER $$

CREATE PROCEDURE GetLocomotiveDrivers(
    IN period_start DATE,       -- Начало периода
    IN period_end DATE,         -- Конец периода
    IN min_avg_salary DECIMAL(10, 2)  -- Минимальная средняя зарплата
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS TempResults;
    -- Временная таблица для хранения результатов
    CREATE TEMPORARY TABLE TempResults (
        employee_id INT,
        full_name VARCHAR(130),
        avg_salary DECIMAL(10, 2),
        total_flights INT
    );

    -- Заполнение временной таблицы
    INSERT INTO TempResults (employee_id, full_name, avg_salary, total_flights)
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        AVG(s.amount) AS avg_salary,
        COUNT(DISTINCT sch.flight_id) AS total_flights
    FROM
        `Train_Station`.`Employees` e
    JOIN
        `Train_Station`.`Salary` s ON e.employee_id = s.employee_id
    JOIN
        `Train_Station`.`Teams` t ON e.team_id = t.team_id
    JOIN
        `Train_Station`.`Locomotives` l ON t.team_id = l.locomotive_crew_id
    JOIN
        `Train_Station`.`Trains` tr ON l.locomotive_id = tr.locomotive_id
    JOIN
        `Train_Station`.`Schedule` sch ON tr.train_id = sch.train_id
    WHERE
        s.date BETWEEN period_start AND period_end
        AND e.post LIKE '%Машинист%'  -- Фильтр по должности "Машинист"
    GROUP BY
        e.employee_id, e.first_name, e.last_name
    HAVING
        AVG(s.amount) > min_avg_salary;

    -- Вывод результатов
    SELECT
        employee_id,
        full_name,
        avg_salary,
        total_flights
    FROM
        TempResults;

    -- Удаление временной таблицы
    DROP TEMPORARY TABLE IF EXISTS TempResults;
END$$

DELIMITER ;

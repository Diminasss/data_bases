-- ФИО и должность для сотрудника, который получает зарплату ниже среднего
CREATE OR REPLACE FUNCTION hr.get_low_price_employees()
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, job_title VARCHAR) AS $$
    SELECT e.first_name, e.last_name, j.job_title
    FROM hr.employees e
    JOIN hr.jobs j ON e.job_id = j.job_id
    WHERE e.salary < (SELECT AVG(salary) FROM hr.employees)
$$ LANGUAGE sql;

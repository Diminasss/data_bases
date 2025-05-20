DELIMITER //

CREATE PROCEDURE GetEmployeeStatistics(
    IN department_type ENUM('Отдел машинистов', 'Отдел деспетчеров', 'Отдел ремонтников', 'Отдел путейцев', 'Отдел кассиров', 'Отдел гражданской службы', 'Отдел справочной службы'),
    IN locomotive_id INT,
    IN age INT,
    IN salary_threshold INT
)
BEGIN
    -- Общее число работников в бригаде по всем параметрам
    SELECT 
        COUNT(e.employee_id) AS total_employees,
        SUM(e.standard_salary) AS total_salary,
        AVG(e.standard_salary) AS average_salary
    FROM 
        Train_Station.Employees e
    JOIN 
        Train_Station.Teams t ON e.team_id = t.team_id
    JOIN 
        Train_Station.Departments d ON t.department_id = d.department_id
    JOIN 
        Train_Station.Locomotives l ON t.team_id = l.locomotive_crew_id
    WHERE 
        d.department_type = department_type
        AND l.locomotive_id = locomotive_id
        AND YEAR(CURDATE()) - YEAR(e.date_of_birth) >= age
        AND e.standard_salary >= salary_threshold;
END //

DELIMITER ;

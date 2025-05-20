DELIMITER $$

CREATE PROCEDURE GetAvgSalaryByDepartment()
BEGIN
    SELECT 
        d.department_type AS Отдел,
        AVG(e.standard_salary) AS "Средняя зарплата"
    FROM 
        Train_Station.Departments d
    JOIN 
        Train_Station.Employees e ON e.team_id = d.department_id
    GROUP BY 
        d.department_type;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CheckAndUpdateMedicalExaminations()
BEGIN
    -- Обновление статусов
    UPDATE Medical_examinations me
    JOIN Employees e ON me.employee_id = e.employee_id
    JOIN Teams t ON e.team_id = t.team_id
    JOIN Departments d ON t.department_id = d.department_id
    SET me.status = CASE
        WHEN d.department_type = 'Отдел машинистов' AND me.date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 0
        WHEN d.department_type != 'Отдел машинистов' AND me.date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) THEN 0
        ELSE 1
    END;

    -- Вывод сотрудников, у которых медосмотр просрочен
    SELECT 
        e.employee_id,
        e.last_name,
        e.first_name,
        e.patronymic,
        d.department_type,
        me.date AS last_medical,
        me.status
    FROM Medical_examinations me
    JOIN Employees e ON me.employee_id = e.employee_id
    JOIN Teams t ON e.team_id = t.team_id
    JOIN Departments d ON t.department_id = d.department_id
    WHERE 
        (d.department_type = 'Отдел машинистов' AND me.date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH))
        OR
        (d.department_type != 'Отдел машинистов' AND me.date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR));
END$$

DELIMITER ;

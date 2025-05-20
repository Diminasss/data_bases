DELIMITER $$

CREATE TRIGGER CivilServiceTeamCheck
BEFORE INSERT ON Train_Station.Trains
FOR EACH ROW
BEGIN
    DECLARE dept_type VARCHAR(50);

    SELECT d.department_type INTO dept_type
    FROM Train_Station.Teams t
    JOIN Train_Station.Departments d ON t.department_id = d.department_id
    WHERE t.team_id = NEW.civil_service_team_id;

    IF dept_type != 'Отдел гражданской службы' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: команда должна относиться к Отделу гражданской службы.';
    END IF;
END$$



CREATE TRIGGER CivilServiceTeamCheck_Update
BEFORE UPDATE ON Train_Station.Trains
FOR EACH ROW
BEGIN
    DECLARE dept_type VARCHAR(50);

    SELECT d.department_type INTO dept_type
    FROM Train_Station.Teams t
    JOIN Train_Station.Departments d ON t.department_id = d.department_id
    WHERE t.team_id = NEW.civil_service_team_id;

    IF dept_type != 'Отдел гражданской службы' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: команда должна относиться к Отделу гражданской службы.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER RepairTeamCheck
BEFORE INSERT ON Train_Station.Repair
FOR EACH ROW
BEGIN
    DECLARE dept_type VARCHAR(50);

    -- Получаем тип отдела для repair_team_id
    SELECT d.department_type INTO dept_type
    FROM Train_Station.Teams t
    JOIN Train_Station.Departments d ON t.department_id = d.department_id
    WHERE t.team_id = NEW.repair_team_id;

    -- Проверяем, чтобы repair_team_id относился к 'Отделу ремонтников'
    IF dept_type != 'Отдел ремонтников' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Команда ремонта должна относиться к Отделу ремонтников.';
    END IF;
END$$

CREATE TRIGGER RepairTeamCheck_Update
BEFORE UPDATE ON Train_Station.Repair
FOR EACH ROW
BEGIN
    DECLARE dept_type VARCHAR(50);

    -- Получаем тип отдела для repair_team_id
    SELECT d.department_type INTO dept_type
    FROM Train_Station.Teams t
    JOIN Train_Station.Departments d ON t.department_id = d.department_id
    WHERE t.team_id = NEW.repair_team_id;

    -- Проверяем, чтобы repair_team_id относился к 'Отделу ремонтников'
    IF dept_type != 'Отдел ремонтников' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Команда ремонта должна относиться к Отделу ремонтников.';
    END IF;
END$$

DELIMITER ;

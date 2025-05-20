DELIMITER $$

CREATE TRIGGER LocomotiveTypeCheck
BEFORE INSERT ON Train_Station.Locomotives
FOR EACH ROW
BEGIN
    DECLARE dept_type VARCHAR(50);
    
    SELECT d.department_type INTO dept_type
    FROM Train_Station.Teams t
    JOIN Train_Station.Departments d ON t.department_id = d.department_id
    WHERE t.team_id = NEW.locomotive_crew_id;

    IF dept_type != 'Отдел машинистов' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: локомотивная бригада должна относиться к Отделу машинистов.';
    END IF;
END$$

CREATE TRIGGER LocomotiveTypeCheck_Update
BEFORE UPDATE ON Train_Station.Locomotives
FOR EACH ROW
BEGIN
    DECLARE dept_type VARCHAR(50);

    SELECT d.department_type INTO dept_type
    FROM Train_Station.Teams t
    JOIN Train_Station.Departments d ON t.department_id = d.department_id
    WHERE t.team_id = NEW.locomotive_crew_id;

    IF dept_type != 'Отдел машинистов' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: локомотивная бригада должна относиться к Отделу машинистов.';
    END IF;
END$$

DELIMITER ;

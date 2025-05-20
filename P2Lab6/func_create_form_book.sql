CREATE OR REPLACE FUNCTION select_data(id_dept INTEGER) RETURNS SETOF departments AS $$

    SELECT * FROM departments WHERE departments.department_id > id_dept ORDER BY departments.department_id;

$$ LANGUAGE sql;

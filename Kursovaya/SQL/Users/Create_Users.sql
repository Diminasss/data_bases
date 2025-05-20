DROP USER IF EXISTS 
    'main_dispatcher'@'localhost',
    'repair_master'@'localhost',
    'administrator'@'localhost',
    'hr_director'@'localhost',
    'cashier'@'localhost',
    'passanger'@'localhost',
    'medical_center'@'localhost';
    
-- Начальник отдела расписаний
CREATE USER IF NOT EXISTS 'main_dispatcher'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'main_dispatcher_pass';
-- Начальник бригады по техническому осмотру
CREATE USER IF NOT EXISTS 'repair_master'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'repair_master_pass';
-- Адмитристратор базы данных
CREATE USER IF NOT EXISTS 'administrator'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'administrator_pass';
-- Диркектор ЖД
CREATE USER IF NOT EXISTS 'hr_director'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'hr_director_pass';
-- Кассир
CREATE USER IF NOT EXISTS 'cashier'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'cashier_pass';
-- Пассажир
CREATE USER IF NOT EXISTS 'passanger'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'passanger_pass';
-- Медицинский центр
CREATE USER IF NOT EXISTS 'medical_center'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'medical_center_pass';

SELECT User, Host FROM mysql.user;
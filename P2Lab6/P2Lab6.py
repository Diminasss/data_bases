import sqlalchemy
from sqlalchemy import create_engine, text, inspect
from sqlalchemy import String, Integer, Column, ForeignKey, func
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv
from os import getenv
from random import choice

Base = declarative_base()


class Employee(Base):
    __tablename__ = 'employees'
    __table_args__ = {'schema': 'hr'}
    employee_id = Column(Integer, primary_key=True, nullable=False)
    first_name = Column(String(20), nullable=False)
    last_name = Column(String(25), nullable=False)
    job_id = Column(String(10), ForeignKey("jobs.job_id"), nullable=False)
    salary = Column(Integer, nullable=True)
    manager_id = Column(Integer)
    department_id = Column(Integer, ForeignKey("departments.department_id"), nullable=False)
    location_id = Column(Integer, ForeignKey("locations.location_id"), nullable=False)

    def __repr__(self):
        return f"employee_id: {self.employee_id}, first_name: {self.first_name}, last_name: {self.last_name}, job_id: {self.job_id}, salary: {self.salary}, manager_id: {self.manager_id}, department_id: {self.department_id}"


class Department(Base):
    __tablename__ = 'departments'
    __table_args__ = {'schema': 'hr'}
    department_id = Column(Integer, primary_key=True, nullable=False)
    department_name = Column(String(30), nullable=False)
    manager_id = Column(Integer, ForeignKey("employees.employee_id"))


class Job(Base):
    __tablename__ = 'jobs'
    __table_args__ = {'schema': 'hr'}
    job_id = Column(String(10), primary_key=True, nullable=False)
    job_title = Column(String(35), nullable=False)
    min_salary = Column(Integer)
    max_salary = Column(Integer)


class Location(Base):
    __tablename__ = 'locations'
    __table_args__ = {'schema': 'hr'}

    location_id = Column(Integer, primary_key=True, nullable=False)
    location_name = Column(String(30), nullable=False)
    location_index = Column(String(20), nullable=False)


if __name__ == '__main__':
    load_dotenv()  # Загрузка секретных переменных
    # Секретное формирование ссылки для подключения к БД
    postgres_link = f"{getenv("DBTYPE")}+{getenv("PSQLDRIVER")}://{getenv("DBUSERNAME")}:{getenv("PASSWORD")}@{getenv("HOST")}:{getenv("PORT")}/{getenv("DATABASE")}"
    engine = create_engine(postgres_link)  # Создание движка для работы с БД
    Base.metadata.create_all(engine)  # Создание всех таблиц
    Session = sessionmaker(bind=engine)  # Фабрика сессий

    # Создание сессии для работы с базой данных для добавления данных в таблицу locations
    with Session() as session:
        if session.query(func.count(Location.location_id)).scalar() == 0:

            # SQL-запросы для вставки данных
            sql_queries = [
                "INSERT INTO locations VALUES (1, 'Roma', '00989');",
                "INSERT INTO locations VALUES (2, 'Venice', '10934');",
                "INSERT INTO locations VALUES (3, 'Tokyo', '1689');",
                "INSERT INTO locations VALUES (4, 'Hiroshima', '6823');",
                "INSERT INTO locations VALUES (5, 'Southlake', '26192');",
                "INSERT INTO locations VALUES (6, 'South San Francisco', '99236');",
                "INSERT INTO locations VALUES (7, 'South Brunswick', '50090');",
                "INSERT INTO locations VALUES (8, 'Seattle', '98199');",
                "INSERT INTO locations VALUES (9, 'Toronto', 'M5V 2L7');",
                "INSERT INTO locations VALUES (10, 'Whitehorse', 'YSW 9T2');"
            ]

            # Выполнение SQL-запросов по одному
            for query in sql_queries:
                session.execute(text(query))
            # Фиксация изменений в базе данных
            session.commit()
        else:
            pass

    # Создание колонки в том случае, если её ещё нет
    try:
        with Session() as session:
            inspector = inspect(engine)
            columns = inspector.get_columns('employees', schema='hr')
            columns = [column['name'] for column in columns]
            new_column_name = 'location_id'
            if new_column_name not in columns:
                print(f"Создание колонки {new_column_name}")
                session.execute(text(
                    f"""
                    ALTER TABLE hr.employees ADD COLUMN {new_column_name} INTEGER REFERENCES hr.locations({new_column_name});
                    """
                ))
                session.commit()
                print(f"Колонка {new_column_name} добавлена")
            else:
                print(f"Колонка уже {new_column_name} существует")
    except Exception as e:
        print("ERROR", e)

    # Заполнение location_id только тех строк, где значение null
    with Session() as session:
        location_ids = [x[0] for x in session.query(Location.location_id).all()]
        employee_ids = [x[0] for x in session.query(Employee.employee_id).where(Employee.location_id.is_(None))]
        if len(location_ids) == 0:
            print("Локации отсутствуют")
        elif len(employee_ids) == 0:
            print("Работники отсутствуют")
        else:
            for employee_id in employee_ids:
                session.query(Employee).where(Employee.employee_id == employee_id).update({Employee.location_id: choice(location_ids)}, synchronize_session='evaluate')
            session.commit()
            print("Все ID вставлены")

    # Найти средние зарплаты по каждому из отделов(можно ли как - то округлить полученные значения?).
    with Session() as session:
        temp = (
            session
            .query(
                Employee.department_id,
                func.round(func.avg(Employee.salary), 2)
            )
            .group_by(Employee.department_id)
            .order_by(func.round(Employee.department_id))
        )

        print(f"{'Отдел':<10} | {'Средняя зарплата':>15}")
        print("-" * 28)
        for dept, avg_salary in temp:
            print(f"{str(dept):<10} | {avg_salary:>15.2f}")

    # Вывести названия должностей и количество сотрудников, соответствующих им. Отсортировать данные по убыванию числа сотрудников.
    with Session() as session:
        temp = (
            session.query(Job.job_title, func.count(Employee.employee_id))
            .join(Employee, Employee.job_id == Job.job_id)
            .group_by(Job.job_title)
            .order_by(func.count(Employee.employee_id).desc())
            .all()
        )
        print(f"{'Должность':<35} | {'Сотрудников':>11}")
        print("-" * 50)
        for job_title, count in temp:
            print(f"{job_title:<35} | {count:>11}")

    # Количество сотрудников по городам
    with Session() as session:
        result = (
            session.query(Location.location_name, func.count(Employee.employee_id).label("emp_count"))
            .join(Employee, Employee.location_id == Location.location_id)
            .group_by(Location.location_name)
            .order_by(func.count(Employee.employee_id).desc())
            .all()
        )

        print(f"{'Местоположение':<30} | {'Сотрудников':>11}")
        print("-" * 45)
        for location_name, count in result:
            print(f"{location_name:<30} | {count:>11}")

    # Вызов хранимой функции
    with Session() as session:
        result = session.execute(text("SELECT * FROM select_data(:id_dept)"), {"id_dept": 30}).fetchall()
        print(f"{'ID':<3} | {'Одел':^20} | {'Manager ID':<3}")
        for row in result:
            print(f"{row[0]:<3} | {row[1]:^20} | {row[2]:<3}")

    # Создание функции с для получения ФИО и должности для сотрудника, который получает зарплату ниже среднего
    try:
        with open('func_create_form_book.sql', 'r', encoding='utf-8') as file:
            sql_script = text(file.read())
        with Session() as session:
            session.execute(sql_script)
            session.commit()
        print("Фукнция успешно создана")
    except Exception as error:
        print(error)

    with Session() as session:
        result = session.execute(text("SELECT * FROM hr.get_low_price_employees();"))
        for row in result:
            print(row)
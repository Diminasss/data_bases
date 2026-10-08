# Часть 2. Лабораторная работа №6. PostgreSQL и Python

## Цель работы

Организовать работу Python с PostgreSQL через SQLAlchemy: изменить схему учебной базы `hr`, выполнить аналитические запросы и вызвать пользовательские SQL-функции.

## Что реализовано

- ORM-модели `employees`, `departments`, `jobs` и `locations`;
- создание и заполнение таблицы `hr.locations`;
- добавление `location_id` в `hr.employees` и заполнение случайными значениями;
- средняя зарплата по отделам;
- количество сотрудников по должностям и городам;
- функции `select_data(id_dept)` и `hr.get_low_price_employees()`.

## Файлы

| Файл | Назначение |
| --- | --- |
| [`P2Lab6.py`](P2Lab6.py) | Работа со схемой и аналитические запросы |
| [`func_create_form_book.sql`](func_create_form_book.sql) | Функция `select_data` |
| [`func_create_own.sql`](func_create_own.sql) | Сотрудники с зарплатой ниже средней |
| [`requirements.txt`](requirements.txt) | Зависимости Python |
| [`Ч2Лаб6_отчёт.pdf`](Ч2Лаб6_отчёт.pdf) | Отчёт по работе |

## Настройка

Требуются Python 3.12+, PostgreSQL 13+ и учебная схема `hr` с таблицами `employees`, `departments` и `jobs`.

Создайте `.env` рядом со скриптом:

```dotenv
DBTYPE=postgresql
PSQLDRIVER=psycopg2
DBUSERNAME=postgres
PASSWORD=your_password
HOST=localhost
PORT=5432
DATABASE=your_database
```

Установите зависимости, выполните оба SQL-файла в PostgreSQL, затем запустите программу:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python P2Lab6.py
```

## Результат

Python-приложение изменяет структуру PostgreSQL, заполняет связанные данные и выполняет агрегатные запросы и пользовательские функции.

> Отдельных изображений в каталоге нет; результаты выполнения приведены в PDF-отчёте.

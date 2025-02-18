import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import pymysql.cursors


# Установка связи между Python и MySQL
connection: pymysql.connect = pymysql.connect(host="localhost",
                                              user="root",
                                              password="qwerty",
                                              db="train_station",
                                              charset="utf8mb4",
                                              cursorclass=pymysql.cursors.DictCursor)


# Вывод с данными всей таблицы
with connection.cursor() as cursor:
    query: str = "SELECT * FROM `administration`;"
    cursor.execute(query)
    rows = cursor.fetchall()
    df: pd.DataFrame = pd.DataFrame(rows).reset_index(drop=True)
    print("Все данные таблицы 'administration'")
    print(df)


# Вывод данных с использованием агрегатной функции count, создание круговой диаграммы
with connection.cursor() as cursor:
    query: str = """
    SELECT SUM(CASE WHEN medical_examination='Пройден' THEN 1 ELSE 0 END) AS 'Пройден', SUM(CASE WHEN medical_examination="Предстоит пройти" THEN 1 ELSE 0 END) AS 'Предстоит пройти' FROM `medical_examinations`;"""

    cursor.execute(query)
    rows = cursor.fetchall()

    df: pd.DataFrame = pd.DataFrame(rows).T.reset_index()
    df.columns = ["Статус", "Количество"]

    plt.figure(figsize=(8, 8))
    plt.pie(x=df["Количество"],
            labels=df["Статус"],
            startangle=140,
            colors=["lightgreen", "red"],
            autopct='%1.1f%%',
            shadow=True)
    plt.title(f"Статус медосмотра по количеству людей - \nвсего {sum(df["Количество"])} записей", fontsize=20)
    plt.savefig("Графики/pie.png")


# Вывод данных с использованием группировки, создание столбчатой диаграммы
with connection.cursor() as cursor:
    query: str = "SELECT status AS 'Статус', COUNT(*) AS 'Количество' FROM tickets GROUP BY status;"
    cursor.execute(query)
    rows = cursor.fetchall()

    df: pd.DataFrame = pd.DataFrame(rows)

    plt.figure(figsize=(10, 8))
    plt.bar(df["Статус"], df["Количество"])
    plt.title('Количество билетов по статусу', fontsize=20)
    plt.xlabel('Статус', fontsize=15)
    plt.ylabel('Количество', fontsize=15)

    plt.savefig("Графики/bars.png")


# Вывод данных с использованием сортировки
with connection.cursor() as cursor:
    query: str = "SELECT * FROM `employees` ORDER BY date_of_birth;"
    cursor.execute(query)
    rows = cursor.fetchall()

    df: pd.DataFrame = pd.DataFrame(rows)

    df['date_of_birth'] = pd.to_datetime(df['date_of_birth'])
    df['age'] = (datetime.today().date().year - df['date_of_birth'].dt.year)

    df.plot(x="age", y="age", kind="scatter")
    plt.xlabel("Возраст (лет)")
    plt.ylabel("Возраст (лет)")
    plt.title("Распределение людей по возрасту")
    plt.savefig("Графики/plot.png")

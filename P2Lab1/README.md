# MySQL и Python: Визуализация данных

## 📌 Описание проекта
Данный проект демонстрирует работу с базой данных MySQL с помощью Python, включая выполнение SQL-запросов и визуализацию данных. В качестве предметной области рассматривается **информационная система железнодорожной пассажирской станции**.

## 🎯 Цель
- Установить связь между MySQL и Python.
- Извлечь данные из базы и провести анализ.
- Визуализировать результаты с помощью графиков.

## 🗂 Структура базы данных
**Основные таблицы:**
- `administration` – администрация станции
- `medical_examinations` – информация о медосмотрах работников
- `tickets` – статус билетов
- `employees` – информация о сотрудниках

## 🔄 Выполненные SQL-запросы
1. **Вывод всех данных из таблицы `administration`**:
   ```python
   with connection.cursor() as cursor:
       query = "SELECT * FROM `administration`;"
       cursor.execute(query)
       rows = cursor.fetchall()
   ```
2. **Анализ медосмотров сотрудников с построением круговой диаграммы**:
   ```python
   with connection.cursor() as cursor:
       query = """
       SELECT SUM(CASE WHEN medical_examination='Пройден' THEN 1 ELSE 0 END) AS 'Пройден',
              SUM(CASE WHEN medical_examination='Предстоит пройти' THEN 1 ELSE 0 END) AS 'Предстоит пройти'
       FROM `medical_examinations`;
       """
       cursor.execute(query)
       rows = cursor.fetchall()
   ```
3. **Анализ количества билетов по статусу с построением столбчатой диаграммы**:
   ```python
   with connection.cursor() as cursor:
       query = "SELECT status AS 'Статус', COUNT(*) AS 'Количество' FROM tickets GROUP BY status;"
       cursor.execute(query)
       rows = cursor.fetchall()
   ```
4. **Распределение сотрудников по возрасту с построением графика**:
   ```python
   with connection.cursor() as cursor:
       query = "SELECT * FROM `employees` ORDER BY date_of_birth;"
       cursor.execute(query)
       rows = cursor.fetchall()
   ```

## 📊 Визуализация данных
Все полученные данные были визуализированы с помощью `matplotlib`:
- **Круговая диаграмма** – процент сотрудников, прошедших медосмотр.
- **Столбчатая диаграмма** – количество билетов по статусу.
- **Точечный график** – распределение сотрудников по возрасту.

## 🛠 Используемые технологии
- **MySQL** – хранилище данных
- **Python (pymysql, pandas, matplotlib)** – работа с БД и визуализация
- **Jupyter Notebook / PyCharm** – среда разработки

## 📌 Как использовать
1. Клонируйте репозиторий:
   ```sh
   git clone https://github.com/yourusername/mysql-python-visualization.git
   ```
2. Установите зависимости:
   ```sh
   pip install pymysql pandas matplotlib
   ```
3. Настройте подключение к MySQL в файле `config.py`.
4. Запустите Python-скрипт и изучите результаты.

## 👨‍💻 Автор
**Никитин Дмитрий** – студент ГУАП, Санкт-Петербург. Разработка в рамках курса "Базы данных".

---
⭐ Если проект оказался полезным, не забудьте поставить звезду на GitHub!


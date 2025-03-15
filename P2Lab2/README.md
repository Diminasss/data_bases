# ChoirMusic Database Migration

## 📌 Описание проекта
Этот проект демонстрирует процесс миграции базы данных **ChoirMusic.accdb** из Microsoft Access в MySQL с использованием ODBC-драйвера. Работа включает подготовку данных, экспорт таблиц и восстановление связей между ними с помощью SQL-запросов.

- [Ссылка на источник базы данных Access](https://drive.google.com/drive/folders/1-0A0vC8ip8pBHNAUZVa6MKpe7KSQVX0w)
- [Ссылка на коннектор](https://dev.mysql.com/downloads/connector/odbc/)

## 🎯 Цель
Осуществить перенос базы данных ChoirMusic из среды Microsoft Access в MySQL, сохранив структуру данных и связи между таблицами.

## 🗂 Структура базы данных
### Таблицы:
- **ChoirMember** – участники хора
- **Composor** – композиторы
- **Work** – произведения
- **MusicalWork** – музыкальные работы
- **Checkout** – записи о выдаче произведений

### Связи между таблицами
В процессе миграции были восстановлены связи между таблицами с использованием первичных и внешних ключей.

## 🔄 Процесс миграции
1. **Подготовка** – база ChoirMusic.accdb была приведена в соответствующий вид (переведены названия на английский, установлены внешние ключи).
2. **Экспорт данных** – таблицы были экспортированы через ODBC-драйвер версии 9.1 с поддержкой UNICODE.
3. **Перенос в MySQL** – после импорта данных выполнено создание первичных и внешних ключей для обеспечения целостности данных.

## 💾 SQL-код для создания ключей
```sql
ALTER TABLE `choirmusic`.`choirmember`
MODIFY COLUMN Memberid INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (Memberid);

ALTER TABLE `choirmusic`.`checkout`
ADD CONSTRAINT fk_memberid_checkout
FOREIGN KEY (Memberid) REFERENCES `choirmusic`.`choirmember`(Memberid)
ON DELETE CASCADE ON UPDATE CASCADE;
```
_(Полный SQL-код доступен в файле .sql.)_

## 📷 Скриншоты
Схема базы данных в Access и MySQL Workbench:
- ![Access Schema](/screenshots/access_schema.png)
- ![MySQL Schema](/screenshots/mysql_schema.png)

## 🛠 Используемые технологии
- **Microsoft Access** – исходная база данных
- **MySQL Workbench** – среда для работы с MySQL
- **ODBC Driver 9.1** – инструмент для экспорта данных

## 📜 Вывод
Миграция успешно выполнена, данные перенесены без потерь, связи между таблицами восстановлены. Проект демонстрирует эффективный способ миграции БД между различными СУБД с использованием ODBC.

## 📌 Как использовать
1. Клонируйте репозиторий:
   ```sh
   git clone https://github.com/Diminasss/data_bases.git
   ```
2. Запустите MySQL и выполните SQL-скрипты для создания таблиц и ключей.
3. Используйте MySQL Workbench для управления данными.

## 👨‍💻 Автор
**Никитин Дмитрий** – студент ГУАП, Санкт-Петербург. Разработка в рамках курса "Базы данных".

---
⭐ Если проект оказался полезным, не забудьте поставить звезду на GitHub!


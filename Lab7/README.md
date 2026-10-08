# Лабораторная работа №7. Триггеры MySQL

## Цель работы

Автоматизировать обработку связанных данных при добавлении, изменении и удалении сотрудников железнодорожной станции.

## Реализованные триггеры

| Триггер | Событие | Действие |
| --- | --- | --- |
| `Medical_after_employee_insert` | `AFTER INSERT` | Создаёт запись о предстоящем медосмотре нового сотрудника |
| `after_employee_update` | `AFTER UPDATE` | При смене должности сбрасывает статус медосмотра |
| `check_employee_before_delete` | `BEFORE DELETE` | Сохраняет сведения об удаляемом сотруднике в `temp_log` |

Для просмотра журнала удаления создаётся процедура `show_temp_log`.

## Файлы

- [`Medical_after_employee_insert.sql`](Medical_after_employee_insert.sql) и [`test_mediacal_after_employee_insert.sql`](test_mediacal_after_employee_insert.sql);
- [`Medical_after_employee_update.sql`](Medical_after_employee_update.sql) и [`test_mediacal_after_employee_update.sql`](test_mediacal_after_employee_update.sql);
- [`after_employee_delete.sql`](after_employee_delete.sql) и [`test_after_employee_delete.sql`](test_after_employee_delete.sql);
- [`Рабочиекоманды.sql`](Рабочиекоманды.sql) — вспомогательные команды;
- [`Лаб7_отчёт.pdf`](Лаб7_отчёт.pdf) — отчёт.

## Запуск

1. Разверните базу `Train_Station` из предыдущих работ.
2. Выполните три файла с определениями триггеров.
3. Запустите соответствующие тестовые сценарии.
4. Проверьте таблицу `Medical_examinations` и результат `CALL show_temp_log();`.

## Результат

Целостность данных о сотрудниках и медосмотрах поддерживается автоматически на уровне MySQL.

> Отдельных изображений в каталоге нет; результаты тестов включены в PDF-отчёт.

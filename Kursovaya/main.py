from PyQt5.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QTabWidget, QLabel, QPushButton,
    QComboBox, QTextEdit, QFormLayout, QLineEdit, QDateEdit, QMessageBox,
    QTableWidget, QTableWidgetItem, QScrollArea, QSizePolicy
)
from PyQt5.QtCore import QDate
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.pyplot as plt
import pymysql
from decimal import Decimal
from dotenv import load_dotenv
from os import getenv
from datetime import datetime
import sys

load_dotenv()


class LoginWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.main_app = None
        self.setWindowTitle("Вход в систему")
        self.setGeometry(150, 150, 300, 200)

        layout = QFormLayout()

        self.password_input = QLineEdit()
        self.password_input.setEchoMode(QLineEdit.Password)

        self.username_combo = QComboBox()
        self.usernames = [
            "main_dispatcher", "repair_master", "administrator",
            "hr_director", "cashier", "passanger", "medical_center"
        ]
        self.username_combo.addItems(self.usernames)

        self.login_button = QPushButton("Войти")
        self.login_button.clicked.connect(self.handle_login)

        layout.addRow("Пароль:", self.password_input)
        layout.addRow("Роль:", self.username_combo)
        layout.addRow(self.login_button)

        self.setLayout(layout)

        self.login_data = {}

    def handle_login(self):

        password = self.password_input.text().strip()
        username = self.username_combo.currentText()

        if not username and not password:
            QMessageBox.warning(self, "Ошибка входа", "Пожалуйста, заполните все поля.")
            return

        # Здесь можно вставить вашу проверку логина и пароля

        self.login_data = {
            "username": username,
            "password": password,
        }
        self.accept_login()

    def accept_login(self):
        self.close()
        self.main_app = TrainStationApp(self.login_data)
        self.main_app.show()


class TrainStationApp(QWidget):
    def __init__(self, login_data):
        super().__init__()
        self.form_layout = None
        self.params_widgets = None
        self.execute_button = None
        self.proc_table_result = None
        self.table_tab = None
        self.table_combo = None
        self.tables = None
        self.show_table_button = None
        self.table_result = None
        self.procedures = None
        self.procedure_combo = None
        self.procedure_label = None
        self.proc_tab = None
        self.canvas1 = None
        self.canvas2 = None
        self.canvas3 = None
        self.chart_button = None
        self.charts_tab = None
        self.login_data = login_data  # {'username': ..., 'password': ...}
        self.setWindowTitle(f"Железнодорожная станция — {self.login_data['username']}")
        self.setGeometry(100, 100, 1000, 700)

        self.tabs = QTabWidget()
        self.layout = QVBoxLayout()
        self.layout.addWidget(self.tabs)
        self.setLayout(self.layout)

        self.init_procedure_tab()
        self.init_table_tab()
        self.init_charts_tab()  # новая вкладка диаграмм

    def init_charts_tab(self):
        self.charts_tab = QWidget()
        layout = QVBoxLayout()

        self.chart_button = QPushButton("Собрать диаграммы")
        self.chart_button.clicked.connect(self.build_charts)
        layout.addWidget(self.chart_button)

        # Обертка со скроллингом
        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)

        scroll_content = QWidget()
        scroll_layout = QVBoxLayout(scroll_content)

        # Создаем канвасы с нормальным фиксированным размером
        self.canvas1 = FigureCanvas(Figure(figsize=(8, 4)))
        self.canvas2 = FigureCanvas(Figure(figsize=(8, 4)))
        self.canvas3 = FigureCanvas(Figure(figsize=(8, 4)))

        for canvas in [self.canvas1, self.canvas2, self.canvas3]:
            canvas.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
            canvas.setMinimumSize(800, 400)  # Задать достаточную высоту

        scroll_layout.addWidget(QLabel("Средняя зарплата по отделам (столбчатая):"))
        scroll_layout.addWidget(self.canvas1)
        scroll_layout.addWidget(QLabel("Количество работников по отделам (круговая):"))
        scroll_layout.addWidget(self.canvas2)
        scroll_layout.addWidget(QLabel("Стоимость ремонта по датам (линейная):"))
        scroll_layout.addWidget(self.canvas3)

        scroll_area.setWidget(scroll_content)

        layout.addWidget(scroll_area)
        self.charts_tab.setLayout(layout)
        self.tabs.addTab(self.charts_tab, "Диаграммы")

    def build_charts(self):
        try:
            conn = pymysql.connect(
                host=getenv('HOST'),
                user=self.login_data.get('username'),
                password=self.login_data.get('password'),
                db=getenv('DB'),
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            cursor = conn.cursor()

            # Chart 1: GetAvgSalaryByDepartment
            cursor.callproc("GetAvgSalaryByDepartment")
            result1 = cursor.fetchall()
            cursor.nextset()
            ax1 = self.canvas1.figure.subplots()
            ax1.clear()
            ax1.bar([row['Отдел'] for row in result1],
                    [float(row['Средняя зарплата']) for row in result1])
            ax1.set_title("Средняя зарплата по отделам")
            ax1.set_xticklabels([row['Отдел'] for row in result1], rotation=45, ha='right')

            # Chart 2: Кол-во работников по отделам (из таблицы employees)
            cursor.execute("""
                           SELECT d.department_type, COUNT(e.employee_id) as employee_count
                           FROM Employees e
                                    JOIN Teams t ON e.team_id = t.team_id
                                    JOIN Departments d ON t.department_id = d.department_id
                           GROUP BY d.department_type;
                           """)
            result2 = cursor.fetchall()
            ax2 = self.canvas2.figure.subplots()
            ax2.clear()
            ax2.pie([row['employee_count'] for row in result2],
                    labels=[row['department_type'] for row in result2], autopct='%1.1f%%')
            ax2.set_title("Количество работников по отделам")

            # Chart 3: Стоимость ремонта по датам (таблица repair)
            cursor.execute("""
                           SELECT date, SUM(cost) as total_cost
                           FROM repair
                           GROUP BY date
                           ORDER BY date
                           """)
            result3 = cursor.fetchall()
            ax3 = self.canvas3.figure.subplots()
            ax3.clear()
            ax3.plot([row['date'] for row in result3],
                     [float(row['total_cost']) for row in result3], marker='o')
            ax3.set_title("Стоимость ремонта по датам")
            ax3.set_xlabel("Дата")
            ax3.set_ylabel("Сумма")
            ax3.tick_params(axis='x', rotation=45)

            self.canvas1.draw()
            self.canvas2.draw()
            self.canvas3.draw()

            cursor.close()
            conn.close()

        except Exception as e:
            QMessageBox.critical(self, "Ошибка", str(e))

    def init_procedure_tab(self):
        self.proc_tab = QWidget()
        proc_layout = QVBoxLayout()

        self.procedure_label = QLabel("Выберите процедуру:")
        proc_layout.addWidget(self.procedure_label)

        self.procedure_combo = QComboBox()
        self.procedures = [
            "CheckAndUpdateMedicalExaminations",
            "GetAvgSalaryByDepartment",
            "GetAvgTickets",
            "GetEmployeeStatistics",
            "GetLocomotiveDrivers",
            "GetLocomotiveStatistics",
            "GetPassengerStatsByDate",
            "GetRoutesByCategoryAndFlightDirection",
            "GetStationsByScheduleId",
            "GetUnredeemedTicketsByFlight"
        ]
        self.procedure_combo.addItems(self.procedures)
        self.procedure_combo.currentTextChanged.connect(self.update_parameters_form)
        proc_layout.addWidget(self.procedure_combo)

        self.form_layout = QFormLayout()
        self.params_widgets = {}
        proc_layout.addLayout(self.form_layout)

        self.execute_button = QPushButton("Выполнить процедуру")
        self.execute_button.clicked.connect(self.execute_procedure)
        proc_layout.addWidget(self.execute_button)

        self.proc_table_result = QTableWidget()
        self.proc_table_result.setColumnCount(0)
        self.proc_table_result.setRowCount(0)
        proc_layout.addWidget(self.proc_table_result)

        self.proc_tab.setLayout(proc_layout)
        self.tabs.addTab(self.proc_tab, "Процедуры")
        self.update_parameters_form(self.procedure_combo.currentText())

    def init_table_tab(self):
        self.table_tab = QWidget()
        table_layout = QVBoxLayout()

        self.table_combo = QComboBox()
        self.tables = [
            "departments", "employees", "inspection", "locomotives",
            "medical_examinations", "passengers", "repair", "routes",
            "salary", "schedule", "stations", "teams",
            "tickets", "trains"
        ]
        self.table_combo.addItems(self.tables)
        table_layout.addWidget(QLabel("Выберите таблицу для отображения:"))
        table_layout.addWidget(self.table_combo)

        self.show_table_button = QPushButton("Показать")
        self.show_table_button.clicked.connect(self.show_table)
        table_layout.addWidget(self.show_table_button)

        self.table_result = QTableWidget()
        table_layout.addWidget(self.table_result)

        self.table_tab.setLayout(table_layout)
        self.tabs.addTab(self.table_tab, "Просмотр таблиц")

    def execute_procedure(self):
        procedure = self.procedure_combo.currentText()
        params = []

        for key, widget in self.params_widgets.items():

            if isinstance(widget, QDateEdit):
                val = widget.date().toPyDate()
            elif isinstance(widget, QComboBox):
                val = widget.currentText().strip()
            elif isinstance(widget, QLineEdit):
                val = widget.text().strip()
                if not val:
                    QMessageBox.warning(self, "Ошибка ввода", f"Поле '{key}' не должно быть пустым.")
                    return

                if key in ['start_date', 'end_date']:
                    try:
                        val = datetime.strptime(val, "%Y-%m-%d %H:%M:%S")
                    except ValueError:
                        QMessageBox.warning(self, "Ошибка формата даты",
                                            f"Поле '{key}' должно быть в формате ГГГГ-ММ-ДД ЧЧ:ММ:СС")
                        return
                elif key == 'route_flight_id':
                    if not val.isdigit():
                        QMessageBox.warning(self, "Ошибка ввода", f"Поле '{key}' должно быть числом.")
                        return
                    val = int(val)
            else:
                QMessageBox.critical(self, "Ошибка", f"Неизвестный тип виджета для параметра '{key}'")
                return

            params.append(val)

        try:
            conn = pymysql.connect(
                host=getenv('HOST'),
                user=self.login_data.get('username'),
                password=self.login_data.get('password'),
                db=getenv('DB'),
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            cursor = conn.cursor()
            cursor.callproc(procedure, params)

            results = []
            while True:
                result = cursor.fetchall()
                if result:
                    results.extend(result)
                if not cursor.nextset():
                    break

            if not results:
                self.proc_table_result.setRowCount(0)
                self.proc_table_result.setColumnCount(0)
                QMessageBox.information(self, "Информация", "Процедура выполнена, но данных нет.")
            else:
                columns = list(results[0].keys())
                self.proc_table_result.setColumnCount(len(columns))
                self.proc_table_result.setRowCount(len(results))
                self.proc_table_result.setHorizontalHeaderLabels(columns)

                for row_idx, row_data in enumerate(results):
                    for col_idx, col_name in enumerate(columns):
                        value = row_data[col_name]
                        if isinstance(value, Decimal):
                            value = str(float(value))
                        self.proc_table_result.setItem(row_idx, col_idx, QTableWidgetItem(str(value)))

            cursor.close()
            conn.close()

        except Exception as e:
            QMessageBox.critical(self, "Ошибка", str(e))

    def update_parameters_form(self, procedure_name):
        self.clear_form()

        param_map = {
            "GetEmployeeStatistics": {
                "department_type": "enum",
                "locomotive_id": "int",
                "age": "int",
                "salary_threshold": "int"
            },
            "GetLocomotiveDrivers": {
                "period_start": "date",
                "period_end": "date",
                "min_avg_salary": "float"
            },
            "GetLocomotiveStatistics": {
                "start_date": "date",
                "end_date": "date",
                "repair_count": "int"
            },
            "GetAvgTickets": {
                "start_date": "datetime",
                "end_date": "datetime",
                "route_flight_id": "int"
            },
            "GetRoutesByCategoryAndFlightDirection": {
                "route_category": "enum",
                "direction_flight_id": "int"
            },
            "GetPassengerStatsByDate": {
                "target_date": "date"
            },
            "GetUnredeemedTicketsByFlight": {
                "in_flight_id": "int"
            },
            "GetStationsByScheduleId": {
                "in_schedule_id": "int"
            },
            # процедуры без параметров
            "CheckAndUpdateMedicalExaminations": {},
            "GetAvgSalaryByDepartment": {}
        }

        enums = {
            "department_type": [
                'Отдел машинистов', 'Отдел деспетчеров', 'Отдел ремонтников',
                'Отдел путейцев', 'Отдел кассиров', 'Отдел гражданской службы',
                'Отдел справочной службы'
            ],
            "route_category": [
                'Внутренний', 'Международный', 'Туристический', 'Специальный'
            ]
        }

        if procedure_name not in param_map:
            return

        for param, param_type in param_map[procedure_name].items():
            if param_type == "date":
                widget = QDateEdit()
                widget.setCalendarPopup(True)
                widget.setDate(QDate.currentDate())
                widget.setToolTip("Дата в формате: ГГГГ-ММ-ДД")
            elif param_type == "datetime":
                widget = QLineEdit()
                widget.setPlaceholderText("ГГГГ-ММ-ДД ЧЧ:ММ:СС")
                widget.setToolTip("Введите дату и время (например: 2025-05-01 14:00:00)")
            elif param_type == "int":
                widget = QLineEdit()
                widget.setPlaceholderText("Целое число")
                widget.setToolTip("Введите целое число")
            elif param_type == "float":
                widget = QLineEdit()
                widget.setPlaceholderText("Число с точкой")
                widget.setToolTip("Введите число с плавающей точкой")
            elif param_type == "enum":
                widget = QComboBox()
                widget.addItems(enums[param])
                widget.setToolTip("Выберите из списка")
            else:
                widget = QLineEdit()
                widget.setToolTip("Введите значение")

            self.form_layout.addRow(param, widget)
            self.params_widgets[param] = widget

    def show_table(self):
        table = self.table_combo.currentText()

        try:
            conn = pymysql.connect(
                host=getenv('HOST'),
                user=self.login_data.get('username'),
                password=self.login_data.get('password'),
                db=getenv('DB'),
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            cursor = conn.cursor()
            cursor.execute(f"SELECT * FROM {table}")
            result = cursor.fetchall()

            if not result:
                self.table_result.setRowCount(0)
                self.table_result.setColumnCount(0)
                QMessageBox.information(self, "Информация", "Таблица пуста.")
                return

            columns = list(result[0].keys())
            self.table_result.setColumnCount(len(columns))
            self.table_result.setRowCount(len(result))
            self.table_result.setHorizontalHeaderLabels(columns)

            for row_idx, row_data in enumerate(result):
                for col_idx, col in enumerate(columns):
                    self.table_result.setItem(row_idx, col_idx, QTableWidgetItem(str(row_data[col])))

            cursor.close()
            conn.close()

        except Exception as e:
            QMessageBox.critical(self, "Ошибка", str(e))

    def clear_form(self):
        for i in reversed(range(self.form_layout.count())):
            widget = self.form_layout.itemAt(i).widget()
            if widget:
                widget.setParent(None)
        self.params_widgets.clear()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    login = LoginWindow()
    login.show()
    # window = TrainStationApp()
    # window.show()
    sys.exit(app.exec_())

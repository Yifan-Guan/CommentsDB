import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QSizePolicy, QMessageBox
from gui.main_window import GMainWindow
from database.manager import DBManager


class GLogin(QMainWindow):
    def __init__(self, manager):
        super().__init__()
        self.main_window_ui = None
        self.main_widget = QWidget()
        self.manager = manager
        self.user_name = ""
        self.user_password = ""
        self.label_font = QFont("SimHei", 20)
        self.title_font = QFont("Roman times", 40)
        self.input_user_name = QLineEdit("comment_manager")
        self.input_user_password = QLineEdit("123456")
        self.button_login = QPushButton(" Log in ")
        self.init_ui()

    def init_ui(self):
        self.setWindowTitle("Log in")
        self.resize(600, 400)

        self.setCentralWidget(self.main_widget)
        layout = QVBoxLayout()
        self.main_widget.setLayout(layout)
        label_title = QLabel("COMMENTS")
        label_user_name = QLabel("Name:")
        label_user_password = QLabel("Password:")

        label_title.setFont(self.title_font)
        label_user_name.setFont(self.label_font)
        label_user_password.setFont(self.label_font)
        self.input_user_name.setFont(self.label_font)
        self.input_user_password.setFont(self.label_font)
        self.button_login.setFont(self.label_font)

        title_layout = QHBoxLayout()
        title_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        title_layout.addWidget(label_title)
        title_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        label_layout = QVBoxLayout()
        label_layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))
        label_layout.addWidget(label_user_name)
        label_layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))
        label_layout.addWidget(label_user_password)
        label_layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))
        input_layout = QVBoxLayout()
        input_layout.addWidget(self.input_user_name)
        input_layout.addWidget(self.input_user_password)
        hint_layout = QHBoxLayout()
        hint_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        hint_layout.addLayout(label_layout)
        hint_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        hint_layout.addLayout(input_layout)
        hint_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        button_layout = QHBoxLayout()
        button_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        button_layout.addWidget(self.button_login)
        button_layout.addSpacerItem(QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))
        layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))
        layout.addLayout(title_layout)
        layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))
        layout.addLayout(hint_layout)
        layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))
        layout.addLayout(button_layout)
        layout.addSpacerItem(QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding))

        self.button_login.clicked.connect(self.db_login)

    def db_login(self):
        self.user_name = self.input_user_name.text()
        self.user_password = self.input_user_password.text()
        self.manager.connect(self.user_name, self.user_password)
        if self.manager.connected:
            self.manager.close_connect()
            self.main_window_ui = GMainWindow(self.user_name, self.user_password)
            self.main_window_ui.show()
            self.close()
        else:
            QMessageBox.critical(self, "Error", "DB connect failure!",
                                 QMessageBox.Yes | QMessageBox.No, QMessageBox.Yes)



if __name__ == "__main__":
    app = QApplication(sys.argv)
    login = GLogin(DBManager())
    login.show()
    sys.exit(app.exec_())

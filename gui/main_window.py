import sys
from PyQt5.QtWidgets import *
from PyQt5.QtWidgets import QMessageBox
from data_display_table import GDataDisplayTable
from database.manager import DBManager

class GMainWindow(QMainWindow):
    def __init__(self, u_name, u_password):
        super().__init__()
        self.user_name = u_name
        self.user_password = u_password
        self.manager = DBManager()

        self.book_display_table = GDataDisplayTable()
        self.comment_information_display_table = GDataDisplayTable()
        self.comment_display_table = GDataDisplayTable()
        self.author_table = GDataDisplayTable()

        self.tab_widget = QTabWidget()
        self.book_name_input = QLineEdit()
        self.book_type_input = QLineEdit()

        self.input_comment_id = QLineEdit()
        self.input_comment_recommend_degree = QSpinBox()
        self.input_comment_content = QLineEdit("insert test")

        self.input_author_id = QLineEdit()
        self.input_author_name = QLineEdit()
        self.input_author_introduction = QLineEdit()

        self.init_ui()

    def init_ui(self):
        self.resize(1960, 1080)
        self.setWindowTitle("Main window")
        self.setCentralWidget(self.tab_widget)
        self.create_book_tab()
        self.create_comment_information_tab()
        self.create_comment_tab()

    def set_user(self, user_name, user_password):
        self.user_name = user_name
        self.user_password = user_password

    def create_book_tab(self):
        tab = QWidget()
        self.tab_widget.addTab(tab, "Book information")

        layout = QVBoxLayout(tab)

        self.flush_book_table()

        add_btn = QPushButton("添加书籍")

        layout.addWidget(QLabel("书名:"))
        layout.addWidget(self.book_name_input)
        layout.addWidget(add_btn)
        layout.addWidget(self.book_display_table)

    def flush_book_table(self):
        self.manager.connect(self.user_name, self.user_password)
        headers = ["book_id", "book_name", "book_type", "author_name", "book_platform_name",
                   "book_introduction", "book_url"]
        data = self.manager.get_table_content("complete_book_information")
        self.manager.close_connect()
        self.book_display_table.load_table_data(headers, data)
        self.book_display_table.update_table_display()

    def create_comment_information_tab(self):
        tab = QWidget()
        self.tab_widget.addTab(tab, "Comment information")

        layout = QVBoxLayout(tab)

        self.flush_comment_information_table()

        layout.addWidget(self.comment_information_display_table, 2)

    def flush_comment_information_table(self):
        self.manager.connect(self.user_name, self.user_password)
        headers = ["id", "create time", "reader name", "ip address", "book", "content"]
        data = self.manager.get_table_content("complete_comment_information")
        self.comment_information_display_table.load_table_data(headers, data)
        self.comment_information_display_table.update_table_display()

    def create_comment_tab(self):
        tab = QWidget()
        self.tab_widget.addTab(tab, "Comments")

        layout = QVBoxLayout(tab)

        control_layout = QHBoxLayout()
        label_layout = QVBoxLayout()
        input_layout = QVBoxLayout()
        button_layout = QVBoxLayout()
        label_comment_id = QLabel("Comment id: ")
        label_comment_recommend_degree = QLabel("Recommend degree: ")
        label_comment_content = QLabel("Comment content: ")
        button_add_comment = QPushButton("Add")
        button_delete_comment = QPushButton("Delete")
        label_layout.addWidget(label_comment_id)
        label_layout.addWidget(label_comment_recommend_degree)
        label_layout.addWidget(label_comment_content)
        input_layout.addWidget(self.input_comment_id)
        input_layout.addWidget(self.input_comment_recommend_degree)
        input_layout.addWidget(self.input_comment_content)
        button_layout.addWidget(button_add_comment)
        button_layout.addWidget(button_delete_comment)

        control_layout.addLayout(label_layout)
        control_layout.addLayout(input_layout, 2)
        control_layout.addLayout(button_layout)

        button_delete_comment.clicked.connect(self.delete_comment_by_id)
        button_add_comment.clicked.connect(self.insert_comment)

        self.flush_comment_table()

        layout.addLayout(control_layout)
        layout.addWidget(self.comment_display_table, 2)

    def flush_comment_table(self):
        self.manager.connect(self.user_name, self.user_password)
        headers = ["id", "content"]
        data = self.manager.get_table_content("book_comments")
        self.comment_display_table.load_table_data(headers, data)
        self.comment_display_table.update_table_display()

    def delete_comment_by_id(self):
        self.manager.connect(self.user_name, self.user_password)
        delete_comment_id = self.input_comment_id.text()
        delete_comment_id = int(delete_comment_id)
        success = self.manager.delete_comment(delete_comment_id)
        if success:
            QMessageBox.information(self, "Success", "Delete comment successfully",
                                    QMessageBox.Yes | QMessageBox.No, QMessageBox.Yes)
            self.flush_comment_table()
        else:
            QMessageBox.critical(self, "Error", "Delete comment error",
                                 QMessageBox.Yes | QMessageBox.No, QMessageBox.Yes)
        self.manager.close_connect()

    def insert_comment(self):
        self.manager.connect(self.user_name, self.user_password)
        insert_comment_id = self.input_comment_id.text()
        insert_comment_id = int(insert_comment_id)
        insert_comment_recommend_degree = self.input_comment_recommend_degree.value()
        insert_comment_content = self.input_comment_content.text()
        success = self.manager.insert_comment(insert_comment_content,
                                              insert_comment_recommend_degree,
                                              insert_comment_id)
        if success:
            QMessageBox.information(self, "Success", "Insert comment successfully",
                                    QMessageBox.Yes | QMessageBox.No, QMessageBox.Yes)
            self.flush_comment_table()
        else:
            QMessageBox.critical(self, "Error", "Insert comment error",
                                 QMessageBox.Yes | QMessageBox.No, QMessageBox.Yes)
        self.manager.close_connect()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    u_name = "comment_manager"
    u_password = "123456"
    window = GMainWindow(u_name, u_password)
    window.show()
    sys.exit(app.exec_())
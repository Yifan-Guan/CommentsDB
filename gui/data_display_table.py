import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QHeaderView
from database.manager import DBManager


class GDataDisplayTable(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)

        self.table = QTableWidget()
        self.headers = list()
        self.data = list()

        self.label_font = QFont("SimHei", 14)
        self.title_font = QFont("Roman times", 14)

        self.init_ui()

    def init_ui(self):
        self.resize(1600, 800)

        self.table.setEditTriggers(QTableWidget.NoEditTriggers)  # 设置只读
        self.table.setSelectionBehavior(QTableWidget.SelectRows)  # 整行选中
        self.table.setSelectionMode(QTableWidget.SingleSelection)  # 单选
        self.table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeToContents)
        self.table.horizontalHeader().setFont(self.label_font)

        layout = QVBoxLayout(self)
        layout.addWidget(self.table)

    def set_column_stretch(self, cols):
        for c in cols:
            self.table.horizontalHeader().setSectionResizeMode(c, QHeaderView.ResizeToContents)

    def load_table_data(self, headers, data):
        self.headers = headers
        self.data = data

    def update_table_display(self):
        # 设置行列数
        row_count = len(self.data)
        col_count = len(self.data[0]) if row_count > 0 else 0
        self.table.setRowCount(row_count)
        self.table.setColumnCount(col_count)

        # 设置表头（列名）
        self.table.setHorizontalHeaderLabels(self.headers)

        # 填充单元格数据
        for row_idx, row_data in enumerate(self.data):
            for col_idx, value in enumerate(row_data):
                item = QTableWidgetItem(str(value))
                item.setFont(self.label_font)
                self.table.setItem(row_idx, col_idx, item)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    dis = GDataDisplayTable()
    dis.show()

    m = DBManager()
    un = "comment_manager"
    pw = "123456"
    db = "comments"
    m.connect(un, pw, db)
    comments = m.get_table_content("book_comments")
    headers = ["id", "recommend degree", "content"]
    m.close_connect()

    dis.load_table_data(headers, comments)
    # dis.set_column_stretch([0, 1])
    dis.update_table_display()

    sys.exit(app.exec_())
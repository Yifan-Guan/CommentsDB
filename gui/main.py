import sys
from PyQt5.QtWidgets import *
from login import GLogin
from database.manager import DBManager

if __name__ == "__main__":
    app = QApplication(sys.argv)
    login = GLogin(DBManager())
    login.show()
    sys.exit(app.exec_())
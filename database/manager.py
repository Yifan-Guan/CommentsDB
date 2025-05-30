import mysql.connector

class manager:
    def __init__(self):
        self.db_connect = mysql.connector.connect(
            host="localhost",
            user="comment_manager",
            password="123456",
            database="comments"
        )
        self.cursor = self.db_connect.cursor()

    def __del__(self):
        self.cursor.close()
        self.db_connect.close()

    def show_tables(self):
        self.cursor.execute("SHOW tables;")
        return self.cursor.fetchall()

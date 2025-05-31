import mysql.connector
import mysql.connector.errors

class DBManager:
    def __init__(self):
        self.db_connect = None
        self.db_cursor = None
        self.connected = False

    def __del__(self):
        self.close_connect()

    def connect(self, username, password, database, host = "localhost"):
        try:
            self.db_connect = mysql.connector.connect(
                host=host,
                user=username,
                password=password,
                database=database
            )
            self.db_cursor = self.db_connect.cursor()
        except Exception as e:
            print("Connection failure!" + " " + repr(e))
            self.connected = False
        else:
            self.connected = True

    def close_connect(self):
        if self.connected:
            self.db_connect.close()
            self.db_cursor.close()
            self.connected = False

    def get_tables(self):
        if not self.connected:
            return tuple()
        self.db_cursor.execute("SHOW tables;")
        return self.db_cursor.fetchall()

    def get_table_content(self, name):
        if not self.connected:
            return tuple()
        try:
            self.db_cursor.execute("SELECT * FROM {name}".format(name=name))
        except Exception as e:
            print(repr(e))
            return tuple()
        else:
            return self.db_cursor.fetchall()

    def delete_comment(self, comment_id):
        instruction = """
        START TRANSACTION;
        DELETE FROM analyses WHERE analysis_comment_id = {comment_id};
        DELETE FROM views WHERE view_book_comment_id = {comment_id};
        DELETE FROM book_comments WHERE book_comment_id = {comment_id};
        COMMIT;
        """.format(comment_id = comment_id)
        self.db_cursor.execute(instruction)
        return self.db_cursor.fetchall()

if __name__ == "__main__":
    m = DBManager()
    un = "comment_manager"
    pw = "123456"
    db = "comments"
    m.connect(un, pw, db)
    if m.connected:
        print("Connect success")
    tables = m.get_tables()
    for t in tables:
        print(t)
    print()
    comments = m.get_table_content("book_comments")
    for c in comments:
        print(c)
    results = m.delete_comment(1001)
    m.close_connect()
import mysql.connector
import mysql.connector.errors

class DBManager:
    def __init__(self):
        self.db_connect = None
        self.db_cursor = None
        self.connected = False

    def __del__(self):
        self.close_connect()

    def connect(self, username, password, database = "comments", host = "localhost"):
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
            return list()
        self.db_cursor.execute("SHOW tables;")
        return self.db_cursor.fetchall()

    def get_table_content(self, name):
        if not self.connected:
            return list()
        try:
            self.db_cursor.execute("SELECT * FROM {name}".format(name=name))
        except Exception as e:
            print(repr(e))
            return list()
        else:
            return self.db_cursor.fetchall()

    def delete_comment(self, comment_id):
        if not self.connected:
            return False
        try:
            instruction = """
            START TRANSACTION;
            DELETE FROM analyses WHERE analysis_comment_id = {comment_id};
            DELETE FROM views WHERE view_book_comment_id = {comment_id};
            DELETE FROM book_comments WHERE book_comment_id = {comment_id};
            COMMIT;
            """.format(comment_id = comment_id)
            self.db_cursor.execute(instruction)
        except Exception as e:
            print("Delete comment error " + repr(e))
            return False
        else:
            return True

    def insert_comment(self, content, recommend_degree, comment_id=None):
        if not self.connected:
            return False
        if comment_id is None:
            instruction = """
            INSERT INTO book_comments (
            recommendation_degree,
            book_comment_content
            )
            VALUES 
            ({r_d}, "{content}");
            """.format(r_d = recommend_degree, content = content)
        else:
            instruction = """
            INSERT INTO book_comments (
            book_comment_id,
            recommendation_degree,
            book_comment_content
            )
            VALUES 
            ({id}, {r_d}, "{content}");
            """.format(id = comment_id, r_d = recommend_degree, content = content)
        try:
            self.db_cursor.execute(instruction)
            self.db_connect.commit()
        except Exception as e:
            print("Insert comment error " + str(e))
            return False
        else:
            return True

    def update_author_information(self, u_id, u_name, u_introduction):
        if not self.connected:
            return False
        instruction = """
        call update_author_information({u_id}, "{u_name}", "{u_introduction}");
        """.format(u_id = u_id, u_name = u_name, u_introduction = u_introduction)
        try:
            self.db_cursor.execute(instruction)
            self.db_connect.commit()
        except Exception as e:
            print("Author update error " + repr(e))
            return False
        else:
            return True

    def get_complete_book_information(self, book_name):
        if not self.connected:
            return list()
        instruction = """
        select * from complete_book_information where book_name = "{book_name}";
        """.format(book_name = book_name)
        result = list()
        try:
            self.db_cursor.execute(instruction)
            result = self.db_cursor.fetchall()
        except Exception as e:
            print("Complete book information get error " + repr(e))
        finally:
            return result



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
    print()
    ## m.delete_comment(4001)
    ## m.insert_comment("insert test", 11, 5001)
    ## m.update_author_information(6002, "Procedure test author name", "in")
    book_information = m.get_complete_book_information("Test book name")
    for bi in book_information:
        print(bi)
        print(type(bi))
    print(type(book_information))
    print()

    authors = m.get_table_content("authors")
    for a in authors:
        print(a)
    m.close_connect()
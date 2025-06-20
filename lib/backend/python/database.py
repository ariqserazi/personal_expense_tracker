import psycopg2
from psycopg2 import sql
from datetime import datetime
from google.protobuf.timestamp_pb2 import Timestamp
import expense_pb2

CATEGORY_MAP = {
    0: "UNKNOWN",
    1: "FOOD",
    2: "TRANSPORT",
    3: "SHOPPING",
    4: "ENTERTAINMENT",
    5: "BILLS",
    6: "EDUCATION",
    7: "HEALTH",
    8: "OTHER"
}

class PostgresDB:
    def __init__(self, host, dbname, user, password, port=5432):
        self.host = host
        self.dbname = dbname
        self.user = user
        self.password = password
        self.port = port
        self.connection = None

    def connect(self):
        try:
            self.connection = psycopg2.connect(
                host=self.host,
                dbname=self.dbname,
                user=self.user,
                password=self.password,
                port=self.port
            )
            print("Connection to the database established successfully.")
        except Exception as e:
            print(f"Error connecting to the database: {e}")

    def execute_query(self, query, params=None):
        if not self.connection:
            raise Exception("Database connection is not established. Call connect() first.")
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query, params)
                self.connection.commit()
        except Exception as e:
            print(f"Error executing query: {e}")

    def fetch_results(self, query, params=None):
        if not self.connection:
            raise Exception("Database connection is not established. Call connect() first.")
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query, params)
                results = cursor.fetchall()
                return results
        except Exception as e:
            print(f"Error fetching results: {e}")
            return None

    def close(self):
        if self.connection:
            self.connection.close()
            print("Connection closed successfully.")

    def insert(self, expense):
        cursor = self.connection.cursor()
        try:
            timestamp = datetime.fromtimestamp(expense.date.seconds)
            category_name = expense_pb2.ExpenseCategory.Name(expense.category)
            query = """
            INSERT INTO expenses (title, amount, category, dates)
            VALUES (%s, %s, %s, %s)
            RETURNING id;
            """
            cursor.execute(query, (expense.title, expense.amount, category_name, timestamp))
            id = cursor.fetchone()[0]
            self.connection.commit()
            return id
        except Exception as e:
            print(f"Insert did not work: {e}")
            return 0
        finally:
            cursor.close()

    def delete(self, id):
        cursor = self.connection.cursor()
        try:
            query = "DELETE FROM expenses WHERE id = %s RETURNING id;"
            cursor.execute(query, (id,))
            deleted_id = cursor.fetchone()

            check_empty_query = "SELECT COUNT(*) FROM expenses;"
            cursor.execute(check_empty_query)
            is_empty = cursor.fetchone()[0] == 0
            if is_empty:
                reset_sequence_query = "SELECT setval('expenses_id_seq', 1, false);"
                cursor.execute(reset_sequence_query)
            self.connection.commit()
            return deleted_id
        except Exception as e:
            print(f"Delete did not work: {e}")
        finally:
            cursor.close() 

    def update(self, expense):
        cursor = self.connection.cursor()
        try:
            timestamp = datetime.fromtimestamp(expense.date.seconds)
            category_name = expense_pb2.ExpenseCategory.Name(expense.category)
            query = """
            UPDATE expenses 
            SET title = %s, amount = %s, category = %s, dates = %s
            WHERE id = %s;
            """
            cursor.execute(query, (expense.title, expense.amount, category_name, timestamp, expense.id))
            self.connection.commit()
        except Exception as e:
            print(f"Update did not work: {e}")
        finally:
            cursor.close()


    def listExpenses(self):
        cursor = self.connection.cursor()
        try:
            query = "SELECT id, title, amount, category, dates FROM expenses;"
            cursor.execute(query)
            rows = cursor.fetchall()

            expenses = []
            for row in rows:
                category_name = str(row[3]).upper().strip()

                try:
                    category_enum = expense_pb2.ExpenseCategory.Value(category_name)
                except ValueError:
                    category_enum = expense_pb2.ExpenseCategory.UNKNOWN

                ts = Timestamp()
                ts.FromDatetime(row[4])

                expense = expense_pb2.Expense(
                    id=row[0],
                    title=row[1],
                    amount=float(row[2]),
                    category=category_enum,
                    date=ts
                )
                expenses.append(expense)

            return expenses
        except Exception as e:
            print(f"List Expenses did not work: {e}")
            return []
        finally:
            cursor.close()

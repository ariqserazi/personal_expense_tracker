from concurrent import futures
import logging
import math
import time

import grpc
import expense_pb2
import expense_pb2_grpc
import database

class ExpenseTrackerServicer(expense_pb2_grpc.ExpenseTrackerServicer):
    idCount = 1
    # expenses = {}
    db = database.PostgresDB(        
        host="localhost",
        dbname="postgres",
        user="postgres",
        password="password",
        port=5432)
    db.connect()
    # results = db.fetch_results("SELECT * FROM expenses;")
    # print(results)
    def CreateExpense(self, request, context):
        gen_id = 0
        # print(" L O L")
        # self.db.execute_query(f"insert into expenses (title, amount, category, dates) values ({request.expense.title}, {request.expense.amount},{request.expense.category},{request.expense.date})")
        print(f"CreateExpense: {request}")
        gen_id = self.db.insert(request.expense)
        # expense = expense_pb2.Expense(id = self.idCount, title=request.expense.title,amount=request.expense.amount, category= request.expense.category, date = request.expense.date)
        # self.expenses[self.idCount] = expense
        
        # self.idCount +=1
        if gen_id != 0:
            return expense_pb2.CreateExpenseResponse(id = gen_id, return_msg = expense_pb2.ReturnMsg(code= 0, msg= "Created"))
        
        return expense_pb2.CreateExpenseResponse(id = gen_id, return_msg = expense_pb2.ReturnMsg(code= 0, msg= "not created"))
    
    def ListExpenses(self, request, context):
        # expenses = [expense_pb2.Expense(id = 1,    title="Food Expense",amount=1.00, category= expense_pb2.ExpenseCategory.FOOD , date = "2024-11-29"),expense_pb2.Expense(id = 2, title="Shopping Expense",amount=2.00, category= expense_pb2.ExpenseCategory.SHOPPING , date = "2024-11-29")]
    
        print(f"ListExpenses: {request}")
        expenses = self.db.listExpenses()
        print(expenses)
        # print(f"expense val {expenses.values()}")
        return expense_pb2.ListExpensesResponse(expenses=expenses)
    
    def DeleteExpense(self, request, context):
        print(f"DeleteExpense: {request}")
        # print(f"key vals: {self.expenses.keys()} : {self.expenses.values()}")
        # print(f"lol {self.expenses[2]}")
        self.db.delete(request.id)
        return expense_pb2.DeleteExpenseResponse(id = request.id,  return_msg = expense_pb2.ReturnMsg(code= 0, msg= "Deleted"))

       
        # if self.expenses == []:
        #     return []]
        
    
    def UpdateExpense(self, request, context):
        print(f"UpdateExpense: {request}")
        self.db.update(request.expense)
        return expense_pb2.UpdateExpenseResponse(id = request.expense.id,  return_msg = expense_pb2.ReturnMsg(code= 0, msg= "successful"))
        
        
    
    def GetExpense(self, request, context):

        print(f"GetExpense: {request}")
        if request.id in self.expenses:
            expense = expense_pb2.Expense(id = request.id, title=self.expenses[request.id].title,amount=self.expenses[request.id].amount, category= self.expenses[request.id].category , date = self.expenses[request.id].date)
            return expense_pb2.GetExpenseResponse(expense=expense,  return_msg = expense_pb2.ReturnMsg(code= 0, msg= "Got it"))
        else: 
            return expense_pb2.GetExpenseResponse(  return_msg = expense_pb2.ReturnMsg(code= 1, msg= "Did not get it"))



def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    expense_pb2_grpc.add_ExpenseTrackerServicer_to_server(ExpenseTrackerServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("Server started")
    server.wait_for_termination()

def main():
    logging.basicConfig()
    serve()

if __name__ == '__main__':
    main()
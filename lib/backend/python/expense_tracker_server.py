from concurrent import futures
import logging
import math
import time

import grpc
import expense_pb2
import expense_pb2_grpc

class ExpenseTrackerServicer(expense_pb2_grpc.ExpenseTrackerServicer):
    idCount = 1
    expenses = {}
    def CreateExpense(self, request, context):
        # print(" L O L")
        print(f"CreateExpense: {request}")
        expense = expense_pb2.Expense(id = self.idCount, title=request.expense.title,amount=request.expense.amount, category= request.expense.category, date = request.expense.date)
        self.expenses[self.idCount] = expense
        
        self.idCount +=1
        return expense_pb2.CreateExpenseResponse(id = expense.id, return_msg = expense_pb2.ReturnMsg(code= 0, msg= "Created"))
    
    def ListExpenses(self, request, context):
        # expenses = [expense_pb2.Expense(id = 1, title="Food Expense",amount=1.00, category= expense_pb2.ExpenseCategory.FOOD , date = "2024-11-29"),expense_pb2.Expense(id = 2, title="Shopping Expense",amount=2.00, category= expense_pb2.ExpenseCategory.SHOPPING , date = "2024-11-29")]
        
        print(f"ListExpenses: {request}")
        print(f"expense val {self.expenses.values()}")
        return expense_pb2.ListExpensesResponse(expenses=self.expenses.values())
    
    def DeleteExpense(self, request, context):
        print(f"DeleteExpense: {request}")
        # print(f"key vals: {self.expenses.keys()} : {self.expenses.values()}")
        # print(f"lol {self.expenses[2]}")
        if request.id in self.expenses:
            self.expenses.pop(request.id)
            return expense_pb2.DeleteExpenseResponse(id = request.id,  return_msg = expense_pb2.ReturnMsg(code= 0, msg= "Deleted"))
        else:
            return expense_pb2.DeleteExpenseResponse(id = request.id,  return_msg = expense_pb2.ReturnMsg(code= 1, msg= "Delte Failed"))
        # if self.expenses == []:
        #     return []]
        
    
    def UpdateExpense(self, request, context):
        print(f"UpdateExpense: {request}")
        if request.expense.id in self.expenses:
            self.expenses[request.expense.id] = request.expense
            return expense_pb2.UpdateExpenseResponse(id = request.expense.id,  return_msg = expense_pb2.ReturnMsg(code= 0, msg= "successful"))
        else:
            return expense_pb2.UpdateExpenseResponse(id = request.expense.id,  return_msg = expense_pb2.ReturnMsg(code= 1, msg= "not successful"))
        
        
    
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
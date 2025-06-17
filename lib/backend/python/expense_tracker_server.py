from concurrent import futures
import logging
import grpc
import expense_pb2
import expense_pb2_grpc
import database


class ExpenseTrackerServicer(expense_pb2_grpc.ExpenseTrackerServicer):
    db = database.PostgresDB(
        host="localhost",
        dbname="postgres",
        user="postgres",
        password="password",
        port=5432
    )
    db.connect()

    def CreateExpense(self, request, context):
        print(f"CreateExpense: {request}")
        gen_id = self.db.insert(request.expense)

        if gen_id != 0:
            return expense_pb2.CreateExpenseResponse(
                id=gen_id,
                status=expense_pb2.SuccessStatus(code=0, msg="Created")
            )
        return expense_pb2.CreateExpenseResponse(
            id=gen_id,
            status=expense_pb2.SuccessStatus(code=1, msg="Not created")
        )

    def ListExpenses(self, request, context):
        print(f"ListExpenses: {request}")
        expenses = self.db.listExpenses()
        print(expenses)
        return expense_pb2.ListExpensesResponse(expenses=expenses)

    def DeleteExpense(self, request, context):
        print(f"DeleteExpense: {request}")
        self.db.delete(request.id)
        return expense_pb2.DeleteExpenseResponse(
            id=request.id,
            status=expense_pb2.SuccessStatus(code=0, msg="Deleted")
        )

    def UpdateExpense(self, request, context):
        print(f"UpdateExpense: {request}")
        self.db.update(request.expense)
        return expense_pb2.UpdateExpenseResponse(
            id=request.expense.id,
            status=expense_pb2.SuccessStatus(code=0, msg="Successful")
        )

    def GetExpense(self, request, context):
        print(f"GetExpense: {request}")
        expense = self.db.get(request.id)
        if expense:
            return expense_pb2.GetExpenseResponse(
                expense=expense,
                status=expense_pb2.SuccessStatus(code=0, msg="Got it")
            )
        else:
            return expense_pb2.GetExpenseResponse(
                status=expense_pb2.SuccessStatus(code=1, msg="Not found")
            )


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    expense_pb2_grpc.add_ExpenseTrackerServicer_to_server(
        ExpenseTrackerServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("Server started")
    server.wait_for_termination()


def main():
    logging.basicConfig()
    serve()


if __name__ == '__main__':
    main()

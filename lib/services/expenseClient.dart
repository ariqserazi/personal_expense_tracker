import 'package:grpc/grpc.dart';
import 'expense.pbgrpc.dart';
import 'dart:math';
// import 'package:personal_expense_tracker/services/google/protobuf/timestamp.pb.dart';
import 'google/protobuf/timestamp.pb.dart' as timestamp;

class ExpenseClient {
  late ClientChannel channel;
  late ExpenseTrackerClient stub;

  ExpenseClient() {
    channel = ClientChannel(
      '10.0.0.32', //'localhost', 54.226.152.43, 10.0.0.26
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    stub = ExpenseTrackerClient(channel);
  }

// Assuming you have the necessary imports for your gRPC service and protobuf-generated classes.

  Future<void> createExpenses(var expense) async {
    try {
      final request = CreateExpenseRequest(expense: expense);

      final response = await stub.createExpense(request);

      print("CreateExpenseResponse: $response");
    } catch (e) {
      print("Error creating expense: $e");
    }
  }

  Future<SuccessStatus> getExpenses(int id) async {
    final request = GetExpenseRequest()..id = id;

    final response = await stub.getExpense(request);
    print('GetExpensesResponse: ${response}');
    return response.status;
  }

  Future<void> listExpenses() async {
    try {
      final request = ListExpensesRequest()..date = timestamp.Timestamp();

      final response = await stub.listExpenses(request);
      print('ListExpensesResponse: ${response.expenses}');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future<SuccessStatus> deleteExpense(int i) async {
    final request = DeleteExpenseRequest()..id = i;

    final response = await stub.deleteExpense(request);
    print('DeleteExpense: ${response}');
    return response.status;
  }

  Future<SuccessStatus> updateExpense(var expense) async {
    final request = UpdateExpenseRequest(expense: expense);

    final response = await stub.updateExpense(request);
    print('UpdateExpenseResponse: ${response}');
    return response.status;
  }

  Future<void> shutdown() async {
    await channel.shutdown();
  }
}

void main() async {
  final client = ExpenseClient();
  // final timestamp = Timestamp.fromDateTime(_selectedDate!);
  final expense = Expense(
    id: 2,
    title: "Movie Tickets",
    amount: 20.00,
    category: ExpenseCategory.ENTERTAINMENT,
    date: timestamp.Timestamp.fromDateTime(DateTime(2022, 6, 12)),
  );
  final expense1 = Expense(
    title: "bills",
    amount: 20.00,
    category: ExpenseCategory.FOOD,
    date: timestamp.Timestamp.fromDateTime(DateTime(2022, 6, 12)),
  );
  await client.createExpenses(expense1);

  // await client.listExpenses();

  // final returnMessage = await client.getExpenses(10);
  // print('${returnMessage}');
  // await client.listExpenses();
  // await client.deleteExpense(11);
  // await client.listExpenses();
  // await client.updateExpense(expense);

  await client.shutdown();
}

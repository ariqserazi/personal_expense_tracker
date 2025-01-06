import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:personal_expense_tracker/pages/summary_page.dart';
import 'package:personal_expense_tracker/pages/update_page.dart';
import '/services/expense.pb.dart';
import 'package:personal_expense_tracker/services/expenseClient.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  const HomePage({required this.expenses, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _expenses = [];
  Future<void> _fetchExpensesFromServer() async {
    // ... fetch expenses
    setState(() {
      _expenses = widget.expenses;
    });
  }

  void _refreshExpenses() {
    _fetchExpensesFromServer();
  }

  Future<List<Map<String, dynamic>>> _fetchExpensesFromServer1() async {
    final client = ExpenseClient();
    try {
      final request = ListExpensesRequest()..date = "";
      final response = await client.stub.listExpenses(request);
      // final response = await client.listExpenses();
      return response.expenses.map((expense) {
        return {
          'id': expense.id,
          'title': expense.title,
          'amount': expense.amount,
          'category': expense.category.name,
          'date': expense.date,
        };
      }).toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  Future<void> _onOptionSelected(
      String option, Map<String, dynamic> expense) async {
    final client = ExpenseClient();
    switch (option) {
      case 'Edit':
        print('Edit selected for: ${expense['title']}');
        // Navigate to edit screen or perform edit logic
        final updatedExpense = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdatePage(
                expense: expense,
                onUpdate: _refreshExpenses,
              ),
            ));
        if (updatedExpense != null) {
          // Update the local expense list with the updated expense
          setState(() {
            final index = widget.expenses
                .indexWhere((e) => e['id'] == updatedExpense['id']);
            if (index != -1) {
              widget.expenses[index] = updatedExpense;
            } else {
              // Handle the case where the updated expense isn't found in the local list
              // This might happen if the expense was added newly
              widget.expenses.add(updatedExpense);
            }
          });
        }

        break;
      case 'Delete':
        print('Delete selected for: ${expense['title']}');

        final response = await client.deleteExpense(expense['id']);
        if (response.code == 0) {
          setState(() {
            widget.expenses.removeWhere((e) => e['id'] == expense['id']);
          });
        }

        break;
    }
    await client.shutdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.blue[300],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchExpensesFromServer1(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading expenses.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }

          final expenses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getColor(expense['category']),
                    child: Text(expense['category'][0]),
                  ),
                  title: Text(expense['title']),
                  subtitle: Text(
                    'Amount: \$${expense['amount']} | Category: ${expense['category']} | Date: ${expense['date']}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (option) => _onOptionSelected(option, expense),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/pages/expense_page.dart';
import 'package:personal_expense_tracker/services/expense.pb.dart';
import 'package:personal_expense_tracker/services/expenseClient.dart';

String _formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date); // Example: 2024-11-25
}

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> expense;
  final Function() onUpdate;
  const UpdatePage({super.key, required this.expense, required this.onUpdate});

  @override
  State<UpdatePage> createState() => UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _selectedCategory; // Default category
  DateTime? _selectedDate;
  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      print('Selected date: $_selectedDate');
    } else {
      print('No date selected.');
    }
  }

  @override
  // final expense = this.expense;
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense['title']);
    _amountController =
        TextEditingController(text: widget.expense['amount'].toString());
    _selectedCategory = widget.expense['category'];
    _selectedDate = DateTime.parse(widget.expense['date']);
  }

  // List<Expense> _expenses = [];
  Future<List<Map<String, dynamic>>> _fetchExpensesFromServer() async {
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

  // Future<void> _fetchExpenses() async {
  //   print('Calling _fetchExpenses()......');
  //   final expenseList = await ExpenseClient().listExpenses();
  //   setState(() {
  //     _expenses = expenseList;
  //   });
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Page for ${widget.expense['title']}",
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Expense Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: [
                'UNKNOWN',
                'FOOD',
                'TRANSPORT',
                'SHOPPING',
                'ENTERTAINMENT',
                'BILLS',
                'EDUCATION',
                'HEALTH',
                'OTHER'
              ]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? (widget.expense['date'] != null
                          ? '${_formatDate(DateTime.parse(widget.expense['date']))}'
                          : 'No date available')
                      : 'Date: ${_formatDate(_selectedDate!)}',
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final titletext = _titleController.text.trim();
                  final amount = double.tryParse(_amountController.text.trim());
                  if (titletext.isNotEmpty &&
                      amount != null &&
                      _selectedDate != null) {
                    Expense expense = Expense()
                      ..id = widget.expense['id']
                      ..title = _titleController.text.trim()
                      ..amount = double.tryParse(_amountController.text.trim())!
                      ..category =
                          ExpenseCategoryExtension.fromString(_selectedCategory)
                      ..date =
                          _selectedDate!.toLocal().toString().split(' ')[0];
                    final client = ExpenseClient();
                    // expense.id = widget.expense['id'];
                    print(expense);
                    await client.updateExpense(expense);
                  }
                  Navigator.pop(context);
                  widget.onUpdate();
                },
                child: const Text('Edit Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

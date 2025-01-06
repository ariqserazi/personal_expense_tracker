import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/pages/home_page.dart';
import 'package:personal_expense_tracker/services/expense.pbgrpc.dart';
import 'package:personal_expense_tracker/services/expenseClient.dart';
import 'package:personal_expense_tracker/widgets/widget_tree.dart';

String _formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date); // Example: 2024-11-25
}

class ExpensePage extends StatefulWidget {
  final Function(Map<String, dynamic>)
      onExpenseAdded; // Callback for new expense

  ExpensePage({required this.onExpenseAdded, Key? key}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'UNKNOWN'; // Default category
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Colors.red[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
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
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : 'Date:  ${_formatDate(_selectedDate!)}',
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
                    widget.onExpenseAdded({
                      'title': titletext,
                      'amount': amount,
                      'category': _selectedCategory,
                      'date': _selectedDate!.toLocal().toString().split(' ')[0],
                    });
                    Expense expense = Expense()
                      ..title = _titleController.text.trim()
                      ..amount = double.tryParse(_amountController.text.trim())!
                      ..category =
                          ExpenseCategoryExtension.fromString(_selectedCategory)
                      ..date =
                          _selectedDate!.toLocal().toString().split(' ')[0];
                    final client = ExpenseClient();

                    await client.createExpenses(expense);

                    _titleController.clear();
                    _amountController.clear();
                    setState(() {
                      _selectedDate = null;
                      _selectedCategory = 'UNKNOWN';
                    });
                    // Navigator.push(())
                  }
                },
                child: const Text('Add Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ExpenseCategoryExtension on ExpenseCategory {
  static ExpenseCategory fromString(String category) {
    switch (category) {
      case 'FOOD':
        return ExpenseCategory.FOOD;
      case 'TRANSPORT':
        return ExpenseCategory.TRANSPORT;
      case 'SHOPPING':
        return ExpenseCategory.SHOPPING;
      case 'ENTERTAINMENT':
        return ExpenseCategory.ENTERTAINMENT;
      case 'BILLS':
        return ExpenseCategory.BILLS;
      case 'OTHER':
        return ExpenseCategory.OTHER;
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }
}

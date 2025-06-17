import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/pages/expense_page.dart';
import 'package:personal_expense_tracker/services/expense.pb.dart';
import 'package:personal_expense_tracker/services/expenseClient.dart';
import 'package:personal_expense_tracker/services/google/protobuf/timestamp.pb.dart';

String _formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
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
  late String _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense['title']);
    _amountController =
        TextEditingController(text: widget.expense['amount'].toString());

    final category = widget.expense['category'];
    if (category is String) {
      _selectedCategory = category;
    } else if (category is ExpenseCategory) {
      _selectedCategory = category.name;
    } else {
      _selectedCategory = 'UNKNOWN';
    }

    final timestamp = widget.expense['date'];
    if (timestamp is Timestamp) {
      _selectedDate = timestamp.toDateTime();
    } else if (timestamp is String) {
      _selectedDate = DateTime.tryParse(timestamp);
    } else {
      _selectedDate = DateTime.now();
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _handleUpdate() async {
    final titleText = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (titleText.isEmpty || amount == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final timestamp = Timestamp.fromDateTime(_selectedDate!);

    final updatedExpense = Expense()
      ..id = widget.expense['id']
      ..title = titleText
      ..amount = amount
      ..category = ExpenseCategoryExtension.fromString(_selectedCategory)
      ..date = timestamp;

    try {
      final client = ExpenseClient();
      await client.updateExpense(updatedExpense);
      widget.onUpdate();
      Navigator.pop(context);
    } catch (e) {
      print('Error updating expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update: ${widget.expense['title']}"),
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
                  _selectedDate != null
                      ? 'Date: ${_formatDate(_selectedDate!)}'
                      : 'No date selected',
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _handleUpdate,
                child: const Text('Edit Expense'),
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
    switch (category.toUpperCase()) {
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
      case 'EDUCATION':
        return ExpenseCategory.EDUCATION;
      case 'HEALTH':
        return ExpenseCategory.HEALTH;
      case 'OTHER':
        return ExpenseCategory.OTHER;
      case 'UNKNOWN':
      default:
        return ExpenseCategory.UNKNOWN;
    }
  }
}

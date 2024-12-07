import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String _selectedCategory = 'Food'; // Default category
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
              items: ['Food', 'Travel', 'Shopping', 'Other']
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
                      : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
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
                onPressed: () {
                  final title = _titleController.text.trim();
                  final amount = double.tryParse(_amountController.text.trim());
                  if (title.isNotEmpty &&
                      amount != null &&
                      _selectedDate != null) {
                    widget.onExpenseAdded({
                      'title': title,
                      'amount': amount,
                      'category': _selectedCategory,
                      'date': _selectedDate!.toLocal().toString().split(' ')[0],
                    });
                    _titleController.clear();
                    _amountController.clear();
                    setState(() {
                      _selectedDate = null;
                      _selectedCategory = 'Food';
                    });
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

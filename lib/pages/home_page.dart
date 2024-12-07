import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  const HomePage({required this.expenses, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        backgroundColor: Colors.blue[300],
      ),
      body: widget.expenses.isEmpty
          ? const Center(child: Text('No expenses yet.'))
          : ListView.builder(
              itemCount: widget.expenses.length,
              itemBuilder: (context, index) {
                final expense = widget.expenses[index];
                return ListTile(
                  title: Text(expense['title'] ?? ''),
                  subtitle: Text(
                      'Amount: \$${expense['amount']} | Category: ${expense['category']} | Date: ${expense['date']}'),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/pages/home_page.dart';
import 'package:personal_expense_tracker/pages/expense_page.dart';
import 'package:personal_expense_tracker/pages/summary_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int currPage = 0;

  // Shared expenses list
  List<Map<String, dynamic>> expenses = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(
        expenses: expenses,
        onExpensesUpdated: (List<Map<String, dynamic>> expenses) {},
      ),
      SummaryPage(),
      ExpensePage(
        onExpenseAdded: (newExpense) {
          setState(() {
            expenses.add(newExpense);
          });
        },
      ),
    ];

    return Scaffold(
      body: pages[currPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Summary'),
          NavigationDestination(icon: Icon(Icons.addchart), label: 'Expense'),
        ],
        selectedIndex: currPage,
        onDestinationSelected: (int value) {
          setState(() {
            currPage = value;
          });
        },
      ),
    );
  }
}

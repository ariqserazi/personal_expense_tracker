import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:grpc/grpc.dart';
import 'package:personal_expense_tracker/services/expense.pb.dart';
import 'package:personal_expense_tracker/services/expenseClient.dart';
import 'package:grpc/grpc.dart' as grpc;

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  Future<List<Map<String, dynamic>>> _fetchExpensesFromServer() async {
    final client = ExpenseClient();
    try {
      final request = ListExpensesRequest()..date = "";
      final response = await client.stub.listExpenses(request);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Page'),
        backgroundColor: Colors.green[300],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchExpensesFromServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading summary data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }

          // Group and sum amounts by category
          Map<String, double> categoryTotals = {};
          for (var expense in snapshot.data!) {
            categoryTotals[expense['category']] =
                (categoryTotals[expense['category']] ?? 0.0) +
                    expense['amount'];
          }

          // Convert data to pie chart sections
          List<PieChartSectionData> pieSections = categoryTotals.entries
              .map((entry) => PieChartSectionData(
                    value: entry.value,
                    title: '',
                    color: _getColor(entry.key),
                    radius: 50,
                  ))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: pieSections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLegend(categoryTotals),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend(Map<String, double> categoryTotals) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: categoryTotals.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getColor(entry.key),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key}: ${entry.value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getColor(String category) {
    switch (category) {
      case 'FOOD':
        return Colors.blue;
      case 'TRANSPORT':
        return Colors.green;
      case 'SHOPPING':
        return Colors.purple;
      case 'ENTERTAINMENT':
        return Colors.yellow;
      case 'BILLS':
        return Colors.red;
      case 'EDUCATION':
        return Colors.pink;
      case 'HEALTH':
        return Colors.indigo;
      default:
        return Colors.orange;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  SummaryPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Group and sum amounts by category
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense['category']] =
          (categoryTotals[expense['category']] ?? 0.0) + expense['amount'];
    }

    // Convert data to pie chart sections
    List<PieChartSectionData> pieSections = categoryTotals.entries
        .map((entry) => PieChartSectionData(
              value: entry.value,
              title: '${entry.key}: ${entry.value.toStringAsFixed(2)}',
              color: _getColor(entry.key), // Assign a color
              radius: 50,
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Page'),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: PieChart(
            PieChartData(
              sections: pieSections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Travel':
        return Colors.green;
      case 'Shopping':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}

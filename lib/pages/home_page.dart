import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:personal_expense_tracker/pages/summary_page.dart';
import 'package:personal_expense_tracker/pages/update_page.dart';
import '/services/expense.pb.dart';
import 'package:personal_expense_tracker/services/expenseClient.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  final Function(List<Map<String, dynamic>>) onExpensesUpdated;

  const HomePage({
    required this.expenses,
    Key? key,
    required this.onExpensesUpdated,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _expenses = [];
  @override
  void initState() {
    super.initState();
    _filteredExpenses = widget.expenses; // Initialize with all expenses
  }

  Future<void> _fetchExpensesFromServer() async {
    // ... fetch expenses
    setState(() {
      _expenses = widget.expenses;
    });
  }

  void _refreshExpenses() {
    _fetchExpensesFromServer();
  }

  void _filterExpenses1() {
    setState(() {
      // Your filtering logic
      // Example: Filter by a specific category or date range
      _filteredExpenses = widget.expenses
          .where((expense) => expense['category'] == 'FOOD') // Example filter
          .toList();

      // Notify the parent widget (WidgetTree) of the updated filtered expenses
      widget.onExpensesUpdated(_filteredExpenses);
    });
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

  void _updateStateWithFilter() {
    setState(() {
      _expenses = _applyFilter(
          _expenses); // Apply the filter to update the displayed expenses
    });
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

  String _selectedFilter = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  Widget _buildFilterOptions() {
    print('Selected Filter: $_selectedFilter');
    return Column(
      children: [
        DropdownButton<String>(
          value: _selectedFilter.isNotEmpty ? _selectedFilter : _selectedFilter,
          items: [
            DropdownMenuItem(value: 'All', child: Text('All')),
            DropdownMenuItem(value: 'Day', child: Text('Specific Day')),
            DropdownMenuItem(value: 'Month', child: Text('Specific Month')),
            DropdownMenuItem(value: 'Year', child: Text('Specific Year')),
            DropdownMenuItem(value: 'Custom', child: Text('Custom Range')),
          ],
          onChanged: (value) async {
            setState(() {
              _selectedFilter = value!;
            });

            if (value == 'Custom') {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                _startDate = picked.start;
                _endDate = picked.end;
              }
            } else if (value == 'Day') {
              _selectDateOption('Day');
            } else if (value == 'Month') {
              _selectDateOption('Month');
            } else if (value == 'Year') {
              _selectDateOption('Year');
            }

            _filterExpenses();
            widget.onExpensesUpdated(_filteredExpenses);
          },
        ),
      ],
    );
  }

  void _selectDateOption(String type) async {
    DateTime now = DateTime.now();
    List<int> options = [];

    if (type == 'Day') {
      int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      options = List<int>.generate(daysInMonth, (i) => i + 1);
    } else if (type == 'Month') {
      options = List<int>.generate(12, (i) => i + 1);
    } else if (type == 'Year') {
      options = List<int>.generate(30, (i) => now.year - i); // Past 30 years
    }

    final selected = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select $type'),
          children: options.map((int value) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, value);
              },
              child: Text(value.toString()),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        if (type == 'Day') {
          _startDate = DateTime(now.year, now.month, selected);
          _endDate = _startDate; // A single day range
        } else if (type == 'Month') {
          _startDate = DateTime(now.year, selected, 1);
          _endDate =
              DateTime(now.year, selected + 1, 0); // Last day of the month
        } else if (type == 'Year') {
          _startDate = DateTime(selected, 1, 1);
          _endDate = DateTime(selected, 12, 31);
        }
        _selectedFilter = type; // Update the filter type
        _updateStateWithFilter(); // Update the displayed state
      });
    }
  }

  List<Map<String, dynamic>> _filteredExpenses = [];
  void _filterExpenses() {
    setState(() {
      print('Selected Filter: $_selectedFilter');
      print('Start Date: $_startDate');
      print('End Date: $_endDate');

      if (_selectedFilter == 'All') {
        // No filtering
        _expenses = widget.expenses; // Reset to original expenses
      } else if (_selectedFilter == 'Custom' &&
          _startDate != null &&
          _endDate != null) {
        // Custom range filtering
        _expenses = widget.expenses.where((expense) {
          final expenseDate = _parseDate(expense['date']);
          return expenseDate != null &&
              expenseDate.isAfter(_startDate!) &&
              expenseDate.isBefore(_endDate!
                  .add(Duration(days: 1))); // Inclusive of the last day
        }).toList();
      } else if (_selectedFilter == 'Day') {
        // Specific day filtering
        _expenses = widget.expenses.where((expense) {
          final expenseDate = _parseDate(expense['date']);
          return expenseDate != null &&
              expenseDate.year == _startDate?.year &&
              expenseDate.month == _startDate?.month &&
              expenseDate.day == _startDate?.day;
        }).toList();
      } else if (_selectedFilter == 'Month') {
        // Specific month filtering
        _expenses = widget.expenses.where((expense) {
          final expenseDate = _parseDate(expense['date']);
          return expenseDate != null &&
              expenseDate.year == _startDate?.year &&
              expenseDate.month == _startDate?.month;
        }).toList();
      } else if (_selectedFilter == 'Year') {
        // Specific year filtering
        _expenses = widget.expenses.where((expense) {
          final expenseDate = _parseDate(expense['date']);
          return expenseDate != null && expenseDate.year == _startDate?.year;
        }).toList();
      }
      print('Filtered Expenses: $_expenses');
    });
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // print(dateStr);
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Error parsing date: $e');
      return null; // Return null if parsing fails
    }
  }

  List<Map<String, dynamic>> _applyFilter(
      List<Map<String, dynamic>> allExpenses) {
    if (_selectedFilter == 'All') {
      // No filtering
      return allExpenses;
    } else if (_selectedFilter == 'Day' && _startDate != null) {
      // Filter for a specific day
      return allExpenses.where((expense) {
        final expenseDate = DateTime.parse(expense['date']); // Parse VARCHAR
        return expenseDate.year == _startDate!.year &&
            expenseDate.month == _startDate!.month &&
            expenseDate.day == _startDate!.day;
      }).toList();
    } else if (_selectedFilter == 'Month' && _startDate != null) {
      // Filter for a specific month
      return allExpenses.where((expense) {
        final expenseDate = DateTime.parse(expense['date']); // Parse VARCHAR
        return expenseDate.year == _startDate!.year &&
            expenseDate.month == _startDate!.month;
      }).toList();
    } else if (_selectedFilter == 'Year' && _startDate != null) {
      // Filter for a specific year
      return allExpenses.where((expense) {
        final expenseDate = DateTime.parse(expense['date']); // Parse VARCHAR
        return expenseDate.year == _startDate!.year;
      }).toList();
    } else if (_selectedFilter == 'Custom' &&
        _startDate != null &&
        _endDate != null) {
      // Custom range filter
      return allExpenses.where((expense) {
        final expenseDate = DateTime.parse(expense['date']); // Parse VARCHAR
        return expenseDate.isAfter(_startDate!) &&
            expenseDate.isBefore(_endDate!
                .add(const Duration(days: 1))); // Inclusive of the end date
      }).toList();
    }
    // Return all expenses if no valid filter is selected
    widget.onExpensesUpdated(_filteredExpenses);
    return allExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.blue[300],
      ),
      body: Column(
        children: [
          _buildFilterOptions(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchExpensesFromServer1(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading expenses.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No expenses found.'));
                }

                // Only update _expenses when snapshot.data changes
                final allExpenses = snapshot.data!;
                _filteredExpenses = _applyFilter(allExpenses);

                return ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: _filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = _filteredExpenses[index];
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
                          onSelected: (option) =>
                              _onOptionSelected(option, expense),
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
          ),
        ],
      ),
    );
  }
}

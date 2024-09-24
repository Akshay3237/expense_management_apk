import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/update_expense_form.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:expense_tracker/models/expense_model.dart';
import '../comonFunctions.dart';

class ExpenseBox extends StatefulWidget {
  final bool isFetchExpense;

  ExpenseBox(this.isFetchExpense);

  @override
  _ExpenseBoxState createState() => _ExpenseBoxState();
}

class _ExpenseBoxState extends State<ExpenseBox> {
  late Future<List<Expense>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = fetchExpenses();
  }

  @override
  void didUpdateWidget(ExpenseBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFetchExpense != oldWidget.isFetchExpense && widget.isFetchExpense) {
      setState(() {
        _expensesFuture = fetchExpenses();
      });
    }
  }

  Future<List<Expense>> fetchExpenses() async {
    final userId = await getUserId();
    if (userId != null) {
      final expenseService = ExpenseService();
      try {
        final expenses = await expenseService.getAllExpenses();
        return expenses['expenses'].where((expense) => expense.userId == userId).toList() ?? [];
      } catch (e) {
        throw Exception('Failed to fetch expenses: $e');
      }
    } else {
      throw Exception("Failed to get user ID from token.");
    }
  }

  Future<void> _deleteExpense(String id) async {
    try {
      final userId = await getUserId();
      if (userId != null) {
        final expenseService = ExpenseService();
        final result = await expenseService.deleteExpenseById(id);
        if (result['success']) {
          setState(() {
            _expensesFuture = fetchExpenses();
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      } else {
        throw Exception("Failed to get user ID from token.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _openUpdateExpenseForm(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateExpenseForm(expense: expense),
      ),
    ).then((_) {
      setState(() {
        _expensesFuture = fetchExpenses();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth * 0.05;
    double subtitleFontSize = screenWidth * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Expenses',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Expense>>(
            future: _expensesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No expenses found.'));
              }

              final expenses = snapshot.data!;

              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: subtitleFontSize),
                          ),
                          SizedBox(height: 8.0),
                          Text('Category: ${expense.category ?? 'Unknown'}', style: TextStyle(fontSize: subtitleFontSize)),
                          Text('Recurring: ${expense.recurring ? 'Yes' : 'No'}', style: TextStyle(fontSize: subtitleFontSize)),
                          Text('Note: ${expense.note ?? 'No notes'}', style: TextStyle(fontSize: subtitleFontSize)),
                          Text('Date: ${expense.date.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: subtitleFontSize)),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _openUpdateExpenseForm(expense),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteExpense(expense.id),
                              ),
                            ],
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
    );
  }
}

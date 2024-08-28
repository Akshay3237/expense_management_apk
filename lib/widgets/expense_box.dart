import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/update_expense_form.dart'; // Import UpdateExpenseForm
import 'package:expense_tracker/services/expense_service.dart'; // Import ExpenseService
import 'package:expense_tracker/models/expense_model.dart'; // Import Expense model
import '../comonFunctions.dart'; // Import your common functions

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
        final expenses = await expenseService.getAllExpenses(); // Ensure this method uses userId
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Expenses',
            style: TextStyle(
              fontSize: 24,
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('₹${expense.amount.toStringAsFixed(2)}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${expense.category ?? 'Unknown'}'),
                          Text('Recurring: ${expense.recurring ? 'Yes' : 'No'}'),
                          Text('Note: ${expense.note ?? 'No notes'}'),
                          Text('Date: ${expense.date.toLocal().toString().split(' ')[0]}'), // Format date
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
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

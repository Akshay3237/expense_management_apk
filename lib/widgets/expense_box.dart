import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense_model.dart'; // Import the Expense model
import 'package:expense_tracker/services/expense_service.dart'; // Import the Expense service

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

  // Fetch expenses using ExpenseService
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

  // Helper method to extract user_id from the JWT token stored in SharedPreferences


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
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount: ₹${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Category: ${expense.category ?? 'No category'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Recurring: ${expense.recurring ? 'Yes' : 'No'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Note: ${expense.note ?? 'No note'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date: ${expense.date.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(fontSize: 16),
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

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart'; // Import jwt_decode package
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:expense_tracker/models/expense_model.dart'; // Import the Expense model
import 'package:expense_tracker/services/expense_service.dart'; // Import the Expense service

class ExpenseBox extends StatefulWidget {
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

  // Fetch expenses using ExpenseService
  Future<List<Expense>> fetchExpenses() async {
    final userId = await _getUserIdFromToken();
    if (userId != null) {
      final expenseService = ExpenseService();
      return await expenseService.getAllExpenses(userId);
    } else {
      throw Exception("Failed to get user ID from token.");
    }
  }

  // Helper method to extract user_id from the JWT token stored in SharedPreferences
  Future<String?> _getUserIdFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String? userId = payload['userId']; // Extract the user_id from the token
      return userId;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Expenses', // Title
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

              // Display the list of expenses
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
                            'Amount: ₹${expense.amount}',
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
                            'Date: ${expense.date.toLocal()}',
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

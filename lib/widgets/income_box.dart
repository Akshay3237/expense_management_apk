import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart'; // Import jwt_decode package
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:expense_tracker/models/income_model.dart'; // Import the Income model
import 'package:expense_tracker/services/income_service.dart'; // Import the Income service

class IncomeBox extends StatefulWidget {
  @override
  _IncomeBoxState createState() => _IncomeBoxState();
}

class _IncomeBoxState extends State<IncomeBox> {
  late Future<List<Income>> _incomesFuture;

  @override
  void initState() {
    super.initState();
    _incomesFuture = fetchIncomes();
  }

  // Fetch incomes using IncomeService
  Future<List<Income>> fetchIncomes() async {
    final userId = await _getUserIdFromToken();
    if (userId != null) {
      final incomeService = IncomeService();
      return await incomeService.getAllIncomes(userId);
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
            'Incomes', // Title
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Income>>(
            future: _incomesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No incomes found.'));
              }

              // Display the list of incomes
              final incomes = snapshot.data!;

              return ListView.builder(
                itemCount: incomes.length,
                itemBuilder: (context, index) {
                  final income = incomes[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount: ₹${income.amount}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Category: ${income.category ?? 'No category'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Recurring: ${income.recurring ? 'Yes' : 'No'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Note: ${income.note ?? 'No note'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date: ${income.date.toLocal()}',
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

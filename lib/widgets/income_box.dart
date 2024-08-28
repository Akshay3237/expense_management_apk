import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/income_model.dart'; // Import the Income model
import 'package:expense_tracker/services/income_service.dart'; // Import the Income service

class IncomeBox extends StatefulWidget {
  final bool isFetchIncome; // Added to allow re-fetching data

  IncomeBox(this.isFetchIncome);

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

  @override
  void didUpdateWidget(IncomeBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFetchIncome != oldWidget.isFetchIncome && widget.isFetchIncome) {
      setState(() {
        _incomesFuture = fetchIncomes();
      });
    }
  }

  // Fetch incomes using IncomeService
  Future<List<Income>> fetchIncomes() async {
    final userId = await getUserId();
    if (userId != null) {
      final incomeService = IncomeService();
      try {
        final incomes = await incomeService.getAllIncomes(); // Pass userId if needed
        return incomes.where((expense) => expense.userId == userId).toList()?? [];
      } catch (e) {
        throw Exception('Failed to fetch incomes: $e');
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
            'Incomes',
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
                            'Amount: ₹${income.amount.toStringAsFixed(2)}', // Format amount
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
                            'Date: ${income.date.toLocal().toString().split(' ')[0]}', // Format date
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

import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/update_income_form.dart'; // Import UpdateIncomeForm
import 'package:expense_tracker/services/income_service.dart'; // Import IncomeService
import 'package:expense_tracker/models/income_model.dart'; // Import Income model
import '../comonFunctions.dart'; // Import your common functions

class IncomeBox extends StatefulWidget {
  final bool isFetchIncome;

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

  Future<List<Income>> fetchIncomes() async {
    final userId = await getUserId();
    if (userId != null) {
      final incomeService = IncomeService();
      try {
        final incomes = await incomeService.getAllIncomes(); // Pass userId if needed
        return incomes.where((income) => income.userId == userId).toList() ?? [];
      } catch (e) {
        throw Exception('Failed to fetch incomes: $e');
      }
    } else {
      throw Exception("Failed to get user ID from token.");
    }
  }

  Future<void> _deleteIncome(String id) async {
    try {
      final userId = await getUserId();
      if (userId != null) {
        final incomeService = IncomeService();
        final result = await incomeService.deleteIncomeById(id); // Pass userId here if needed
        if (result['success']) {
          setState(() {
            _incomesFuture = fetchIncomes();
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

  void _openUpdateIncomeForm(Income income) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateIncomeForm(income: income),
      ),
    ).then((_) {
      // Refresh the income list after returning from the form
      setState(() {
        _incomesFuture = fetchIncomes();
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
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('\$${income.amount.toStringAsFixed(2)}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${income.category ?? 'Unknown'}'),
                          Text('Recurring: ${income.recurring ? 'Yes' : 'No'}'),
                          Text('Note: ${income.note ?? 'No notes'}'),
                          Text('Date: ${income.date.toLocal().toString().split(' ')[0]}'), // Format date
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _openUpdateIncomeForm(income),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteIncome(income.id),
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

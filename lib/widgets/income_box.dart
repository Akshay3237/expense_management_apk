import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/update_income_form.dart';
import 'package:expense_tracker/services/income_service.dart';
import 'package:expense_tracker/models/income_model.dart';
import '../comonFunctions.dart';

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
        final incomes = await incomeService.getAllIncomes();
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
        final result = await incomeService.deleteIncomeById(id);
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
      setState(() {
        _incomesFuture = fetchIncomes();
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
            'Incomes',
            style: TextStyle(
              fontSize: titleFontSize,
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${income.amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: subtitleFontSize),
                          ),
                          SizedBox(height: 8.0),
                          Text('Category: ${income.category ?? 'Unknown'}', style: TextStyle(fontSize: subtitleFontSize)),
                          Text('Recurring: ${income.recurring ? 'Yes' : 'No'}', style: TextStyle(fontSize: subtitleFontSize)),
                          Text('Note: ${income.note ?? 'No notes'}', style: TextStyle(fontSize: subtitleFontSize)),
                          Text('Date: ${income.date.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: subtitleFontSize)),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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

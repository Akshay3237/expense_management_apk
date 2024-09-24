import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/history_income.dart';  // Import HistoryIncome widget
import 'package:expense_tracker/widgets/history_expense.dart';

import '../comonFunctions.dart'; // Import HistoryExpense widget

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    checkAuthToken(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body:PageView(
        children: [
          HistoryIncomeWidget(),
          HistoryExpenseWidget()
        ],
      ),
    );
  }
}

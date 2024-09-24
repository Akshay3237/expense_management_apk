import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/budget_form.dart';
import 'package:expense_tracker/widgets/budget_list.dart';

import '../comonFunctions.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final GlobalKey<BudgetListState> _budgetListKey = GlobalKey();

  // This function is called when a new budget is submitted, to refresh the budget list.
  void _onBudgetSubmitted() {
    _budgetListKey.currentState?.fetchBudgets(); // Trigger refresh
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthToken(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BudgetForm(onBudgetSubmitted: _onBudgetSubmitted),
          ),
          Expanded(
            child: BudgetList(key: _budgetListKey),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/widgets/app_drawer.dart';
import 'package:expense_tracker/widgets/expense_box.dart';
import 'package:expense_tracker/widgets/income_box.dart';
import 'package:expense_tracker/widgets/add_income.dart';
import 'package:expense_tracker/widgets/add_expense.dart';
import 'package:expense_tracker/widgets/add_category.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isFetchIncome = false;
  bool isFetchExpense = false;


  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showAddIncomeForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Income'),
          content: AddIncome(
            onClose: () => Navigator.of(context).pop(),
            onSuccess: () {
              Navigator.of(context).pop();
              setState(() {
                isFetchIncome = true;
              });
            },
          ),
        );
      },
    );
  }

  void _showAddExpenseForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: AddExpense(
            onClose: () => Navigator.of(context).pop(),
            onSuccess: () {
              Navigator.of(context).pop();
              setState(() {
                isFetchExpense = true;
              });
            },
          ),
        );
      },
    );
  }

  void _showAddCategoryForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: AddCategory(
            onClose: () => Navigator.of(context).pop(),
            onSuccess: () {
              Navigator.of(context).pop();
              setState(() {

              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _showAddIncomeForm,
                  child: Text('Insert Income'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showAddExpenseForm,
                  child: Text('Insert Expense'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showAddCategoryForm,
                  child: Text('Insert Category'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Logic to download data
                  },
                  child: Text('Download Data'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ExpenseBox(isFetchExpense),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: IncomeBox(isFetchIncome),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

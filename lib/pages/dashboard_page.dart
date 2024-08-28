import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/widgets/app_drawer.dart'; // Import the AppDrawer widget
import 'package:expense_tracker/widgets/expense_box.dart'; // Import the ExpenseBox widget
import 'package:expense_tracker/widgets/income_box.dart'; // Import the IncomeBox widget

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken == null) {
      // If no auth_token is found, navigate to the login page by URL
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AppDrawer(), // Add the AppDrawer widget here
      body: Column(
        children: [
          // Scrollable buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic to insert income
                  },
                  child: Text('Insert Income'),
                ),
                SizedBox(width: 16), // Add space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Logic to insert expense
                  },
                  child: Text('Insert Expense'),
                ),
                SizedBox(width: 16), // Add space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Logic to insert category
                  },
                  child: Text('Insert Category'),
                ),
                SizedBox(width: 16), // Add space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Logic to download data
                  },
                  child: Text('Download Data'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Add space between buttons and boxes
          // Row for ExpenseBox and IncomeBox
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Expand ExpenseBox and IncomeBox to take available space
                Expanded(
                  child: ExpenseBox(),
                ),
                SizedBox(width: 20), // Add space between ExpenseBox and IncomeBox
                Expanded(
                  child: IncomeBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

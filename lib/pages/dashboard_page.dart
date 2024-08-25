import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/app_drawer.dart'; // Import the AppDrawer widget

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AppDrawer(), // Add the AppDrawer widget here
      body: Center(
        child: Text('This is the Dashboard Page'),
      ),
    );
  }
}

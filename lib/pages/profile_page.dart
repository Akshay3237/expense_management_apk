import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:expense_tracker/services/logout_service.dart'; // Adjust the import path accordingly

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await logout(); // Call the logout function
            Navigator.pushReplacementNamed(context, '/login'); // Redirect to the login page
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}

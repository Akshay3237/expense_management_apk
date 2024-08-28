import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:expense_tracker/services/login_service.dart'; // Adjust the import path accordingly

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  final LoginService _loginService = LoginService(); // Create an instance of LoginService

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16.0),
              Center(
                child: Container(
                  width: screenWidth * 0.75,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.lightBlue[50],
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Add vertical spacing
              Center(
                child: Container(
                  width: screenWidth * 0.75,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.lightBlue[50],
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Add vertical spacing
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Call the login service
                      final result = await _loginService.loginUser(
                        email: _email,
                        password: _password,
                      );

                      if (result['success']) {
                        // Save the token to local storage
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('auth_token', result['token']);

                        // Handle successful login
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                        // Navigate to dashboard page
                        Navigator.pushReplacementNamed(context, '/');
                      } else {
                        // Handle login failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    }
                  },
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 20.0), // Add vertical spacing
              Center(
                child: TextButton(
                  onPressed: () {
                    // Redirect to the registration page
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:expense_tracker/services/register_service.dart'; // Import your RegisterService
import 'package:expense_tracker/constants.dart'; // Import constants for URLs

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterService _registerService = RegisterService(); // Instantiate RegisterService

  String? _gender;
  String? _profession;
  String _firstName = '';
  String _surname = '';
  String _fullName = '';
  String _mobileNo = '';
  String _email = '';
  String _otp = '';
  String _password = '';
  String _confirmPassword = '';

  // Visibility toggle states for password fields
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'First Name',
              onChanged: (value) {
                _firstName = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'Surname',
              onChanged: (value) {
                _surname = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            Text('Select Gender', textAlign: TextAlign.center),
            buildGenderRadioTile(context, 'male'),
            buildGenderRadioTile(context, 'female'),
            buildGenderRadioTile(context, 'other'),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'Full Name',
              onChanged: (value) {
                _fullName = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'Mobile No',
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                _mobileNo = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              suffixIcon: ElevatedButton(
                onPressed: () {
                  // Implement OTP sending logic here
                },
                child: Text('Send OTP'),
              ),
              onChanged: (value) {
                _email = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'OTP',
              onChanged: (value) {
                _otp = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            buildDropdownField(
              context,
              screenWidth,
              label: 'Select Profession',
              value: _profession,
              items: ['Developer', 'Designer']
                  .map((profession) => DropdownMenuItem<String>(
                value: profession,
                child: Text(profession),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _profession = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'Password',
              obscureText: !_passwordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              onChanged: (value) {
                _password = value ?? '';
              },
            ),
            SizedBox(height: 16.0),
            buildInputField(
              context,
              screenWidth,
              label: 'Confirm Password',
              obscureText: !_confirmPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
              onChanged: (value) {
                _confirmPassword = value ?? '';
              },
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Send data to the RegisterService without validation
                  try {
                    final result = await _registerService.registerUser(
                      firstName: _firstName,
                      surname: _surname,
                      fullName: _fullName,
                      gender: _gender!,
                      mobileno: _mobileNo,
                      email: _email,
                      profession: _profession!,
                      password: _password,
                    );

                    if (result['success']) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'])),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(BuildContext context, double screenWidth,
      {required String label,
        TextInputType? keyboardType,
        bool obscureText = false,
        Widget? suffixIcon,
        void Function(String?)? onChanged}) {
    return Center(
      child: Container(
        width: screenWidth * 0.75,
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.lightBlue[50],
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildDropdownField(BuildContext context, double screenWidth,
      {required String label,
        String? value,
        required List<DropdownMenuItem<String>> items,
        void Function(String?)? onChanged}) {
    return Center(
      child: Container(
        width: screenWidth * 0.75,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.lightBlue[50],
          ),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildGenderRadioTile(BuildContext context, String gender) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: RadioListTile<String>(
          title: Text(gender),
          value: gender,
          groupValue: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),
      ),
    );
  }
}

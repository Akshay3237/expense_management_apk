import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16.0),
              buildInputField(
                context,
                screenWidth,
                label: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
              buildInputField(
                context,
                screenWidth,
                label: 'Surname',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
                onSaved: (value) {
                  _surname = value!;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
              Text('Select Gender', textAlign: TextAlign.center),
              buildGenderRadioTile(context, 'Male'),
              buildGenderRadioTile(context, 'Female'),
              buildGenderRadioTile(context, 'Other'),
              SizedBox(height: 16.0), // Add vertical spacing
              buildInputField(
                context,
                screenWidth,
                label: 'Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value!;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
              buildInputField(
                context,
                screenWidth,
                label: 'Mobile No',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _mobileNo = value!;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
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
              SizedBox(height: 16.0), // Add vertical spacing
              buildInputField(
                context,
                screenWidth,
                label: 'OTP',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
                onSaved: (value) {
                  _otp = value!;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select a profession';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
              buildInputField(
                context,
                screenWidth,
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 16.0), // Add vertical spacing
              buildInputField(
                context,
                screenWidth,
                label: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value!;
                },
              ),
              SizedBox(height: 20.0), // Add vertical spacing
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Implement registration logic here
                      print('First Name: $_firstName');
                      print('Surname: $_surname');
                      print('Gender: $_gender');
                      print('Full Name: $_fullName');
                      print('Mobile No: $_mobileNo');
                      print('Email: $_email');
                      print('OTP: $_otp');
                      print('Profession: $_profession');
                      print('Password: $_password');
                    }
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(BuildContext context, double screenWidth,
      {required String label,
        TextInputType? keyboardType,
        bool obscureText = false,
        Widget? suffixIcon,
        String? Function(String?)? validator,
        void Function(String?)? onSaved}) {
    return Center(
      child: Container(
        width: screenWidth * 0.75,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.lightBlue[50],
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }

  Widget buildDropdownField(
      BuildContext context, double screenWidth,
      {required String label,
        String? value,
        required List<DropdownMenuItem<String>> items,
        void Function(String?)? onChanged,
        String? Function(String?)? validator}) {
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
          validator: validator,
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

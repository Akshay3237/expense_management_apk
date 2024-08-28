// lib/services/register_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart'; // Import the constants file

class RegisterService {
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String surname,
    required String fullName,
    required String gender,
    required String mobileno,
    required String email,
    required String profession,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(REGISTER_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'firstName': firstName,
          'surname': surname,
          'fullName': fullName,
          'gender': gender,
          'mobileno': mobileno,
          'email': email,
          'profession': profession,
          'password': password,
        }),
      );
      print(jsonEncode({
        'firstName': firstName,
        'surname': surname,
        'fullName': fullName,
        'gender': gender,
        'mobileno': mobileno,
        'email': email,
        'profession': profession,
        'password': password,
      }));

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'User registered successfully'};
      } else {
        print(response.statusCode);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (error) {
      print("here 8");
      return {
        'success': false,
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }
}

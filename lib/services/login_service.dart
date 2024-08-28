// lib/services/login_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart'; // Import the constants file

class LoginService {
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(LOGIN_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'success': true,
          'token': responseData['token'],
          'message': responseData['message'],
        };
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }
}

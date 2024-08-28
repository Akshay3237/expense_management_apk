// File: lib/services/user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/user_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class UserService {
  // Create a new user
  Future<Map<String, dynamic>> createUser(User user) async {
    final response = await http.post(
      Uri.parse(USER_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'User created successfully!',
      };
    } else {
      throw Exception('Failed to create user: \${response.body}');
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(USER_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromMap(user)).toList();
    } else {
      throw Exception('Failed to load users: \${response.body}');
    }
  }

  // Get user by ID
  Future<User> getUserById(String id) async {
    final response = await http.get(Uri.parse('\$USER_URL/\$id'));

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user: \${response.body}');
    }
  }

  // Update user by ID
  Future<User> updateUser(String id, User user) async {
    final response = await http.put(
      Uri.parse('\$USER_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user: \${response.body}');
    }
  }

  // Delete user by ID
  Future<String> deleteUserById(String id) async {
    final response = await http.delete(Uri.parse('\$USER_URL/\$id'));

    if (response.statusCode == 200) {
      return 'User deleted successfully!';
    } else {
      throw Exception('Failed to delete user: \${response.body}');
    }
  }

  // Delete all users
  Future<String> deleteAllUsers() async {
    final response = await http.delete(Uri.parse(USER_URL));

    if (response.statusCode == 200) {
      return 'All users deleted successfully!';
    } else {
      throw Exception('Failed to delete all users: \${response.body}');
    }
  }
}
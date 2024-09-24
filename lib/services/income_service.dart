import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/income_model.dart'; // Import the Income model
import 'package:expense_tracker/constants.dart'; // Import your constants
import 'package:shared_preferences/shared_preferences.dart'; // For JWT storage

class IncomeService {
  // Helper function to get the JWT token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Get the JWT token from storage
  }

  // Create a new income
  Future<String> createIncome(Income income) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(INCOME_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(income.toMap()),
      );

      if (response.statusCode == 201) {
        return 'Income created successfully!';
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to create income: ${errorResponse['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Get all incomes
  Future<List<Income>> getAllIncomes() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(INCOME_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((income) => Income.fromMap(income)).toList();
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to load incomes: ${errorResponse['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Get income by ID
  Future<Income> getIncomeById(String id) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$INCOME_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return Income.fromMap(jsonDecode(response.body));
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to load income: ${errorResponse['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Update income by ID
  Future<Map<String, Object>> updateIncome(String id, Income income) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$INCOME_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode({
          'amount': income.amount,
          'category': income.category,
          'recurring': income.recurring,
          'note': income.note,
          'date': income.date.toIso8601String(), // Ensure date is in ISO format
          'userId': income.userId, // Include userId if required
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Income updated successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update Income: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }

  }



  // Delete income by ID
  Future<Map<String, dynamic>> deleteIncomeById(String id) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$INCOME_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Income deleted successfully!'};
      } else {
        final errorResponse = jsonDecode(response.body);
        return {'success': false, 'message': errorResponse['error'] ?? 'Unknown error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Delete all incomes
  Future<String> deleteAllIncomes() async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse(INCOME_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return 'All incomes deleted and archived successfully!';
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to delete all incomes: ${errorResponse['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}

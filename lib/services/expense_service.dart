import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/expense_model.dart'; // Import the Expense model
import 'package:expense_tracker/constants.dart'; // Import your constants
import 'package:shared_preferences/shared_preferences.dart'; // For token storage

class ExpenseService {
  // Helper function to get auth token
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Create a new expense
  Future<Map<String, dynamic>> createExpense(Expense expense) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse(EXPENSE_URL),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(expense.toMap()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Expense created successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all expenses
  Future<Map<String, dynamic>> getAllExpenses() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse(EXPENSE_URL),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Expense> expenses = data.map((expense) => Expense.fromMap(expense)).toList();
        return {
          'success': true,
          'expenses': expenses,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load expenses: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get expense by ID
  Future<Map<String, dynamic>> getExpenseById(String id) async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$EXPENSE_URL/$id'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'expense': Expense.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update expense by ID
  Future<Map<String, Object>> updateExpense(String id, Expense expense) async {
    try {
      final token = await _getAuthToken();
      final response = await http.put(
        Uri.parse('$EXPENSE_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(expense.toMap()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Expense updated successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete expense by ID
  Future<Map<String, dynamic>> deleteExpenseById(String id) async {
    try {
      final token = await _getAuthToken();
      final response = await http.delete(
        Uri.parse('$EXPENSE_URL/$id'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Expense archived and deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all expenses
  Future<Map<String, dynamic>> deleteAllExpenses() async {
    try {
      final token = await _getAuthToken();
      final response = await http.delete(
        Uri.parse(EXPENSE_URL),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All expenses archived and deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all expenses: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}

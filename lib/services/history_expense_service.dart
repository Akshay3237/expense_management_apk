import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/history_expense_model.dart'; // Import your HistoryExpense model
import 'package:expense_tracker/constants.dart'; // Import your constants
import 'package:shared_preferences/shared_preferences.dart'; // For accessing stored token

class HistoryExpenseService {
  // Fetch the JWT token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Get the JWT token from storage
  }

  // Create a new history expense record
  Future<Map<String, dynamic>> createHistoryExpense(HistoryExpense historyExpense) async {
    try {
      final token = await _getToken(); // Fetch the token
      final response = await http.post(
        Uri.parse(HISTORY_EXPENSE_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
        body: jsonEncode(historyExpense.toMap()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'History expense created successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create history expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all history expense records
  Future<Map<String, dynamic>> getAllHistoryExpenses() async {
    try {
      final token = await _getToken(); // Fetch the token
      final response = await http.get(
        Uri.parse(HISTORY_EXPENSE_URL),
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<HistoryExpense> historyExpenses = data.map((expense) => HistoryExpense.fromMap(expense)).toList();
        return {
          'success': true,
          'historyExpenses': historyExpenses,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load history expenses: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get history expense record by ID
  Future<Map<String, dynamic>> getHistoryExpenseById(String id) async {
    try {
      final token = await _getToken(); // Fetch the token
      final response = await http.get(
        Uri.parse('$HISTORY_EXPENSE_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'historyExpense': HistoryExpense.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load history expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update history expense record by ID
  Future<Map<String, dynamic>> updateHistoryExpense(String id, HistoryExpense historyExpense) async {
    try {
      final token = await _getToken(); // Fetch the token
      final response = await http.put(
        Uri.parse('$HISTORY_EXPENSE_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
        body: jsonEncode(historyExpense.toMap()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'History expense updated successfully!',
          'historyExpense': HistoryExpense.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update history expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete history expense record by ID
  Future<Map<String, dynamic>> deleteHistoryExpenseById(String id) async {
    try {
      final token = await _getToken(); // Fetch the token
      final response = await http.delete(
        Uri.parse('$HISTORY_EXPENSE_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'History expense deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete history expense: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all history expense records
  Future<Map<String, dynamic>> deleteAllHistoryExpenses() async {
    try {
      final token = await _getToken(); // Fetch the token
      final response = await http.delete(
        Uri.parse(HISTORY_EXPENSE_URL),
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the Authorization header
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All history expense records deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all history expense records: ${errorResponse['error'] ?? 'Unknown error'}',
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

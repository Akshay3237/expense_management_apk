// File: lib/services/budget_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/budget_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path
import 'package:shared_preferences/shared_preferences.dart'; // For JWT storage

class BudgetService {
  // Helper function to get the JWT token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Get the JWT token from storage
  }

  // Create a new budget
  Future<Map<String, dynamic>> createBudget(Budget budget) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.post(
        Uri.parse(BUDGET_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(budget.toMap()),
      );


      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Budget created successfully!',


        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create budget: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all budgets
  Future<Map<String, dynamic>> getAllBudgets() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse(BUDGET_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Budget> budgets = data.map((budget) => Budget.fromMap(budget)).toList();
        return {
          'success': true,
          'budgets': budgets,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load budgets: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get budget by ID
  Future<Map<String, dynamic>> getBudgetById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse('$BUDGET_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'budget': Budget.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load budget: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update budget by ID
  Future<Map<String, dynamic>> updateBudget(String id, Budget budget) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.put(
        Uri.parse('$BUDGET_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(budget.toMap()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Budget updated successfully!',
          'budget': Budget.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update budget: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete budget by ID
  Future<Map<String, dynamic>> deleteBudgetById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse('$BUDGET_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Budget deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete budget: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all budgets
  Future<Map<String, dynamic>> deleteAllBudgets() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse(BUDGET_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All budgets deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all budgets: ${errorResponse['error'] ?? 'Unknown error'}',
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

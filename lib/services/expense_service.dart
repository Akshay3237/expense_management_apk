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
  Future<String> createExpense(Expense expense) async {
    String? token = await _getAuthToken();

    final response = await http.post(
      Uri.parse(EXPENSE_URL),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(expense.toMap()),
    );

    if (response.statusCode == 201) {
      return 'Expense created successfully!';
    } else {
      throw Exception('Failed to create expense: ${response.statusCode} - ${response.body}');
    }
  }

  // Get all expenses
  Future<List<Expense>> getAllExpenses(String userId) async {
    String? token = await _getAuthToken();

    final response = await http.get(
      Uri.parse(EXPENSE_URL),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((expense) => Expense.fromMap(expense)).toList();
    } else {
      throw Exception('Failed to load expenses: ${response.statusCode} - ${response.body}');
    }
  }

  // Get expense by ID
  Future<Expense> getExpenseById(String id) async {
    String? token = await _getAuthToken();

    final response = await http.get(
      Uri.parse('$EXPENSE_URL/$id'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Expense.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load expense: ${response.statusCode} - ${response.body}');
    }
  }

  // Update expense by ID
  Future<Expense> updateExpense(String id, Expense expense) async {
    String? token = await _getAuthToken();

    final response = await http.put(
      Uri.parse('$EXPENSE_URL/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(expense.toMap()),
    );

    if (response.statusCode == 200) {
      return Expense.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update expense: ${response.statusCode} - ${response.body}');
    }
  }

  // Delete expense by ID
  Future<String> deleteExpenseById(String id) async {
    String? token = await _getAuthToken();

    final response = await http.delete(
      Uri.parse('$EXPENSE_URL/$id'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return 'Expense archived and deleted successfully!';
    } else {
      throw Exception('Failed to delete expense: ${response.statusCode} - ${response.body}');
    }
  }

  // Delete all expenses
  Future<String> deleteAllExpenses() async {
    String? token = await _getAuthToken();

    final response = await http.delete(
      Uri.parse(EXPENSE_URL),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return 'All expenses archived and deleted successfully!';
    } else {
      throw Exception('Failed to delete all expenses: ${response.statusCode} - ${response.body}');
    }
  }
}

// File: lib/services/budget_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/budget_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class BudgetService {
  // Create a new budget
  Future<Map<String, dynamic>> createBudget(Budget budget) async {
    final response = await http.post(
      Uri.parse(BUDGET_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(budget.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'Budget created successfully!',
        'budget': Budget.fromMap(jsonDecode(response.body)),
      };
    } else {
      throw Exception('Failed to create budget: \${response.body}');
    }
  }

  // Get all budgets
  Future<List<Budget>> getAllBudgets() async {
    final response = await http.get(Uri.parse(BUDGET_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((budget) => Budget.fromMap(budget)).toList();
    } else {
      throw Exception('Failed to load budgets: \${response.body}');
    }
  }

  // Get budget by ID
  Future<Budget> getBudgetById(String id) async {
    final response = await http.get(Uri.parse('\$BUDGET_URL/\$id'));

    if (response.statusCode == 200) {
      return Budget.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load budget: \${response.body}');
    }
  }

  // Update budget by ID
  Future<Budget> updateBudget(String id, Budget budget) async {
    final response = await http.put(
      Uri.parse('\$BUDGET_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(budget.toMap()),
    );

    if (response.statusCode == 200) {
      return Budget.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update budget: \${response.body}');
    }
  }

  // Delete budget by ID
  Future<String> deleteBudgetById(String id) async {
    final response = await http.delete(Uri.parse('\$BUDGET_URL/\$id'));

    if (response.statusCode == 200) {
      return 'Budget deleted successfully!';
    } else {
      throw Exception('Failed to delete budget: \${response.body}');
    }
  }

  // Delete all budgets
  Future<String> deleteAllBudgets() async {
    final response = await http.delete(Uri.parse(BUDGET_URL));

    if (response.statusCode == 200) {
      return 'All budgets deleted successfully!';
    } else {
      throw Exception('Failed to delete all budgets: \${response.body}');
    }
  }
}
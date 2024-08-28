// File: lib/services/history_expense_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/history_expense_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class HistoryExpenseService {
  // Create a new history expense record
  Future<Map<String, dynamic>> createHistoryExpense(HistoryExpense historyExpense) async {
    final response = await http.post(
      Uri.parse(HISTORY_EXPENSE_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(historyExpense.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'History expense created successfully!',
      };
    } else {
      throw Exception('Failed to create history expense: \${response.body}');
    }
  }

  // Get all history expense records
  Future<List<HistoryExpense>> getAllHistoryExpenses() async {
    final response = await http.get(Uri.parse(HISTORY_EXPENSE_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((expense) => HistoryExpense.fromMap(expense)).toList();
    } else {
      throw Exception('Failed to load history expenses: \${response.body}');
    }
  }

  // Get history expense record by ID
  Future<HistoryExpense> getHistoryExpenseById(String id) async {
    final response = await http.get(Uri.parse('\$HISTORY_EXPENSE_URL/\$id'));

    if (response.statusCode == 200) {
      return HistoryExpense.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load history expense: \${response.body}');
    }
  }

  // Update history expense record by ID
  Future<HistoryExpense> updateHistoryExpense(String id, HistoryExpense historyExpense) async {
    final response = await http.put(
      Uri.parse('\$HISTORY_EXPENSE_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(historyExpense.toMap()),
    );

    if (response.statusCode == 200) {
      return HistoryExpense.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update history expense: \${response.body}');
    }
  }

  // Delete history expense record by ID
  Future<String> deleteHistoryExpenseById(String id) async {
    final response = await http.delete(Uri.parse('\$HISTORY_EXPENSE_URL/\$id'));

    if (response.statusCode == 200) {
      return 'History expense deleted successfully!';
    } else {
      throw Exception('Failed to delete history expense: \${response.body}');
    }
  }

  // Delete all history expense records
  Future<String> deleteAllHistoryExpenses() async {
    final response = await http.delete(Uri.parse(HISTORY_EXPENSE_URL));

    if (response.statusCode == 200) {
      return 'All history expense records deleted successfully!';
    } else {
      throw Exception('Failed to delete all history expense records: \${response.body}');
    }
  }
}
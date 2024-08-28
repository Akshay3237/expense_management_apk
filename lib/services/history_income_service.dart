// File: lib/services/history_income_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/history_income_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class HistoryIncomeService {
  // Create a new history income record
  Future<Map<String, dynamic>> createHistoryIncome(HistoryIncome historyIncome) async {
    final response = await http.post(
      Uri.parse(HISTORY_INCOME_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(historyIncome.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'History income created successfully!',
      };
    } else {
      throw Exception('Failed to create history income: \${response.body}');
    }
  }

  // Get all history income records
  Future<List<HistoryIncome>> getAllHistoryIncomes() async {
    final response = await http.get(Uri.parse(HISTORY_INCOME_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((income) => HistoryIncome.fromMap(income)).toList();
    } else {
      throw Exception('Failed to load history incomes: \${response.body}');
    }
  }

  // Get history income record by ID
  Future<HistoryIncome> getHistoryIncomeById(String id) async {
    final response = await http.get(Uri.parse('\$HISTORY_INCOME_URL/\$id'));

    if (response.statusCode == 200) {
      return HistoryIncome.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load history income: \${response.body}');
    }
  }

  // Update history income record by ID
  Future<HistoryIncome> updateHistoryIncome(String id, HistoryIncome historyIncome) async {
    final response = await http.put(
      Uri.parse('\$HISTORY_INCOME_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(historyIncome.toMap()),
    );

    if (response.statusCode == 200) {
      return HistoryIncome.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update history income: \${response.body}');
    }
  }

  // Delete history income record by ID
  Future<String> deleteHistoryIncomeById(String id) async {
    final response = await http.delete(Uri.parse('\$HISTORY_INCOME_URL/\$id'));

    if (response.statusCode == 200) {
      return 'History income deleted successfully!';
    } else {
      throw Exception('Failed to delete history income: \${response.body}');
    }
  }

  // Delete all history income records
  Future<String> deleteAllHistoryIncomes() async {
    final response = await http.delete(Uri.parse(HISTORY_INCOME_URL));

    if (response.statusCode == 200) {
      return 'All history income records deleted successfully!';
    } else {
      throw Exception('Failed to delete all history income records: \${response.body}');
    }
  }
}
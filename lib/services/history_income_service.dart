import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/history_income_model.dart'; // Import your HistoryIncome model
import 'package:expense_tracker/constants.dart'; // Import your constants

class HistoryIncomeService {
  // Create a new history income record
  Future<Map<String, dynamic>> createHistoryIncome(HistoryIncome historyIncome) async {
    try {
      final response = await http.post(
        Uri.parse(HISTORY_INCOME_URL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(historyIncome.toMap()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'History income created successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create history income: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all history income records
  Future<Map<String, dynamic>> getAllHistoryIncomes() async {
    try {
      final response = await http.get(Uri.parse(HISTORY_INCOME_URL));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<HistoryIncome> historyIncomes = data.map((income) => HistoryIncome.fromMap(income)).toList();
        return {
          'success': true,
          'historyIncomes': historyIncomes,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load history incomes: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get history income record by ID
  Future<Map<String, dynamic>> getHistoryIncomeById(String id) async {
    try {
      final response = await http.get(Uri.parse('$HISTORY_INCOME_URL/$id'));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'historyIncome': HistoryIncome.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load history income: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update history income record by ID
  Future<Map<String, dynamic>> updateHistoryIncome(String id, HistoryIncome historyIncome) async {
    try {
      final response = await http.put(
        Uri.parse('$HISTORY_INCOME_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(historyIncome.toMap()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'History income updated successfully!',
          'historyIncome': HistoryIncome.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update history income: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete history income record by ID
  Future<Map<String, dynamic>> deleteHistoryIncomeById(String id) async {
    try {
      final response = await http.delete(Uri.parse('$HISTORY_INCOME_URL/$id'));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'History income deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete history income: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all history income records
  Future<Map<String, dynamic>> deleteAllHistoryIncomes() async {
    try {
      final response = await http.delete(Uri.parse(HISTORY_INCOME_URL));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All history income records deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all history income records: ${errorResponse['error'] ?? 'Unknown error'}',
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

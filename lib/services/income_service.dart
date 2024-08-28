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
    final token = await _getToken(); // Fetch the JWT token
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
      throw Exception('Failed to create income: ${response.body}');
    }
  }

  // Get all incomes
  Future<List<Income>> getAllIncomes(String userId) async {
    final token = await _getToken(); // Fetch the JWT token
    final response = await http.get(
      Uri.parse(INCOME_URL),
      headers: {
        'Authorization': 'Bearer $token', // Include the JWT token in the headers
      },
    );

    if (response.statusCode == 200) {

      List<dynamic> data = jsonDecode(response.body);
      // Income income=Income.fromMap(data[0]);
      // print(data[0].runtimeType);
      return data.map((income) => Income.fromMap(income)).toList();

    } else {
      throw Exception('Failed to load incomes: ${response.body}');
    }
  }

  // Get income by ID
  Future<Income> getIncomeById(String id) async {
    final token = await _getToken(); // Fetch the JWT token
    final response = await http.get(
      Uri.parse('$INCOME_URL/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include the JWT token in the headers
      },
    );

    if (response.statusCode == 200) {
      return Income.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load income: ${response.body}');
    }
  }

  // Update income by ID
  Future<Income> updateIncome(String id, Income income) async {
    final token = await _getToken(); // Fetch the JWT token
    final response = await http.put(
      Uri.parse('$INCOME_URL/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the JWT token in the headers
      },
      body: jsonEncode(income.toMap()),
    );

    if (response.statusCode == 200) {
      return Income.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update income: ${response.body}');
    }
  }

  // Delete income by ID
  Future<String> deleteIncomeById(String id) async {
    final token = await _getToken(); // Fetch the JWT token
    final response = await http.delete(
      Uri.parse('$INCOME_URL/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include the JWT token in the headers
      },
    );

    if (response.statusCode == 200) {
      return 'Income deleted successfully!';
    } else {
      throw Exception('Failed to delete income: ${response.body}');
    }
  }

  // Delete all incomes
  Future<String> deleteAllIncomes() async {
    final token = await _getToken(); // Fetch the JWT token
    final response = await http.delete(
      Uri.parse(INCOME_URL),
      headers: {
        'Authorization': 'Bearer $token', // Include the JWT token in the headers
      },
    );

    if (response.statusCode == 200) {
      return 'All incomes deleted and archived successfully!';
    } else {
      throw Exception('Failed to delete all incomes: ${response.body}');
    }
  }
}

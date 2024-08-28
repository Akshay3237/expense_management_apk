// File: lib/services/category_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/category_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path
import 'package:shared_preferences/shared_preferences.dart'; // For JWT storage

class CategoryService {
  // Helper function to get the JWT token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Get the JWT token from storage
  }

  // Create a new category
  Future<Map<String, dynamic>> createCategory(Category category) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.post(
        Uri.parse(CATEGORY_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(category.toMap()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Category created successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create category: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all categories
  Future<Map<String, dynamic>> getAllCategories() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse(CATEGORY_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories = data.map((category) => Category.fromMap(category)).toList();
        return {
          'success': true,
          'categories': categories,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load categories: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get category by ID
  Future<Map<String, dynamic>> getCategoryById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse('$CATEGORY_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        Category category = Category.fromMap(jsonDecode(response.body));
        return {
          'success': true,
          'category': category,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load category: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update category by ID
  Future<Map<String, dynamic>> updateCategory(String id, Category category) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.put(
        Uri.parse('$CATEGORY_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(category.toMap()),
      );

      if (response.statusCode == 200) {
        Category updatedCategory = Category.fromMap(jsonDecode(response.body));
        return {
          'success': true,
          'category': updatedCategory,
          'message': 'Category updated successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update category: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete category by ID
  Future<Map<String, dynamic>> deleteCategoryById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse('$CATEGORY_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Category deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete category: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all categories
  Future<Map<String, dynamic>> deleteAllCategories() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse(CATEGORY_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All categories deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all categories: ${errorResponse['error'] ?? 'Unknown error'}',
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

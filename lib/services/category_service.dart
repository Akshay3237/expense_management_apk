// File: lib/services/category_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/category_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class CategoryService {
  // Create a new category
  Future<Map<String, dynamic>> createCategory(Category category) async {
    final response = await http.post(
      Uri.parse(CATEGORY_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'Category created successfully!',
      };
    } else {
      throw Exception('Failed to create category: \${response.body}');
    }
  }

  // Get all categories
  Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse(CATEGORY_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((category) => Category.fromMap(category)).toList();
    } else {
      throw Exception('Failed to load categories: \${response.body}');
    }
  }

  // Get category by ID
  Future<Category> getCategoryById(String id) async {
    final response = await http.get(Uri.parse('\$CATEGORY_URL/\$id'));

    if (response.statusCode == 200) {
      return Category.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load category: \${response.body}');
    }
  }

  // Update category by ID
  Future<Category> updateCategory(String id, Category category) async {
    final response = await http.put(
      Uri.parse('\$CATEGORY_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toMap()),
    );

    if (response.statusCode == 200) {
      return Category.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update category: \${response.body}');
    }
  }

  // Delete category by ID
  Future<String> deleteCategoryById(String id) async {
    final response = await http.delete(Uri.parse('\$CATEGORY_URL/\$id'));

    if (response.statusCode == 200) {
      return 'Category deleted successfully!';
    } else {
      throw Exception('Failed to delete category: \${response.body}');
    }
  }

  // Delete all categories
  Future<String> deleteAllCategories() async {
    final response = await http.delete(Uri.parse(CATEGORY_URL));

    if (response.statusCode == 200) {
      return 'All categories deleted successfully!';
    } else {
      throw Exception('Failed to delete all categories: \${response.body}');
    }
  }
}
// lib/widgets/add_category.dart

import 'package:expense_tracker/models/category_model.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  final VoidCallback onClose; // Callback for closing the form
  final VoidCallback onSuccess; // Callback for successful submission

  AddCategory({required this.onClose, required this.onSuccess});

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _categoryController = TextEditingController();
  String _error = '';

  void _handleCategoryInputChange(String value) {
    // Handle category input change if needed
  }

  void _handleCategorySubmit() async {
    final newCategory = _categoryController.text.trim();

    if (newCategory.isEmpty) {
      setState(() {
        _error = 'Category name cannot be empty';
      });


      Category category=new Category(id: '',name: newCategory,userId:'');
      CategoryService categoryService=new CategoryService();
      await categoryService.createCategory(category);
    }

    // Add logic for submitting the category here
    // For now, we assume success and call the onSuccess callback
    widget.onSuccess();
    widget.onClose(); // Close the form after submission
  }

  void _handleCategoryCancel() {
    widget.onClose(); // Simply close the form without submitting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (true) // Replace with your condition to show the form
            Container(
              color: Colors.black54, // Overlay color
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          hintText: 'Enter new category',
                        ),
                        onChanged: _handleCategoryInputChange,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _handleCategorySubmit,
                        child: Text('Submit'),
                      ),
                      SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _handleCategoryCancel,
                        child: Text('Cancel'),
                      ),
                      if (_error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            _error,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

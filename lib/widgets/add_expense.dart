import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/comonFunctions.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:expense_tracker/services/category_service.dart';
import '../models/category_model.dart';

class AddExpense extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSuccess;

  AddExpense({required this.onClose, required this.onSuccess});

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  Category? _selectedCategory;
  DateTime _date = DateTime.now();
  String _note = '';
  bool _recurring = false;
  String _error = '';
  bool _isLoading = false; // Loading state

  List<Category> _categories = []; // List of Category objects

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_date);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoryService = CategoryService();
      final result = await categoryService.getAllCategories();

      if (result['success']) {
        final categories = result['categories'] as List<Category>;
        setState(() {
          _categories = categories;
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories.first;
          }
        });
      } else {
        setState(() {
          _error = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch categories: ${e.toString()}';
      });
    }
  }

  void _handleCategoryChange(Category? value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  void _handleDateChange(DateTime value) {
    setState(() {
      _date = value;
      _dateController.text = DateFormat('yyyy-MM-dd').format(value);
    });
  }

  void _handleNoteChange(String value) {
    setState(() {
      _note = value;
    });
  }

  void _handleRecurringChange(bool? value) {
    setState(() {
      _recurring = value ?? false;
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        final userId = await getUserId();
        if (userId != null && _selectedCategory != null) {
          final expense = Expense(
            id: '',
            amount: double.tryParse(_amountController.text) ?? 0.0,
            category: _selectedCategory!.id, // Passing category ID
            date: _date,
            note: _note,
            recurring: _recurring,
            userId: userId,
          );

          final expenseService = ExpenseService();
          await expenseService.createExpense(expense);

          widget.onSuccess();

        } else {
          setState(() {
            _error = 'Failed to get user ID or category selection is missing.';
          });
        }
      } catch (e) {
        setState(() {
          _error = 'Failed to create expense: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onClose,
          )
        ],
      ),
      body: _isLoading // Check if loading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name), // Display category name
                  );
                }).toList(),
                onChanged: _handleCategoryChange,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _date) {
                    _handleDateChange(selectedDate);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note',
                ),
                maxLines: 3,
                onChanged: _handleNoteChange,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _recurring,
                    onChanged: _handleRecurringChange,
                  ),
                  Text('Recurring'),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Add Expense'),
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
    );
  }
}

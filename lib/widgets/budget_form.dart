import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/budget_model.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:expense_tracker/models/category_model.dart';
import 'package:expense_tracker/services/budget_service.dart';
import '../comonFunctions.dart';

class BudgetForm extends StatefulWidget {
  final VoidCallback onBudgetSubmitted; // Callback function

  BudgetForm({required this.onBudgetSubmitted});

  @override
  _BudgetFormState createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _amountController = TextEditingController();
  Category? _selectedCategory;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));
  final _budgetService = BudgetService();
  bool _isSubmitting = false; // For loading indicator

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoryService = CategoryService();
      final result = await categoryService.getAllCategories();

      if (result['success']) {
        final categories = result['categories'] as List<Category>;
        String userId = (await getUserId())!;
        // Filter categories based on userId
        List<Category> filteredCategories = categories
            .where((category) => category.userId == userId)
            .toList();
        setState(() {
          _categories = filteredCategories;
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories.first;
          }
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
        });
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  void _submitForm() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final categoryId = _selectedCategory?.id ?? '';

    if (amount <= 0 || categoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter valid details.')));
      return;
    }

    setState(() {
      _isSubmitting = true; // Show progress indicator
    });

    final budget = Budget(
      id: "",
      userId: (await getUserId()).toString(),
      amount: amount,
      categoryId: categoryId,
      startDate: _startDate,
      endDate: _endDate,
    );

    final result = await _budgetService.createBudget(budget);

    setState(() {
      _isSubmitting = false; // Hide progress indicator
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      widget.onBudgetSubmitted(); // Trigger budget list refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate ? _startDate : _endDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isSubmitting
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Category'),
              items: _categories.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text('Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate)}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('Select Start Date'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('End Date: ${DateFormat('yyyy-MM-dd').format(_endDate)}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('Select End Date'),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

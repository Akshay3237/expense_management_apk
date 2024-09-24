import 'package:flutter/material.dart';
import 'package:expense_tracker/comonFunctions.dart';
import 'package:expense_tracker/models/expense_model.dart'; // Adjust path as necessary
import 'package:expense_tracker/services/expense_service.dart'; // Adjust path as necessary
import 'package:expense_tracker/services/category_service.dart';
import '../models/category_model.dart'; // Import CategoryService to fetch categories

class UpdateExpenseForm extends StatefulWidget {
  final Expense expense;

  UpdateExpenseForm({required this.expense});

  @override
  _UpdateExpenseFormState createState() => _UpdateExpenseFormState();
}

class _UpdateExpenseFormState extends State<UpdateExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late double _amount;
  late String _category;
  late bool _recurring;
  late String _note;
  late DateTime _date;
  List<Category> _categories = [];
  bool _isLoading = false; // Add this variable for loading state

  @override
  void initState() {
    super.initState();
    _amount = widget.expense.amount;
    _category = widget.expense.category ?? '';
    _recurring = widget.expense.recurring;
    _note = widget.expense.note ?? '';
    _date = widget.expense.date;
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categoryService = CategoryService();
    final response = await categoryService.getAllCategories();

    if (response['success']) {
      // Convert response to List<Category>
      List<Category> allCategories = (response['categories']);

      String userId = (await getUserId())!;
      // Filter categories based on userId
      List<Category> filteredCategories = allCategories
          .where((category) => category.userId == userId)
          .toList();

      setState(() {
        _categories = filteredCategories;
      });
    }
  }

  Future<void> _updateExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Set loading to true when the update starts
      });

      final expenseService = ExpenseService();
      final updatedExpense = Expense(
        id: widget.expense.id,
        amount: _amount,
        category: _category,
        recurring: _recurring,
        note: _note,
        date: _date,
        userId: widget.expense.userId, // Ensure userId is set
      );

      try {
        final result = await expenseService.updateExpense(updatedExpense.id, updatedExpense) as Map<String, Object>;
        if (result['success'] as bool) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] as String)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false; // Set loading to false when the update completes
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    for (Category category in _categories) {
      if (category.name == _category) {
        _category = category.id;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Expense'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: _amount.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Amount'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _amount = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _category.isEmpty ? null : _category,
                      decoration: InputDecoration(labelText: 'Category'),
                      items: _categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                      onSaved: (value) {
                        _category = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Recurring'),
                      value: _recurring,
                      onChanged: (value) {
                        setState(() {
                          _recurring = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _note,
                      decoration: InputDecoration(labelText: 'Note'),
                      onSaved: (value) {
                        _note = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _date.toLocal().toString().split(' ')[0],
                      decoration: InputDecoration(labelText: 'Date'),
                      onSaved: (value) {
                        _date = DateTime.parse(value!);
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateExpense,
                      child: Text('Update Expense'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) // Show progress indicator when loading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/income_model.dart'; // Adjust path as necessary
import 'package:expense_tracker/services/income_service.dart'; // Adjust path as necessary
import 'package:expense_tracker/services/category_service.dart';
import '../models/category_model.dart'; // Import CategoryService to fetch categories

class UpdateIncomeForm extends StatefulWidget {
  final Income income;

  UpdateIncomeForm({required this.income});

  @override
  _UpdateIncomeFormState createState() => _UpdateIncomeFormState();
}

class _UpdateIncomeFormState extends State<UpdateIncomeForm> {
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
    _amount = widget.income.amount;
    _category = widget.income.category ?? '';
    _recurring = widget.income.recurring;
    _note = widget.income.note ?? '';
    _date = widget.income.date;
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

  Future<void> _updateIncome() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Set loading to true when the update starts
      });

      final incomeService = IncomeService();
      final updatedIncome = Income(
        id: widget.income.id,
        amount: _amount,
        category: _category,
        recurring: _recurring,
        note: _note,
        date: _date,
        userId: widget.income.userId, // Ensure userId is set
      );

      try {
        final result = await incomeService.updateIncome(updatedIncome.id, updatedIncome) as Map<String, Object>;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
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
        title: Text('Update Income'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _date.toLocal().toString().split(' ')[0],
                        ),
                        decoration: InputDecoration(labelText: 'Date'),
                        onSaved: (value) {
                          _date = DateTime.parse(value!);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateIncome,
                    child: Text('Update Income'),
                  ),
                ],
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

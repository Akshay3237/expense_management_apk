import 'package:flutter/material.dart';

class AddIncome extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSuccess;

  AddIncome({required this.onClose, required this.onSuccess});

  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _note = '';
  bool _recurring = false;
  String _error = '';

  final List<String> _categories = [
    'Category 1',
    'Category 2',
    'Category 3'
    // Add actual categories here
  ];

  void _handleCategoryChange(String? value) {
    setState(() {
      _selectedCategory = value ?? '';
    });
  }

  void _handleAmountChange(String value) {
    setState(() {
      _amount = double.tryParse(value) ?? 0.0;
    });
  }

  void _handleDateChange(DateTime value) {
    setState(() {
      _date = value;
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

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission
      print('Income added with amount: $_amount, category: $_selectedCategory, date: $_date, note: $_note, recurring: $_recurring');

      widget.onSuccess();
      widget.onClose(); // Close the form after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Income'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onClose,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                onChanged: _handleAmountChange,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: _handleCategoryChange,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
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
                controller: TextEditingController(text: _date.toLocal().toString().split(' ')[0]),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
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
                child: Text('Add Income'),
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

import 'package:flutter/material.dart';
import 'package:expense_tracker/models/budget_model.dart';
import 'package:expense_tracker/services/budget_service.dart';
import 'package:intl/intl.dart';

import '../comonFunctions.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class BudgetList extends StatefulWidget {
  BudgetList({Key? key}) : super(key: key);

  @override
  BudgetListState createState() => BudgetListState();
}

class BudgetListState extends State<BudgetList> {
  List<Budget> _budgets = [];
  bool _isLoading = true;
  Map<String, String> _categories = {};

  @override
  void initState() {
    super.initState();
    fetchBudgets();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoryService = CategoryService();
      final result = await categoryService.getAllCategories();

      if (result['success']) {
        final categories = result['categories'] as List<Category>;
        String? userId = (await getUserId());
        if (userId == null) {
          throw Exception("userId is null");
        }
        // Filter categories based on userId
        List<Category> filteredCategories = categories
            .where((category) => category.userId == userId)
            .toList();
        Map<String, String> cat = {};
        for (Category c in filteredCategories) {
          cat[c.id] = c.name;
        }
        setState(() {
          _categories = cat;
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

  Future<void> fetchBudgets() async {
    setState(() {
      _isLoading = true; // Show loading
    });
    try {
      final budgetService = BudgetService();
      final result = await budgetService.getAllBudgets();
      if (result['success']) {
        final budgets = result['budgets'] as List<Budget>;

        setState(() {
          _budgets = budgets;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch budgets: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
    }
  }

  Future<void> _deleteBudget(String budgetId) async {
    setState(() {
      _isLoading = true; // Show loading during deletion
    });
    try {
      final budgetService = BudgetService();
      final result = await budgetService.deleteBudgetById(budgetId);

      if (result['success']) {
        setState(() {
          // Remove the budget from the list
          _budgets.removeWhere((budget) => budget.id == budgetId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Budget deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete budget: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false; // Hide loading after deletion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: _budgets.length,
      itemBuilder: (context, index) {
        final budget = _budgets[index];
        return ListTile(
          title: Text(budget.amount.toString()),
          subtitle: Text(_categories[budget.categoryId] ?? "unknown category"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${DateFormat('yyyy-MM-dd').format(budget.startDate)} to ${DateFormat('yyyy-MM-dd').format(budget.endDate)}'),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteBudget(budget.id),
              ),
            ],
          ),
        );
      },
    );
  }
}

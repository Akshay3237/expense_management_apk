import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/history_expense_model.dart';
import 'package:expense_tracker/services/history_expense_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryExpenseWidget extends StatefulWidget {
  @override
  _HistoryExpenseWidgetState createState() => _HistoryExpenseWidgetState();
}

class _HistoryExpenseWidgetState extends State<HistoryExpenseWidget> {
  List<HistoryExpense> _historyExpenses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  List<String> showByUserIds = [];

  @override
  void initState() {
    super.initState();
    _initializeUserIdsAndFetchHistory();
  }

  void _initializeUserIdsAndFetchHistory() async {
    await _fillUserIds();
    await _fetchHistoryExpenses();
  }

  Future<void> _fillUserIds() async {
    try {
      String? uid = await getUserId();
      if (uid == null) throw Exception("Logged-in user ID is null");

      setState(() {
        showByUserIds.add(uid);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? collaboratingList = prefs.getStringList('collaboratingUsers');

      if (collaboratingList != null && collaboratingList.isNotEmpty) {
        setState(() {
          showByUserIds.addAll(collaboratingList);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _fetchHistoryExpenses() async {
    try {
      HistoryExpenseService historyExpenseService = HistoryExpenseService();
      Map<String, dynamic> result = await historyExpenseService.getAllHistoryExpenses();

      if (result['success']) {
        List<HistoryExpense> allExpenses = result['historyExpenses'] as List<HistoryExpense>;

        List<HistoryExpense> filteredExpenses = allExpenses.where((expense) {
          return showByUserIds.contains(expense.userId);
        }).toList();

        setState(() {
          _historyExpenses = filteredExpenses;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> deleteExpense(String id) async {
    setState(() {
      _isLoading = true;
    });
    HistoryExpenseService historyExpenseService = HistoryExpenseService();
    Map<String, dynamic> response = await historyExpenseService.deleteHistoryExpenseById(id);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Expense deleted successfully")));
      // Refresh the list after deletion
      _fetchHistoryExpenses();
    } else {
      String? message = response['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong: $message")));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _confirmDeleteExpense(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteExpense(id); // Proceed with deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Expense'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text('Error: $_errorMessage'))
                : _historyExpenses.isEmpty
                ? Center(child: Text('No expense history available'))
                : SingleChildScrollView(
              child: Column(
                children: _historyExpenses.map((expense) {
                  return ListTile(
                    title: Text(
                      'Category: ${expense.category}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Amount: ₹${expense.amount.toStringAsFixed(2)}\nDate: ${expense.date.toLocal()}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteExpense(expense.id), // Call confirm delete
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

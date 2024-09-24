import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/history_income_model.dart';
import 'package:expense_tracker/services/history_income_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryIncomeWidget extends StatefulWidget {
  @override
  _HistoryIncomeWidgetState createState() => _HistoryIncomeWidgetState();
}

class _HistoryIncomeWidgetState extends State<HistoryIncomeWidget> {
  List<HistoryIncome> _historyIncomes = [];
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
    await _fetchHistoryIncomes();
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

  Future<void> _fetchHistoryIncomes() async {
    try {
      HistoryIncomeService historyIncomeService = HistoryIncomeService();
      Map<String, dynamic> result = await historyIncomeService.getAllHistoryIncomes();

      if (result['success']) {
        List<HistoryIncome> allIncomes = result['historyIncomes'] as List<HistoryIncome>;
        print(showByUserIds);

        List<HistoryIncome> filteredIncomes = allIncomes.where((income) {
          return showByUserIds.contains(income.userId);
        }).toList();

        setState(() {
          _historyIncomes = filteredIncomes;
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

  void _deleteIncomeById(String incomeId) async {
    setState(() {
      _isLoading = true;
    });

    HistoryIncomeService historyIncomeService = HistoryIncomeService();
    Map<String, dynamic> response = await historyIncomeService.deleteHistoryIncomeById(incomeId);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Income entry deleted successfully.")));
      _fetchHistoryIncomes(); // Refresh the list after deletion
    } else {
      String? message = response['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message ?? "Something went wrong")));
    }
  }

  void _confirmDeleteIncomeById(String incomeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this income entry?'),
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
                _deleteIncomeById(incomeId); // Proceed with deletion
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
        title: Text('History Income'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text('Error: $_errorMessage'))
                : _historyIncomes.isEmpty
                ? Center(child: Text('No income history available'))
                : SingleChildScrollView(
              child: Column(
                children: _historyIncomes.map((income) {
                  return ListTile(
                    title: Text(
                      'Category: ${income.category}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Amount: ₹${income.amount.toStringAsFixed(2)}\nDate: ${income.date.toLocal()}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeleteIncomeById(income.id); // Call delete confirmation
                      },
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

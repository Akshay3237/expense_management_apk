import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/widgets/app_drawer.dart';
import 'package:expense_tracker/widgets/expense_box.dart';
import 'package:expense_tracker/widgets/income_box.dart';
import 'package:expense_tracker/widgets/add_income.dart';
import 'package:expense_tracker/widgets/add_expense.dart';
import 'package:expense_tracker/widgets/add_category.dart';
import 'package:expense_tracker/services/income_service.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:expense_tracker/models/income_model.dart';
import 'package:expense_tracker/models/expense_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isFetchIncome = false;
  bool isFetchExpense = false;
  bool _isDownloading = false; // New state variable

  final IncomeService _incomeService = IncomeService();
  final ExpenseService _expenseService = ExpenseService();

  @override
  void initState() {
    super.initState();
    checkAuthToken(context);
  }



  void _showAddIncomeForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Income'),
          content: AddIncome(
            onClose: () => Navigator.of(context).pop(),
            onSuccess: () {
              Navigator.of(context).pop();
              setState(() {
                isFetchIncome = true;
              });
            },
          ),
        );
      },
    );
  }

  void _showAddExpenseForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: AddExpense(
            onClose: () => Navigator.of(context).pop(),
            onSuccess: () {
              Navigator.of(context).pop();
              setState(() {
                isFetchExpense = true;
              });
            },
          ),
        );
      },
    );
  }

  void _showAddCategoryForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: AddCategory(
            onClose: () => Navigator.of(context).pop(),
            onSuccess: () {
              Navigator.of(context).pop();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Future<void> _downloadData() async {
    setState(() {
      _isDownloading = true; // Start progress indicator
    });

    try {
      // Fetch expenses
      final String userId = (await getUserId())!;
      final List<Expense> expenses = (await _expenseService.getAllExpenses())['expenses']
          .where((expense) => expense.userId == userId)
          .toList();

      // Fetch incomes
      final List<Income> incomes = (await _incomeService.getAllIncomes())
          .where((income) => income.userId == userId)
          .toList();

      final pdf = pw.Document();

      // Add expenses page
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Expenses', style: pw.TextStyle(fontSize: 24)),
                pw.Table.fromTextArray(
                  data: [
                    ['ID', 'Amount', 'Date', 'Category', 'Note'],
                    ...expenses.map((e) => [
                      e.id,
                      e.amount.toString(),
                      e.date.toLocal().toString().split(' ')[0],
                      e.category,
                      e.note ?? '',
                    ])
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Add incomes page
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Incomes', style: pw.TextStyle(fontSize: 24)),
                pw.Table.fromTextArray(
                  data: [
                    ['ID', 'Amount', 'Date', 'Category', 'Note'],
                    ...incomes.map((i) => [
                      i.id,
                      i.amount.toString(),
                      i.date.toLocal().toString().split(' ')[0],
                      i.category,
                      i.note ?? '',
                    ])
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Save and share the PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'expenses_and_incomes.pdf');
    } catch (e) {
      // Handle errors if needed
      print('Error generating PDF: $e');
    } finally {
      setState(() {
        _isDownloading = false; // Stop progress indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _showAddIncomeForm,
                      child: Text('Insert Income'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _showAddExpenseForm,
                      child: Text('Insert Expense'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _showAddCategoryForm,
                      child: Text('Insert Category'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _downloadData,
                      child: Text('Download Data'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ExpenseBox(isFetchExpense),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: IncomeBox(isFetchIncome),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isDownloading) // Show progress indicator if downloading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

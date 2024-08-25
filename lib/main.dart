import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/budget_page.dart';
import 'pages/history_page.dart';
import 'pages/collaboration_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/profile_page.dart';
import 'pages/about_us_page.dart';
import 'pages/contact_us_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardPage(),
        '/budget': (context) => BudgetPage(),
        '/history': (context) => HistoryPage(),
        '/collaboration': (context) => CollaborationPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/about': (context) => AboutUsPage(),
        '/contact': (context) => ContactUsPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('About Us')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            const Text(
              'Expense Management',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),


            // About the Application
            const Text(
              'Expense Management is a comprehensive financial management solution designed to help users track their income, expenses, and budget efficiently. '
                  'The app prioritizes data security and user-friendly interactions to make managing finances a seamless experience.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),


            // Core Features Section
            _sectionHeader('Core Features'),
            _buildFeature(
              'User Authentication',
              'Securely sign up, log in, and manage your account with encryption and HTTPS protocols.',
            ),
            _buildFeature(
              'Dashboard Overview',
              'Get a quick glance at your financial status with visual summaries of income, expenses, and budgets.',
            ),
            _buildFeature(
              'Expense Logging',
              'Log expenses (recurring or one-time) and track them by category easily.',
            ),
            _buildFeature(
              'Income Tracking',
              'Track your income, including amounts, dates, and sources.',
            ),
            _buildFeature(
              'Budget Setting',
              'Set monthly or custom budgets for categories.',
            ),
            _buildFeature(
              'Security and Privacy',
              'We prioritize your security with encryption, JWT for APIs, and HTTPS.',
            ),
            const SizedBox(height: 30),


            // Additional Features
            _sectionHeader('Additional Features'),
            _buildFeature(
              'Data Export/Import',
              'Export financial data to CSV or PDF formats for record keeping.',
            ),
            _buildFeature(
              'Collaboration',
              'Share your financial data with family members for joint management.',
            ),


            const SizedBox(height: 30),


            // Contact Information
            _sectionHeader('Contact Us'),
            const Text(
              'For more information or support, reach out to us at: \n\nakshaygohel364@gmail.com  or chiragchavda@gmail.com',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }


  // Helper method to build individual feature sections
  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }


  // Helper method for section headers
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}



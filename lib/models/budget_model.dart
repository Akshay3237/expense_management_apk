import 'package:flutter/material.dart';

// Define a class to represent the Budget model
class Budget {
  final String id;
  final String userId;
  final double amount;
  final String categoryId;
  final DateTime startDate;
  final DateTime endDate;

  // Constructor for the Budget class
  Budget({
    required this.id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.startDate,
    required this.endDate,
  });


  // Factory method to create a Budget instance from a map (e.g., JSON)
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['_id'],
      userId: map['user_id']['userId'],
      amount: map['amount'].toDouble(),
      categoryId: map['category']['_id'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }


  // Convert the Budget instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'amount': amount,
      'category': categoryId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}

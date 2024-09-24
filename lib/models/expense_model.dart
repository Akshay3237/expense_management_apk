import 'package:flutter/material.dart';

// Define a class to represent the Expense model
class Expense {
  final String id; // Assuming the ObjectId will be used as a String
  final String userId; // Represents user_id field
  final double amount; // Represents amount field
  final DateTime date; // Represents date field
  final bool recurring; // Represents recurring field
  final String category; // Represents category field
  final String? note; // Represents note field (optional)

  // Constructor for the Expense class
  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.recurring,
    required this.category,
    this.note,
  });

  // Factory method to create an Expense instance from a map (e.g., JSON)
  factory Expense.fromMap(Map<String, dynamic> map) {

    return Expense(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      userId: map['user_id']['_id'],
      amount: map['amount'].toDouble(),
      date: DateTime.parse(map['date']),
      recurring: map['recurring'],
      category: map['category']['name'],
      note: map['note'],
    );
  }

  // Convert the Expense instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      '_id': id, // MongoDB ObjectId typically maps to '_id'
      'user_id': userId,
      'amount': amount,
      'date': date.toIso8601String(),
      'recurring': recurring,
      'category': category,
      'note': note,
    };
  }
}

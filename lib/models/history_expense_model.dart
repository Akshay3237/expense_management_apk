import 'package:flutter/material.dart';

// Define a class to represent the HistoryExpense model
class HistoryExpense {
  final String id; // Represents the MongoDB ObjectId
  final String userId; // Represents user_id field
  final double amount; // Represents amount field
  final DateTime date; // Represents date field
  final String category; // Represents category field
  final String description; // Represents description field

  // Constructor for the HistoryExpense class
  HistoryExpense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
  });

  // Factory method to create a HistoryExpense instance from a map (e.g., JSON)
  factory HistoryExpense.fromMap(Map<String, dynamic> map) {
    return HistoryExpense(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      userId: map['user_id']['_id'],
      amount: map['amount'].toDouble(),
      date: DateTime.parse(map['date']),
      category: map['category']['name'],
      description: map['description'],
    );
  }

  // Convert the HistoryExpense instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      '_id': id, // MongoDB ObjectId typically maps to '_id'
      'user_id': userId,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
    };
  }
}

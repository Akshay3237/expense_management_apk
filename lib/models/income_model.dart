import 'package:flutter/material.dart';

// Define a class to represent the Income model
class Income {
  final String id; // Represents the MongoDB ObjectId
  final String userId; // Represents user_id field
  final double amount; // Represents amount field
  final DateTime date; // Represents date field
  final bool recurring; // Represents recurring field
  final String? category; // Represents category field
  final String? note; // Represents optional note field

  // Constructor for the Income class
  Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    this.recurring = false,
    this.category,
    this.note,
  });

  // Factory method to create an Income instance from a map (e.g., JSON)
  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      userId: map['user_id']['_id'],
      amount: map['amount'].toDouble(),
      date: DateTime.parse(map['date']),
      recurring: map['recurring'] ?? false,
      category: map['category']?['name'],
      note: map['note'],
    );
  }

  // Convert the Income instance to a map (e.g., for JSON serialization)
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

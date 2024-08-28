import 'package:flutter/material.dart';

// Define a class to represent the Notification model
class Notification {
  final String id; // Represents the MongoDB ObjectId
  final String userId; // Represents user_id field
  final String? budgetId; // Represents optional budget_id field
  final String message; // Represents message field
  final bool read; // Represents read field
  final DateTime createdAt; // Represents created_at field

  // Constructor for the Notification class
  Notification({
    required this.id,
    required this.userId,
    this.budgetId,
    required this.message,
    this.read = false,
    required this.createdAt,
  });

  // Factory method to create a Notification instance from a map (e.g., JSON)
  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      userId: map['user_id'],
      budgetId: map['budget_id'],
      message: map['message'],
      read: map['read'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Convert the Notification instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      '_id': id, // MongoDB ObjectId typically maps to '_id'
      'user_id': userId,
      'budget_id': budgetId,
      'message': message,
      'read': read,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

import 'package:flutter/material.dart';

// Define a class to represent the Category model
class Category {
  final String id; // Assuming the ObjectId will be used as a String
  final String name;
  final String userId; // Represents user_id field

  // Constructor for the Category class
  Category({
    required this.id,
    required this.name,
    required this.userId,
  });

  // Factory method to create a Category instance from a map (e.g., JSON)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      name: map['name'],
      userId: map['user_id'],
    );
  }

  // Convert the Category instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      '_id': id, // MongoDB ObjectId typically maps to '_id'
      'name': name,
      'user_id': userId,
    };
  }
}

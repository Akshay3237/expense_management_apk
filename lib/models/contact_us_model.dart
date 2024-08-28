import 'package:flutter/material.dart';

// Define a class to represent the ContactUs model
class ContactUs {
  final String id; // Assuming the ObjectId will be used as a String
  final String userName;
  final String email;
  final String description;
  final int feedbackRating;

  // Constructor for the ContactUs class
  ContactUs({
    required this.id,
    required this.userName,
    required this.email,
    required this.description,
    required this.feedbackRating,
  });

  // Factory method to create a ContactUs instance from a map (e.g., JSON)
  factory ContactUs.fromMap(Map<String, dynamic> map) {
    return ContactUs(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      userName: map['userName'],
      email: map['email'],
      description: map['description'],
      feedbackRating: map['feedbackRating'],
    );
  }

  // Convert the ContactUs instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      '_id': id, // MongoDB ObjectId typically maps to '_id'
      'userName': userName,
      'email': email,
      'description': description,
      'feedbackRating': feedbackRating,
    };
  }
}

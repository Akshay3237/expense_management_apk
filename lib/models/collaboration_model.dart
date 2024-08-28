import 'package:flutter/material.dart';

// Define a class to represent the Collaboration model
class Collaboration {
  final String id; // Assuming the ObjectId will be used as a String
  final String requestedUser; // Represents requested_user field
  final String requestingUser; // Represents requesting_user field
  final bool accepted;

  // Constructor for the Collaboration class
  Collaboration({
    required this.id,
    required this.requestedUser,
    required this.requestingUser,
    this.accepted = false,
  });

  // Factory method to create a Collaboration instance from a map (e.g., JSON)
  factory Collaboration.fromMap(Map<String, dynamic> map) {
    return Collaboration(
      id: map['_id'], // MongoDB ObjectId typically maps to '_id'
      requestedUser: map['requested_user'],
      requestingUser: map['requesting_user'],
      accepted: map['accepted'] ?? false,
    );
  }

  // Convert the Collaboration instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      '_id': id, // MongoDB ObjectId typically maps to '_id'
      'requested_user': requestedUser,
      'requesting_user': requestingUser,
      'accepted': accepted,
    };
  }
}

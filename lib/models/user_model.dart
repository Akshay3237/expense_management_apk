import 'package:flutter/material.dart';

// Define a class to represent the User model
class User {
  final String firstName;
  final String surname;
  final String fullName;
  final String gender;
  final String mobileno;
  final String email;
  final String profession;
  final String password;
  final String profilePicture;
  final String role;

  // Constructor for the User class
  User({
    required this.firstName,
    required this.surname,
    required this.fullName,
    required this.gender,
    required this.mobileno,
    required this.email,
    required this.profession,
    required this.password,
    this.profilePicture = 'defaultProfilePicture', // Default value for profilePicture
    this.role = 'user', // Default value for role
  });

  // Factory method to create a User instance from a map (e.g., JSON)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      surname: map['surname'],
      fullName: map['fullName'],
      gender: map['gender'],
      mobileno: map['mobileno'],
      email: map['email'],
      profession: map['profession'],
      password: map['password'],
      profilePicture: map['profilePicture'] ?? 'defaultProfilePicture',
      role: map['role'] ?? 'user',
    );
  }

  // Convert the User instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'fullName': fullName,
      'gender': gender,
      'mobileno': mobileno,
      'email': email,
      'profession': profession,
      'password': password,
      'profilePicture': profilePicture,
      'role': role,
    };
  }
}

// File: lib/services/contact_us_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/contact_us_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path
import 'package:shared_preferences/shared_preferences.dart'; // For JWT storage

class ContactUsService {
  // Helper function to get the JWT token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Get the JWT token from storage
  }

  // Create a new contact us entry
  Future<Map<String, dynamic>> createContactUs(ContactUs contactUs) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.post(
        Uri.parse(CONTACT_US_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(contactUs.toMap()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Contact Us entry created successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create Contact Us entry: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all contact us entries
  Future<Map<String, dynamic>> getAllContactUs() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse(CONTACT_US_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ContactUs> entries = data.map((entry) => ContactUs.fromMap(entry)).toList();
        return {
          'success': true,
          'contactUs': entries,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load Contact Us entries: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get contact us entry by ID
  Future<Map<String, dynamic>> getContactUsById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse('$CONTACT_US_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'contactUs': ContactUs.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load Contact Us entry: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update contact us entry by ID
  Future<Map<String, dynamic>> updateContactUs(String id, ContactUs contactUs) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.put(
        Uri.parse('$CONTACT_US_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(contactUs.toMap()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Contact Us entry updated successfully!',
          'contactUs': ContactUs.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update Contact Us entry: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete contact us entry by ID
  Future<Map<String, dynamic>> deleteContactUsById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse('$CONTACT_US_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Contact Us entry deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete Contact Us entry: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all contact us entries
  Future<Map<String, dynamic>> deleteAllContactUs() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse(CONTACT_US_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All Contact Us entries deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all Contact Us entries: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}

// File: lib/services/contact_us_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/contact_us_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class ContactUsService {
  // Create a new contact us entry
  Future<Map<String, dynamic>> createContactUs(ContactUs contactUs) async {
    final response = await http.post(
      Uri.parse(CONTACT_US_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contactUs.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'Contact Us entry created successfully!',
      };
    } else {
      throw Exception('Failed to create Contact Us entry: \${response.body}');
    }
  }

  // Get all contact us entries
  Future<List<ContactUs>> getAllContactUs() async {
    final response = await http.get(Uri.parse(CONTACT_US_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((entry) => ContactUs.fromMap(entry)).toList();
    } else {
      throw Exception('Failed to load Contact Us entries: \${response.body}');
    }
  }

  // Get contact us entry by ID
  Future<ContactUs> getContactUsById(String id) async {
    final response = await http.get(Uri.parse('\$CONTACT_US_URL/\$id'));

    if (response.statusCode == 200) {
      return ContactUs.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Contact Us entry: \${response.body}');
    }
  }

  // Update contact us entry by ID
  Future<ContactUs> updateContactUs(String id, ContactUs contactUs) async {
    final response = await http.put(
      Uri.parse('\$CONTACT_US_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contactUs.toMap()),
    );

    if (response.statusCode == 200) {
      return ContactUs.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Contact Us entry: \${response.body}');
    }
  }

  // Delete contact us entry by ID
  Future<String> deleteContactUsById(String id) async {
    final response = await http.delete(Uri.parse('\$CONTACT_US_URL/\$id'));

    if (response.statusCode == 200) {
      return 'Contact Us entry deleted successfully!';
    } else {
      throw Exception('Failed to delete Contact Us entry: \${response.body}');
    }
  }

  // Delete all contact us entries
  Future<String> deleteAllContactUs() async {
    final response = await http.delete(Uri.parse(CONTACT_US_URL));

    if (response.statusCode == 200) {
      return 'All Contact Us entries deleted successfully!';
    } else {
      throw Exception('Failed to delete all Contact Us entries: \${response.body}');
    }
  }
}
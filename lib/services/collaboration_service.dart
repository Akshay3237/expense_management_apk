// File: lib/services/collaboration_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/collaboration_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class CollaborationService {
  // Create a new collaboration request
  Future<Map<String, dynamic>> createCollaboration(Collaboration collaboration) async {
    final response = await http.post(
      Uri.parse(COLLABORATION_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collaboration.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'Collaboration request created successfully!',
      };
    } else {
      throw Exception('Failed to create collaboration request: \${response.body}');
    }
  }

  // Get all collaboration requests
  Future<List<Collaboration>> getAllCollaborations() async {
    final response = await http.get(Uri.parse(COLLABORATION_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((request) => Collaboration.fromMap(request)).toList();
    } else {
      throw Exception('Failed to load collaboration requests: \${response.body}');
    }
  }

  // Get collaboration request by ID
  Future<Collaboration> getCollaborationById(String id) async {
    final response = await http.get(Uri.parse('\$COLLABORATION_URL/\$id'));

    if (response.statusCode == 200) {
      return Collaboration.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load collaboration request: \${response.body}');
    }
  }

  // Update collaboration request by ID
  Future<Collaboration> updateCollaboration(String id, Collaboration collaboration) async {
    final response = await http.put(
      Uri.parse('\$COLLABORATION_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collaboration.toMap()),
    );

    if (response.statusCode == 200) {
      return Collaboration.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update collaboration request: \${response.body}');
    }
  }

  // Delete a collaboration request by ID
  Future<String> deleteCollaborationById(String id) async {
    final response = await http.delete(Uri.parse('\$COLLABORATION_URL/\$id'));

    if (response.statusCode == 200) {
      return 'Collaboration request deleted successfully!';
    } else {
      throw Exception('Failed to delete collaboration request: \${response.body}');
    }
  }

  // Delete all collaboration requests
  Future<String> deleteAllCollaborations() async {
    final response = await http.delete(Uri.parse(COLLABORATION_URL));

    if (response.statusCode == 200) {
      return 'All collaboration requests deleted successfully!';
    } else {
      throw Exception('Failed to delete all collaboration requests: \${response.body}');
    }
  }
}
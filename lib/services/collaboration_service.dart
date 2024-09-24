// File: lib/services/collaboration_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/collaboration_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path
import 'package:shared_preferences/shared_preferences.dart'; // For JWT storage

class CollaborationService {
  // Helper function to get the JWT token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Get the JWT token from storage
  }

  // Create a new collaboration request
  Future<Map<String, dynamic>> createCollaboration(Collaboration collaboration) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.post(
        Uri.parse(COLLABORATION_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(collaboration.toMap()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Collaboration request created successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to create collaboration request: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get all collaboration requests
  Future<Map<String, dynamic>> getAllCollaborations() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse(COLLABORATION_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Collaboration> collaborations = data.map((request) => Collaboration.fromMap(request)).toList();
        return {
          'success': true,
          'collaborations': collaborations,
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load collaboration requests: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get collaboration request by ID
  Future<Map<String, dynamic>> getCollaborationById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.get(
        Uri.parse('$COLLABORATION_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'collaboration': Collaboration.fromMap(jsonDecode(response.body)),
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to load collaboration request: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update collaboration request by ID
  Future<Map<String, dynamic>> updateCollaboration(String id, Collaboration collaboration) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.put(
        Uri.parse('$COLLABORATION_URL/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
        body: jsonEncode(collaboration.toMap()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Collaboration request updated successfully!',

        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to update collaboration request: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete a collaboration request by ID
  Future<Map<String, dynamic>> deleteCollaborationById(String id) async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse('$COLLABORATION_URL/$id'),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Collaboration request deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete collaboration request: ${errorResponse['error'] ?? 'Unknown error'}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete all collaboration requests
  Future<Map<String, dynamic>> deleteAllCollaborations() async {
    try {
      final token = await _getToken(); // Fetch the JWT token
      final response = await http.delete(
        Uri.parse(COLLABORATION_URL),
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in the headers
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'All collaboration requests deleted successfully!',
        };
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Failed to delete all collaboration requests: ${errorResponse['error'] ?? 'Unknown error'}',
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

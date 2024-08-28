// File: lib/services/notification_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/notification_model.dart'; // Adjust to your actual model path
import 'package:expense_tracker/constants.dart'; // Adjust to your actual constants path

class NotificationService {
  // Create a new notification
  Future<Map<String, dynamic>> createNotification(Notification notification) async {
    final response = await http.post(
      Uri.parse(NOTIFICATION_URL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(notification.toMap()),
    );

    if (response.statusCode == 201) {
      return {
        'message': 'Notification created successfully!',
      };
    } else {
      throw Exception('Failed to create notification: \${response.body}');
    }
  }

  // Get all notifications
  Future<List<Notification>> getAllNotifications() async {
    final response = await http.get(Uri.parse(NOTIFICATION_URL));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((notification) => Notification.fromMap(notification)).toList();
    } else {
      throw Exception('Failed to load notifications: \${response.body}');
    }
  }

  // Get notification by ID
  Future<Notification> getNotificationById(String id) async {
    final response = await http.get(Uri.parse('\$NOTIFICATION_URL/\$id'));

    if (response.statusCode == 200) {
      return Notification.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load notification: \${response.body}');
    }
  }

  // Update notification by ID
  Future<Notification> updateNotification(String id, Notification notification) async {
    final response = await http.put(
      Uri.parse('\$NOTIFICATION_URL/\$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(notification.toMap()),
    );

    if (response.statusCode == 200) {
      return Notification.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update notification: \${response.body}');
    }
  }

  // Delete notification by ID
  Future<String> deleteNotification(String id) async {
    final response = await http.delete(Uri.parse('\$NOTIFICATION_URL/\$id'));

    if (response.statusCode == 200) {
      return 'Notification deleted successfully!';
    } else {
      throw Exception('Failed to delete notification: \${response.body}');
    }
  }
}
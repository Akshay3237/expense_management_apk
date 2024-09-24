// File: lib/commonFunctions.dart

import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserId() async {
  // Get the instance of SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the JWT token from SharedPreferences
  String? token = prefs.getString('auth_token');

  if (token != null) {
    // Parse the JWT token
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    // Extract and return the userId from the token
    return payload['userId'];
  } else {
    // Return null if no token is found
    return null;
  }
}

Future<void> checkAuthToken(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('auth_token');

  if (authToken == null) {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }
}
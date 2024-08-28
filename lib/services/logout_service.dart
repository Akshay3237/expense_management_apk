import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

Future<void> logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token'); // Remove the auth_token
}

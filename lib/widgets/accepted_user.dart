import 'package:flutter/material.dart';
import 'package:expense_tracker/services/collaboration_service.dart';
import 'package:expense_tracker/services/user_service.dart';
import 'package:expense_tracker/models/collaboration_model.dart';
import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/comonFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedUser extends StatefulWidget {
  @override
  _AcceptedUserState createState() => _AcceptedUserState();
}

class _AcceptedUserState extends State<AcceptedUser> {
  final CollaborationService _collaborationService = CollaborationService();
  final UserService _userService = UserService();
  List<Collaboration> _collaborations = [];
  Map<String, User> _usersMap = {};
  List<String> _collaboratingUserIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _initializeCollaboratingUsers();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final collaborationResponse = await _collaborationService.getAllCollaborations();
      final List<User> users = await _userService.getAllUsers();

      String? userId = await getUserId();
      if (userId == null) {
        throw Exception("User ID is null in accepted users page");
      }

      if (collaborationResponse['success']) {
        setState(() {
          _collaborations = (collaborationResponse['collaborations'] as List<Collaboration>)
              .where((col) => col.requestingUser == userId && col.accepted)
              .toList();

          // Map users by their ID for easy access
          _usersMap = {for (var user in users) user.userid!: user};
          _isLoading = false;
        });
      } else {
        print('Error fetching collaborations: ${collaborationResponse['message']}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeCollaboratingUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userIds = prefs.getStringList('collaboratingUsers') ?? [];
    setState(() {
      _collaboratingUserIds = userIds;
    });
  }

  Future<void> _updateCollaboratingUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('collaboratingUsers', _collaboratingUserIds);
  }

  void _onCheckboxChanged(String userId, bool isChecked) {
    setState(() {
      if (isChecked) {
        _collaboratingUserIds.add(userId);
      } else {
        _collaboratingUserIds.remove(userId);
      }
    });
    _updateCollaboratingUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Users'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _collaborations.isEmpty
          ? Center(child: Text('No accepted users found.'))
          : ListView.builder(
        itemCount: _collaborations.length,
        itemBuilder: (context, index) {
          final collaboration = _collaborations[index];
          final user = _usersMap[collaboration.requestedUser];

          return ListTile(
            title: Text(user?.fullName ?? "Unknown"),
            subtitle: Text(user?.email ?? "No email"),
            trailing: Checkbox(
              value: _collaboratingUserIds.contains(user?.userid),
              onChanged: (bool? value) {
                if (user != null) {
                  _onCheckboxChanged(user.userid!, value ?? false);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

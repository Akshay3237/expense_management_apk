import 'package:expense_tracker/comonFunctions.dart';
import 'package:expense_tracker/services/collaboration_service.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/services/user_service.dart';
import '../models/collaboration_model.dart';

class SearchUserWidget extends StatefulWidget {
  final VoidCallback onRequestSent; // Callback to trigger refresh when a request is sent

  SearchUserWidget({required this.onRequestSent});

  @override
  _SearchUserWidgetState createState() => _SearchUserWidgetState();
}

class _SearchUserWidgetState extends State<SearchUserWidget> {
  TextEditingController emailController = TextEditingController();
  CollaborationService _collaborationService = CollaborationService();
  UserService _userService = UserService();
  List<User> users = [];
  List<User> allUsers = [];
  bool _isLoading = true; // Loading state for fetching users
  bool _isRequestLoading = false; // Loading state for sending requests

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    String? userId;
    try {
      userId = await getUserId();
      if (userId == null) throw Exception("User ID is null in search_user_widget.dart");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching user ID: $e")));
      return;
    }

    List<Collaboration> removeableUser = [];
    try {
      Map<String, dynamic> colabUser = await _collaborationService.getAllCollaborations();
      if (colabUser['success']) {
        removeableUser = colabUser['collaborations'] as List<Collaboration>;
      } else {
        throw Exception("Error fetching collaborations: ${colabUser['message']}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching collaborations: $e")));
      return;
    }

    setState(() {
      _isLoading = true; // Set loading to true
    });

    try {
      List<User> fetchedUsers = (await _userService.getAllUsers())
          .where((user) => user.userid != userId)
          .toList();

      for (Collaboration col in removeableUser) {
        fetchedUsers = fetchedUsers.where((u) => u.userid != col.requestedUser).toList();
      }

      setState(() {
        allUsers = fetchedUsers;
        users = fetchedUsers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching users: $e")));
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }
  }

  void onSearchTextChanged(String value) {
    setState(() {
      users = allUsers
          .where((user) => user.email.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> sendCollaborationRequest(User user) async {
    setState(() {
      _isRequestLoading = true; // Set loading to true for request
    });

    try {
      String? requestingUserid = await getUserId();
      String? requestedUserId = user.userid;

      if (requestingUserid != null && requestedUserId != null) {
        Collaboration colab = Collaboration(
          requestedUser: requestedUserId,
          requestingUser: requestingUserid,
        );

        Map<String, dynamic> response = await _collaborationService.createCollaboration(colab);
        if (response['success']) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response['message'])));
          widget.onRequestSent(); // Trigger refresh on request sent
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response['message'])));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Requesting or requested user ID is null")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isRequestLoading = false; // Set loading to false after request
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Enter email to search',
              border: OutlineInputBorder(),
            ),
            onChanged: onSearchTextChanged,
          ),
        ),
        _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching users
            : Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return ListTile(
                title: Text(user.fullName),
                subtitle: Text(user.email),
                trailing: _isRequestLoading
                    ? CircularProgressIndicator() // Show loading indicator for request
                    : ElevatedButton(
                  onPressed: () async {
                    await sendCollaborationRequest(user);
                  },
                  child: Text('Send Request'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:expense_tracker/comonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/collaboration_service.dart';
import 'package:expense_tracker/services/user_service.dart';
import 'package:expense_tracker/models/collaboration_model.dart';
import 'package:expense_tracker/models/user_model.dart';

class RequestedUser extends StatefulWidget {
  final VoidCallback onRequestSent; // Callback to refresh the data when request is sent

  RequestedUser({required this.onRequestSent});

  @override
  _RequestedUserState createState() => _RequestedUserState();
}

class _RequestedUserState extends State<RequestedUser> {
  final CollaborationService _collaborationService = CollaborationService();
  final UserService _userService = UserService();
  List<Collaboration> _collaborations = [];
  Map<String, String> _userEmails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final collaborationResponse = await _collaborationService.getAllCollaborations();
      final List<User> users = await _userService.getAllUsers();

      Map<String, String> userEmailMap = {
        for (var user in users) user.userid!: user.email,
      };

      String? userid = await getUserId();
      if (userid == null) {
        throw Exception("User ID is null in requested_user page");
      }

      if (collaborationResponse['success']) {
        setState(() {
          _collaborations = (collaborationResponse['collaborations'] as List<Collaboration>)
              .where((col) => !col.accepted && col.requestingUser == userid)
              .toList();
          _userEmails = userEmailMap;
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

  Future<void> _deleteCollaboration(String id) async {
    final response = await _collaborationService.deleteCollaborationById(id);

    if (response['success']) {
      setState(() {
        _collaborations.removeWhere((collaboration) => collaboration.id == id);
        widget.onRequestSent(); // Trigger refresh when request is deleted
      });
    } else {
      print('Error deleting collaboration: ${response['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requested Collaborations'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _collaborations.isEmpty
          ? Center(child: Text('No collaborations found.'))
          : ListView.builder(
        itemCount: _collaborations.length,
        itemBuilder: (context, index) {
          final collaboration = _collaborations[index];
          final requestedUserEmail = _userEmails[collaboration.requestedUser];

          return ListTile(
            title: Text(
              'Requested User: ${requestedUserEmail ?? "Unknown"}',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCollaboration(collaboration.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

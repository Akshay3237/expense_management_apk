import 'package:flutter/material.dart';
import 'package:expense_tracker/services/collaboration_service.dart';
import 'package:expense_tracker/services/user_service.dart';
import 'package:expense_tracker/models/collaboration_model.dart';
import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/comonFunctions.dart';

class RequestingUser extends StatefulWidget {
  final VoidCallback onRequestSent; // Callback to refresh the data when request is processed

  RequestingUser({required this.onRequestSent});

  @override
  _RequestingUserState createState() => _RequestingUserState();
}

class _RequestingUserState extends State<RequestingUser> {
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

      String? userId = await getUserId();
      if (userId == null) {
        throw Exception("User ID is null in requesting user page");
      }

      if (collaborationResponse['success']) {
        setState(() {
          _collaborations = (collaborationResponse['collaborations'] as List<Collaboration>)
              .where((col) => col.requestedUser == userId && !col.accepted)
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

  Future<void> _acceptCollaboration(String id) async {
    Collaboration c=Collaboration(accepted: true);
    final response = await _collaborationService.updateCollaboration(id,c );

    if (response['success']) {
      setState(() {
        _collaborations.removeWhere((collaboration) => collaboration.id == id);
        widget.onRequestSent(); // Trigger refresh when request is accepted
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Collaboration accepted!')));
    } else {
      print('Error accepting collaboration: ${response['message']}');
    }
  }

  Future<void> _denyCollaboration(String id) async {
    final response = await _collaborationService.deleteCollaborationById(id);

    if (response['success']) {
      setState(() {
        _collaborations.removeWhere((collaboration) => collaboration.id == id);
        widget.onRequestSent(); // Trigger refresh when request is denied
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Collaboration denied!')));
    } else {
      print('Error denying collaboration: ${response['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requesting Users'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _collaborations.isEmpty
          ? Center(child: Text('No collaboration requests found.'))
          : ListView.builder(
        itemCount: _collaborations.length,
        itemBuilder: (context, index) {
          final collaboration = _collaborations[index];
          final requestedUserEmail = _userEmails[collaboration.requestingUser];

          return ListTile(
            title: Text(
              'Requested User: ${requestedUserEmail ?? "Unknown"}',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => _acceptCollaboration(collaboration.id!),
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _denyCollaboration(collaboration.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

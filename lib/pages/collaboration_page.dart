import 'package:expense_tracker/widgets/accepted_user.dart';
import 'package:expense_tracker/widgets/requesting_user.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/requested_user.dart';
import 'package:expense_tracker/widgets/search_user_widget.dart';

import '../comonFunctions.dart';

class CollaborationPage extends StatefulWidget {
  @override
  _CollaborationPageState createState() => _CollaborationPageState();
}

class _CollaborationPageState extends State<CollaborationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthToken(context);
  }
  void _refreshData() {
    setState(() {
      // Triggers re-build, hence refreshing data in both widgets
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collaborations'),
      ),
      body: PageView(
        children: [
          SearchUserWidget(onRequestSent: _refreshData),
          RequestedUser(onRequestSent: _refreshData),
          RequestingUser(onRequestSent: () { setState(() {

          }); },),
          AcceptedUser()
        ],
      ),
    );
  }
}

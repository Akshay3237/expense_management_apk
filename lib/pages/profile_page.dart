import 'package:expense_tracker/comonFunctions.dart';
import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/logout_service.dart'; // Adjust the import path accordingly


class ProfilePage extends StatefulWidget {
   ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserService _userService=UserService();
  bool _isLoading=false;
  User? user;

  void fetchData(BuildContext context) async{
    String? userId;
    try{
      userId=await getUserId();
      if(userId==null){
        throw Exception("UserId is null");
      }
      User userData=await _userService.getUserById(userId);

      if(userData==null) throw Exception("User is null");
      if(userData?.fullName==null) throw Exception('username is null');
      setState(() {
        user=userData;
      });
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("inside profile fetching userid is $e:")));
    }

   setState(() {
     _isLoading=false;
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading=true;
    });
    checkAuthToken(context);
    fetchData(context);
  }
  @override
  Widget build(BuildContext context)
  {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body:(_isLoading)
          ?Center(child: LinearProgressIndicator())
          :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Icon Section
              _buildProfileHeader(name: user?.firstName??"unknown",surname: user?.surname??"unknown",email: user?.email??"unknown"),
              const SizedBox(height: 20),


              // Personal Information
              _buildInfoSection("Full Name", user?.fullName??"unknown"),
              _buildInfoSection("Email", user?.email??"unknown"),
              _buildInfoSection("Phone", user?.mobileno??"unknown"),
              _buildInfoSection("gender", user?.gender??"Unknown"),
              _buildInfoSection("profession", user?.profession??"Unknown"),


              const SizedBox(height: 20),


              // Logout Button
              const SizedBox(height: 40),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create the Profile Header with Icon
  Widget _buildProfileHeader({String? name,String? email,String? surname}) {
    return Column(
      children: [
         Text(
          name??"unknown"+" "+(surname??"unknown"),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
         Text(
          email??"unknown",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Widget to build information section
  Widget _buildInfoSection(String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(value),
    );
  }

  // Widget for Logout Button
  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text("Logout"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Red for emphasis
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: () async{
        // Implement logout logic
         await logout();
         Navigator.pop(context);
         Navigator.pushReplacementNamed(context, "/login");
      },
    );
  }
}




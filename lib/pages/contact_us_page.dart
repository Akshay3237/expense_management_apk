import 'package:expense_tracker/services/contact_us_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/contact_us_model.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});


  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}


class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _feedbackRating = 3.0;
  bool _isLoading=false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  void _submitForm() async{
    setState(() {
      _isLoading=true;
    });
    if (_formKey.currentState!.validate()) {
      // Create a new ContactUs instance
      ContactUs contact = ContactUs(
        id: '',
        userName: _userNameController.text,
        email: _emailController.text,
        description: _descriptionController.text,
        feedbackRating: _feedbackRating.toInt(),
      );

      ContactUsService cs=ContactUsService();
      Map<String,dynamic>result=await cs.createContactUs(contact);
      if(result['success']){
          String message=result['message'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thank you for feedback\n$message")));
          setState(() {
            _userNameController.text="";
            _emailController.text="";
            _descriptionController.text="";
            _feedbackRating=3;
          });
      }
      else{
        String message=result['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error:$message")));
      }
      // Process the data (send to backend, display on screen, etc.)
      print('Contact Us Form Submitted: ${contact.toMap()}');
      // You can replace the above print statement with your actual logic
      setState(() {
        _isLoading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Feedback Rating:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // RatingBar for feedback rating
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _feedbackRating = rating;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child:(_isLoading)?CircularProgressIndicator() :ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/user_model.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class EditAccountScreen extends StatefulWidget {
  final String email;

  const EditAccountScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  late Future<UserModel?> _userDataFuture;
  ProgressDialog? _progressDialog;

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    _userDataFuture = fetchUserData();
    _userDataFuture.then((user) {
      if (user != null) {
        setState(() {
          _nameController.text = user.name;
          _bioController.text = user.bio;
        });
      }
    });
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  Future<UserModel?> fetchUserData() async {
    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .get();

      final userData = userSnapshot.data() as Map<String, dynamic>;

      return UserModel.fromJSON(userData);
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<void> updateUser(
    String name,
    String email,
    String bio,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'name': name,
        'bio': bio,
      });
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = widget.email;
      String bio = _bioController.text;

      UserModel? currentUser = await fetchUserData();

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data not found. Please try again.'),
          ),
        );
      } else {
        bool isNameExists = false;
        if (name != currentUser.name) {
          // Check if the updated name already exists in Firestore
          final userCollection =
              await FirebaseFirestore.instance.collection('users').get();
          final users = userCollection.docs
              .map((doc) => UserModel.fromJSON(doc.data()))
              .toList();
          isNameExists = users.any((user) => user.name == name);
        }

        if (isNameExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$name has already been taken. Please use another name.',
              ),
            ),
          );
          return; // Exit the method without updating the user information
        }

        // Show loading pop-up
        _progressDialog = ProgressDialog(context);
        _progressDialog!.style(
          progressWidget: const CircularProgressIndicator(),
          message: 'Updating user information...',
        );
        _progressDialog!.show();

        await updateUser(
          name,
          email,
          bio,
        );

        _progressDialog!.hide();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text(
                'User information updated successfully. Please re-login to see the updated changes.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _userDataFuture,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            toolbarHeight: 65,
            elevation: 1,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 5.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'User Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a user name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    enabled: false,
                    initialValue: widget.email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a bio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    onPressed: _submitForm,
                    text: 'Update',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

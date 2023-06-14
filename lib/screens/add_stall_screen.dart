// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawkerbro/utils/utils.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddStallScreen extends StatefulWidget {
  const AddStallScreen({Key? key}) : super(key: key);

  @override
  State<AddStallScreen> createState() => _AddStallScreenState();
}

class _AddStallScreenState extends State<AddStallScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<File> _imageFileList = [];

  @override
  void dispose() {
    _nameController.dispose();
    _unitNumberController.dispose();
    _postalCodeController.dispose();
    _openingHoursController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> getImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    List<XFile>? xfilePick = pickedFile;

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        _imageFileList.add(File(xfilePick[i].path));
      }
      setState(() {});
    } else {
      showSnackBar(context, 'Nothing is selected');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String unitNumber = _unitNumberController.text.trim();
      String postalCode = _postalCodeController.text.trim();
      String openingHours = _openingHoursController.text;
      String phoneNumber = _phoneNumberController.text;
      String bio = _bioController.text;

      String stallId = unitNumber;

      // Check if the stall already exists in the same postal code
      bool isStallExists = await checkStallExists(stallId, postalCode);
      if (isStallExists) {
        showSnackBar(context, 'Stall already exists in the same postal code');
        return;
      }

      // Upload images to Firebase Storage and get the download URLs
      List<String> imageUrls = await _uploadImages(stallId);

      // Store the data in Firestore along with the image URLs
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('hawkerCentres')
          .doc(postalCode)
          .collection('stalls')
          .doc(stallId)
          .set({
        'name': name,
        'unitNumber': unitNumber,
        'postalCode': postalCode,
        'openingHours': openingHours,
        'phoneNumber': phoneNumber,
        'bio': bio,
        'stall images': imageUrls,
      });

      _formKey.currentState!.reset();
      _nameController.clear();
      _unitNumberController.clear();
      _postalCodeController.clear();
      _openingHoursController.clear();
      _phoneNumberController.clear();
      _bioController.clear();
      setState(() {
        _imageFileList = [];
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Restaurant added successfully.'),
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

  Future<bool> checkStallExists(String stallId, String postalCode) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await firestore
        .collection('hawkerCentres')
        .doc(postalCode)
        .collection('stalls')
        .doc(stallId)
        .get();

    return snapshot.exists;
  }

  Future<List<String>> _uploadImages(String stallId) async {
    List<String> imageUrls = [];

    FirebaseStorage storage = FirebaseStorage.instance;
    for (var i = 0; i < _imageFileList.length; i++) {
      File imageFile = _imageFileList[i];
      String imageName = '$stallId-image-$i.jpg';

      try {
        TaskSnapshot snapshot = await storage
            .ref()
            .child('stall images')
            .child(stallId)
            .child(imageName)
            .putFile(imageFile);

        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        showSnackBar(context, 'Error uploading image: $e');
      }
    }

    return imageUrls;
  }

  Widget _buildImagesSection() {
    if (_imageFileList.isEmpty) {
      return ElevatedButton.icon(
        onPressed: getImages,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Select Images'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[600],
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _imageFileList.map((image) {
              return SizedBox(
                width: double.infinity,
                height: 260,
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: ElevatedButton.icon(
              onPressed: getImages,
              icon: const Icon(Icons.add),
              label: const Text('Add More Images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[600],
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add a Hawker Stall',
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
              _buildImagesSection(),
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
                  hintText: 'Stall Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a stall name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _unitNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Unit Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Postal Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a postal code';
                  } else if (value.length != 6) {
                    return 'Please enter a valid 6-digit postal code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _openingHoursController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Opening Hours',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter opening hours';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'About the Stall',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some information about the stall';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              CustomButton(
                text: 'Add Stall',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

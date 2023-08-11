// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawkerbro/provider/stall_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class AddStallScreen extends StatefulWidget {
  const AddStallScreen({Key? key}) : super(key: key);

  @override
  State<AddStallScreen> createState() => _AddStallScreenState();
}

class _AddStallScreenState extends State<AddStallScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _unitNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bioController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<File> _imageFileList = [];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _unitNumberController.dispose();
    _postalCodeController.dispose();
    _openingHoursController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String address = _addressController.text;
      String unitNumber = _unitNumberController.text.trim();
      String postalCode = _postalCodeController.text.trim();
      String openingHours = _openingHoursController.text;
      String phoneNumber = _phoneNumberController.text;
      String bio = _bioController.text;

      try {
        StallProvider stallProvider = StallProvider();
        await stallProvider.addStall(
          name,
          address,
          unitNumber,
          postalCode,
          openingHours,
          phoneNumber,
          bio,
          _imageFileList,
        );

        _formKey.currentState!.reset();
        _nameController.clear();
        _addressController.clear();
        _unitNumberController.clear();
        _postalCodeController.clear();
        _openingHoursController.clear();
        _phoneNumberController.clear();
        _bioController.clear();
        setState(() {
          _imageFileList = [];
        });

        Navigator.pop(context);

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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _unitNumberController,
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
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
                  } else if (value.length != 8) {
                    return 'Please enter a valid 8-digit phone number';
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
                  hintText: 'Business Information',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  foregroundColor: Colors.black,
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Add Stall',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

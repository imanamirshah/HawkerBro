import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AddStallScreen extends StatefulWidget {
  const AddStallScreen({super.key});

  @override
  State<AddStallScreen> createState() => _AddStallScreenState();
}

class _AddStallScreenState extends State<AddStallScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<File> _imageFileList = [];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100, // To set quality of images
      maxHeight: 1000, // To set maxheight of images that you want in your app
      maxWidth: 1000,
    ); // To set maxheight of images that you want in your app
    List<XFile> xfilePick = pickedFile;

    // if atleast 1 images is selected it will add
    // all images in selectedImages
    // variable so that we can easily show them in UI
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        _imageFileList.add(File(xfilePick[i].path));
      }
      setState(
        () {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing is selected'),
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String address = _addressController.text;

      // Process the data and save the new restaurant (add backend here)

      // Reset the form
      _formKey.currentState!.reset();
      _nameController.clear();
      _addressController.clear();
      setState(() {
        _imageFileList = [];
      });

      // Show a confirmation dialog or navigate to another page
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
          'Add a Restaurant',
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                onPressed: _submitForm,
                text: "Add Restaurant",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawkerbro/model/fetch_stall_model.dart';
import 'package:hawkerbro/provider/stall_provider.dart';
import 'package:hawkerbro/widgets/loading_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class EditStallScreen extends StatefulWidget {
  final String unitNumber;
  final String postalCode;

  const EditStallScreen({
    Key? key,
    required this.unitNumber,
    required this.postalCode,
  }) : super(key: key);

  @override
  State<EditStallScreen> createState() => _EditStallScreenState();
}

class _EditStallScreenState extends State<EditStallScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bioController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final List<File> _imageFileList = [];
  late Future<FetchStallModel?> _stallDataFuture;
  FetchStallModel? stall;
  // Stream<List<StallModel>>? _existingStallsStream; // Stream of existing stalls
  ProgressDialog? _progressDialog;

  @override
  void initState() {
    super.initState();
    _stallDataFuture = _fetchStallData();
    //  _existingStallsStream = _fetchExistingStalls(); // Fetch existing stalls
    _stallDataFuture.then((stallData) {
      if (stallData != null) {
        setState(() {
          _nameController.text = stallData.name;
          _unitNumberController.text = stallData.unitNumber;
          _postalCodeController.text = stallData.postalCode;
          _openingHoursController.text = stallData.openingHours;
          _phoneNumberController.text = stallData.phoneNumber;
          _bioController.text = stallData.bio;
        });
      }
    });
  }

  Future<FetchStallModel?> _fetchStallData() async {
    try {
      final DocumentSnapshot stallSnapshot = await FirebaseFirestore.instance
          .collection('hawkerCentres')
          .doc(widget.postalCode)
          .collection('stalls')
          .doc(widget.unitNumber)
          .get();

      final stallData = stallSnapshot.data() as Map<String, dynamic>;

      return FetchStallModel.fromJSON(stallData);
    } catch (e) {
      throw Exception('Error fetching stall data: $e');
    }
  }

  // Stream<List<StallModel>> _fetchExistingStalls() {
  //   // Create a stream of existing stalls
  //   return FirebaseFirestore.instance
  //       .collection('hawkerCentres')
  //       .doc(widget.postalCode)
  //       .collection('stalls')
  //       .snapshots()
  //       .map((querySnapshot) {
  //     return querySnapshot.docs.map((doc) {
  //       final stallData = doc.data() as Map<String, dynamic>;
  //       return StallModel.fromJSON(stallData);
  //     }).toList();
  //   });
  // }

  // bool _isUnitNumberExists(List<StallModel> stalls, String unitNumber) {
  //   // Check if a stall with the given unit number exists
  //   return stalls.any(
  //     (stall) =>
  //         stall.unitNumber == unitNumber &&
  //         stall.unitNumber != widget.unitNumber,
  //   );
  // }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
    }
  }

  Future<List<FetchStallModel>> _fetchStalls() async {
    try {
      final QuerySnapshot stallSnapshot = await FirebaseFirestore.instance
          .collection('hawkerCentres')
          .doc(widget.postalCode)
          .collection('stalls')
          .get();

      return stallSnapshot.docs
          .map(
            (doc) =>
                FetchStallModel.fromJSON(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Error fetching stalls: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String unitNumber = _unitNumberController.text;
      String postalCode = _postalCodeController.text;
      String openingHours = _openingHoursController.text;
      String phoneNumber = _phoneNumberController.text;
      String bio = _bioController.text;

      // Fetch the current stall data
      FetchStallModel? currentStall = await _fetchStallData();

      if (currentStall == null) {
        // Handle case when stall data is not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stall data not found. Please try again.'),
          ),
        );
      } else {
        // Check if unitNumber already exists
        List<FetchStallModel> stalls = await _fetchStalls();
        bool isUnitNumberExists =
            stalls.any((stall) => stall.unitNumber == unitNumber);

        if (isUnitNumberExists && unitNumber != currentStall.unitNumber) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Stall with unit number $unitNumber already exists'),
            ),
          );
          return; // Exit the method without updating the stall information
        }

        // Show loading pop-up
        _progressDialog = ProgressDialog(context);
        _progressDialog!.style(
          progressWidget: const CircularProgressIndicator(),
          message: 'Updating stall information...',
        );
        _progressDialog!.show();

        // Update the stall data in Firestore
        StallProvider stallProvider = StallProvider();

        // Check if unitNumber has changed
        if (unitNumber != currentStall.unitNumber) {
          // Update the stall with the new unitNumber
          await stallProvider.updateUnitNumber(
            currentStall.unitNumber,
            unitNumber,
            postalCode,
          );
        }

        // Update the other stall information
        await stallProvider.updateStall(
          name,
          unitNumber,
          postalCode,
          openingHours,
          phoneNumber,
          bio,
          _imageFileList,
        );

        _progressDialog!.hide();

        Navigator.pop(context, stall);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Stall information updated successfully.'),
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

  // Widget _buildImagesSection() {
  //   if (_imageFileList.isEmpty) {
  //     return ElevatedButton.icon(
  //       onPressed: getImages,
  //       icon: const Icon(Icons.add_a_photo),
  //       label: const Text('Select Images'),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.yellow[600],
  //         foregroundColor: Colors.black,
  //         textStyle: const TextStyle(
  //           fontSize: 16,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Wrap(
  //           spacing: 8.0,
  //           runSpacing: 8.0,
  //           children: _imageFileList.map((image) {
  //             return SizedBox(
  //               width: double.infinity,
  //               height: 260,
  //               child: Image.file(
  //                 image,
  //                 fit: BoxFit.cover,
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //         const SizedBox(height: 8.0),
  //         Center(
  //           child: ElevatedButton.icon(
  //             onPressed: getImages,
  //             icon: const Icon(Icons.add),
  //             label: const Text('Add More Images'),
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.yellow[600],
  //               foregroundColor: Colors.black,
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FetchStallModel?>(
      future: _stallDataFuture,
      builder: (context, stallSnapshot) {
        if (stallSnapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Hawker Stall information',
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
                  //        _buildImagesSection(),
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
                    enabled: false,
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
                    enabled: false,
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
                      'Update',
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
      },
    );
  }
}

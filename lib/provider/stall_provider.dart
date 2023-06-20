import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/stall_model.dart';
import 'package:hawkerbro/utils/globals.dart';

class StallProvider extends ChangeNotifier {
  StallModel? _stallModel;
  StallModel get stallModel => _stallModel!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addStall(
    String name,
    String unitNumber,
    String postalCode,
    String openingHours,
    String phoneNumber,
    String bio,
    List<File> imageFiles,
  ) async {
    bool isStallExists = await checkStallExists(unitNumber, postalCode);
    bool snackBarShown = false;
    while (isStallExists) {
      if (!snackBarShown) {
        const SnackBar snackBar = SnackBar(
          content: Text('Stall already exists in the same postal code'),
        );
        snackBarKey.currentState?.showSnackBar(snackBar);
        snackBarShown = true;
      }
      isStallExists = await checkStallExists(unitNumber, postalCode);
    }

    // Upload images to Firebase Storage and get the download URLs
    List<String> imageUrls = await _uploadImages(unitNumber, imageFiles);

    // Store the data in Firestore along with the image URLs
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('hawkerCentres')
        .doc(postalCode)
        .collection('stalls')
        .doc(unitNumber)
        .set({
      'name': name,
      'unitNumber': unitNumber,
      'postalCode': postalCode,
      'openingHours': openingHours,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'stall images': imageUrls,
    });
  }

  Future<bool> checkStallExists(String unitNumber, String postalCode) async {
    DocumentSnapshot snapshot = await firestore
        .collection('hawkerCentres')
        .doc(postalCode)
        .collection('stalls')
        .doc(unitNumber)
        .get();

    return snapshot.exists;
  }

  Future<List<String>> _uploadImages(
    String unitNumber,
    List<File> imageFiles,
  ) async {
    List<String> imageUrls = [];

    FirebaseStorage storage = FirebaseStorage.instance;
    for (var i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];
      String imageName = '$unitNumber-image-$i.jpg';

      try {
        TaskSnapshot snapshot = await storage
            .ref()
            .child('stall images')
            .child(unitNumber)
            .child(imageName)
            .putFile(imageFile);

        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        throw Exception('Error uploading image: $e');
      }
    }

    return imageUrls;
  }
}

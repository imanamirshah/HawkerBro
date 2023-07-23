import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/stall_model.dart';

class StallProvider extends ChangeNotifier {
  AddStallModel? _stallModel;
  AddStallModel get stallModel => _stallModel!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addStall(
    String name,
    String address,
    String unitNumber,
    String postalCode,
    String openingHours,
    String phoneNumber,
    String bio,
    List<File> imageFiles,
  ) async {
    // Check if the hawker centre (ancestor document) exists
    bool isHawkerCentreExists = await checkHawkerCentreExists(postalCode);
    if (!isHawkerCentreExists) {
      // Create the hawker centre document if it doesn't exist
      await createHawkerCentreDocument(postalCode);
    }

    // Upload images to Firebase Storage and get the download URLs
    List<String> imageUrls = await uploadImages(unitNumber, imageFiles);

    // Store the data in Firestore along with the image URLs
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('hawkerCentres')
        .doc(postalCode)
        .collection('stalls')
        .doc(unitNumber)
        .set({
      'name': name,
      'address': address,
      'unitNumber': unitNumber,
      'postalCode': postalCode,
      'openingHours': openingHours,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'stall images': imageUrls,
    });
  }

  Future<bool> checkHawkerCentreExists(String postalCode) async {
    DocumentSnapshot snapshot =
        await firestore.collection('hawkerCentres').doc(postalCode).get();

    return snapshot.exists;
  }

  Future<void> createHawkerCentreDocument(String postalCode) async {
    await firestore.collection('hawkerCentres').doc(postalCode).set({});
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

  Future<void> updateUnitNumber(
    String currentUnitNumber,
    String newUnitNumber,
    String postalCode,
  ) async {
    // Check if the new unitNumber already exists in Firebase
    QuerySnapshot newUnitNumberSnapshot = await firestore
        .collection('stalls')
        .where('unitNumber', isEqualTo: newUnitNumber)
        .get();
    if (newUnitNumberSnapshot.size > 0) {
      // Show a snackbar informing the user that the new unit number already exists
      // Implement snackbar logic here
      return;
    }

    // Get the stall document with the current unitNumber
    QuerySnapshot currentUnitNumberSnapshot = await firestore
        .collection('stalls')
        .where('unitNumber', isEqualTo: currentUnitNumber)
        .get();

    if (currentUnitNumberSnapshot.size == 1) {
      // Get the existing stall document
      QueryDocumentSnapshot existingDocument =
          currentUnitNumberSnapshot.docs[0];
      String existingDocumentId = existingDocument.id;

      // Create a new document with the new unitNumber and copy the data
      Map<String, dynamic> newData = {
        'unitNumber': newUnitNumber,
        'postalCode': postalCode,
        // Copy other fields from existingDocument as needed
      };
      await firestore.collection('stalls').doc(newUnitNumber).set(newData);

      // Delete the existing document
      await firestore.collection('stalls').doc(existingDocumentId).delete();
    }
  }

  Future<void> updateStall(
    String name,
    String address,
    String unitNumber,
    String postalCode,
    String openingHours,
    String phoneNumber,
    String bio,
    List<File> imageFiles,
  ) async {
    // Upload images to Firebase Storage and get the download URLs
    List<String> imageUrls = await uploadImages(unitNumber, imageFiles);

    // Update the data in Firestore along with the image URLs
    await firestore
        .collection('hawkerCentres')
        .doc(postalCode)
        .collection('stalls')
        .doc(unitNumber)
        .update({
      'name': name,
      'address': address,
      'unitNumber': unitNumber,
      'openingHours': openingHours,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'stall images': imageUrls,
    });
  }

  Future<List<String>> uploadImages(
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

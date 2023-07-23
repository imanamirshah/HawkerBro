// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/model/user_model.dart';
import 'package:hawkerbro/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _name;
  String get uid => _name!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    if (_isSignedIn) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        _name = user.email!;
        _userModel = await getUserProfile(_name!);
      } else {
        _isSignedIn = false;
      }
    }
    notifyListeners();
  }

  Future<UserModel?> getUserProfile(String email) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection("users").doc(email).get();
      if (snapshot.exists) {
        return UserModel.fromJSON(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _name = email;
        _isSignedIn = true;
        _userModel = await getUserProfile(_name!);
        saveUserDataToSP();
      } else {
        _isSignedIn = false;
      }
    } catch (e) {
      _isSignedIn = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERATIONS

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_name).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      _name = user.email!;
      try {
        // Uploading image to Firebase Storage
        String profilePicUrl =
            await storeFiletoStorage("profilePic/$_name", profilePic);
        userModel.profilePic = profilePicUrl;
        _userModel = userModel;

        // Saving user data to Firestore
        await _firebaseFirestore
            .collection("users")
            .doc(_name)
            .set(userModel.toJSON())
            .then((value) {
          onSuccess();
          _isLoading = false;
          notifyListeners();
        });
      } catch (e) {
        showSnackBar(context, e.toString());
        _isLoading = false;
        notifyListeners();
      }
    } else {
      showSnackBar(context, "User not logged in");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFiletoStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        profilePic: snapshot['profilePic'],
      );
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toJSON()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromJSON(jsonDecode(data));
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  // void signInWithPhone(BuildContext context, String phoneNumber) async {
  //   try {
  //     await _firebaseAuth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
  //         await _firebaseAuth.signInWithCredential(phoneAuthCredential);
  //       },
  //       verificationFailed: (error) {
  //         throw Exception(error.message);
  //       },
  //       codeSent: ((verificationId, forceResendingToken) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OtpScreen(verificationID: verificationId),
  //           ),
  //         );
  //       }),
  //       codeAutoRetrievalTimeout: (verificationID) {},
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //   }
  // }

  // void verifyOtp({
  //   required BuildContext context,
  //   required String verificationId,
  //   required String userOtp,
  //   required Function onSuccess,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     PhoneAuthCredential creds = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: userOtp,
  //     );

  //     User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

  //     if (user != null) {
  //       // carry out logic
  //       _uid = user.uid;
  //       onSuccess();
  //     }
  //     _isLoading = false;
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}

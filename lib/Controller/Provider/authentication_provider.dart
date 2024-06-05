import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  // instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _loading = false;

  get loading => _loading;
  void setLoading(bool value) {
    _loading = value;
    Future.microtask(() => notifyListeners());
  }

  bool _googleLoading = false;

  get googleLoading => _googleLoading;

  void setGoogleLoading(bool value) {
    _googleLoading = value;
    Future.microtask(() => notifyListeners());
  }

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;
  String? _phone;
  String? get phone => _phone;

  String? _about;
  String? get about => _about;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  set isSignedIn(bool value) {
    _isSignedIn = value;
  }

  AuthProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //SignUp
  Future signUpWithEmailPassword(
    BuildContext context,
    String photoURL,
    String name,
    String phone,
    String email,
    String password,
  ) async {
    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      // Now save user details
      _imageUrl = photoURL;
      _name = name;
      _email = email;
      _phone = phone;
      _uid = value.user!.uid;
      _about = "";
      //_password = password;
    });

    notifyListeners();
  }

  //SignIn
  Future signInWithEmailAndPwd(context, String email, String password) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        final QuerySnapshot<Map<String, dynamic>> result =
            await FirebaseFirestore.instance.collection('users').where("uid", isEqualTo: value.user!.uid).get();

        //print("This is document Data1 == ${result.docs[0]['password']}");
        if (result.docs.isNotEmpty) {
          final userDoc = result.docs[0];
          if (userDoc['uid'] == value.user!.uid) {
            _uid = userDoc['uid'];
            _name = userDoc['name'];
            _phone = userDoc['phone'];
            _email = userDoc['email'];
            _imageUrl = userDoc['image_url'];
            _about = userDoc['about'];

            // Clear any previous error
            _hasError = false;
            _errorCode = "Welcome back! It's fantastic to see you again.";
            // openSnackBar(context, _errorCode, Colors.red);
            notifyListeners();
          } else {
            _hasError = true;
            _errorCode = "Uh-oh, it seems like we couldn't find a match for your credentials.";
            notifyListeners();
          }
          notifyListeners();
        } else {
          _hasError = true;
          _errorCode = "User not found or incorrect credentials";
          //openSnackBar(context, _errorCode, Colors.red);
          notifyListeners();
        }
      });
    } catch (e) {
      _hasError = true;
      print("Exception === $e");
      _errorCode = "An error occurred while signing in: $e";
      // openSnackBar(context, _errorCode, Colors.red);
      notifyListeners();
    }
  }

//Forget password
  Future<bool> forgotPassword({email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException {
      // Handle password reset email failure, display an error message, etc.
      return false;
    }
  }

// ENTRY FOR CLOUDFIRESTORE
  Future getUserDataFromFirestore(
    uid,
  ) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then((DocumentSnapshot snapshot) => {
          _uid = snapshot['uid'],
          _name = snapshot['name'],
          _email = snapshot['email'],
          _imageUrl = snapshot['image_url'],
          _phone = snapshot['phone'],
          _about = snapshot['about'],
        });
  }

  // Save data to fireStore Database
  Future saveDataToFirestore() async {
    final DocumentReference r = FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "phone": _phone,
      "about": _about,
      //"password": _password,
    });
    notifyListeners();
  }

  // Save Data to SharedPreferences
  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('phone', _phone!);
    await s.setString('about', _about!);
    notifyListeners();
  }

  // get data from sharedpref
  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _phone = s.getString('phone');

    _about = s.getString('about');
    notifyListeners();
  }

  // checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      return true;
    } else {
      return false;
    }
  }

  // signout
  Future userSignOut() async {
    setLoading(true);

    firebaseAuth.signOut;
    await googleSignIn.signOut();

    _isSignedIn = false;

    // clear all storage information
    clearStoredData();
    setLoading(false);
    notifyListeners();
  }

  // clear data from sharedpref
  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  // Delete user from firestore database
  Future deleteUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid).delete();
      clearStoredData();
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }
}

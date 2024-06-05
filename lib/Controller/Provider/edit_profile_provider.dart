/*
  UpdateProfileProvider Class

  This Dart file defines the `UpdateProfileProvider` class, which is a provider responsible for managing and updating user profile information in Firestore.

  Dependencies:
  - Ensure that the `cloud_firestore` package is included in your project's dependencies.

  Functionality:
  - Provides a method to update the user's profile information (image, name, and phone number) in Firestore.
  - Takes the user's ID, new image URL, new name, and new phone number as parameters for updating the profile.

  Note: Ensure that you have Firestore set up in your project and proper security rules configured.

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';

class EditProfileProvider extends ChangeNotifier {
  bool _loading = false;

  get loading => _loading;
  void setLoading(bool value) {
    _loading = value;
    Future.microtask(() => notifyListeners());
  }

  // Update user profile
  Future<bool> updateProfile(BuildContext context, String userId, newImage, newName, newPhoneNumber, about) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Update the image, name, and phone number using the user's document ID
      await users.doc(userId).update({
        'image_url': newImage,
        'name': newName,
        'phone': newPhoneNumber,
        'about': about,
      });

      // Notify listeners that the data has changed
      print('Profile updated successfully');
      openSnackBar(context, "Profile updated successfully", Colors.green);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      openSnackBar(context, "Error updating profile: $e", LightColor.danger);
      return false;
    }
  }
}

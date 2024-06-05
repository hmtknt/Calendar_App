import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';

class AddEventProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<DocumentSnapshot>>? eventsStream;
  Stream<List<DocumentSnapshot>>? myEventsStream;

  bool _loading = false;

  get loading => _loading;
  void setLoading(bool value) {
    _loading = value;
    Future.microtask(() => notifyListeners());
  }

  bool _myEventLoading = false;

  get myEventLoading => _myEventLoading;
  void setMyEventLoading(bool value) {
    _myEventLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<bool> addEvent(BuildContext context, String userId, userImage, userName, phone, title, description, DateTime date) async {
    try {
      setLoading(true);
      CollectionReference events = FirebaseFirestore.instance.collection('events');

      // Update the image, name, and phone number using the user's document ID
      await events.add({
        'userId': userId,
        'userImage': userImage,
        'userName': userName,
        'phone': phone,
        "title": title,
        "description": description,
        "date": Timestamp.fromDate(date),
      });

      // Notify listeners that the data has changed
      print('Event Added successfully');
      openSnackBar(context, "Event Added successfully", Colors.green);
      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error Adding Event: $e');
      openSnackBar(context, "Error Occurred during Adding Event: $e", LightColor.danger);
      setLoading(false);
      notifyListeners();
      return false;
    }
  }

  void fetchEvents(
    DateTime firstDay,
    DateTime lastDay,
  ) {
    try {
      setLoading(true);
      eventsStream = _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: firstDay)
          .where('date', isLessThanOrEqualTo: lastDay)
          .snapshots()
          .map((snapshot) => snapshot.docs);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      print('Error fetching events: $e');
      setLoading(false);
      notifyListeners();
    }
  }

  void fetchMyEvents(String userId) {
    try {
      setMyEventLoading(true);
      myEventsStream = _firestore.collection('events').where('userId', isEqualTo: userId).snapshots().map((snapshot) => snapshot.docs);
      setMyEventLoading(false);
      notifyListeners();
    } catch (e) {
      print('Error fetching events: $e');
      setMyEventLoading(false);
      notifyListeners();
    }
  }
}

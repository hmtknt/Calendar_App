import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/View/Utils/snack_bar.dart';
import 'package:flutter_events_2023/model/event_model.dart';

final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('scheduleEvents');

class EventScheduleProvider with ChangeNotifier {
  List<EventScheduleModel> _upcomingEventSchedule = [];

  List<EventScheduleModel> get upcomingEventSchedule => _upcomingEventSchedule;

  List<EventScheduleModel> _canceledEventSchedule = [];

  List<EventScheduleModel> get canceledEventSchedule => _canceledEventSchedule;

  List<EventScheduleModel> _completedEventSchedule = [];

  List<EventScheduleModel> get completedEventSchedule => _completedEventSchedule;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  bool _isCanceled = false;

  bool get isCanceled => _isCanceled;

  void setIsCanceled(bool value) {
    _isCanceled = value;
    Future.microtask(() => notifyListeners());
  }

  bool _isReSchedule = false;

  bool get isReSchedule => _isReSchedule;

  void setIsReSchedule(bool value) {
    _isReSchedule = value;
    Future.microtask(() => notifyListeners());
  }

  String generateRandomId(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final idList = List.generate(length, (index) => chars[random.nextInt(chars.length)]);
    return idList.join();
  }

  Future<void> addSchedule({
    required BuildContext context,
    required String userId,
    required String eventHolderId,
    required String phone,
    required String userName,
    required String eventTitle,
    required String eventDescription,
    required String photoUrl,
    required String eventDate,
    required String eventTime,
  }) async {
    try {
      setIsLoading(true);

      var docId = generateRandomId(10 + Random().nextInt(11));

      // Check if event already exists for the current user and user
      QuerySnapshot existingEventSchedule = await eventsCollection.where('userId', isEqualTo: userId).where('status', isEqualTo: "canceled").get();

      if (existingEventSchedule.docs.isNotEmpty) {
        // If event exists, update the existing one
        await existingEventSchedule.docs.first.reference.update({
          'eventDate': eventDate,
          'eventTime': eventTime,
          'status': 'upcoming',
        });
        openSnackBar(context, "Your event has been updated successfully", Colors.green);
      } else {
        // If event does not exist, add a new one
        await eventsCollection.doc(docId).set({
          'docId': docId,
          'userName': userName,
          'eventTitle': eventTitle,
          'photoUrl': photoUrl,
          'eventDate': eventDate,
          'eventTime': eventTime,
          'eventDescription': eventDescription,
          'status': 'upcoming',
          'userId': userId,
          'eventHolderId': eventHolderId,
          'phone': phone,
        });
        openSnackBar(context, "Your event has been scheduled successfully", Colors.green);
      }

      setIsLoading(false);
      notifyListeners();
    } catch (error) {
      // Handle error
      print("Error adding/updating event: $error");
      openSnackBar(context, "Error adding/updating event", Colors.red);
      setIsLoading(false);
    }
  }

  Future<void> fetchUpcomingEventSchedule(String userId) async {
    setIsLoading(true);

    eventsCollection.where('status', isEqualTo: "upcoming").where('userId', isEqualTo: userId).snapshots().listen((querySnapshot) {
      _upcomingEventSchedule = querySnapshot.docs
          .map((doc) => EventScheduleModel(
                eventId: doc.id,
                userId: doc['userId'],
                eventHolderId: doc['eventHolderId'],
                userName: doc['userName'],
                eventTitle: doc['eventTitle'],
                eventDescription: doc['eventDescription'],
                photoUrl: doc['photoUrl'],
                eventDate: doc['eventDate'],
                eventTime: doc['eventTime'],
                phone: doc['phone'],
              ))
          .toList();

      setIsLoading(false);
      notifyListeners();
    });
  }

  Future<void> fetchCompletedEventSchedule(String userId) async {
    setIsLoading(true);

    eventsCollection.where('status', isEqualTo: "completed").where('userId', isEqualTo: userId).snapshots().listen((querySnapshot) {
      _completedEventSchedule = querySnapshot.docs
          .map((doc) => EventScheduleModel(
                eventId: doc.id,
                userId: doc['userId'],
                eventHolderId: doc['eventHolderId'],
                phone: doc['phone'],
                userName: doc['userName'],
                eventTitle: doc['eventTitle'],
                eventDescription: doc['eventDescription'],
                photoUrl: doc['photoUrl'],
                eventDate: doc['eventDate'],
                eventTime: doc['eventTime'],
              ))
          .toList();

      setIsLoading(false);
      notifyListeners();
    });
  }

  Future<void> fetchCanceledEventSchedule(String userId) async {
    setIsLoading(true);

    eventsCollection.where('status', isEqualTo: "canceled").where('userId', isEqualTo: userId).snapshots().listen((querySnapshot) {
      _canceledEventSchedule = querySnapshot.docs
          .map((doc) => EventScheduleModel(
                eventId: doc.id,
                userId: doc['userId'],
                eventHolderId: doc['eventHolderId'],
                phone: doc['phone'],
                userName: doc['userName'],
                eventTitle: doc['eventTitle'],
                eventDescription: doc['eventDescription'],
                photoUrl: doc['photoUrl'],
                eventDate: doc['eventDate'],
                eventTime: doc['eventTime'],
              ))
          .toList();

      setIsLoading(false);
      notifyListeners();
    });
  }

  Future<void> cancelSchedule(String eventId) async {
    setIsCanceled(true);
    await eventsCollection.doc(eventId).update({'status': 'canceled'});
    _upcomingEventSchedule.removeWhere((event) => event.eventId == eventId);
    setIsCanceled(false);
    notifyListeners();
  }

  Future<void> rescheduleSchedule(String eventId, String newDate, String newTime) async {
    setIsReSchedule(true);
    await eventsCollection.doc(eventId).update({
      'status': "upcoming",
      'eventDate': newDate,
      'eventTime': newTime,
    });
    setIsReSchedule(false);
    notifyListeners();
  }

  Future<void> completeTheSchedule(String eventId, String newDate, String newTime) async {
    setIsReSchedule(true);
    print('This is parameter data $eventId $newDate $newTime');
    await eventsCollection.doc(eventId).update({
      'status': "completed",
      'rated': false,
      'eventDate': newDate,
      'eventTime': newTime,
    });
    setIsReSchedule(false);
    notifyListeners();
  }
}

/*
  ChatProvider Class

  This Dart file defines the `ChatProvider` class, which is a provider responsible for managing chat functionality.

  Dependencies:
  - Ensure that the necessary dependencies are included based on the imports used in the file.

  Functionality:
  - Provides methods to send messages and listen for updates in a chat.
  - Utilizes the `Chat` class to represent chat messages.
  - Includes a listener for real-time updates in the chat messages.

  Note: The `Chat` class includes methods to convert the object to and from JSON.

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatProvider extends ChangeNotifier {
  Map<String, dynamic> _messageData = {};

  // Getter and setter for messageData
  Map<String, dynamic> get messageData => _messageData;

  set messageData(Map<String, dynamic> value) {
    _messageData = value;
    Future.microtask(() => notifyListeners());
  }

  final List<Chat> _chat = [];

  List<Chat> get chats => _chat;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  set searchQuery(String query) {
    _searchQuery = query;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  } // Method to send a message in a chat

  Future<bool> sendMessage(String appointmentId, String senderId, String receiverId, String message) async {
    try {
      final chat = Message(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        isRead: false,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('chats').doc(appointmentId.toString()).set({"docId": appointmentId.toString()});
      await FirebaseFirestore.instance.collection('chats').doc(appointmentId.toString()).collection('messages').add(chat.toJson());
      return true;
    } catch (error) {
      print('Error sending message: $error');
      return false;
    }
  }

  Future<void> fetchChats(List<String> chatIds) async {
    print(chats.length);
    _chat.clear();
    print('Contents of chatIds: $chatIds');
    setLoading(true);
    for (String chatId in chatIds) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('appointments').where('docId', isEqualTo: chatId).get();

      print('Current chatId: $chatId');
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        setLoading(true);
        var message = (await FirebaseFirestore.instance
                .collection('chats')
                .doc(doc.id)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get())
            .docs
            .first
            .data();
        String timestamp = message['timestamp'];
        DateTime dateTime = DateTime.parse(timestamp);
        String formattedTime = DateFormat.Hm().format(dateTime);
        print('Current docId: $formattedTime');
        _chat.add(Chat(
          appointmentId: doc.id,
          doctorId: doc['doctorId'],
          doctorName: doc['doctorName'],
          phone: doc['phone'],
          photoUrl: doc['photoUrl'],
          lastMessage: message['message'],
          lastMessageTime: formattedTime,
        ));
      }
    }
    setLoading(false);
    notifyListeners();
  }

  List<Chat> get filteredChats {
    return _chat.where((chat) {
      return chat.doctorName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
}

// Chat Class
class Message {
  String senderId;
  String receiverId;
  String message;
  bool isRead;
  DateTime timestamp;

  // Constructor
  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.timestamp,
  });

  // Define a toJson method to convert Chat object to JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'isRead': isRead,
      'timestamp': timestamp.toUtc().toIso8601String(), // Convert DateTime to ISO 8601 format
    };
  }

  // Define a factory method to create a Chat object from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      isRead: json['isRead'],
      timestamp: DateTime.parse(json['timestamp']), // Parse ISO 8601 string back to DateTime
    );
  }
}

class Chat {
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String phone;
  final String photoUrl;
  final String lastMessage;
  final String lastMessageTime;

  Chat({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.phone,
    required this.photoUrl,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}

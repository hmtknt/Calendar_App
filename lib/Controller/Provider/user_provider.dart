import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Functions/user_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<DocumentSnapshot>>? _usersStream;
  Stream<DocumentSnapshot>? _followersStream;
  List<String> followedUserIds = [];

  Stream<List<DocumentSnapshot>>? get usersStream => _usersStream;
  Stream<DocumentSnapshot>? get followersStream => _followersStream;

  bool _isFriend = false;

  bool get isFriend => _isFriend;

  void setIsFriend(bool value) {
    _isFriend = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> getAllUsers(String userId) async {
    try {
      _usersStream = _firebaseService.getAllUsersStream(userId);
    } catch (e) {
      print('Error get user: $e');
      rethrow;
    }
  }

  Future<void> followUser(String userIdToFollow) async {
    try {
      followedUserIds.clear();
      await _firebaseService.followUser(userIdToFollow);
      QuerySnapshot followingSnapshot = await _firestore.collection('users').doc(loggedInUser!.uid).collection('following').get();
      for (var doc in followingSnapshot.docs) {
        followedUserIds.add(doc['userId']);
      }
      setIsFriend(true);
      notifyListeners();
    } catch (e) {
      print('Error following user: $e');
      rethrow;
    }
  }

  Future<void> unfollowUser(String userIdToUnfollow) async {
    try {
      followedUserIds.clear();
      await _firebaseService.unfollowUser(userIdToUnfollow);
      QuerySnapshot followingSnapshot = await _firestore.collection('users').doc(loggedInUser!.uid).collection('following').get();
      for (var doc in followingSnapshot.docs) {
        followedUserIds.add(doc['userId']);
      }
      setIsFriend(false);
      notifyListeners();
    } catch (e) {
      print('Error unfollowing user: $e');
      rethrow;
    }
  }

  Future<void> followingSnapshot() async {
    try {
      followedUserIds.clear();
      QuerySnapshot followingSnapshot = await _firestore.collection('users').doc(loggedInUser!.uid).collection('following').get();
      for (var doc in followingSnapshot.docs) {
        followedUserIds.add(doc['userId']);
      }
      notifyListeners();
    } catch (e) {
      print('Error followingSnapshot: $e');
      rethrow;
    }
  }

  Future<void> fetchFollowers(String userId) async {
    _followersStream = _firebaseService.getFollowersStream(userId);
  }
}

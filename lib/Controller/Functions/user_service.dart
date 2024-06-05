import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
User? loggedInUser = _auth.currentUser;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> getAllUsersStream(String userId) {
    return _firestore.collection('users').where("uid", isNotEqualTo: userId).snapshots().map((snapshot) => snapshot.docs);
  }

  Future<void> followUser(String userIdToFollow) async {
    try {
      print("User ID : ${loggedInUser!.uid}");
      await _firestore.collection('users').doc(loggedInUser!.uid).collection('following').doc(userIdToFollow).set({
        'userId': userIdToFollow,
      });

      await _firestore.collection('users').doc(userIdToFollow).collection('followers').doc(loggedInUser!.uid).set({
        'userId': loggedInUser!.uid,
      });
    } catch (e) {
      print('Error following user: $e');
      rethrow;
    }
  }

  Future<void> unfollowUser(String userIdToUnfollow) async {
    try {
      await _firestore.collection('users').doc(loggedInUser!.uid).collection('following').doc(userIdToUnfollow).delete();

      await _firestore.collection('users').doc(userIdToUnfollow).collection('followers').doc(loggedInUser!.uid).delete();
    } catch (e) {
      print('Error unfollowing user: $e');
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getFollowersStream(String userId) {
    return _firestore.collection('users').doc(userId).collection('followers').doc(loggedInUser!.uid).snapshots();
  }
}

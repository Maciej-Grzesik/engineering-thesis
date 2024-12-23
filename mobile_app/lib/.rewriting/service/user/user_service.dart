import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserInfo(String username, String userInfo) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'userInfo': userInfo,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding user info: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        return null;
      }
  
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error retrieving user info: $e");
      rethrow;
    }
  }

  Future<void> updateUserInfo(String updatedUserInfo) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      await _firestore.collection('users').doc(user.uid).update({
        'userInfo': updatedUserInfo,
      });
    } catch (e) {
      print("Error updating user info: $e");
      rethrow;
    }
  }
}

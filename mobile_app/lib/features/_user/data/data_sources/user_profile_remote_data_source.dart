import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/core/error/exception.dart';
import 'package:mobile_app/features/_user/data/models/user_profile_model.dart';

abstract interface class IUserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile({
    required String name,
    required String email,
  });

  Future<void> logout();
}

class UserProfileRemoteDataSource implements IUserProfileRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  UserProfileRemoteDataSource(
    this._firebaseAuth,
    this._firebaseFirestore,
  );

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final userProfile = _firebaseAuth.currentUser;
      if (userProfile == null) {
        throw const ServiceException("error_code_no_user");
      }
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(userProfile.uid)
          .get();
      if (!userDoc.exists) {
        throw Exception("error_code_no_doc");
      }
      return UserProfileModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    required String name,
    required String email,
  }) async {
    try {
      final userProfile = _firebaseAuth.currentUser;
      if (userProfile == null) {
        throw Exception('error_code_no_user');
      }
      final userDocRef =
          _firebaseFirestore.collection('users').doc(userProfile.uid);
      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        await userDocRef.set({
          'name': name,
          'email': email,
        });
      } else {
        await userDocRef.update({
          'name': name,
          'email': email,
        });
      }
      return UserProfileModel(name: name, email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

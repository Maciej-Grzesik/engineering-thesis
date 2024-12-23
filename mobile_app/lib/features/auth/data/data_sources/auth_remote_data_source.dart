import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/core/error/exception.dart';
import 'package:mobile_app/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signupWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const ServiceException("User is null");
      }
      return UserModel.fromJson({
        "id": response.user!.uid,
        "email": response.user!.email,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Wystąpił nieoczekiwany błąd. Spróbuj ponownie.");
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (response.user == null) {
        throw const ServiceException("User is null");
      }
      return UserModel.fromJson({
        "id": response.user!.uid,
        "email": response.user!.email,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

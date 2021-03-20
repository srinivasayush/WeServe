import 'package:firebase_auth/firebase_auth.dart';
import 'package:WeServe/services/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with Email and Password with Firebase Authentication
  Future registerWithEmailAndPassword(
      {String email,
      String password,
      String username,
      String phoneNumber,
      bool isVolunteer,
      String towerNumber,
      String block,
      String houseNumber}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await updateUserData(
        result.user.uid,
        username: username,
        phoneNumber: "+91" + phoneNumber,
        isVolunteer: isVolunteer,
        towerNumber: towerNumber,
        block: block,
        houseNumber: houseNumber,
      );
      return result.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Signs the user in using Firebase Authentication

  Future signInWithEmailAndPassword({String email, String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Signs the user out using Firebase Authentication
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}

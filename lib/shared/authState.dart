import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateStreamProvider = StreamProvider.autoDispose<User>((ref) {
  final userStream = FirebaseAuth.instance.authStateChanges();
  ref.maintainState = true;
  return userStream;
});

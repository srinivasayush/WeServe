import 'package:WeServe/models/userInformation.dart';
import 'package:WeServe/services/database.dart';
import 'package:WeServe/shared/authState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInformationStreamProvider =
    StreamProvider.autoDispose<UserInformation>((ref) async* {
  final user = await ref.watch(authStateStreamProvider.last);
  if (user == null) {
    yield null;
  } else {
    final stream = userInformationStream(user.uid);
    ref.maintainState = true;
    yield* stream;
  }
});

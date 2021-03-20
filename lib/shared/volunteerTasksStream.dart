import 'package:WeServe/models/task.dart';
import 'package:WeServe/services/database.dart';
import 'package:WeServe/shared/authState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final volunteerTasksStreamProvider =
    StreamProvider.autoDispose<List<Task>>((ref) async* {
  final user = await ref.watch(authStateStreamProvider.last);
  if (user == null) {
    yield null;
  } else {
    final stream = volunteerTasksStream(user.uid);
    ref.maintainState = true;
    yield* stream;
  }
});

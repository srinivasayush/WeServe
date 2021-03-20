import 'package:WeServe/models/task.dart';
import 'package:WeServe/services/database.dart';
import 'package:WeServe/shared/authState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final elderlyTasksStreamProvider =
    StreamProvider.autoDispose<List<Task>>((ref) async* {
  final user = await ref.watch(authStateStreamProvider.last);
  final stream = elderlyTaskStream(user.uid);
  ref.maintainState = true;
  yield* stream;
});

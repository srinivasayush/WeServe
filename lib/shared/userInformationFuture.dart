import 'package:WeServe/models/userInformation.dart';
import 'package:WeServe/services/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInformationProvider = FutureProvider.autoDispose
    .family<UserInformation, String>((ref, uid) async {
  if (uid == null || uid == '') {
    return null;
  }
  final citizenInformation = await getCitizenInformation(uid);

  ref.maintainState = true;
  return citizenInformation;
});

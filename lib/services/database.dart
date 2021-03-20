import 'package:WeServe/models/userInformation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WeServe/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

final tasksRef = FirebaseFirestore.instance.collection('tasks');
final usersRef = FirebaseFirestore.instance.collection('users');

Future<void> updateUserData(
  String uid, {
  String username,
  String phoneNumber,
  String towerNumber,
  String block,
  String houseNumber,
  bool isVolunteer,
}) async {
  await usersRef.doc(uid).set({
    "username": username,
    "phoneNumber": phoneNumber,
    "isVolunteer": isVolunteer,
    "address":
        "Devarabisenahalli, Varthur Post,Outer Ring Road, Bellandur Post, Bangalore-560103 T$towerNumber ${block.toString() + houseNumber.toString()}",
  });
}

Future<void> addTask(
  String uid, {
  String taskType,
  String byWhen,
  String task,
  String issuedByName,
  String issuedByAddress,
  String issuedByPhoneNumber,
}) async {
  await tasksRef.doc().set({
    "acknowledged": false,
    "byWhen": byWhen ?? '',
    "isComplete": false,
    "issuedBy": uid,
    "taskType": taskType,
    "task": task,
    "volunteer": "",
    "issuedByName": issuedByName,
    "issuedByPhoneNumber": issuedByPhoneNumber,
    "issuedByAddress": issuedByAddress,
  });
}

Future<void> updateTask({
  String volunteerId = '',
  @required String taskId,
  @required bool isComplete,
}) async {
  await tasksRef.doc(taskId).update({
    "volunteer": volunteerId,
    "isComplete": isComplete,
  });
}

Future<void> deleteTask({String taskId}) async {
  await tasksRef.doc(taskId).delete();
}

Future<void> dismissCompletedTask({String taskId}) async {
  await tasksRef.doc(taskId).update({
    "acknowledged": true,
  });
}

Future<void> deleteAllElderlyUserData(String uid) async {
  final querySnapshot = await tasksRef
      .where('issuedBy', isEqualTo: uid)
      .where('isComplete', isEqualTo: false)
      .get();
  WriteBatch batch = FirebaseFirestore.instance.batch();

  querySnapshot.docs.forEach((DocumentSnapshot document) {
    batch.delete(document.reference);
  });

  batch.commit();
  usersRef.doc(uid).delete();
}

Future<void> deleteAllVolunteerData(String uid) async {
  tasksRef
      .where('volunteer', isEqualTo: uid)
      .where('isComplete', isEqualTo: false)
      .get()
      .then((QuerySnapshot qs) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    qs.docs.forEach((DocumentSnapshot ds) {
      batch.delete(ds.reference);
    });

    batch.commit();
  });
  await usersRef.doc(uid).delete();
}

Future<UserInformation> getCitizenInformation(String uid) async {
  var ds = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return _userInformationFromDocumentSnapshot(ds);
}

UserInformation _userInformationFromDocumentSnapshot(DocumentSnapshot ds) {
  return UserInformation.fromMap({
    ...ds.data(),
    ...{
      'uid': ds.id,
    }
  });
}

// Task List from QuerySnapshot
List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
  print('read ${snapshot.docs.length} documents');
  return snapshot.docs.map((doc) {
    final documentData = doc.data();
    return Task(
      taskId: doc.id,
      acknowledged: documentData['acknowledged'] ?? false,
      byWhen: documentData['byWhen'] ?? '',
      isComplete: documentData['isComplete'] ?? false,
      issuedBy: documentData['issuedBy'] ?? '',
      issuedByName: documentData['issuedByName'] ?? '',
      issuedByPhoneNumber: documentData['issuedByPhoneNumber'],
      issuedByAddress: documentData['issuedByAddress'] ?? '',
      taskType: documentData['taskType'] ?? '',
      task: documentData['task'] ?? '',
      volunteer: documentData['volunteer'] ?? '',
    );
  }).toList();
}

Stream<List<Task>> elderlyTaskStream(String uid) {
  return tasksRef
      .where('issuedBy', isEqualTo: uid)
      .where('acknowledged', isEqualTo: false)
      .snapshots()
      .map(_taskListFromSnapshot);
}

Stream<UserInformation> userInformationStream(String uid) {
  return usersRef.doc(uid).snapshots().map((ds) {
    print('the value of ds.data() is: ');
    print(ds.data());
    return _userInformationFromDocumentSnapshot(ds);
  });
}

Stream<List<Task>> volunteerTasksStream(String uid) {
  return tasksRef
      .where('volunteer', isEqualTo: uid)
      .where('acknowledged', isEqualTo: false)
      .snapshots()
      .map(_taskListFromSnapshot);
}

Stream<List<Task>> get allTasksStream {
  return tasksRef
      .where('isComplete', isEqualTo: false)
      .where('volunteer', isEqualTo: '')
      .snapshots()
      .map(_taskListFromSnapshot);
}

Stream<List<Task>> historyTasksStream(String uid) {
  return tasksRef
      .where('volunteer', isEqualTo: uid)
      .where('isComplete', isEqualTo: true)
      .snapshots()
      .map(_taskListFromSnapshot);
}

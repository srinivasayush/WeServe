import 'package:meta/meta.dart';

class UserInformation {
  UserInformation({
    @required this.address,
    @required this.isVolunteer,
    @required this.phoneNumber,
    @required this.username,
    @required this.uid,
  });

  String address;
  bool isVolunteer;
  String phoneNumber;
  String username;
  String uid;

  factory UserInformation.fromMap(Map<String, dynamic> json) => UserInformation(
        address: json["address"],
        isVolunteer: json["isVolunteer"],
        phoneNumber: json["phoneNumber"],
        username: json["username"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "isVolunteer": isVolunteer,
        "phoneNumber": phoneNumber,
        "username": username,
        "uid": uid,
      };
}

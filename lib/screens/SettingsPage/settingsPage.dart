import 'package:WeServe/shared/authState.dart';
import 'package:WeServe/shared/userInformationFuture.dart';
import 'package:WeServe/shared/userInformationStream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/services/auth.dart';
import 'package:WeServe/services/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _errorProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class SettingsPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  _showDeleteUserAlert(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you Sure?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final userData =
                    await context.read(userInformationStreamProvider.last);
                if (userData.isVolunteer) {
                  await deleteAllVolunteerData(user.uid);
                } else {
                  await deleteAllElderlyUserData(user.uid);
                }
                await user.delete();
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.white;
                }),
              ),
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.white;
                }),
              ),
              child: Text("No"),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  InkWell _signOutButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () async {
        final authService = context.read(authServiceProvider);
        var result = await authService.signOut();
        if (result != null) {
          context.read(_errorProvider).state =
              "Error signing out. Please try again later.";
        } else if (result == null) {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.red]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Text(
          "Sign Out",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  InkWell _deleteAccountButton(BuildContext context, User user) {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () {
        _showDeleteUserAlert(context, user);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.red]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Text(
          "Delete Account",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Container _form(BuildContext context, User user) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            _signOutButton(context),
            SizedBox(
              height: 20,
            ),
            _deleteAccountButton(context, user),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: watch(authStateStreamProvider).when(
        data: (user) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Colors.green,
                    Colors.blue,
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      BackButton(),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Settings",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 60.0),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    child: _form(context, user),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Something went wrong: $error',
          ),
        ),
      ),
    );
  }
}

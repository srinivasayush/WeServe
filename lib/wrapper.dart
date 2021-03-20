import 'package:WeServe/screens/VolunteerWrapper/volunteerWrapper.dart';
import 'package:WeServe/shared/userInformationStream.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/screens/ElderlyHomePage/elderlyHomePage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:WeServe/screens/WelcomePage/welcomePage.dart';

class Wrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(userInformationStreamProvider).when(
      data: (userInformation) {
        if (userInformation == null) {
          return WelcomePage();
        } else {
          if (userInformation.isVolunteer) {
            return VolunteerWrapper();
          } else {
            return ElderlyHomePage();
          }
        }
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        print(error);
        print(stackTrace);
        return Scaffold(
          body: Text(
            'Something went wrong $error',
          ),
        );
      },
    );
  }
}

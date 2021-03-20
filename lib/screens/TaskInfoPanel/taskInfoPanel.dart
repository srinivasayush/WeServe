import 'package:WeServe/components/elderlyInformation.dart';
import 'package:WeServe/components/volunteerInformation.dart';
import 'package:WeServe/models/task.dart';
import 'package:WeServe/shared/userInformationStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskInfoPanel extends ConsumerWidget {
  final Task task;
  TaskInfoPanel({@required this.task});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: Center(
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
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  BackButton(),
                ],
              ),
              Text(
                "Task Info",
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: watch(userInformationStreamProvider).when<Widget>(
                    data: (userInformation) {
                      if (userInformation.isVolunteer) {
                        return VolunteerInformationForm(
                          task: task,
                        );
                      } else {
                        return ElderlyInformationForm(
                          task: task,
                        );
                      }
                    },
                    loading: () => Center(
                          child: CircularProgressIndicator(),
                        ),
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(
                          'Something went wrong: $error',
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

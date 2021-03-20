import 'package:WeServe/models/task.dart';
import 'package:WeServe/services/database.dart';
import 'package:WeServe/shared/userInformationStream.dart';
import 'package:WeServe/utils/taskStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskActionComponent extends ConsumerWidget {
  final Task task;
  TaskActionComponent({@required this.task});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(userInformationStreamProvider).when<Widget>(
      data: (userInformation) {
        final taskStatus = calculateTaskStatus(task: task);
        print(
          'components/taskInfoPanel.dart: taskStatus value: ' +
              taskStatus.toString(),
        );

        if (taskStatus == TaskStatus.confirmed) {
          return Center(
            child: Text(
              "Confirmed!",
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.0,
              ),
            ),
          );
        } else if (taskStatus == TaskStatus.waitingForConfirmation &&
            userInformation.isVolunteer) {
          return Center(
            child: Text(
              "Task Complete! Waiting for Confirmation...",
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.0,
              ),
            ),
          );
        } else if (taskStatus == TaskStatus.waitingForConfirmation &&
            !userInformation.isVolunteer) {
          return InkWell(
            onTap: () {
              dismissCompletedTask(
                taskId: task.taskId,
              );
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            borderRadius: BorderRadius.circular(80.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Center(
                child: Text("Confirm Completion",
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
              ),
            ),
          );
        } else if (taskStatus == TaskStatus.notAccepted &&
            userInformation.isVolunteer) {
          return InkWell(
            borderRadius: BorderRadius.circular(80.0),
            onTap: () {
              updateTask(
                volunteerId: userInformation.uid,
                taskId: task.taskId,
                isComplete: false,
              );
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Text(
                "Accept Task",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          );
        } else if (taskStatus == TaskStatus.notAccepted &&
            !userInformation.isVolunteer) {
          return InkWell(
            onTap: () async {
              await deleteTask(
                taskId: task.taskId,
              );
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(80.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          );
        } else if (taskStatus == TaskStatus.inProgress &&
            userInformation.isVolunteer) {
          return InkWell(
            borderRadius: BorderRadius.circular(80.0),
            onTap: () {
              updateTask(
                volunteerId: userInformation.uid,
                taskId: task.taskId,
                isComplete: true,
              );
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Center(
                child: Text(
                  "Mark as Complete",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          );
        }
        return Container();
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Something went wrong: $error',
        ),
      ),
    );
  }
}

import 'package:WeServe/components/taskActionComponent.dart';
import 'package:WeServe/models/task.dart';
import 'package:WeServe/shared/userInformationFuture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElderlyInformationForm extends ConsumerWidget {
  final Task task;
  ElderlyInformationForm({@required this.task});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    if (task == null) {
      return Text('literally how can task be null');
    }
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      padding: EdgeInsets.only(top: 20),
      child: Container(
        padding: EdgeInsets.all(0),
        height: 250,
        child: watch(userInformationProvider(task.volunteer)).when<Widget>(
          data: (volunteerInformation) {
            return ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Scroll all the way down for more fields",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.grey,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Type: ${task.taskType}",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (task.volunteer == '')
                  Text(
                    "Task has not been accepted yet",
                    style: TextStyle(fontSize: 23.0),
                  ),
                if (volunteerInformation != null &&
                    volunteerInformation.username != '')
                  Text(
                    "Name: ${volunteerInformation.username}",
                    style: TextStyle(fontSize: 23.0),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Task: " + task.task,
                      style: TextStyle(fontSize: 23.0),
                    ),
                  ],
                ),
                if (volunteerInformation != null &&
                    volunteerInformation.phoneNumber != '')
                  Text(
                    "Phone Number: ${volunteerInformation.phoneNumber}",
                    style: TextStyle(fontSize: 23.0),
                  ),
                if (task.byWhen != '')
                  Text(
                    "Time: ${task.byWhen}",
                    style: TextStyle(fontSize: 23.0),
                  ),
                if (volunteerInformation != null &&
                    volunteerInformation.address != '')
                  Text(
                    "Address: ${volunteerInformation.address}",
                    style: TextStyle(fontSize: 23.0),
                  ),
                SizedBox(
                  height: 20,
                ),
                TaskActionComponent(
                  task: task,
                ),
              ],
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) {
            print(error);
            print(stackTrace);
            return Center(
              child: Text(
                'Something went wrong: $error',
              ),
            );
          },
        ),
      ),
    );
  }
}

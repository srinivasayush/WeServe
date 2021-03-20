import 'package:WeServe/components/taskActionComponent.dart';
import 'package:WeServe/models/task.dart';
import 'package:flutter/material.dart';

class VolunteerInformationForm extends StatelessWidget {
  final Task task;
  VolunteerInformationForm({@required this.task});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      padding: EdgeInsets.only(top: 20),
      child: Container(
        padding: EdgeInsets.all(0),
        height: 250,
        child: ListView(
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
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (task.volunteer == '')
              Text(
                "Task has not been accepted yet",
                style: TextStyle(fontSize: 23.0),
              ),
            if (task.issuedByName != '')
              Text(
                "Name: ${task.issuedByName}",
                style: TextStyle(fontSize: 23.0),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Task: " + task.task.toString(),
                  style: TextStyle(fontSize: 23.0),
                ),
              ],
            ),
            if (task.issuedByPhoneNumber != '')
              Text(
                "Phone Number: ${task.issuedByPhoneNumber}",
                style: TextStyle(fontSize: 23.0),
              ),
            if (task.byWhen != '')
              Text(
                "Time: ${task.byWhen}",
                style: TextStyle(fontSize: 23.0),
              ),
            if (task.issuedByAddress != '')
              Text(
                "Address: ${task.issuedByAddress}",
                style: TextStyle(fontSize: 23.0),
              ),
            SizedBox(
              height: 20,
            ),
            TaskActionComponent(
              task: task,
            ),
          ],
        ),
      ),
    );
  }
}

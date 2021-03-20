import 'package:WeServe/screens/SettingsPage/settingsPage.dart';
import 'package:WeServe/screens/TaskInfoPanel/taskInfoPanel.dart';
import 'package:WeServe/shared/elderlyTaskStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ElderlyTaskForm/elderlyTaskForm.dart';
import 'package:WeServe/services/database.dart';

class ElderlyHomePage extends ConsumerWidget {
  SliverAppBar _customAppBar(BuildContext context) {
    return SliverAppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            );
          },
        ),
      ],
      floating: true,
      pinned: false,
      snap: false,
      title: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "Home - APR",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      centerTitle: true,
      expandedHeight: 120.0,
      elevation: 1.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.green, Colors.blue],
          ),
        ),
      ),
    );
  }

  InkWell _addButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ElderlyTaskForm()));
      },
      borderRadius: BorderRadius.circular(80.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.green]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Center(
          child: Text(
            "Request Help",
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _statusIcon({
    bool acknowledged,
    String volunteer,
    bool isComplete,
    String taskId,
  }) {
    if (volunteer == '') {
      return Text(
        "In queue",
        style: TextStyle(fontSize: 17.0, color: Colors.orange[900]),
      );
    } else if (volunteer != '' && isComplete == false) {
      return Text(
        "In progress",
        style: TextStyle(fontSize: 17.0, color: Colors.orange),
      );
    } else if (volunteer != '' && isComplete == true) {
      return IconButton(
        onPressed: () {
          dismissCompletedTask(taskId: taskId);
        },
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(elderlyTasksStreamProvider).when(
      data: (tasks) {
        return Material(
          child: CustomScrollView(
            slivers: <Widget>[
              _customAppBar(context),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 20,
                  ),
                  _addButton(context),
                ]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final _status = _statusIcon(
                      acknowledged: tasks[index].acknowledged,
                      isComplete: tasks[index].isComplete,
                      volunteer: tasks[index].volunteer,
                      taskId: tasks[index].taskId,
                    );
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskInfoPanel(
                                task: tasks[index],
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskInfoPanel(
                                  task: tasks[index],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.more_horiz),
                        ),
                        leading: _status,
                        title: Text(
                          tasks[index].taskType,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Request: ${tasks[index].task.toString()}",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                            ),
                            if (tasks[index].isComplete == true)
                              Text(
                                "Click on the check mark to confirm completion",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 17.0,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: tasks.length,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        // print(error.toString());
        // print(stackTrace.toString());
        return Scaffold(
          body: Center(
            child: Text(
              'Something went wrong: $error',
            ),
          ),
        );
      },
    );
  }
}

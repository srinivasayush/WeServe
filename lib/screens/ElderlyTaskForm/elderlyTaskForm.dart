import 'package:WeServe/services/database.dart';
import 'package:WeServe/shared/authState.dart';
import 'package:WeServe/shared/userInformationStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _taskTypeProvider = StateProvider.autoDispose<String>((ref) {
  return 'Medicine';
});

final _taskProvider = StateProvider.autoDispose<String>((ref) {
  final taskContent = '';
  ref.maintainState = true;
  return taskContent;
});

class ElderlyTaskForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        BackButton(),
                      ],
                    ),
                    Text(
                      "Add Task",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40.0),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          _TaskForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTypeDropDown extends ConsumerWidget {
  final List<String> _taskTypes = <String>['Medicine', 'Groceries', 'Other'];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final taskType = watch(_taskTypeProvider).state;
    return Container(
      height: 89.0,
      child: DropdownButtonFormField(
        value: taskType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        onChanged: (value) {
          context.read(_taskTypeProvider).state = value;
        },
        items: _taskTypes.map((String type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type,
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TaskForm extends ConsumerWidget {
  static final _formKey = GlobalKey<FormState>();

  InkWell _submitButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () async {
        final user = await context.read(authStateStreamProvider.last);
        if (_formKey.currentState.validate()) {
          final userInformation =
              await context.read(userInformationStreamProvider.last);
          await addTask(
            user.uid,
            task: context.read(_taskProvider).state.trim(),
            taskType: context.read(_taskTypeProvider).state.trim(),
            issuedByName: userInformation.username,
            issuedByAddress: userInformation.address,
            issuedByPhoneNumber: userInformation.phoneNumber,
          );
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.green]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Text(
          "Submit",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Container _taskField(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        maxLines: 50,
        validator: (String value) {
          if (value.trim() == '') {
            return 'Please enter some text';
          } else {
            return null;
          }
        },
        onChanged: (String value) {
          context.read(_taskProvider).state = value;
        },
        decoration: InputDecoration(
          hintText: "Enter requirement/task here",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              _TaskTypeDropDown(),
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                height: 160,
                child: _taskField(context),
              ),
              SizedBox(
                height: 5,
              ),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

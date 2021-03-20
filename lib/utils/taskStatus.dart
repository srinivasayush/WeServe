import 'package:WeServe/models/task.dart';
import 'package:meta/meta.dart';

enum TaskStatus {
  confirmed,
  waitingForConfirmation,
  notAccepted,
  inProgress,
}

TaskStatus calculateTaskStatus({@required Task task}) {
  if (task.volunteer == '') {
    return TaskStatus.notAccepted;
  } else if (task.volunteer != '' && task.isComplete == false) {
    return TaskStatus.inProgress;
  } else if (task.isComplete == true && task.acknowledged == false) {
    return TaskStatus.waitingForConfirmation;
  } else if (task.isComplete == true && task.acknowledged == true) {
    return TaskStatus.confirmed;
  }
}

import 'package:flutter/cupertino.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({Key? key}) : super(key: key);

  @override
  TaskCreatePageState createState() => TaskCreatePageState();
}

class TaskCreatePageState extends State<TaskCreatePage> {

  Map<String, dynamic> changes = {
  };

  Map<String, List<String>> fieldOptions = {
    'stage': [],
    'user': [],
    'company': [],
    'client': [],
    'tags': [],
    'team': [],
  };

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
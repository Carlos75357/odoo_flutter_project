import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCreatePage extends StatefulWidget {
  final String projectName;
  const TaskCreatePage({Key? key, required this.projectName}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Tarea para el proyecto ${widget.projectName}'),
      ),
      body: Container(),
    );
  }
}
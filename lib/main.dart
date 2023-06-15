import 'package:flutter/material.dart';
import 'package:flutter_sql/task_list_page.dart';
import 'package:flutter_sql/db_test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListPage(),
    );
  }
}

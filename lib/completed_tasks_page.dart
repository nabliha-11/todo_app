import 'package:flutter/material.dart';
import 'package:flutter_sql/db_test.dart';

class CompletedTasksPage extends StatefulWidget {
  @override
  _CompletedTasksPageState createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  List<Task> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedTasks();
  }

  Future<void> _fetchCompletedTasks() async {
    final completedTasks = await DatabaseHelper.getCompletedTasks();
    setState(() {
      this.completedTasks = completedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedTasks[index].title ?? 'No Title'),
            subtitle: Text(completedTasks[index].description ?? 'No Description'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          );
        },
      ),
    );
  }
}

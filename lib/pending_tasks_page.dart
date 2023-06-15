import 'package:flutter/material.dart';
import 'package:flutter_sql/db_test.dart';

class PendingTasksPage extends StatefulWidget {
  @override
  _PendingTasksPageState createState() => _PendingTasksPageState();
}

class _PendingTasksPageState extends State<PendingTasksPage> {
  List<Task> pendingTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingTasks();
  }

  Future<void> _fetchPendingTasks() async {
    final pendingTasks = await DatabaseHelper.getPendingTasks();
    setState(() {
      this.pendingTasks = pendingTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks'),
      ),
      body: ListView.builder(
        itemCount: pendingTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pendingTasks[index].title ?? 'No Title'),
            subtitle: Text(pendingTasks[index].description ?? 'No Description'),
            trailing: Icon(Icons.pending, color: Colors.red),
          );
        },
      ),
    );
  }
}

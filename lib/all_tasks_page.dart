import 'package:flutter/material.dart';
import 'package:flutter_sql/db_test.dart';

class AllTasksPage extends StatefulWidget {
  @override
  _AllTasksPageState createState() => _AllTasksPageState();
}


class _AllTasksPageState extends State<AllTasksPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final allTasks = await DatabaseHelper.getAllTasks();
    setState(() {
      tasks = allTasks;
    });
  }

  Future<void> _updateTaskStatus(int taskId, bool isCompleted) async {
    await DatabaseHelper.updateTaskStatus(taskId, isCompleted);
    _fetchTasks();
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, Task task) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.deleteTask(task.id!);
                _fetchTasks();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                // Handle title input logic
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                // Handle description input logic
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle task submission logic
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title ?? 'No Title'),
            subtitle: Text(task.description ?? 'No Description'),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) async {
                setState(() {
                  tasks[index] = Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    isCompleted: value ?? false,
                  );
                });
                await DatabaseHelper.updateTaskStatus(task.id!, value ?? false);
              },
            ),
            onTap: () {
              // Handle task update or delete logic
              _showDeleteConfirmationDialog(context, task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


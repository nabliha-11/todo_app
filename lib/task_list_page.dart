import 'package:flutter/material.dart';
import 'package:flutter_sql/add_task_page.dart';
import 'package:flutter_sql/all_tasks_page.dart';
import 'package:flutter_sql/completed_tasks_page.dart';
import 'package:flutter_sql/pending_tasks_page.dart';
import 'package:flutter_sql/db_test.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      AllTasksPage(),
      CompletedTasksPage(),
      PendingTasksPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'Pending',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
      ),
    );
  }
}

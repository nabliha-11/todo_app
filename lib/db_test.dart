import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  final int? id;
  final String? title;
  final String? description;
  final bool isCompleted;

  Task({this.id, this.title, this.description, this.isCompleted=false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );

    return _database!;
  }

  static Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks');
    return taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  static Future<List<Task>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    return taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  static Future<List<Task>> getPendingTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks', where: 'isCompleted = ?', whereArgs: [0]);
    return taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
  }
  static Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
  static Future<void> deleteTask(int taskId) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}

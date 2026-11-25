import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task_model.dart';

class DatabaseHelper {
  // Creates one shared instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._instance();

  // Stores the database connection
  static Database? _database;

  // Private constructor prevents creating multiple instances
  DatabaseHelper._instance();

  // Returns the database, opening it only when needed
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Creates or opens the SQLite database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Creates the complete database file path
    final path = join(databasePath, "tasks.db");

    return await openDatabase(
      path,
      version: 1,

      // Runs when the database is created for the first time
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            dueDate TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // Inserts a new task into SQLite

  Future<int> insertTask(TaskModel task) async {
    final db = await instance.database;
    return await db.insert(
      "tasks",
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieves all tasks from SQLite
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;

    final result = await db.query("tasks");

    // Converts database Map data into TaskModel objects

    return result
        .map((task) => TaskModel.fromMap(Map<String, dynamic>.from(task)))
        .toList();
  }

  // Updates an existing task using its ID
  Future<int> updateTask(TaskModel task) async {
    final db = await database;

    return await db.update(
      "tasks",
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  // Deletes a task using its ID
  Future<int> deleteTask(int id) async {
    final db = await database;

    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

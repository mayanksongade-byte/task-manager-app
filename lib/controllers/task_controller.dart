
import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {

  // Connect the controller to our database.
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  // This list stores all tasks.
  // .obs tells GetX to watch for changes.
  var tasks = <TaskModel>[].obs;

  // Gets all saved tasks from SQLite.
  Future<void> loadTasks() async {
    tasks.value = await databaseHelper.getAllTasks();
  }

  // Adds a new task to SQLite.
  Future<void> addTask(TaskModel task) async {
    await databaseHelper.insertTask(task);

    // Refresh the task list after saving.
    await loadTasks();
  }
  // Updates an existing task in SQLite.
  Future<void> updateTask(TaskModel task) async {
    await databaseHelper.updateTask(task);

    // Refresh the task list after updating.
    await loadTasks();
  }

  // Deletes a task from SQLite.
  Future<void> deleteTask(int id) async {
    await databaseHelper.deleteTask(id);

    // Refresh the task list after deleting.
    await loadTasks();
  }
}

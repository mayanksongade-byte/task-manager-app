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

  // Changes a task between Completed and Pending.
  Future<void> toggleTaskStatus(TaskModel task) async {
    // Create a copy of the task with the opposite status.
    final updatedTask = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: !task.isCompleted,
    );

    // Save the changed task in SQLite.
    await updateTask(updatedTask);
  }

  // Stores the currently selected filter.
  var selectedFilter = 'All'.obs;

  // Stores the text entered in the search box.
  var searchQuery = ''.obs;

  // Returns tasks based on the selected filter and search text.
  List<TaskModel> get filteredTasks {

    // Start with all tasks.
    List<TaskModel> result = tasks;

    // If Pending is selected, keep only pending tasks.
    if (selectedFilter.value == 'Pending') {
      result = result.where((task) => !task.isCompleted).toList();
    }

    // If Completed is selected, keep only completed tasks.
    else if (selectedFilter.value == 'Completed') {
      result = result.where((task) => task.isCompleted).toList();
    }

    // Get the search text and convert it to lowercase.
    final query = searchQuery.value.trim().toLowerCase();

    // If the user entered something, search inside task titles.
    if (query.isNotEmpty) {
      result = result.where((task) {
        return task.title.toLowerCase().contains(query);
      }).toList();
    }

    // Return the final filtered and searched task list.
    return result;
  }
}

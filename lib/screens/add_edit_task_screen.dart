import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class AddEditTaskScreen extends StatefulWidget {
  // Existing task when we want to edit.
  // null means we are creating a new task.
  final TaskModel? task;

  const AddEditTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}



class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  // Checks whether this screen is editing an existing task.
  bool get isEditing => widget.task != null;
  // These controllers read what the user types.
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Stores the selected due date.
  DateTime? selectedDate;

  // Connect to our task manager.
  final TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();

    // If an existing task was provided, fill its data into the form.
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDate = DateTime.parse(widget.task!.dueDate);
    }
  }

  // Opens the calendar.
  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  // Saves the new task.

  Future<void> saveTask() async {
    debugPrint('1. SAVE BUTTON PRESSED');

    // Check whether all fields are filled.
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedDate == null) {
      debugPrint('2. VALIDATION FAILED');

      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    debugPrint('2. VALIDATION PASSED');

    try {
      // Create a task object.
      final task = TaskModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: selectedDate!.toIso8601String().split('T')[0],
      );

      debugPrint('3. TASK OBJECT CREATED');

      // Save task using the controller.
      await taskController.addTask(task);

      debugPrint('4. TASK SAVED SUCCESSFULLY');

      // Return to Home Screen.
      Get.back();

      Get.snackbar('Success', 'Task added successfully');
    } catch (e) {
      debugPrint('5. DATABASE ERROR: $e');

      Get.snackbar('Error', 'Unable to save task: $e');
    }
  }


  @override
  void dispose() {
    // Clean up the text controllers when leaving this screen.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: pickDate,
              child: Text(
                selectedDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${selectedDate!.toString().split(' ')[0]}',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(onPressed: saveTask, child: const Text('Save Task')),
          ],
        ),
      ),
    );
  }
}

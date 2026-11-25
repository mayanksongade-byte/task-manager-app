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

  // Saves and update  the new task.


  Future<void> saveTask() async {
    // Check whether the user entered all required information.
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedDate == null) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    try {
      // Create a task object using the form information.
      final task = TaskModel(
        // Keep the old ID when editing an existing task.
        id: widget.task?.id,

        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: selectedDate!.toIso8601String().split('T')[0],

        // Keep the existing completion status when editing.
        isCompleted: widget.task?.isCompleted ?? false,
      );

      if (widget.task == null) {
        // No existing task means we are creating a new task.
        await taskController.addTask(task);
      } else {
        // Existing task means we are updating it.
        await taskController.updateTask(task);
      }

      Get.back();

      Get.snackbar(
        'Success',
        widget.task == null
            ? 'Task added successfully'
            : 'Task updated successfully',
      );
    } catch (e) {
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

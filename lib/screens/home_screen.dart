import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Connect this screen to our TaskController.
  final TaskController controller = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();

    // Load saved tasks when the screen opens.
    controller.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager'), centerTitle: true),

      // Button to add a new task.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddEditTaskScreen());
        },
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        // Get tasks according to the selected filter.
        final filteredTasks = controller.filteredTasks;

        return Column(
          children: [
            // Display All, Pending and Completed buttons.
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: ['All', 'Pending', 'Completed'].map((filter) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.selectedFilter.value = filter;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.selectedFilter.value == filter
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                          foregroundColor:
                              controller.selectedFilter.value == filter
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text(filter),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Show a message if no tasks match the selected filter.
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        controller.tasks.isEmpty
                            ? 'No tasks yet!\nTap + to add your first task.'
                            : 'No ${controller.selectedFilter.value.toLowerCase()} tasks found.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  // Display the filtered task list.
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];

                        return ListTile(
                          // Display task title.
                          title: Text(task.title),

                          // Display task description.
                          subtitle: Text(task.description),

                          // Change Pending / Completed status.
                          leading: IconButton(
                            icon: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              controller.toggleTaskStatus(task);
                            },
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit task.
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Get.to(() => AddEditTaskScreen(task: task));
                                },
                              ),

                              // Delete task.
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'Delete Task?',
                                    middleText: 'Are you sure you want to delete this task?',
                                    textCancel: 'Cancel',
                                    textConfirm: 'Delete',
                                    confirmTextColor: Colors.white,
                                    buttonColor: Colors.red,
                                    onConfirm: () async {
                                      await controller.deleteTask(task.id!);
                                      Get.back();

                                      Get.snackbar(
                                        'Success',
                                        'Task deleted successfully',
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../controllers/theme_controller.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Connect this screen to our TaskController.
  final TaskController controller = Get.find<TaskController>();

  // Connect this screen to our ThemeController.
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();

    // Load saved tasks when the screen opens.
    controller.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,

        // Place the theme toggle button on the right side.
        actions: [
          Obx(() {
            return IconButton(
              // Show the correct icon for the current theme.
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),

              // Switch between Light Mode and Dark Mode.
              onPressed: () {
                themeController.toggleTheme();
              },

              // Explain what the button does.
              tooltip: themeController.isDarkMode.value
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            );
          }),
        ],
      ),

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
            // Search box for finding tasks by title.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
                decoration: InputDecoration(
                  hintText: 'Search tasks by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Display All, Pending and Completed buttons.
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: ['All', 'Pending', 'Completed'].map((filter) {
                  // Check whether this filter is currently selected.
                  final isSelected = controller.selectedFilter.value == filter;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.selectedFilter.value = filter;
                        },

                        // Use colors that automatically support both themes.
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                          foregroundColor: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
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
                        // Show the correct message depending on the situation.
                        controller.tasks.isEmpty
                            ? 'No tasks yet!\nTap + to add your first task.'
                            : controller.searchQuery.value.isNotEmpty
                            ? 'No tasks found for "${controller.searchQuery.value}".'
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

                          // Display task description and due date.
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.description),

                              const SizedBox(height: 4),

                              // Display the task's due date.
                              Text(
                                'Due: ${task.dueDate}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),

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

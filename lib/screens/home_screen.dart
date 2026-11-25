import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../controllers/theme_controller.dart';
import 'add_edit_task_screen.dart';
import '../widgets/task_card.dart';

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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            filter,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
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

                        return TaskCard(
                          // Send the current task to the card.
                          task: task,

                          // Change Pending to Completed or vice versa.
                          onToggle: () {
                            controller.toggleTaskStatus(task);
                          },

                          // Open the Edit Task screen.
                          onEdit: () {
                            Get.to(() => AddEditTaskScreen(task: task));
                          },

                          // Show confirmation before deleting.
                          onDelete: () {
                            Get.defaultDialog(
                              title: 'Delete Task?',
                              middleText:
                                  'Are you sure you want to delete this task?',
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

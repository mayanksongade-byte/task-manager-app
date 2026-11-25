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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddEditTaskScreen());
        },
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        // Check whether there are any tasks.
        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks yet!\nTap + to add your first task.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        // Display all saved tasks.
        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];

            return ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Icon(
                task.isCompleted ? Icons.check_circle : Icons.pending_actions,
              ),
            );
          },
        );
      }),
    );
  }
}

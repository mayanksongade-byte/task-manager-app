
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/task_controller.dart';
import 'screens/home_screen.dart';

void main() {
  // Register our controller before opening the app.
  Get.put(TaskController());

  // Start the Flutter application.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Application name.
      title: 'Task Manager',

      // Hide the debug banner.
      debugShowCheckedModeBanner: false,

      // Open our Home Screen first.
      home: const HomeScreen(),
    );
  }
}

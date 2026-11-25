import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/task_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/home_screen.dart';

void main() {
  // Register our task controller.
  Get.put(TaskController());

  // Register our theme controller.
  Get.put(ThemeController());

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

      // Theme used when Light Mode is selected.
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      // Theme used when Dark Mode is selected.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Start the app in Light Mode.
      themeMode: ThemeMode.light,

      // Open our Home Screen first.
      home: const HomeScreen(),
    );
  }
}

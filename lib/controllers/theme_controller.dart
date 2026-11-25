import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manages the app's Light and Dark themes.
class ThemeController extends GetxController {
  // Stores the current theme.
  var isDarkMode = false.obs;

  // Loads the previously saved theme when the app starts.
  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  // Reads the saved theme from device storage.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // If no preference exists, use Light Mode.
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    // Apply the saved theme.
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Changes the theme and saves the choice.
  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;

    // Save the selected theme on the device.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);

    // Apply the selected theme.
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

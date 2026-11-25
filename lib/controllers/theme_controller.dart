
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// This controller manages the app's Light and Dark themes.
class ThemeController extends GetxController {

  // This variable stores the current theme.
  // false means Light Mode; true means Dark Mode.
  var isDarkMode = false.obs;

  // This method changes the current theme.
  void toggleTheme() {
    // Change Light to Dark or Dark to Light.
    isDarkMode.value = !isDarkMode.value;

    // Tell GetMaterialApp to apply the selected theme.
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

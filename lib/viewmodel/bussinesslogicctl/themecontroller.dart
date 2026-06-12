import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Directly observe the ThemeMode enum
  final themeMode = ThemeMode.dark.obs;

  // Synchronous getter for inline color choices
  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }
}

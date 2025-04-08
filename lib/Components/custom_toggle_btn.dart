// widgets/theme_toggle_switch.dart

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Controller/theme_controller.dart';

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = Get.find<ThemeController>();

    return Obx(() {
      bool isDark = controller.themeMode.value == ThemeMode.dark;

      return FlutterSwitch(
        width: 60.0,
        height: 30.0,
        toggleSize: 25.0,
        value: isDark,
        borderRadius: 30.0,
        padding: 4.0,
        activeToggleColor: Colors.white,
        inactiveToggleColor: Colors.orange,
        activeColor: Colors.grey.shade600,
        inactiveColor: Colors.grey.shade300,
        activeIcon: const Icon(Icons.nightlight, color: Colors.black, size: 18),
        inactiveIcon: const Icon(Icons.wb_sunny, color: Colors.white, size: 18),
        onToggle: (val) {
          controller.toggleTheme(val);
        },
      );
    });
  }
}

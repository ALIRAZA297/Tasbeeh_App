// import 'package:flutter/material.dart';

// const Color transparent = Colors.transparent;

// const Color primary = Colors.teal;
// Color secondary = Colors.teal.shade50;
// Color primary100 = Colors.teal.shade100;
// Color primary200 = Colors.teal.shade200;
// Color primary300 = Colors.teal.shade300;
// Color primary700 = Colors.teal.shade700;
// Color primary900 = Colors.teal.shade900;

// const Color blue = Colors.blue;

// const Color white = Colors.white;
// Color white12 = Colors.white12;
// Color white38 = Colors.white38;
// Color white54 = Colors.white54;
// Color white60 = Colors.white60;
// Color white70 = Colors.white70;

// const Color black = Colors.black;
// const Color black45 = Colors.black45;
// const Color black54 = Colors.black54;
// const Color black87 = Colors.black87;

// const Color grey = Colors.grey;
// Color grey100 = Colors.grey.shade100;
// Color grey200 = Colors.grey.shade200;
// Color grey300 = Colors.grey.shade300;
// Color grey400 = Colors.grey.shade400;
// Color grey500 = Colors.grey.shade500;
// Color grey600 = Colors.grey.shade600;
// Color grey700 = Colors.grey.shade700;
// Color grey800 = Colors.grey.shade800;

// const Color red = Colors.red;
// Color lightred = Colors.red.shade200;
// Color redDark = Colors.red.shade700;

// const Color orange = Colors.orange;
// Color orange200 = Colors.orange.shade200;

// const Color purple = Color(0xFF4F46E5);

// const Color yellow = Colors.yellow;

// const Color cyan = Colors.cyan;

// Color green100 = Colors.green.shade100;
// Color green = Colors.green.shade500;
// Color green700 = Colors.green.shade700;

// const Color kAccentColor = Color(0xFF185ADB);
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/setting_controller.dart';

class AppColors {
  static final SettingsController _settingsController =
      Get.put(SettingsController());

  // Static colors (unchanged)
  static const Color transparent = Colors.transparent;
  static const Color blue = Colors.blue;
  static const Color white = Colors.white;
  static Color white12 = Colors.white12;
  static Color white38 = Colors.white38;
  static Color white54 = Colors.white54;
  static Color white60 = Colors.white60;
  static Color white70 = Colors.white70;

  static const Color black = Colors.black;
  static const Color black45 = Colors.black45;
  static const Color black54 = Colors.black54;
  static const Color black87 = Colors.black87;

  static const Color grey = Colors.grey;
  static Color grey100 = Colors.grey.shade100;
  static Color grey200 = Colors.grey.shade200;
  static Color grey300 = Colors.grey.shade300;
  static Color grey400 = Colors.grey.shade400;
  static Color grey500 = Colors.grey.shade500;
  static Color grey600 = Colors.grey.shade600;
  static Color grey700 = Colors.grey.shade700;
  static Color grey800 = Colors.grey.shade800;

  static const Color red = Colors.red;
  static Color lightred = Colors.red.shade200;
  static Color redDark = Colors.red.shade700;

  static const Color orange = Colors.orange;
  static Color orange200 = Colors.orange.shade200;

  static const Color purple = Color(0xFF4F46E5);
  static const Color yellow = Colors.yellow;
  static const Color cyan = Colors.cyan;

  static Color green100 = Colors.green.shade100;
  static Color green = Colors.green.shade500;
  static Color green700 = Colors.green.shade700;

  static const Color kAccentColor = Color(0xFF185ADB);

  static const Color amber = Colors.amber;
  static Color amber700 = Colors.amber.shade700;

  // Dynamic primary colors based on selected color
  static Color get primary => _settingsController.selectedPrimaryColor.value;
  static Color get secondary =>
      _settingsController.selectedPrimaryColor.value.shade50;
  static Color get primary100 =>
      _settingsController.selectedPrimaryColor.value.shade100;
  static Color get primary200 =>
      _settingsController.selectedPrimaryColor.value.shade200;
  static Color get primary300 =>
      _settingsController.selectedPrimaryColor.value.shade300;
  static Color get primary400 =>
      _settingsController.selectedPrimaryColor.value.shade400;
  static Color get primary500 =>
      _settingsController.selectedPrimaryColor.value.shade500;
  static Color get primary600 =>
      _settingsController.selectedPrimaryColor.value.shade600;
  static Color get primary700 =>
      _settingsController.selectedPrimaryColor.value.shade700;
  static Color get primary900 =>
      _settingsController.selectedPrimaryColor.value.shade900;
}

// Create these getters for backward compatibility with your existing code
Color get primary => AppColors.primary;
Color get secondary => AppColors.secondary;
Color get primary100 => AppColors.primary100;
Color get primary200 => AppColors.primary200;
Color get primary300 => AppColors.primary300;
Color get primary400 => AppColors.primary400;
Color get primary500 => AppColors.primary500;
Color get primary600 => AppColors.primary600;
Color get primary700 => AppColors.primary700;
Color get primary900 => AppColors.primary900;

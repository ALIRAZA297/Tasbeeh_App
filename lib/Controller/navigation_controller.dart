import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/View/Home%20Items/Prayer%20Tracker/prayer_tracker.dart';
import 'package:tasbeeh_app/View/Home%20Items/Tasbeeh/tasbeeh_screen.dart';
import 'package:tasbeeh_app/View/Home/home.dart';

import '../View/Home Items/Qibla Direction/qibla_direction.dart';
import '../View/Home Items/Settings/settings.dart';

class NavigationController extends GetxController {
  // Reactive index for the current tab
  final RxInt currentIndex = 0.obs;

  // List of screens for navigation
  final List<Widget> screens = [
    HomeScreen(),
    const QiblaScreen(),
    const TasbeehScreen(),
    const PrayerTrackerScreen(),
    const SettingsScreen(),
  ];

  // Method to change the current tab
  void changeTab(int index) {
    currentIndex.value = index;
  }
}

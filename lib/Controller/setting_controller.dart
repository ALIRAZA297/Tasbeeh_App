import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tasbeeh_app/View/Home/all_prayers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../View/Home Items/About us/about_page.dart';

class SettingsController extends GetxController {
  // Reactive theme mode
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize theme based on current GetX theme
    themeMode.value = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle theme between light and dark
  // void toggleTheme() {
  //   if (themeMode.value == ThemeMode.light) {
  //     themeMode.value = ThemeMode.dark;
  //     Get.changeThemeMode(ThemeMode.dark);
  //   } else {
  //     themeMode.value = ThemeMode.light;
  //     Get.changeThemeMode(ThemeMode.light);
  //   }
  // }

  // Navigate to About Us page
  void goToAboutUs() {
    Get.to(() => const AboutPage());
  }

  // View all prayer times
  void viewPrayerTimes() {
    Get.to(() => AllPrayersScreen());
  }

  // Rate the app
  Future<void> rateApp() async {
    const storeUrl =
        'https://play.google.com/store/apps/details?id=com.tasbeehApp.app&pcampaignid=web_share';
    final Uri uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open store URL');
    }
  }

  // Share the app
  void shareApp() {
    Share.share(
      'Check out Tasbeeh & Quran App for prayer times, Qibla direction, and more! Download now: https://play.google.com/store/apps/details?id=com.tasbeehApp.app&pcampaignid=web_share',
      subject: 'Share Tasbeeh & Quran App',
    );
  }
}

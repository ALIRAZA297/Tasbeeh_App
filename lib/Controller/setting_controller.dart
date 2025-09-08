import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/app_colors.dart';
import '../View/Home Items/About us/about_page.dart';
import '../View/Home Items/Favorite/favorite_screen.dart';
import '../View/Home/all_prayers.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();

  // Reactive theme mode
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // Reactive primary color
  final Rx<MaterialColor> selectedPrimaryColor = Colors.teal.obs;

  // Available color options
  final List<ColorOption> availableColors = [
    ColorOption(name: 'Teal', color: Colors.teal, icon: Icons.water_drop),
    ColorOption(name: 'Blue', color: Colors.blue, icon: Icons.water),
    ColorOption(name: 'Purple', color: Colors.purple, icon: Icons.auto_awesome),
    ColorOption(name: 'Green', color: Colors.green, icon: Icons.eco),
    ColorOption(name: 'Orange', color: Colors.orange, icon: Icons.wb_sunny),
    ColorOption(name: 'Pink', color: Colors.pink, icon: Icons.favorite),
    ColorOption(name: 'Indigo', color: Colors.indigo, icon: Icons.nights_stay),
    ColorOption(
      name: 'Red',
      color: Colors.red,
      icon: Icons.local_fire_department,
    ),
  ];

  @override
  void onInit() {
    super.onInit();

    // Initialize theme based on current GetX theme
    themeMode.value = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

    // Load saved color (if exists)
    String? savedColorName = _storage.read('primaryColor');
    if (savedColorName != null) {
      final match = availableColors.firstWhereOrNull(
        (option) => option.name == savedColorName,
      );
      if (match != null) {
        selectedPrimaryColor.value = match.color;
      }
    }
  }

  // Change primary color
  void changePrimaryColor(MaterialColor color) {
    selectedPrimaryColor.value = color;

    // Save to storage
    final match = availableColors.firstWhereOrNull(
      (option) => option.color == color,
    );
    if (match != null) {
      _storage.write('primaryColor', match.name);
    }

    Get.snackbar(
      'Color Changed',
      'App color updated successfully!',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 700),
      backgroundColor: color.shade100,
      colorText: color.shade700,
      icon: Icon(Icons.palette, color: color.shade700),
    );
  }

  // Show color selection dialog
  void showColorPicker() {
    Get.dialog(
      ColorSelectionDialog(
        availableColors: availableColors,
        onColorSelected: changePrimaryColor,
      ),
    );
  }

  void goToAboutUs() {
    Get.to(() => const AboutPage());
  }

  // View all prayer times
  void viewPrayerTimes() {
    Get.to(() => AllPrayersScreen());
  }

  // Favorite
  void viewFavorite() {
    Get.to(() => const FavoriteScreen());
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

class ColorOption {
  final String name;
  final MaterialColor color;
  final IconData icon;

  ColorOption({
    required this.name,
    required this.color,
    required this.icon,
  });
}

class ColorSelectionDialog extends StatelessWidget {
  final List<ColorOption> availableColors;
  final Function(MaterialColor) onColorSelected;

  const ColorSelectionDialog({
    super.key,
    required this.availableColors,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose App Color',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? AppColors.white : AppColors.black87,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: availableColors.length,
              itemBuilder: (context, index) {
                final colorOption = availableColors[index];

                return Obx(() {
                  final isSelected = controller.selectedPrimaryColor.value ==
                      colorOption.color;

                  return GestureDetector(
                    onTap: () {
                      onColorSelected(colorOption.color);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorOption.color.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorOption.color.shade700
                              : colorOption.color.shade200,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            colorOption.icon,
                            color: colorOption.color.shade700,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            colorOption.name,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorOption.color.shade700,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colorOption.color.shade700,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: Get.isDarkMode ? AppColors.white70 : AppColors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

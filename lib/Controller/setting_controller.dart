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
    ColorOption(name: 'Amber', color: Colors.amber, icon: Icons.lightbulb),
    ColorOption(name: 'Cyan', color: Colors.cyan, icon: Icons.waves),
    ColorOption(
        name: 'Deep Purple', color: Colors.deepPurple, icon: Icons.diamond),
    ColorOption(
        name: 'Deep Orange', color: Colors.deepOrange, icon: Icons.sunny),
    ColorOption(name: 'Light Blue', color: Colors.lightBlue, icon: Icons.cloud),
    ColorOption(
        name: 'Light Green', color: Colors.lightGreen, icon: Icons.grass),
    ColorOption(name: 'Lime', color: Colors.lime, icon: Icons.local_florist),
    ColorOption(name: 'Brown', color: Colors.brown, icon: Icons.coffee),
    ColorOption(name: 'Grey', color: Colors.grey, icon: Icons.cloud_outlined),
    ColorOption(name: 'Blue Grey', color: Colors.blueGrey, icon: Icons.palette),
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate responsive grid
                  double itemWidth = 100; // Desired item width
                  int crossAxisCount =
                      (constraints.maxWidth / itemWidth).floor();
                  crossAxisCount =
                      crossAxisCount.clamp(3, 5); // Min 3, Max 5 columns

                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.85, // Make items slightly taller
                    ),
                    itemCount: availableColors.length,
                    itemBuilder: (context, index) {
                      final colorOption = availableColors[index];

                      return Obx(() {
                        final isSelected =
                            controller.selectedPrimaryColor.value ==
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
                                // Icon with flexible sizing
                                Flexible(
                                  flex: 3,
                                  child: Icon(
                                    colorOption.icon,
                                    color: colorOption.color.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 2),

                                // Text with overflow handling
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Text(
                                      colorOption.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: colorOption.color.shade700,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ),

                                // Selected indicator
                                if (isSelected)
                                  Flexible(
                                    flex: 1,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: colorOption.color.shade700,
                                      size: 16,
                                    ),
                                  )
                                else
                                  const Flexible(
                                    flex: 1,
                                    child: SizedBox(height: 14),
                                  ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color:
                        Get.isDarkMode ? AppColors.white70 : AppColors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

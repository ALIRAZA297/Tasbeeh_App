import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

import '../../../Components/custom_toggle_btn.dart';
import '../../../Controller/setting_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Get.isDarkMode ? AppColors.white : AppColors.black87,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Toggle
            Obx(
              () => _buildSettingCard(
                icon: Icons.brightness_6,
                title: 'Theme',
                subtitle: controller.themeMode.value == ThemeMode.light
                    ? 'Light Mode'
                    : 'Dark Mode',
                trailing: const ThemeToggleSwitch(),
              ),
            ),
            // Color Selection
            Obx(
              () => _buildSettingCard(
                icon: Icons.palette,
                title: 'App Color',
                subtitle: 'Customize app appearance',
                onTap: controller.showColorPicker,
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: controller.selectedPrimaryColor.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                ),
              ),
            ),
            // Language
            Obx(
              () => _buildSettingCard(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Change app language',
                onTap: () {
                  Get.snackbar(
                    "Coming Soon",
                    "This Functionality will come soon",
                    snackPosition: SnackPosition.TOP,
                    colorText: AppColors.white,
                    backgroundColor: AppColors.red,
                  );
                },
              ),
            ),
            //All Prayer Times
            Obx(
              () => _buildSettingCard(
                icon: FlutterIslamicIcons.solidMosque,
                title: 'Prayer Times',
                subtitle: 'View all prayer times',
                onTap: controller.viewPrayerTimes,
              ),
            ),
            // Favorite
            Obx(
              () => _buildSettingCard(
                icon: Icons.favorite,
                title: 'Favorites',
                subtitle: 'View all your favorites',
                onTap: controller.viewFavorite,
              ),
            ),
            // About Us
            Obx(
              () => _buildSettingCard(
                icon: CupertinoIcons.info_circle_fill,
                title: 'About Us',
                subtitle: 'Learn more about Tasbeeh & Quran App',
                onTap: controller.goToAboutUs,
              ),
            ),
            // Rate Us
            Obx(
              () => _buildSettingCard(
                icon: CupertinoIcons.star_fill,
                title: 'Rate Us',
                subtitle: 'Support us with a review',
                onTap: controller.rateApp,
              ),
            ),
            // Share App
            Obx(
              () => _buildSettingCard(
                icon: Icons.share,
                title: 'Share App',
                subtitle: 'Invite friends to use Tasbeeh & Quran App',
                onTap: controller.shareApp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary700.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primary700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.black45,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

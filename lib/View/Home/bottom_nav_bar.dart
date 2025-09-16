import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

import '../../Controller/navigation_controller.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Show exit confirmation dialog only on home tab
        if (controller.currentIndex.value == 0) {
          _showExitDialog(context);
        } else {
          // Navigate to home tab if not already there
          controller.changeTab(0);
        }
      },
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: controller.screens,
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              enableFeedback: true,
              backgroundColor: AppColors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Get.isDarkMode ? primary100 : primary700,
              unselectedItemColor: AppColors.grey300,
              selectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(CupertinoIcons.house_fill,
                      controller.currentIndex.value == 0),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(FlutterIslamicIcons.solidKaaba,
                      controller.currentIndex.value == 1),
                  label: 'Qibla',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(FlutterIslamicIcons.solidTasbih,
                      controller.currentIndex.value == 2),
                  label: 'Tasbeeh',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(FlutterIslamicIcons.prayingPerson,
                      controller.currentIndex.value == 3),
                  label: 'Prayer Tracker',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(CupertinoIcons.settings,
                      controller.currentIndex.value == 4),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? primary100 : AppColors.grey500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? primary700 : AppColors.white70,
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppColors.grey800 : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (Get.isDarkMode ? primary100 : primary700)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.question_circle,
                    size: 48,
                    color: Get.isDarkMode ? primary100 : primary700,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Exit App?',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? AppColors.white : AppColors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  'Are you sure you want to exit the app?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:
                        Get.isDarkMode ? AppColors.white70 : AppColors.grey600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // No Button
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Get.isDarkMode
                                  ? AppColors.grey600
                                  : AppColors.grey300,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? AppColors.white70
                                : AppColors.grey700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Yes Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Exit the app
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? primary100 : primary700,
                          foregroundColor:
                              Get.isDarkMode ? primary700 : AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Yes, Exit',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

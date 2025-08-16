import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            enableFeedback: true,
            backgroundColor: transparent,
            elevation: 0,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Get.isDarkMode ? primary100 : primary700,
            unselectedItemColor: grey300,
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
    );
  }

  Widget _buildNavIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? primary100 : grey500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? primary700 : white70,
      ),
    );
  }
}

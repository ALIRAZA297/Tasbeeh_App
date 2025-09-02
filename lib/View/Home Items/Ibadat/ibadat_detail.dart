import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class IbadatDetailScreen extends StatelessWidget {
  final Map<String, String> prayer;
  final String? imgPath;

  const IbadatDetailScreen({super.key, required this.prayer, this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          prayer["title"]!,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 80,
          ),
          child: Image.asset(
            imgPath.toString(),
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}

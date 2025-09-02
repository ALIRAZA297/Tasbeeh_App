import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class NamazDetailScreen extends StatelessWidget {
  const NamazDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> namazSteps = [
      {
        "title": "Step 1: Takbeer Olaa —• Say Allaahu Akbar",
        "image": "assets/images/s1.png",
      },
      {
        "title": "Step 2: Al-Qayaam —• Say Sana",
        "image": "assets/images/s2.png",
      },
      {
        "title": "Step 3: Al-Qayaam —• Say Ta’awwudh & Tasmiyya",
        "image": "assets/images/s3.png",
      },
      {
        "title": "Step 4: Al-Qayaam —• Say Surah Fatiha",
        "image": "assets/images/s4.png",
      },
      {
        "title": "Step 5: Al-Qayaam —• Say Surah Kausar",
        "image": "assets/images/s5.png",
      },
      {
        "title":
            "Step 6: Takbeer —• Say Allaahu Akbar Ruku —• Say Subhaana Rabbi’yal Azeem (3 times)",
        "image": "assets/images/s6.png",
      },
      {
        "title":
            "Step 7: Qauma —• Say Sami Allaahu Liman Hamidah Rabbanaa lakal Hamd",
        "image": "assets/images/s7.png",
      },
      {
        "title": "Step 8: Takbeer —• Say Allaahu Akbar",
        "image": "assets/images/s8.png",
      },
      {
        "title": "Step 9: Sajdah —• Say Subhaana Rabbi yal A’alaa (3 times)",
        "image": "assets/images/s9.png",
      },
      {
        "title": "Step 10: Takbeer —• Say Allaahu Akbar",
        "image": "assets/images/s10.png"
      },
      {
        "title": "Step 11: Takbeer —• Say Allaahu Akbar",
        "image": "assets/images/s11.png"
      },
      {
        "title": "Step 12: Sajdah —• Say Subhaana Rabbi yal A’alaa (3 times)",
        "image": "assets/images/s12.png"
      },
      {
        "title":
            "Step 13:  Takbeer —• Say Allaahu Akbar, while standing up for next rakat OR sitting for Tashahhud",
        "image": "assets/images/s13.png"
      },
      {
        "title":
            "Step 14: Tashahhud —• Say AthahiyyaatuLillahi Was Salawaatu Wattayyibatu",
        "image": "assets/images/s14.png"
      },
      {
        "title":
            "Step 15: Tashahhud —• Say Allaahumma Salleh Alaa Muhammadin…..",
        "image": "assets/images/s15.png"
      },
      {
        "title":
            "Step 16: Tashahhud —• Say Rabbij’alnee muqeemas salaati wa mindhur-riy yatee",
        "image": "assets/images/s16.png"
      },
      {
        "title": "Step 17: Salam —• Say Assalamu Alai’kumWarah’matullaah",
        "image": "assets/images/s17.png"
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Namaz",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: namazSteps.map((step) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      step["title"]!,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode
                            ? AppColors.white
                            : AppColors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.AppColors.black12,
                      //     blurRadius: 4,
                      //     spreadRadius: 2,
                      //     offset: Offset(2, 2),
                      //   ),
                      // ],
                      color: AppColors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        step["image"]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

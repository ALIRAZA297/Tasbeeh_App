import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/ibadat_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

import 'ibadat_detail.dart';
import 'namaz_detail_screen.dart';

class IbadatScreen extends StatelessWidget {
  final IbadatController controller = Get.put(IbadatController());

  IbadatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "Ibadat",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: controller.ibadats.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondary,
              ),
              child: ListTile(
                title: Text(
                  controller.ibadats[index]["title"]!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.black,
                    height: 2,
                  ),
                ),
                subtitle: Text(
                  controller.ibadats[index]["subtitle"]!,
                  style: GoogleFonts.notoNastaliqUrdu(
                    color: AppColors.black45,
                    height: 2,
                  ),
                ),
                onTap: () {
                  if (controller.ibadats[index]["title"] == "Namaz") {
                    Get.to(() => const NamazDetailScreen());
                  } else {
                    Get.to(
                      () => IbadatDetailScreen(
                        prayer: controller.ibadats[index],
                        imgPath: controller.imgPath[index],
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

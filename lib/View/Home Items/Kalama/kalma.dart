import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/kalma_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class KalimaScreen extends StatelessWidget {
  final KalimaController controller = Get.find<KalimaController>();

  KalimaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Six Kalimas",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? white : black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: controller.kalimas.length,
          itemBuilder: (context, index) {
            final kalima = controller.kalimas[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondary,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        kalima['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kalima['arabic']!,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.amiri(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 2,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kalima['urdu']!,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoNastaliqUrdu(
                        height: 2,
                        fontSize: 20,
                        color: black45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kalima['english']!,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: black45,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

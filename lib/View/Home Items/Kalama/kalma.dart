import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/kalma_controller.dart';

class KalimaScreen extends StatelessWidget {
  final KalimaController controller = Get.find<KalimaController>();

  KalimaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Six Kalimas"),
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
                color: Colors.green.shade50,
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
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kalima['arabic']!,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.amiri(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 2,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kalima['urdu']!,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoNastaliqUrdu(
                        height: 2,
                        fontSize: 20,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kalima['english']!,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black45,
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

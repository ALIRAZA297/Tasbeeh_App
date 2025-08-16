import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class NooraniQaida extends StatelessWidget {
  const NooraniQaida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Noorani Qaida',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? white : black,
          ),
        ),
        iconTheme: const IconThemeData(color: primary),
      ),
      body: SfPdfViewer.asset('assets/norani_qaida.pdf'),
    );
  }
}

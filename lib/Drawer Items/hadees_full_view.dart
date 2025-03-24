import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Model/hadees_model.dart';

class FullHadithView extends StatelessWidget {
  final Hadith hadith;

  const FullHadithView({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hadith No. ${hadith.hadithNumber}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Heading in Arabic, Urdu, and English
            Text(
              hadith.headingArabic,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hadith.headingUrdu,
              textAlign: TextAlign.right,
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hadith.headingEnglish,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Divider(thickness: 2, height: 20),

            // 📌 Hadith Text in Arabic
            Text(
              hadith.hadithArabic,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // 📌 Hadith Text in Urdu
            Text(
              hadith.hadithUrdu,
              textAlign: TextAlign.right,
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // 📌 Hadith Text in English
            Text(
              hadith.hadithEnglish,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

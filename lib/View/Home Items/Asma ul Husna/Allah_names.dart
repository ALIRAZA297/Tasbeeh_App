import 'package:asmaulhusna/asmaulhusna.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animated_loader.dart';

class AsmaulHusnaScreen extends StatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  State<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends State<AsmaulHusnaScreen> {
  List<Map<String, String>> namesOfAllah = [];

  @override
  void initState() {
    super.initState();
    fetchAsmaulHusna();
  }

  /// Fetch 99 Names of Allah using package functions
  void fetchAsmaulHusna() {
    List<String> arabicNames = getEveryArabicName();
    List<String> englishNames = getEveryEnglishName();

    setState(() {
      for (int i = 0; i < 99; i++) {
        namesOfAllah.add({
          'arabic': arabicNames[i],
          'english': englishNames[i],
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "99 Names of Allah",
           style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: namesOfAllah.isEmpty
          ? const Center(
              child: AnimatedLoader(
                color: Colors.green,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: namesOfAllah.length,
                itemBuilder: (context, index) {
                  final name = namesOfAllah[index];

                  return Container(
                    margin: const EdgeInsets.all(2),
                    // elevation: 3,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/bg image.jpg",
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade100,
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Arabic Name
                          Text(
                            name['arabic'] ?? '',
                            style: GoogleFonts.amiri(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          // English Name
                          Text(
                            textAlign: TextAlign.center,
                            name['english'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Description
                          Text(
                            name['description'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
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

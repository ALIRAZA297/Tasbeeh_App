import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/hadees_controller.dart';

class HadithsView extends StatefulWidget {
  final String bookSlug;
  final int chapterId;

  const HadithsView(
      {super.key, required this.bookSlug, required this.chapterId});

  @override
  State<HadithsView> createState() => _HadithsViewState();
}

class _HadithsViewState extends State<HadithsView> {
  late HadithsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HadithsController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHadiths(widget.bookSlug, widget.chapterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hadiths",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.filteredHadiths.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.filteredHadiths.length,
                itemBuilder: (context, index) {
                  final hadith = controller.filteredHadiths[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        hadith.headingEnglish,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        hadith.headingUrdu,
                        style: GoogleFonts.amiri(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 📌 Load More Button
            if (controller.hasMore.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    controller.fetchHadiths(widget.bookSlug, widget.chapterId);
                    setState(() {}); // Force UI Update
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Load More",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

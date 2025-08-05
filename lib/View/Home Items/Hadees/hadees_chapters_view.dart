import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animated_loader.dart';
import 'package:tasbeeh_app/Components/animation.dart';
import 'package:tasbeeh_app/Controller/hadees_chapters.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';
import 'package:tasbeeh_app/View/Home%20Items/Hadees/hadees_view.dart';

class HadithChaptersView extends StatelessWidget {
  final String bookSlug;

  const HadithChaptersView({super.key, required this.bookSlug});

  @override
  Widget build(BuildContext context) {
    final HadithChaptersController controller =
        Get.put(HadithChaptersController());
    controller.fetchHadithChapters(bookSlug);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          "Chapters of $bookSlug",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: AnimatedLoader(
            color: primary,
          ));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.chapters.length,
          itemBuilder: (context, index) {
            final chapter = controller.chapters[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: AppButtonAnimation(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primary700,
                    child: Text(
                      chapter.chapterNumber,
                      style: const TextStyle(
                          color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    chapter.chapterEnglish,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5.0,
                      top: 5,
                    ),
                    child: Text(
                      chapter.chapterUrdu,
                      style: GoogleFonts.notoNastaliqUrdu(fontSize: 18),
                    ),
                  ),
                  onTap: () => Get.to(() => HadithsView(
                        bookSlug: chapter.bookSlug,
                        chapterId: chapter.id,
                      )),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
